use std::fmt::Write;

use spdlog::{
    formatter::{FmtExtraInfo, Formatter},
    LevelFilter,
};

#[derive(Clone, Default)]
struct AppLogFormatter;

impl Formatter for AppLogFormatter {
    fn format(
        &self,
        record: &spdlog::Record,
        dest: &mut spdlog::StringBuf,
    ) -> spdlog::Result<spdlog::formatter::FmtExtraInfo> {
        let style_range_begin: usize = dest.len();

        let prefix = match record.level() {
            spdlog::Level::Info => " ->".to_string(),
            other => format!("{}:", other.as_str().to_ascii_uppercase()),
        };
        dest.write_str(&prefix)
            .map_err(spdlog::Error::FormatRecord)?;

        let style_range_end: usize = dest.len();

        writeln!(dest, " {}", record.payload()).map_err(spdlog::Error::FormatRecord)?;

        Ok(FmtExtraInfo::builder()
            .style_range(style_range_begin..style_range_end)
            .build())
    }

    fn clone_box(&self) -> Box<dyn Formatter> {
        Box::new(self.clone())
    }
}

pub fn setup_logger() {
    let formatter = Box::<AppLogFormatter>::default();
    spdlog::default_logger().set_level_filter(LevelFilter::All);
    for sink in spdlog::default_logger().sinks() {
        sink.set_formatter(formatter.clone())
    }
}
