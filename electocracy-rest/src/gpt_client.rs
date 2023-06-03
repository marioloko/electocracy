use std::sync::Arc;

use anyhow::{anyhow, Context};
use openai_rust::chat::{ChatArguments, Message};
use openai_rust::Client;

use crate::models::gpt::{GptSummary, GptTitle};

const SYSTEM_ROLE: &str = "system";
const GPT_VERSION: &str = "gpt-3.5-turbo";

macro_rules! format_prompt {
    ($prompt_name:literal, $($arg:tt)*) => {{
        format!(
            include_str!(concat!(env!("CARGO_MANIFEST_DIR"), "/prompts/", $prompt_name)),
            $($arg)*
        )
    }};
}

macro_rules! prompt_function {
    ($function_name:ident, $ret_type:ty, $prompt_name:literal) => {
        pub async fn $function_name(&self, text: &str) -> anyhow::Result<$ret_type> {
            let system_prompt = format_prompt!($prompt_name, text = text);
            let messages = vec![Message {
                role: SYSTEM_ROLE.to_owned(),
                content: system_prompt,
            }];
            let response_json = self.send_messages(messages).await?;
            serde_json::from_str::<$ret_type>(&response_json)
                .with_context(|| format!("Cannot deserialize the response JSON: {response_json}"))
        }
    };
}

#[derive(Clone)]
pub struct GptClient {
    client: Arc<Client>,
}

impl GptClient {
    pub fn new(api_key: &str) -> GptClient {
        let client = Client::new(api_key);
        let client = Arc::new(client);
        GptClient { client }
    }

    prompt_function!(summarize, GptSummary, "summarize.txt");

    prompt_function!(generate_title, GptTitle, "generate_title.txt");

    async fn send_messages(&self, messages: Vec<Message>) -> anyhow::Result<String> {
        let mut args = ChatArguments::new(GPT_VERSION, messages);
        args.temperature = Some(0.0);
        let response = self.client.create_chat(args).await?;
        let choice = response
            .choices
            .into_iter()
            .next()
            .ok_or_else(|| anyhow!("Could not optain any response from GPT model"))?;
        let response_text = choice.message.content;
        Ok(response_text)
    }
}
