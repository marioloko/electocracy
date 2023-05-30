use anyhow::{anyhow, Context};
use diesel::r2d2::{ConnectionManager, Pool};
use diesel::PgConnection;

use crate::gpt_client::GptClient;

#[derive(Clone)]
pub struct AppState {
    db_pool: Pool<ConnectionManager<PgConnection>>,
    gpt_client: GptClient,
}

impl AppState {
    pub fn new(db_url: &str, openai_api_key: &str) -> anyhow::Result<AppState> {
        let manager = ConnectionManager::<PgConnection>::new(db_url);
        let db_pool = Pool::builder()
            .build(manager)
            .context("Cannot create db pool")?;
        let gpt_client = GptClient::new(openai_api_key);

        Ok(AppState {
            db_pool,
            gpt_client,
        })
    }

    pub fn get_connection(
        &self,
    ) -> anyhow::Result<diesel::r2d2::PooledConnection<ConnectionManager<PgConnection>>> {
        self.db_pool
            .get()
            .map_err(|err| anyhow!("Cannot get any connection from pool: {err}"))
    }

    pub fn gpt_client(&self) -> &GptClient {
        &self.gpt_client
    }
}
