create table customers (
    id integer primary key,
    name varchar(255),
    birth_date date
);

create table accounts(
    account_id varchar(40) primary key ,
    customer_id integer references customers(id),
    currency varchar(3),
    balance float,
    "limit" float
);

create table transactions (
    id serial primary key ,
    date timestamp,
    src_account varchar(40) references accounts(account_id),
    dst_account varchar(40) references accounts(account_id),
    amount float,
    status varchar(20)
);

INSERT INTO customers VALUES (201, 'John', '2021-11-05');
INSERT INTO customers VALUES (202, 'Anny', '2021-11-02');
INSERT INTO customers VALUES (203, 'Rick', '2021-11-24');

INSERT INTO accounts VALUES ('NT10204', 201, 'KZT', 1000, null);
INSERT INTO accounts VALUES ('AB10203', 202, 'USD', 100, 0);
INSERT INTO accounts VALUES ('DK12000', 203, 'EUR', 500, 200);
INSERT INTO accounts VALUES ('NK90123', 201, 'USD', 400, 0);
INSERT INTO accounts VALUES ('RS88012', 203, 'KZT', 5000, -100);

INSERT INTO transactions VALUES (1, '2021-11-05 18:00:34.000000', 'NT10204', 'RS88012', 1000, 'commited');
INSERT INTO transactions VALUES (2, '2021-11-05 18:01:19.000000', 'NK90123', 'AB10203', 500, 'rollback');
INSERT INTO transactions VALUES (3, '2021-06-05 18:02:45.000000', 'RS88012', 'NT10204', 400, 'init');


-- Task1
-- How can we store large-object types?
-- We can store large objects by 2 ways. There are :
-- 1. blob: binary large object - object is a large collection of uninterpreted binary data
-- 2. clob: character large object -- object is a large collection of character data


--Task2
-- 1. Privilege - the method, when you may authorize the user all, none,or a combination of these
--types of privileges on specified parts of a database, such as a relation or a view
-- 2. Role - a way to distinguish among various users as far as what  these users can access/update in the database
-- 3. User - need to be assigned to the role
--In other words, privilege is ability, role is position.

CREATE ROLE accountant;
CREATE ROLE administrator;
CREATE ROLE support;

GRANT ALL ON customers TO administrator;
GRANT SELECT ON accounts TO accountant;
GRANT INSERT, UPDATE, DELETE ON transactions TO support;

CREATE USER fari;
CREATE USER azi;
CREATE USER don;

GRANT administrator TO fari;
GRANT accountant TO azi;
GRANT support TO don;

REVOKE DELETE ON transactions FROM azi;


-- Task3
ALTER TABLE accounts
ALTER COLUMN "limit" SET NOT NULL;

--Task5
CREATE UNIQUE INDEX index_account123 on accounts(customer_id, currency);

CREATE INDEX index_transaction123 on accounts (currency, balance);

--Task6
BEGIN;
UPDATE accounts SET balance = balance - 100.00 WHERE account_id = 'AB10203';
SAVEPOINT sav;
UPDATE accounts SET balance = balance + 100.00 WHERE account_id = 'NT10204';
-- if in source account balance becomes below limit, then make rollback
ROLLBACK TO sav;
UPDATE accounts SET balance = balance + 100.00 WHERE account_id = 'AB10203';
COMMIT;
