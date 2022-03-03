use actix_web::{HttpResponse, Responder};

pub async fn registrer_free_time() -> impl Responder {
    HttpResponse::Ok().body("Received.")
}
