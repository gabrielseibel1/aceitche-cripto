drop table if exists customer;
drop table if exists candidate_appointment;
drop table if exists scheduled_appointment;

create table customer
(
    email varchar(100) primary key,
    phone varchar(100) not null unique,
    name varchar(100) not null
);

create table candidate_appointment
(
    id serial primary key,
    date_time timestamp with time zone not null,
    customer_email varchar(100) references customer(email) not null,
    comment varchar(200),
    unique (date_time, customer_email)
);

create table scheduled_appointment
(
    date_time timestamp with time zone primary key,
    customer_email varchar(100) references customer(email) not null,
    comment varchar(200)
);