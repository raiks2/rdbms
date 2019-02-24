CREATE DATABASE restaurant CHARACTER SET utf8;

USE restaurant;

CREATE TABLE IF NOT EXISTS client (
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    lastname varchar(45) NOT NULL,
    firstname varchar(45) NOT NULL,
    phone varchar(50) DEFAULT NULL,
    email varchar(50) DEFAULT NULL,

    INDEX idx_client_last_name (lastname),
    INDEX idx_client_first_and_last_name (lastname, firstname)
);

CREATE TABLE IF NOT EXISTS client_discount (
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    discount DECIMAL(9,2) NOT NULL DEFAULT 0.00,
    is_relative BOOLEAN NOT NULL DEFAULT false,
    created_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    closed_datetime DATETIME DEFAULT NULL,
    client_id INT,

    FOREIGN KEY (client_id) REFERENCES client(id)   
);

CREATE TABLE IF NOT EXISTS waiter (
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    lastname varchar(45) NOT NULL,
    firstname varchar(45) NOT NULL,
    phone varchar(50) DEFAULT NULL,
    email varchar(50) DEFAULT NULL,
    INDEX idx_waiter_last_name (lastname),
    INDEX idx_waiter_first_and_last_name (lastname, firstname)
);

CREATE TABLE IF NOT EXISTS payment_method (
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name varchar(25) NOT NULL,
    description varchar(125),
    CONSTRAINT u_payment_method_name UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS dish (
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    description TEXT DEFAULT NULL,
    net_price DECIMAL(9,2) NOT NULL DEFAULT 0.00,
    sale_price DECIMAL(9,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT u_dish_name UNIQUE (name)
);


CREATE TABLE IF NOT EXISTS dish_discount (
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    discount DECIMAL(9,2) NOT NULL DEFAULT 0.00,
    is_relative BOOLEAN NOT NULL DEFAULT false,
    created_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    closed_datetime DATETIME DEFAULT NULL,
    dish_id INT,

    FOREIGN KEY (dish_id) REFERENCES dish(id)   
);

CREATE TABLE IF NOT EXISTS meal_order (
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    table_number TINYINT NOT NULL DEFAULT 1,
    total_amount DECIMAL(9,2) NOT NULL DEFAULT 0.00,
    tips DECIMAL(9,2) NOT NULL DEFAULT 0.00,
    status ENUM('accepted', 'paid', 'ready') NOT NULL DEFAULT 'accepted',
    payment_datetime DATETIME DEFAULT NULL,
    modified_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_method_id INT NOT NULL,
    waiter_id INT NOT NULL,
    client_id INT DEFAULT NULL,  

    INDEX idx_order_status (status),
    INDEX idx_order_datetime_paid_at (datetime_paid_at),

    FOREIGN KEY (payment_method_id) REFERENCES payment_method(id),
    FOREIGN KEY (waiter_id) REFERENCES waiter(id),
    FOREIGN KEY (client_id) REFERENCES client(id)
);


CREATE TABLE IF NOT EXISTS order_dish ( 
    order_id INT NOT NULL,
    dish_id INT NOT NULL,

    FOREIGN KEY (order_id) REFERENCES meal_order(id),
    FOREIGN KEY (dish_id) REFERENCES dish(id),

    CONSTRAINT uc_order_dish UNIQUE (order_id, dish_id)
);
