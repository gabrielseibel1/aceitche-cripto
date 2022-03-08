use actix_web::{HttpResponse, Responder};

pub async fn get() -> impl Responder {
    HttpResponse::Ok().body("v0.2.0")
}
