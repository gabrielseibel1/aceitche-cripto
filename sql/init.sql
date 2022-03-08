drop table if exists customer;
drop table if exists candidate_appointment;
drop table if exists scheduled_appointment;

create table customer
(
    id serial primary key,
    name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(100) not null unique
);

create table candidate_appointment
(
    id serial primary key,
    date_time timestamp not null,
    customer_id serial references customer(id) not null,
    unique (date_time, customer_id)
);

create table scheduled_appointment
(
    id serial primary key,
    date_time timestamp not null unique,
    customer_id serial references customer(id) not null
);