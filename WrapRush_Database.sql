-- Create the database if it does not exist
CREATE DATABASE IF NOT EXISTS wraprush;

-- Switch to the newly created or existing database
USE wraprush;

-- Create the 'driver' table
CREATE TABLE IF NOT EXISTS driver (
    driver_id INTEGER,
    reg_date DATE
);

-- Insert data into the 'driver' table
INSERT INTO driver (driver_id, reg_date) 
VALUES 
    (1, '2021-01-01'),
    (2, '2021-01-03'),
    (3, '2021-01-8'),
    (4, '2021-01-15');

-- Create the 'ingredients' table
CREATE TABLE IF NOT EXISTS ingredients (
    ingredients_id INTEGER,
    ingredients_name VARCHAR(60)
);

-- Insert data into the 'ingredients' table
INSERT INTO ingredients (ingredients_id, ingredients_name) 
VALUES 
    (1, 'BBQ Chicken'),
    (2, 'Chilli Sauce'),
    (3, 'Chicken'),
    (4, 'Cheese'),
    (5, 'Kebab'),
    (6, 'Mushrooms'),
    (7, 'Onions'),
    (8, 'Egg'),
    (9, 'Peppers'),
    (10, 'Schezwan Sauce'),
    (11, 'Tomatoes'),
    (12, 'Tomato Sauce');

-- Create the 'rolls' table
CREATE TABLE IF NOT EXISTS rolls (
    roll_id INTEGER,
    roll_name VARCHAR(30)
);

-- Insert data into the 'rolls' table
INSERT INTO rolls (roll_id, roll_name) 
VALUES 
    (1, 'Non Veg Roll'),
    (2, 'Veg Roll');

-- Create the 'rolls_recipes' table
CREATE TABLE IF NOT EXISTS rolls_recipes (
    roll_id INTEGER,
    ingredients VARCHAR(24)
);

-- Insert data into the 'rolls_recipes' table
INSERT INTO rolls_recipes (roll_id, ingredients) 
VALUES 
    (1, '1,2,3,4,5,6,8,10'),
    (2, '4,6,7,9,11,12');

-- Create the 'driver_order' table
CREATE TABLE IF NOT EXISTS driver_order (
    order_id INTEGER,
    driver_id INTEGER,
    pickup_time DATETIME,
    distance VARCHAR(7),
    duration VARCHAR(10),
    cancellation VARCHAR(23)
);

-- Insert data into the 'driver_order' table
INSERT INTO driver_order (order_id, driver_id, pickup_time, distance, duration, cancellation) 
VALUES
    (1, 1, '2021-01-01 18:15:34', '20km', '32 minutes', ''),
    (2, 1, '2021-01-01 19:10:54', '20km', '27 minutes', ''),
    (3, 1, '2021-01-03 00:12:37', '13.4km', '20 mins', 'NaN'),
    (4, 2, '2021-01-04 13:53:03', '23.4', '40', 'NaN'),
    (5, 3, '2021-01-08 21:10:57', '10', '15', 'NaN'),
    (6, 3, NULL, NULL, NULL, 'Cancellation'),
    (7, 2, '2021-01-08 21:30:45', '25km', '25mins', NULL),
    (8, 2, '2021-01-10 00:15:02', '23.4 km', '15 minute', NULL),
    (9, 2, NULL, NULL, NULL, 'Customer Cancellation'),
    (10, 1, '2021-01-11 18:50:20', '10km', '10minutes', NULL);

-- Create the 'customer_orders' table
CREATE TABLE IF NOT EXISTS customer_orders (
    order_id INTEGER,
    customer_id INTEGER,
    roll_id INTEGER,
    not_include_items VARCHAR(4),
    extra_items_included VARCHAR(4),
    order_date DATETIME
);

-- Insert data into the 'customer_orders' table
INSERT INTO customer_orders (order_id, customer_id, roll_id, not_include_items, extra_items_included, order_date) 
VALUES
    (1, 101, 1, '', '', '2021-01-01 18:05:02'),
    (2, 101, 1, '', '', '2021-01-01 19:00:52'),
    (3, 102, 1, '', '', '2021-01-02 23:51:23'),
    (3, 102, 2, '', 'NaN', '2021-01-02 23:51:23'),
    (4, 103, 1, '4', '', '2021-01-04 13:23:46'),
    (4, 103, 1, '4', '', '2021-01-04 13:23:46'),
    (4, 103, 2, '4', '', '2021-01-04 13:23:46'),
    (5, 104, 1, NULL, '1', '2021-01-08 21:00:29'),
    (6, 101, 2, NULL, NULL, '2021-01-08 21:03:13'),
    (7, 105, 2, NULL, '1', '2021-01-08 21:20:29'),
    (8, 102, 1, NULL, NULL, '2021-01-09 23:54:33'),
    (9, 103, 1, '4', '1,5', '2021-01-10 11:22:59'),
    (10, 104, 1, NULL, NULL, '2021-01-11 18:34:49'),
    (10, 104, 1, '2,6', '1,4', '2021-01-11 18:34:49');

-- Select data from your tables
SELECT * FROM customer_orders;
SELECT * FROM driver_order;
SELECT * FROM ingredients;
SELECT * FROM driver;
SELECT * FROM rolls;
SELECT * FROM rolls_recipes;
