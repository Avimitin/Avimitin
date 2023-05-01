use serde::Deserialize;
use spdlog as log;

#[derive(Deserialize)]
struct RepoContent {
    name: String,
    url: String,
    download_url: Option<String>,
    #[serde(rename = "type")]
    file_type: String,
}

const GITHUB_API: &str = "https://api.github.com/repos/felixonmars/archriscv-packages/contents";

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    infra::assist::setup_logger();

    let pkg = std::env::args()
        .nth(1)
        .ok_or_else(|| anyhow::anyhow!("No argument given"))?;

    log::info!("Search patch for file {pkg}");

    let client = infra::HttpClient::new();
    let response: Vec<RepoContent> = client.gh_json(GITHUB_API).await?;
    let target_patch_dir = response
        .iter()
        .filter(|content| content.file_type == "dir")
        .find(|content| content.name == pkg)
        .ok_or_else(|| anyhow::anyhow!("Target pkg not found"))?;
    let response: Vec<RepoContent> = client.gh_json(&target_patch_dir.url).await?;
    let save_job = response
        .into_iter()
        .map(|content| {
            let client = client.clone();
            tokio::spawn(async move {
                log::info!("Downloading {}", content.name);
                client
                    .download_github_file(content.download_url.unwrap(), &content.name)
                    .await
            })
        })
        .collect::<Vec<_>>();

    for handle in save_job {
        handle.await??;
    }

    Ok(())
}
