use actix_web::{web, App, HttpServer};
use actix_files::Files;

mod free_time;
mod version;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .route("/api/version", web::get().to(version::get))
            .route("/api/free_time", web::post().to(free_time::registrer_free_time))
            .service(Files::new("/img", "/var/img"))
            .service(Files::new("/", "/var/src").index_file("index.html"))
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}
