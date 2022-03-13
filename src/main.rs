use actix_files::Files;
use actix_web::{web, App, HttpServer};
use dotenv::dotenv;
use tokio_postgres::NoTls;

mod app_config;
mod handlers;
mod version;
mod data;
mod db;
mod actions;


#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();

    let app_config = app_config::AppConfig::from_env().expect("failed to read app config from env");
    let pool = app_config
        .pg
        .create_pool(None, NoTls)
        .expect("failed to create pool");

    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone()))
            .route("/api/version", web::get().to(version::get))
            .route(
                "/api/free_time",
                web::post().to(handlers::handle_free_time_form),
            )
            .service(Files::new("/img", "./img"))
            .service(Files::new("/", "./src/frontend").index_file("index.html"))
    })
    .bind(app_config.address.clone())?
    .run()
    .await
}
