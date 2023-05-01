use infra::HttpClient;

const MIRROR_URL: &str = "https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/testing/20230405_openEuler-23.03-V1-riscv64/QEMU/";

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let client = HttpClient::new();

    let webpage = client.get(MIRROR_URL).send().await?.text().await?;
    let document = scraper::Html::parse_document(&webpage);
    let selector = scraper::Selector::parse("td.link a").expect("Invalid CSS");
    let files = document
        .select(&selector)
        .skip(1)
        .map(|tag| tag.value().attr("href").unwrap())
        .collect::<Vec<_>>();

    let mut response = Vec::with_capacity(files.len());

    for file in files {
        let resp = client.get(format!("{MIRROR_URL}{file}")).send().await?;
        response.push(resp)
    }

    client.parallel_dl(response).await?;

    Ok(())
}
