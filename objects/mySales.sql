-- Created by XSQLite v2.0.0 [https://github.com/wdonadelli/XSQLite] --

-------------------------------------------------------------------------------

PRAGMA foreign_keys = ON;

-------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS clients (
	_id_ INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL,
	birth TEXT NOT NULL,
	doc NUMBER UNIQUE NOT NULL
);

-------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS products (
	_id_ INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT UNIQUE NOT NULL
);

-------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS sales (
	_id_ INTEGER PRIMARY KEY AUTOINCREMENT,
	client_id INTEGER NOT NULL,
	product_id INTEGER NOT NULL,
	value NUMBER NOT NULL,
	FOREIGN KEY(client_id) REFERENCES clients(_id_) ON UPDATE CASCADE,
	FOREIGN KEY(product_id) REFERENCES products(_id_) ON UPDATE CASCADE
);

-------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS _log_clients (
	_log_ TEXT DEFAULT(DATETIME('now', 'localtime')),
	_event_ INTEGER CHECK(_event_ IN (0, 1, 2)),
	_id_ INTEGER,
	name TEXT,
	birth TEXT,
	doc NUMBER
);

-------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS _log_products (
	_log_ TEXT DEFAULT(DATETIME('now', 'localtime')),
	_event_ INTEGER CHECK(_event_ IN (0, 1, 2)),
	_id_ INTEGER,
	name TEXT
);

-------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS _log_sales (
	_log_ TEXT DEFAULT(DATETIME('now', 'localtime')),
	_event_ INTEGER CHECK(_event_ IN (0, 1, 2)),
	_id_ INTEGER,
	client_id INTEGER,
	product_id INTEGER,
	value NUMBER
);

-------------------------------------------------------------------------------

CREATE VIEW IF NOT EXISTS _vw_clients AS SELECT
	clients._id_ AS 'clients._id_',
	UPPER(clients.name) AS 'clients.name',
	STRFTIME('%Y-%m-%d', clients.birth) AS 'clients.birth',
	PRINTF('%f', clients.doc) AS 'clients.doc'
	FROM clients
;

-------------------------------------------------------------------------------

CREATE VIEW IF NOT EXISTS _vw_products AS SELECT
	products._id_ AS 'products._id_',
	UPPER(products.name) AS 'products.name'
	FROM products
;

-------------------------------------------------------------------------------

CREATE VIEW IF NOT EXISTS _vw_sales AS SELECT
	sales._id_ AS 'sales._id_',
	sales.client_id AS 'sales.client_id',
	sales.product_id AS 'sales.product_id',
	PRINTF('%f', sales.value) AS 'sales.value',
	UPPER(clients.name) AS 'clients.name',
	STRFTIME('%Y-%m-%d', clients.birth) AS 'clients.birth',
	PRINTF('%f', clients.doc) AS 'clients.doc',
	UPPER(products.name) AS 'products.name'
	FROM sales
	INNER JOIN clients ON clients._id_ = sales.client_id
	INNER JOIN products ON products._id_ = sales.product_id
;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_before_insert_clients BEFORE INSERT ON clients BEGIN

	SELECT CASE
		WHEN new.name IS NULL
		THEN RAISE(ABORT, 'Client name is required.')
		WHEN UPPER(new.name) GLOB '*[^A-Z ]*' OR UPPER(new.name) NOT GLOB '[A-Z]*[A-Z]' OR new.name GLOB '*  *'
		THEN RAISE(ABORT, 'Enter the customer name accordingly.')
	END;

	SELECT CASE
		WHEN new.birth IS NULL
		THEN RAISE(ABORT, 'Date of birth is required.')
		WHEN DATE(new.birth, '+1 day', '-1 day') != new.birth
		THEN RAISE(ABORT, 'Enter the date of birth accordingly.')
		WHEN new.birth > DATE('now', '-18 years')
		THEN RAISE(ABORT, 'Customer must be over 18 years old.')
	END;

	SELECT CASE
		WHEN new.doc IS NULL
		THEN RAISE(ABORT, 'Document number is required.')
		WHEN UPPER(TYPEOF(new.doc)) NOT IN ('INTEGER', 'REAL')
		THEN RAISE(ABORT, 'Enter the customer document number.')
		WHEN (SELECT COUNT(*) FROM clients WHERE doc = new.doc) > 0
		THEN RAISE(ABORT, 'Document number already used.')
		WHEN new.doc < 1
		THEN RAISE(ABORT, 'Document number must be from 1.')
		WHEN new.doc > 9999999
		THEN RAISE(ABORT, 'Document number must be up to 9999999.')
	END;

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_before_insert_products BEFORE INSERT ON products BEGIN

	SELECT CASE
		WHEN new.name IS NULL
		THEN RAISE(ABORT, 'Product name is required.')
		WHEN UPPER(new.name) GLOB '*[^A-Z ]*' OR UPPER(new.name) NOT GLOB '[A-Z]*[A-Z]' OR new.name GLOB '*  *'
		THEN RAISE(ABORT, 'Enter the product name accordingly.')
		WHEN (SELECT COUNT(*) FROM products WHERE name LIKE new.name) > 0
		THEN RAISE(ABORT, 'Product already registered.')
	END;

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_before_insert_sales BEFORE INSERT ON sales BEGIN

	SELECT CASE
		WHEN UPPER(TYPEOF(new.client_id)) != 'INTEGER' OR (SELECT COUNT(*) FROM clients WHERE _id_ = new.client_id) != 1
		THEN RAISE(ABORT, 'client_id: Register not found.')
	END;

	SELECT CASE
		WHEN UPPER(TYPEOF(new.product_id)) != 'INTEGER' OR (SELECT COUNT(*) FROM products WHERE _id_ = new.product_id) != 1
		THEN RAISE(ABORT, 'product_id: Register not found.')
	END;

	SELECT CASE
		WHEN new.value IS NULL
		THEN RAISE(ABORT, 'Product value is required.')
		WHEN UPPER(TYPEOF(new.value)) NOT IN ('INTEGER', 'REAL')
		THEN RAISE(ABORT, 'Enter the value of the product.')
		WHEN new.value < 0.01
		THEN RAISE(ABORT, 'Minimum product value must be $ 0.01.')
	END;

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_before_update_clients BEFORE UPDATE ON clients BEGIN

	SELECT CASE
		WHEN new._id_ != old._id_
		THEN RAISE(ABORT, 'The table identifier cannot be changed.')
	END;

	SELECT CASE
		WHEN new.name = old.name
		THEN NULL
		WHEN new.name IS NULL
		THEN RAISE(ABORT, 'Client name is required.')
		WHEN UPPER(new.name) GLOB '*[^A-Z ]*' OR UPPER(new.name) NOT GLOB '[A-Z]*[A-Z]' OR new.name GLOB '*  *'
		THEN RAISE(ABORT, 'Enter the customer name accordingly.')
	END;

	SELECT CASE
		WHEN new.birth = old.birth
		THEN NULL
		WHEN new.birth IS NULL
		THEN RAISE(ABORT, 'Date of birth is required.')
		WHEN DATE(new.birth, '+1 day', '-1 day') != new.birth
		THEN RAISE(ABORT, 'Enter the date of birth accordingly.')
		WHEN new.birth > DATE('now', '-18 years')
		THEN RAISE(ABORT, 'Customer must be over 18 years old.')
	END;

	SELECT CASE
		WHEN new.doc = old.doc
		THEN NULL
		WHEN new.doc IS NULL
		THEN RAISE(ABORT, 'Document number is required.')
		WHEN UPPER(TYPEOF(new.doc)) NOT IN ('INTEGER', 'REAL')
		THEN RAISE(ABORT, 'Enter the customer document number.')
		WHEN (SELECT COUNT(*) FROM clients WHERE doc = new.doc) > 0
		THEN RAISE(ABORT, 'Document number already used.')
		WHEN new.doc < 1
		THEN RAISE(ABORT, 'Document number must be from 1.')
		WHEN new.doc > 9999999
		THEN RAISE(ABORT, 'Document number must be up to 9999999.')
	END;

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_before_update_products BEFORE UPDATE ON products BEGIN

	SELECT CASE
		WHEN new._id_ != old._id_
		THEN RAISE(ABORT, 'The table identifier cannot be changed.')
	END;

	SELECT CASE
		WHEN new.name = old.name
		THEN NULL
		WHEN new.name IS NULL
		THEN RAISE(ABORT, 'Product name is required.')
		WHEN UPPER(new.name) GLOB '*[^A-Z ]*' OR UPPER(new.name) NOT GLOB '[A-Z]*[A-Z]' OR new.name GLOB '*  *'
		THEN RAISE(ABORT, 'Enter the product name accordingly.')
		WHEN (SELECT COUNT(*) FROM products WHERE name LIKE new.name) > 0
		THEN RAISE(ABORT, 'Product already registered.')
	END;

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_before_update_sales BEFORE UPDATE ON sales BEGIN

	SELECT CASE
		WHEN new._id_ != old._id_
		THEN RAISE(ABORT, 'The table identifier cannot be changed.')
	END;

	SELECT CASE
		WHEN new.client_id = old.client_id
		THEN NULL
		WHEN UPPER(TYPEOF(new.client_id)) != 'INTEGER' OR (SELECT COUNT(*) FROM clients WHERE _id_ = new.client_id) != 1
		THEN RAISE(ABORT, 'client_id: Register not found.')
	END;

	SELECT CASE
		WHEN new.product_id = old.product_id
		THEN NULL
		WHEN UPPER(TYPEOF(new.product_id)) != 'INTEGER' OR (SELECT COUNT(*) FROM products WHERE _id_ = new.product_id) != 1
		THEN RAISE(ABORT, 'product_id: Register not found.')
	END;

	SELECT CASE
		WHEN new.value = old.value
		THEN NULL
		WHEN new.value IS NULL
		THEN RAISE(ABORT, 'Product value is required.')
		WHEN UPPER(TYPEOF(new.value)) NOT IN ('INTEGER', 'REAL')
		THEN RAISE(ABORT, 'Enter the value of the product.')
		WHEN new.value < 0.01
		THEN RAISE(ABORT, 'Minimum product value must be $ 0.01.')
	END;

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_after_insert_clients AFTER INSERT ON clients BEGIN

	INSERT INTO _log_clients (
		_event_,
		_id_,
		name,
		birth,
		doc
	) VALUES (
		0,
		new._id_,
		new.name,
		new.birth,
		new.doc
	);

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_after_insert_products AFTER INSERT ON products BEGIN

	INSERT INTO _log_products (
		_event_,
		_id_,
		name
	) VALUES (
		0,
		new._id_,
		new.name
	);

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_after_insert_sales AFTER INSERT ON sales BEGIN

	INSERT INTO _log_sales (
		_event_,
		_id_,
		client_id,
		product_id,
		value
	) VALUES (
		0,
		new._id_,
		new.client_id,
		new.product_id,
		new.value
	);

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_after_update_clients AFTER UPDATE ON clients BEGIN

	INSERT INTO _log_clients (
		_event_,
		_id_,
		name,
		birth,
		doc
	) VALUES (
		1,
		new._id_,
		new.name,
		new.birth,
		new.doc
	);

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_after_update_products AFTER UPDATE ON products BEGIN

	INSERT INTO _log_products (
		_event_,
		_id_,
		name
	) VALUES (
		1,
		new._id_,
		new.name
	);

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_after_update_sales AFTER UPDATE ON sales BEGIN

	INSERT INTO _log_sales (
		_event_,
		_id_,
		client_id,
		product_id,
		value
	) VALUES (
		1,
		new._id_,
		new.client_id,
		new.product_id,
		new.value
	);

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_after_delete_clients AFTER DELETE ON clients BEGIN

	INSERT INTO _log_clients (
		_event_,
		_id_
	) VALUES (
		2,
		old._id_
	);

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_after_delete_products AFTER DELETE ON products BEGIN

	INSERT INTO _log_products (
		_event_,
		_id_
	) VALUES (
		2,
		old._id_
	);

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_after_delete_sales AFTER DELETE ON sales BEGIN

	INSERT INTO _log_sales (
		_event_,
		_id_
	) VALUES (
		2,
		old._id_
	);

END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_before_update_log_clients BEFORE UPDATE ON _log_clients BEGIN
	SELECT RAISE(ABORT, 'The log table cannot be changed!') END;
END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_before_update_log_products BEFORE UPDATE ON _log_products BEGIN
	SELECT RAISE(ABORT, 'The log table cannot be changed!') END;
END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_before_update_log_sales BEFORE UPDATE ON _log_sales BEGIN
	SELECT RAISE(ABORT, 'The log table cannot be changed!') END;
END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_before_delete_log_clients BEFORE DELETE ON _log_clients BEGIN
	SELECT RAISE(ABORT, 'The log table cannot be changed!') END;
END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_before_delete_log_products BEFORE DELETE ON _log_products BEGIN
	SELECT RAISE(ABORT, 'The log table cannot be changed!') END;
END;

-------------------------------------------------------------------------------

CREATE TRIGGER IF NOT EXISTS _tr_before_delete_log_sales BEFORE DELETE ON _log_sales BEGIN
	SELECT RAISE(ABORT, 'The log table cannot be changed!') END;
END;
