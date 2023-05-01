use anyhow::Context;
use indicatif::{MultiProgress, ProgressBar, ProgressStyle};
use std::{fmt::Display, ops::Deref};
use tokio::io::AsyncWriteExt;
use tokio_stream::StreamExt;

use reqwest::{IntoUrl, Response, StatusCode};
use serde::de::DeserializeOwned;

#[derive(Clone, Default)]
pub struct HttpClient(reqwest::Client);

impl Deref for HttpClient {
    type Target = reqwest::Client;
    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl HttpClient {
    pub fn new() -> Self {
        Self(reqwest::Client::new())
    }

    pub async fn gh_get(&self, url: impl IntoUrl) -> anyhow::Result<reqwest::Response> {
        let response = self
            .get(url)
            .header("Accept", "application/vnd.github+json")
            .header(
                "User-Agent",
                "Mozilla/5.0 (platform; rv:geckoversion) Gecko/geckotrail Firefox/firefoxversion",
            )
            .send()
            .await?;
        if response.status() != StatusCode::OK {
            let status = response.status();
            let body = response
                .text()
                .await
                .with_context(|| "Response is not a valid UTF-8 text")?;
            anyhow::bail!("[{status}] {body}");
        }

        Ok(response)
    }

    pub async fn gh_json<T: DeserializeOwned>(&self, url: impl IntoUrl) -> anyhow::Result<T> {
        let response = self.gh_get(url).await?;

        response.json::<T>().await.with_context(|| {
            format!(
                "fail to deserialize response into type {}",
                std::any::type_name::<T>()
            )
        })
    }

    pub async fn download_github_file(
        &self,
        url: impl IntoUrl,
        filename: impl Display + AsRef<std::path::Path>,
    ) -> anyhow::Result<()> {
        let content = self.gh_get(url).await?.text().await?;
        tokio::fs::write(&filename, content)
            .await
            .with_context(|| format!("fail to save github content into file {filename}"))?;

        Ok(())
    }

    #[inline]
    fn byte_to_mb(byte: u64) -> u64 {
        byte / 1048576
    }

    pub async fn dl_with_progress(
        resp: Response,
        progress: MultiProgress,
        style: ProgressStyle,
    ) -> anyhow::Result<()> {
        let filesize = resp
            .headers()
            .get("content-length")
            .ok_or_else(|| anyhow::anyhow!("This file doesn't have content length"))?
            .to_str()?
            .parse::<u64>()?;
        let filesize = Self::byte_to_mb(filesize);
        let subbar = progress.add(ProgressBar::new(filesize));
        subbar.set_style(style);

        let filename = resp
            .url()
            .path_segments()
            .unwrap()
            .last()
            .unwrap()
            .to_string();
        subbar.set_message(filename.to_owned());
        let mut file = tokio::fs::OpenOptions::new()
            .create(true)
            .append(true)
            .open(&filename)
            .await?;
        let mut stream = resp.bytes_stream();
        let mut writed = 0;
        while let Some(Ok(chunk)) = stream.next().await {
            writed += chunk.len();
            file.write_all(&chunk)
                .await
                .with_context(|| format!("fail to download {filename}"))?;
            subbar.set_position(Self::byte_to_mb(writed as u64));
        }

        Ok(())
    }

    pub async fn parallel_dl(
        &self,
        resp: impl IntoIterator<Item = Response>,
    ) -> anyhow::Result<()> {
        let progress = MultiProgress::new();
        let style =
            ProgressStyle::with_template("> {bar:40.cyan/blue} [{msg} {pos:>7}MB/{len:7}MB]")
                .unwrap()
                .progress_chars("##-");

        let tasks = resp
            .into_iter()
            .map(|resp| {
                let progress = progress.clone();
                let style = style.clone();
                tokio::spawn(async move { Self::dl_with_progress(resp, progress, style).await })
            })
            .collect::<Vec<_>>();

        for t in tasks {
            t.await??;
        }

        Ok(())
    }
}
