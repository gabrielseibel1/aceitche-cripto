use chrono::{DateTime, Utc};

// table "customer"
pub struct Customer {
    pub email: String,
    pub phone: String,
    pub name: String,
}

// table "candidate_appointment"
pub struct CandidateAppointment {
    pub id: i32,
    pub datetime: DateTime<Utc>,
    pub customer_email: String,
    pub comment: String,
}

// table "scheduled_appointment"
pub struct ScheduledAppointment {
    pub datetime: DateTime<Utc>,
    pub customer_email: String,
    pub comment: String,
}

impl Into<Customer> for tokio_postgres::Row {
    fn into(self) -> Customer {
        Customer {
            name: self.get("name"),
            email: self.get("email"),
            phone: self.get("phone"),
        }
    }
}
