--Task1
--a
create function inc(val integer) returns integer
    language plpgsql
as
$$
BEGIN RETURN val + 1; END;
$$;

SELECT * FROM inc(5);

--b
create function sum(val integer,val2 integer) returns integer
    language plpgsql
as
$$
BEGIN RETURN val + val2; END;
$$;

SELECT * FROM sum(5,6);

--c
create function check_divas(num numeric) returns BOOLEAN
    language plpgsql
as
$$
BEGIN
    IF ( num%2=0)

        then return true;
    else
        return false;
     END IF;

END;
$$;

SELECT * FROM check_divas(7);

--d
create function check_pass(pass text) returns BOOLEAN
    language plpgsql
as
$$
BEGIN
    IF (length(pass) > 10)

        then return true;
    else
        return false;
     END IF;

END;
$$;

SELECT * FROM check_pass('qwertyuioqq');

--e
create or replace function splitting(text varchar(30)) returns record
    language plpgsql
as
$$
declare text1 record;
begin
    select split_part(text, ',', 1) ,
           split_part(text, ',', 2)
           into text1;
    return text1;
end;
$$;
select splitting('hello,world');


--Task2
--a
create table change_t(
    times timestamp
);
create table query(
    operation varchar
);
create or replace function curr_time() returns trigger
   as $$
   begin
       insert into change_t values(now());
       return new;
   end;
   $$ language plpgsql;
create trigger process_t before insert or update or delete on query
    for each statement execute procedure curr_time();

insert into query values('insert');
update query set operation = 'update' where operation='insert';
select * from change_t;

--b
create table person(
    name varchar,
    year_birth integer
);
create table age(
    name varchar,
    age integer
);
create or replace function solve() returns trigger
 as $$
   begin

       insert into age values(new.name,2021-new.year_birth);
       return new;
   end;
   $$ language plpgsql;
create trigger tr_person after insert on person
    for each row execute procedure solve();

insert into person values ('Fariza',2001);
insert into person values ('Aziza',1995);
insert into person values ('Dancho',2002);
insert into person values ('Damir',1999);
select * from age;

-- c
CREATE table food(
    id integer primary key,
    name varchar(50),
    price integer
);

create or replace FUNCTION total()
returns trigger
    language plpgsql
    as

    $$
        BEGIN
            update food
            set price=price+0.12*price
            where id = new.id;
            return new;
        end;
    $$;


create trigger cost after insert on food
    for each row execute procedure total();
insert into food(id, name,price) values (1, 'wood', 100);
insert into food(id,name,price) values (3, 'stone', 50);

-- d
create or replace function reset() returns trigger language plpgsql
    as $$
    begin
        insert into food(id,name,price) values(old.id,old.name,old.price);
        return old;
    end;
    $$;

create trigger back
    after delete
    on food
    for each row
    execute procedure reset();
delete from food where id=2;
select * from food;

--Task3
-- A function is used to calculate result using given inputs.A procedure is used to perform certain task in order.
-- A function can be called by a procedure.A procedure cannot be called by a function.
-- A function returns a value and control to calling function or code.A procedure returns the control but not any value to calling function or code.

--Task4
create table employees(
    id int not null unique primary key ,
    name varchar(50) not null ,
    date_of_birth date not null ,
    age int not null ,
    salary int not null ,
    workexperience int not null ,
    discount int not null
);
insert into employees values (1,'Arman','12-06-1998',25,55000,1,7000);
insert into employees values (2,'Alan','12-04-1985',36,65000,3,6000);
insert into employees values (3,'Didar','11-12-1967',54,200000,10,14000);
insert into employees values (4,'Dauren','01-02-1995',29,40000,4,5000);
--a
create or replace procedure increase()
      as $$
      begin
          update employees set salary = salary*1.1 where workexperience>=2;
          update employees set discount=discount*1.1 where workexperience>=2;
          update employees set discount = discount*1.01 where workexperience>=5;
      end; $$
      language plpgsql;
call increase();
select * from employees;

--b
create or replace procedure increase2()
      as $$
      begin
          update employees set salary = salary*1.15 where age>=40;
          update employees set salary = salary*1.15 where workexperience>=8;
          update employees set discount = discount*1.20  where workexperience>=8;
      end; $$
      language plpgsql;
call increase2();