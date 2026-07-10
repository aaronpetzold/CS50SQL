CREATE DATABASE `linkedin`;

USE `linkedin`;

CREATE TABLE `users` (
    `id` INT AUTO_INCREMENT,
    `first_name` VARCHAR(32) NOT NULL,
    `last_name` VARCHAR(32) NOT NULL,
    `username` VARCHAR(32) NOT NULL UNIQUE,
    `password` VARCHAR(128) NOT NULL,
    PRIMARY KEY(`id`)
); 

CREATE TABLE `schools` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `type` ENUM('Primary', 'Secondary', 'Higher Education') NOT NULL,
    `city` VARCHAR(32) NOT NULL, 
    `state` VARCHAR(32) NOT NULL,
    `country` VARCHAR(32) NOT NULL,
    `year_founded` YEAR NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `companies` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `industry` ENUM('Technology', 'Education', 'Business') NOT NULL,
    `city` VARCHAR(32) NOT NULL, 
    `state` VARCHAR(32) NOT NULL,
    `country` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `user_connections` (
    `id` INT AUTO_INCREMENT,
    `user_a_id` INT,
    `user_b_id` INT,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`user_a_id`) REFERENCES `users`(`id`),
    FOREIGN KEY(`user_b_id`) REFERENCES `users`(`id`)
);

CREATE TABLE `school_connections` (
    `id` INT AUTO_INCREMENT,
    `user_id` INT,
    `school_id` INT,
    `start_affiliation` DATETIME NOT NULL,
    `end_affiliation` DATETIME DEFAULT NULL,
    `degree_type` VARCHAR(16) NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY(`school_id`) REFERENCES `schools`(`id`)
);

CREATE TABLE `company_connections` (
    `id` INT AUTO_INCREMENT,
    `user_id` INT,
    `company_id` INT,
    `title` VARCHAR(64), 
    `start_affiliation` DATETIME NOT NULL,
    `end_affiliation` DATETIME DEFAULT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY(`company_id`) REFERENCES `companies`(`id`)
);

SHOW DATABASES;

SHOW TABLES;