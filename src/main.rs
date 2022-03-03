use actix_web::{web, App, HttpServer};

mod free_time;
mod version;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .route("/version", web::get().to(version::get))
            .route("/free_time", web::post().to(free_time::registrer_free_time))
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
