--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';

CREATE SEQUENCE ftp_id_seq INCREMENT BY 1 MINVALUE 1 START WITH 1;

CREATE TABLE users (
    id integer DEFAULT nextval('ftp_id_seq'::regclass) NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    home character varying(255) NOT NULL
);


ALTER TABLE users OWNER TO postgres;

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
