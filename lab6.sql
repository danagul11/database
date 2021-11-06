--Ex1:
--a
SELECT * FROM dealer cross join client;
--b
SELECT d.name, c.name, c.city, c.priority, s.id as sell_number, s.date, s.amount
FROM dealer as d
         inner join client as c on d.id = c.dealer_id
         inner join sell as s on c.id = s.client_id
ORDER BY d.id;
--c
SELECT d.name, c.name, city
from dealer as d
         inner join client as c on d.location = c.city;
--d
SELECT s.id, amount, name, city
FROM sell as s
         inner join client on amount >= 100 AND amount <= 500 and s.client_id = client.id
order by amount;
--e
SELECT d.id, d.name
FROM client
         right join dealer as d on d.id = client.dealer_id;
--f
SELECT c.name, city, d.name, charge
FROM client c inner join dealer d on c.dealer_id = d.id;
--g
SELECT c.name, city, d.name, charge
FROM client c
         inner join dealer d on c.dealer_id = d.id and charge > 0.12;

--h
SELECT c.name, city, s.id, s.date, amount, d.name, charge
FROM client c
         left join dealer d on c.dealer_id = d.id
         left join sell s on c.id = s.client_id;

--i
SELECT c.name, c.city,c.priority, d.name, s.id,s.date, s.amount
FROM client c
         RIGHT OUTER JOIN dealer d
                          ON d.id = c.dealer_id
         LEFT OUTER JOIN sell s
                         ON s.client_id = c.id
WHERE s.amount >= 2000
  and c.priority is NOT NULL;

--Ex2
--a
CREATE VIEW each_date_amount AS
SELECT date, COUNT (DISTINCT client_id),AVG (amount), SUM (amount)
        FROM sell
        GROUP BY date
        ORDER BY date;

--b
CREATE VIEW each_date_sum
AS
SELECT date, sum (amount) FROM sell
        GROUP BY date
        ORDER BY sum (amount) desc limit 5;

--c
CREATE VIEW dealers_sale AS
SELECT dealer_id, count(dealer_id), AVG(amount), SUM(amount)
FROM sell
GROUP BY dealer_id
ORDER BY dealer_id;

--d
CREATE VIEW earnings AS
SELECT location, sum(total)
FROM (SELECT d.location, SUM(amount) * d.charge as total
      FROM sell
               inner join dealer d on sell.dealer_id = d.id
      GROUP BY d.location, d.charge) q
GROUP BY location
having location = q.location;

--e
CREATE VIEW city_dealer AS
SELECT location, count(sell.id), sum(amount), avg(amount)
FROM sell
         inner join dealer on sell.dealer_id = dealer.id
GROUP BY location;

--f
CREATE VIEW each_city AS
SELECT city, count(city), sum(amount), avg(amount)
FROM client
         inner join sell s on client.id = s.client_id
GROUP BY city;

--g
CREATE VIEW q AS
SELECT c
FROM (SELECT sum(amount) AS sales, location AS l
      FROM sell
               INNER JOIN dealer on sell.dealer_id = dealer.id
      GROUP BY location) q
         inner join (select city as c, sum(amount) as expences
                     FROM client
                              inner join sell on client.id = sell.client_id
                     GROUP BY city) w ON expences > sales
    and q.l = w.c;