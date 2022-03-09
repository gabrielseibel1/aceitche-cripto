pub use config::ConfigError;
use config::{Config, Environment};
use serde::Deserialize;

#[derive(Deserialize, Default)]
pub struct AppConfig {
    pub address: String,
    pub pg: deadpool_postgres::Config,
}

impl AppConfig {
    pub fn from_env() -> Result<Self, ConfigError> {
        Config::builder()
            .add_source(Environment::default().separator("__"))
            .build()?
            .try_deserialize()
    }
}
