use actix_web::web;
use deadpool_postgres::Pool;
use std::io::{Error, ErrorKind};

use super::data::{CandidateAppointment, Customer};

pub struct Db {
    conn_pool: web::Data<Pool>,
}

impl Db {
    pub fn new(conn_pool: web::Data<Pool>) -> Db {
        Db { conn_pool }
    }

    pub async fn insert_customer(&self, customer: Customer) -> Option<Error> {
        let client = match self
            .conn_pool
            .get()
            .await
            .map_err(|e| Error::new(ErrorKind::NotConnected, e))
        {
            Ok(client) => client,
            Err(e) => return Some(e),
        };

        client
            .execute(
                r#"insert into "customer" ("name", "phone", "email") values ($1, $2, $3)"#,
                &[&customer.name, &customer.phone, &customer.email],
            )
            .await
            .map_err(|e| Error::new(ErrorKind::AlreadyExists, e))
            .err()
    }

    pub async fn insert_candidate_appointment(
        &self,
        candidate: CandidateAppointment,
    ) -> Option<Error> {
        let client = match self
            .conn_pool
            .get()
            .await
            .map_err(|e| Error::new(ErrorKind::NotConnected, e))
        {
            Ok(client) => client,
            Err(e) => return Some(e),
        };

        let time: std::time::SystemTime = candidate.datetime.into();

        client
            .execute(
            r#"insert into "candidate_appointment" ("date_time", "customer_email", "comment") values ($1, $2, $3)"#,
            &[&time, &candidate.customer_email, &candidate.comment],
            )
            .await
            .map_err(|e| Error::new(ErrorKind::AlreadyExists, e))
            .err()
    }

    pub async fn select_customer(&self, email: String) -> Result<Customer, Error> {
        let client = self
            .conn_pool
            .get()
            .await
            .map_err(|e| Error::new(ErrorKind::NotConnected, e))?;
        
        let row = client
            .query_one(r#"select * from users where email = $1"#, &[&email])
            .await;

        match row {
            Ok(row) => Ok(row.into()),
            Err(err) => Err(Error::new(ErrorKind::NotFound, err)),
        }
    }
}
