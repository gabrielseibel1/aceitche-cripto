use actix_web::{web, HttpResponse, Responder};
use chrono::{DateTime, TimeZone, Utc};
use deadpool_postgres::{Client, Pool};
use serde::{Deserialize, Serialize};

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

pub async fn registrer_free_time(
    db_pool: web::Data<Pool>,
    form: web::Form<FreeTimeForm>,
) -> impl Responder {
    let ft = FreeTime {
        customer: form.name.clone(),
        phone: form.phone.clone(),
        email: form.email.clone(),
        datetime: Utc
            .datetime_from_str(
                &format!("{} {}:00", form.date.clone(), form.time.clone()),
                "%F %T",
            )
            .expect(
                &format!("date: {}, time: {}.", form.date, form.time), //TODO use HTTP error instead
            ),
        comment: form.comment.clone(),
    };

    let client = db_pool.get().await.expect("Database pool is not available");

    let stmt = client
        .prepare(
            r#"
        insert into "customer" ("name", "phone", "email") 
        values ($1, $2, $3)
        "#,
        )
        .await
        .expect("statement could net be prepared");

    let rows_modified = client
        .execute(&stmt, &[&ft.customer, &ft.phone, &ft.email])
        .await
        .expect("query failed"); // TODO handle this as corresponding http error
    
    assert_eq!(rows_modified, 1);
    
    HttpResponse::Ok().json(ft) // <- send response
}
