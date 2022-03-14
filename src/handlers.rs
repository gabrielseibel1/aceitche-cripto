use actix_web::{web, HttpResponse, Responder};
use chrono::{TimeZone, Utc};
use deadpool_postgres::Pool;
use serde::Deserialize;

use crate::actions::registrer_free_time;

#[derive(Deserialize)]
pub struct FreeTimeForm {
    name: String,
    phone: String,
    email: String,
    date: String,
    time: String,
    comment: String,
}

pub async fn handle_free_time_form(
    db_pool: web::Data<Pool>,
    form: web::Form<FreeTimeForm>,
) -> impl Responder {
    let datetime = Utc
        .datetime_from_str(&format!("{} {}:00", form.date, form.time), "%F %T")
        .expect(
            &format!("date: {}, time: {}.", form.date, form.time), //TODO use HTTP error instead
        );

    match registrer_free_time(
        db_pool,
        form.name.clone(),
        form.email.clone(),
        form.phone.clone(),
        datetime,
        form.comment.clone(),
    )
    .await
    {
        None => HttpResponse::SeeOther()
            .insert_header((actix_web::http::header::LOCATION, "/consult_received.html"))
            .finish(),
        Some(err) => HttpResponse::InternalServerError()
            .body(format!("failed to register free time: {}", err.to_string())),
    }
}
