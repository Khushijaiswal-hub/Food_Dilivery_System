CREATE DATABASE food_delivery;
USE food_delivery;
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    rating DECIMAL(2,1)
);

CREATE TABLE menu (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT,
    item_name VARCHAR(100),
    price DECIMAL(10,2),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);
CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    quantity INT,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES menu(item_id)
);
CREATE TABLE delivery (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    delivery_time INT, -- minutes
    delivery_status VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
INSERT INTO customers (name, email) VALUES
('Rahul', 'rahul@gmail.com'),
('Anita', 'anita@gmail.com');

INSERT INTO restaurants (name, location, rating) VALUES
('Pizza Hub', 'Bhopal', 4.5),
('Burger Point', 'Bhopal', 4.2);

INSERT INTO menu (restaurant_id, item_name, price) VALUES
(1, 'Pizza', 300),
(2, 'Burger', 150);
SELECT c.name, r.name AS restaurant, o.order_id, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id;
SELECT r.name, SUM(m.price * oi.quantity) AS revenue
FROM order_items oi
JOIN menu m ON oi.item_id = m.item_id
JOIN restaurants r ON m.restaurant_id = r.restaurant_id
GROUP BY r.name;
SELECT r.name, COUNT(o.order_id) AS total_orders
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.name
ORDER BY total_orders DESC;
SELECT AVG(delivery_time) AS avg_time
FROM delivery;
DELIMITER //

CREATE TRIGGER update_order_status
AFTER INSERT ON delivery
FOR EACH ROW
BEGIN
    UPDATE orders
    SET status = 'Delivered'
    WHERE order_id = NEW.order_id;
END //
ALTER TABLE order_items ADD CHECK (quantity > 0);
CREATE INDEX idx_customer ON orders(customer_id);

