use crate::data::{CandidateAppointment, Customer};
use crate::db::Db;
use actix_web::web;
use chrono::{DateTime, Utc};
use deadpool_postgres::Pool;
use std::io::Error;

pub async fn registrer_free_time(
    db_pool: web::Data<Pool>,
    name: String,
    email: String,
    phone: String,
    datetime: DateTime<Utc>,
    comment: String,
) -> Option<Error> {
    let customer = Customer {
        name: name.clone(),
        phone: phone.clone(),
        email: email.clone(),
    };

    let candidate = CandidateAppointment {
        id: 0,
        datetime,
        customer_email: email.clone(),
        comment: comment.clone(),
    };

    let db = Db::new(db_pool);

    db.insert_customer(customer).await;

    db.insert_candidate_appointment(candidate).await
}
