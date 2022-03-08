use actix_web::{web, HttpResponse, Responder};

use serde::{Deserialize, Serialize};

use chrono::{DateTime, Utc, TimeZone};

#[derive(Deserialize)]
pub struct FreeTimeForm {
    name: String,
    phone: String,
    email: String,
    date: String,
    time: String,
    comment: String,
}

#[derive(Serialize)]
pub struct FreeTime {
    customer: String,
    phone: String,
    email: String,
    datetime: DateTime<Utc>,
    comment: String,
}

pub async fn registrer_free_time(form: web::Form<FreeTimeForm>) -> impl Responder {
    let ft = FreeTime{
        customer: form.name.clone(),
        phone: form.phone.clone(),
        email: form.email.clone(),
        datetime: Utc.datetime_from_str(
            &format!("{} {}:00", form.date.clone(), form.time.clone()), "%F %T"
        ).expect(
            &format!("date: {}, time: {}.", form.date, form.time) //TODO use HTTP error instead 
        ),
        comment: form.comment.clone(),
    };
    
    HttpResponse::Ok().json(ft) // <- send response
}
