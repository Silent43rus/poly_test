--DROP SCHEMA shikhaldin CASCADE;
CREATE SCHEMA shikhaldin;
CREATE TABLE "shikhaldin".sales(
	sale_date DATE,
	salesman_id INTEGER,
	item_id VARCHAR(10),
	quantity INTEGER,
	final_price INTEGER
);
CREATE TABLE "shikhaldin".products(
	id VARCHAR(10),
	name TEXT,
	price INTEGER,
	sdate DATE,
	edate DATE,
	is_actual INTEGER
);
CREATE TABLE "shikhaldin".services(
	id VARCHAR(10),
	name TEXT,
	price INTEGER,
	sdate DATE,
	edate DATE,
	is_actual INTEGER
);
CREATE TABLE "shikhaldin".sellers(
	id INTEGER,
	fio TEXT,
	department_id INTEGER
);
CREATE TABLE "shikhaldin".departments(
	filial_id INTEGER,
	department_id INTEGER,
	dep_chif_id INTEGER
);