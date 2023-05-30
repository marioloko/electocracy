use actix_web::middleware::Logger;
use actix_web::{web, App, HttpServer};
use std::env;

use electocracy::services as svc;
use electocracy::state::AppState;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenvy::dotenv().expect("The .env file does not exist");

    env_logger::init();

    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    let openai_api_key = env::var("OPENAI_API_KEY").expect("OPENAI_API_KEY must be set");
    let bind_address = env::var("BIND_ADDRESS").unwrap_or_else(|_| String::from("127.0.0.1:8000"));

    let app_state =
        AppState::new(&database_url, &openai_api_key).expect("Cannot create application state.");

    log::info!("Starting server at: {bind_address}");

    HttpServer::new(move || {
        App::new()
            .wrap(Logger::default())
            .app_data(web::Data::new(app_state.clone()))
            .route("/poll/{id}", web::get().to(svc::get_poll))
            .route("/poll", web::get().to(svc::list_polls))
            .route("/poll", web::post().to(svc::create_poll))
            .route("/summarize", web::post().to(svc::summarize))
            .route("/generate-title", web::post().to(svc::generate_title))
    })
    .bind(&bind_address)?
    .run()
    .await
}
