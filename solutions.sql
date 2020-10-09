PRACTICE JOINS
1. SELECT *
FROM invoice i
JOIN invoice_line il ON il.invoice_id = i.invoice_id
WHERE il.unit_price > 0.99;
2.SELECT i.invoice_date, c.first_name, c.last_name, i.total
FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id;
3.SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c
JOIN employee e ON c.support_rep_id = e.employee_id;
4.SELECT al.title, ar.name
FROM album al
JOIN artist ar ON al.artist_id = ar.artist_id;
5.SELECT pt.track_id
FROM playlist_track pt
JOIN playlist p ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music';
6.SELECT t.name
FROM track t
JOIN playlist_track pt ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5;
7.SELECT t.name, p.name
FROM track t
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p ON pt.playlist_id = p.playlist_id;
8.SELECT t.name, a.title
FROM track t
JOIN album a ON t.album_id = a.album_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Alternative & Punk';

PRACTICE NESTED QUERIES
1.SELECT *
FROM invoice
WHERE invoice_id IN ( SELECT invoice_id FROM invoice_line WHERE unit_price > 0.99 );
2.SELECT *
FROM playlist_track
WHERE playlist_id IN ( SELECT playlist_id FROM playlist WHERE name = 'Music' );
3.SELECT name
FROM track
WHERE track_id IN ( SELECT track_id FROM playlist_track WHERE playlist_id = 5 );
4.SELECT *
FROM track
WHERE genre_id IN ( SELECT genre_id FROM genre WHERE name = 'Comedy' );
5.SELECT *
FROM track
WHERE album_id IN ( SELECT album_id FROM album WHERE title = 'Fireball' );
6.SELECT *
FROM track
WHERE album_id IN ( 
  SELECT album_id FROM album WHERE artist_id IN ( 
    SELECT artist_id FROM artist WHERE name = 'Queen'
  )
); 

PRACTICE UPDATING ROWS
1. UPDATE customer
SET fax = null
WHERE fax IS NOT null;
2. UPDATE customer
SET company = 'Self'
WHERE company IS null;
3. UPDATE customer 
SET last_name = 'Thompson' 
WHERE first_name = 'Julia' AND last_name = 'Barnett';
4. UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';
5.UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id = ( SELECT genre_id FROM genre WHERE name = 'Metal' )
AND composer IS null;

GROUP BY
1. SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY g.name;
2.SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;
3. SELECT ar.name, COUNT(*)
FROM album al
JOIN artist ar ON ar.artist_id = al.artist_id
GROUP BY ar.name;

USE DISTINCT
1. SELECT DISTINCT composer
FROM track;
2.SELECT DISTINCT billing_postal_code
FROM invoice;
3. SELECT DISTINCT company
FROM customer;

DELETE ROWS
1.DELETE 
FROM practice_delete 
WHERE type = 'bronze';
2.DELETE 
FROM practice_delete 
WHERE type = 'silver';
3.DELETE 
FROM practice_delete 
WHERE value = 150;

ECOMMERCE SIMULATION

1. CREATE TABLE users(
    id SERIAL PRIMARY KEY NOT NULL,
    user_name VARCHAR(60) NOT NULL,
    user_email VARCHAR(100) NOT NULL
);
-- (Create products table - id, name, price)
CREATE TABLE products(
    id SERIAL PRIMARY KEY NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    product_price FLOAT(2) NOT NULL
);
-- (Create orders table - id, user_id, date )
CREATE TABLE orders(
    id SERIAL PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    order_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
     CONSTRAINT fk_user
     	FOREIGN KEY(user_id) 
	  		REFERENCES users(id)
);
-- (Create users_orders_products table - id, order_id, product_id, quantity)
CREATE TABLE users_orders_products(
    id SERIAL PRIMARY KEY NOT NULL,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT fk_order
     	FOREIGN KEY(order_id) 
	  		REFERENCES orders(id),
    CONSTRAINT fk_product
     	FOREIGN KEY(product_id) 
	  		REFERENCES products(id)          
);
-- Add 3 users
INSERT INTO users (user_name, user_email) 
VALUES 
('JANE SMITH', 'JS@AOL.COM'),
('FRED FLINSTONE', 'FF@MSN.COM'),
('BETTY WHITE', 'BW@fHOTMAIL.COM');
-- Add 3 products
INSERT INTO products (product_name, product_price) 
VALUES 
('JEANS', 187.43),
('EARRINGS', 8.23),
('CANDLES', 112.44);
-- Add 3 orders
INSERT INTO orders (user_id)
VALUES 
(1),
(2),
(3);
-- Add products/qty to order
INSERT INTO users_orders_products (order_id, product_id, quantity) 
VALUES 
(1, 1, 3),
(1, 2, 1),
(1, 3, 5);

INSERT INTO users_orders_products (order_id, product_id, quantity) 
VALUES 
(2, 1, 3),
(2, 2, 10);

INSERT INTO users_orders_products (order_id, product_id, quantity) 
VALUES 
(3, 1, 13),
(3, 3, 100);
-- Get all products for the first order.
SELECT * FROM users_orders_products WHERE order_id = 1;
-- Get all orders.
SELECT * FROM orders;
-- Get the total cost of an order ( sum the price of all products on an order ).
SELECT SUM (quantity * products.product_price) AS total FROM users_orders_products 
INNER JOIN products ON products.id = users_orders_products.product_id WHERE order_id = 1;

