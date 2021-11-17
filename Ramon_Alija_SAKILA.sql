
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP SCHEMA sakila_v2 ;
CREATE SCHEMA sakila_v2 ;
USE sakila_v2 ;

CREATE TABLE actor (
  actor_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (actor_id),
  INDEX idx_actor_last_name (last_name ASC)
) ENGINE = InnoDB AUTO_INCREMENT = 201;


CREATE TABLE country (
  country_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  country VARCHAR(50) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (country_id)
) ENGINE = InnoDB AUTO_INCREMENT = 110;


CREATE TABLE city (
  city_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  city VARCHAR(50) NOT NULL,
  country_id INT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (city_id),
  INDEX idx_fk_country_id (country_id ASC),
  CONSTRAINT fk_city_country
    FOREIGN KEY (country_id) REFERENCES country (country_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 601;


CREATE TABLE address (
  address_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) NULL DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id INT UNSIGNED NOT NULL,
  postal_code VARCHAR(10) NULL DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (address_id),
  INDEX idx_fk_city_id (city_id ASC),
  CONSTRAINT fk_address_city
    FOREIGN KEY (city_id) REFERENCES city (city_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;



CREATE TABLE category (
  category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(25) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE current_timestamp,
  PRIMARY KEY (category_id)
) ENGINE = InnoDB AUTO_INCREMENT = 17;


-- BUGADA
CREATE TABLE staff (
  staff_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  address_id INT UNSIGNED NOT NULL,
  picture BLOB NULL,
  email VARCHAR(50) NULL DEFAULT NULL,
  store_id INT UNSIGNED NOT NULL,
  active INT(1) NOT NULL DEFAULT TRUE,
  username VARCHAR(16) NOT NULL,
  password VARCHAR(40) BINARY NULL DEFAULT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE current_timestamp,
  PRIMARY KEY (staff_id),
  INDEX idx_fk_store_id (store_id ASC),
  INDEX idx_fk_address_id (address_id ASC),
  CONSTRAINT fk_staff_store
    FOREIGN KEY (store_id) REFERENCES store (store_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_staff_address
    FOREIGN KEY (address_id) REFERENCES address (address_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 200;


-- BUGADA
CREATE TABLE store (
  store_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  manager_staff_id INT UNSIGNED NOT NULL,
  address_id INT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE current_timestamp,
  PRIMARY KEY (store_id),
  UNIQUE INDEX idx_unique_manager (manager_staff_id ASC),
  INDEX idx_fk_address_id (address_id ASC),
  CONSTRAINT fk_store_staff
    FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_store_address
    FOREIGN KEY (address_id) REFERENCES address (address_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8;


-- BUGADA
CREATE TABLE customer (
  customer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  store_id INT UNSIGNED NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) NULL DEFAULT NULL,
  address_id INT UNSIGNED NOT NULL,
  active INT(1) NOT NULL DEFAULT TRUE,
  create_date DATETIME NOT NULL,
  last_update TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE current_timestamp,
  PRIMARY KEY (customer_id),
  INDEX idx_fk_store_id (store_id ASC),
  INDEX idx_fk_address_id (address_id ASC),
  INDEX idx_last_name (last_name ASC),
  CONSTRAINT fk_customer_address
    FOREIGN KEY (address_id) REFERENCES address (address_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_customer_store
    FOREIGN KEY (store_id) REFERENCES store (store_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8
COMMENT = 'Table storing all customers. Holds foreign keys to the address table and the store table where this customer is registered.\n\nBasic information about the customer like first and last name are stored in the table itself. Same for the date the record was created and when the information was last updated.';


CREATE TABLE language (
  language_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name CHAR(20) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE current_timestamp,
  PRIMARY KEY (language_id)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8;


CREATE TABLE film (
  film_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  description TEXT NULL,
  release_year YEAR NULL,
  language_id INT UNSIGNED NOT NULL,
  original_language_id INT UNSIGNED NULL DEFAULT NULL,
  rental_duration INT UNSIGNED NOT NULL DEFAULT 3,
  rental_rate DECIMAL(4,2) NOT NULL DEFAULT 4.99,
  length INT UNSIGNED NULL DEFAULT NULL,
  replacement_cost DECIMAL(5,2) NOT NULL DEFAULT 19.99,
  rating ENUM('G','PG','PG-13','R','NC-17') NULL DEFAULT 'G',
  special_features SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE current_timestamp,
  INDEX idx_title (title ASC),
  INDEX idx_fk_language_id (language_id ASC),
  INDEX idx_fk_original_language_id (original_language_id ASC),
  PRIMARY KEY (film_id),
  CONSTRAINT fk_film_language
    FOREIGN KEY (language_id) REFERENCES language (language_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_language_original
    FOREIGN KEY (original_language_id) REFERENCES language (language_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8;


CREATE TABLE film_actor (
  actor_id INT UNSIGNED NOT NULL,
  film_id INT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE current_timestamp,
  PRIMARY KEY (actor_id, film_id),
  INDEX idx_fk_film_id (film_id ASC),
  INDEX fk_film_actor_actor_idx (actor_id ASC),
  CONSTRAINT fk_film_actor_actor
    FOREIGN KEY (actor_id) REFERENCES actor (actor_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_actor_film
    FOREIGN KEY (film_id) REFERENCES film (film_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8;


CREATE TABLE film_category (
  film_id INT UNSIGNED NOT NULL,
  category_id INT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE current_timestamp,
  PRIMARY KEY (film_id, category_id),
  INDEX fk_film_category_category_idx (category_id ASC),
  INDEX fk_film_category_film_idx (film_id ASC),
  CONSTRAINT fk_film_category_film
    FOREIGN KEY (film_id) REFERENCES film (film_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_category_category
    FOREIGN KEY (category_id) REFERENCES category (category_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8;


CREATE TABLE film_text (
  film_id INT UNSIGNED NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NULL,
  PRIMARY KEY (film_id),
  FULLTEXT INDEX idx_title_description (title, description)
) ENGINE = InnoDB;


-- BUGADA
CREATE TABLE inventory (
  inventory_id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  film_id INT UNSIGNED NOT NULL,
  store_id INT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE current_timestamp,
  PRIMARY KEY (inventory_id),
  INDEX idx_fk_film_id (film_id ASC),
  INDEX idx_store_id_film_id (store_id ASC, film_id ASC),
  INDEX fk_inventory_store_idx (store_id ASC),
  CONSTRAINT fk_inventory_store
    FOREIGN KEY (store_id) REFERENCES store (store_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_inventory_film
    FOREIGN KEY (film_id) REFERENCES film (film_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8;


-- BUGADA
CREATE TABLE rental (
  rental_id INT NOT NULL AUTO_INCREMENT,
  rental_date DATETIME NOT NULL,
  inventory_id MEDIUMINT UNSIGNED NOT NULL,
  customer_id INT UNSIGNED NOT NULL,
  return_date DATETIME NULL,
  staff_id INT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE current_timestamp,
  PRIMARY KEY (rental_id),
  UNIQUE INDEX idx_rental (rental_date ASC, inventory_id ASC, customer_id ASC),
  INDEX idx_fk_inventory_id (inventory_id ASC),
  INDEX idx_fk_customer_id (customer_id ASC),
  INDEX idx_fk_staff_id (staff_id ASC),
  CONSTRAINT fk_rental_staff
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rental_inventory
    FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rental_customer
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8;


-- BUGADA
CREATE TABLE payment (
  payment_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  customer_id INT UNSIGNED NOT NULL,
  staff_id INT UNSIGNED NOT NULL,
  rental_id INT NULL DEFAULT NULL,
  amount DECIMAL(5,2) NOT NULL,
  payment_date DATETIME NOT NULL,
  last_update TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
	ON UPDATE current_timestamp,
  PRIMARY KEY (payment_id),
  INDEX idx_fk_staff_id (staff_id ASC),
  INDEX idx_fk_customer_id (customer_id ASC),
  INDEX fk_payment_rental_idx (rental_id ASC),
  CONSTRAINT fk_payment_rental
    FOREIGN KEY (rental_id) REFERENCES rental (rental_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_payment_customer
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_payment_staff
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB auto_increment = 16050;


-- #################################################################################################################################################################################
-- ########################################################################################################################################################################################################################################################
DELIMITER $$
CREATE PROCEDURE rewards_report (
    IN min_monthly_purchases INT UNSIGNED, 
    IN min_dollar_amount_purchased DECIMAL(10,2) UNSIGNED,
    OUT count_rewardees INT
)
LANGUAGE SQL
NOT DETERMINISTIC 
READS SQL DATA
SQL SECURITY DEFINER

proc: BEGIN
    
    DECLARE last_month_start DATE;
    DECLARE last_month_end DATE;

    IF min_monthly_purchases = 0 THEN
        SELECT 'Minimum monthly purchases parameter must be > 0';
        LEAVE proc;
    END IF;
    
    IF min_dollar_amount_purchased = 0.00 THEN
        SELECT 'Minimum monthly dollar amount purchased parameter must be > $0.00';
        LEAVE proc;
    END IF;

    SET last_month_start = DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH);
    SET last_month_start = STR_TO_DATE(CONCAT(YEAR(last_month_start),'-',MONTH(last_month_start),'-01'),'%Y-%m-%d');
    SET last_month_end = LAST_DAY(last_month_start);

    CREATE TEMPORARY TABLE tmpCustomer (customer_id INT UNSIGNED NOT NULL PRIMARY KEY);

    INSERT INTO tmpCustomer (customer_id)
    SELECT p.customer_id 
    FROM payment AS p
    WHERE DATE(p.payment_date) BETWEEN last_month_start AND last_month_end
    GROUP BY customer_id
    HAVING SUM(p.amount) > min_dollar_amount_purchased
    AND COUNT(customer_id) > min_monthly_purchases;

    SELECT COUNT(*) FROM tmpCustomer INTO count_rewardees;

    SELECT c.* 
    FROM tmpCustomer AS t   
    INNER JOIN customer AS c ON t.customer_id = c.customer_id;

    DROP TABLE tmpCustomer;
END$$

DELIMITER ;

DELIMITER $$


CREATE FUNCTION get_customer_balance
	(p_customer_id INT, p_effective_date DATETIME) RETURNS DECIMAL(5,2)
DETERMINISTIC

	READS SQL DATA

BEGIN

  DECLARE v_rentfees DECIMAL(5,2); #FEES PAID TO RENT THE VIDEOS INITIALLY
  DECLARE v_overfees INTEGER;      #LATE FEES FOR PRIOR RENTALS
  DECLARE v_payments DECIMAL(5,2); #SUM OF PAYMENTS MADE PREVIOUSLY

SELECT 
	IFNULL(
		SUM(film.rental_rate),0) INTO v_rentfees
        
FROM film, inventory, rental

WHERE film.film_id = inventory.film_id AND
	inventory.inventory_id = rental.inventory_id AND
    rental.rental_date <= p_effective_date AND
    rental.customer_id = p_customer_id
;

SELECT 
	IFNULL(
		SUM(
			IF(
				(TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) > film.rental_duration,
				((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) - film.rental_duration),0
			)
		),0
	) INTO v_overfees
    
FROM 
	rental,
	inventory,
    film 
    WHERE film.film_id = inventory.film_id AND
	inventory.inventory_id = rental.inventory_id AND
    rental.rental_date <= p_effective_date AND
    rental.customer_id = p_customer_id
;

SELECT 
	IFNULL(
		SUM(payment.amount),0
	) INTO v_payments
    
FROM payment
WHERE payment.payment_date <= p_effective_date AND
	payment.customer_id = p_customer_id
;
  RETURN v_rentfees + v_overfees - v_payments;
END$$

DELIMITER ;


DELIMITER $$


CREATE PROCEDURE film_in_stock(
	IN p_film_id INT,
    IN p_store_id INT,
    OUT p_film_count INT
)
	READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     SELECT FOUND_ROWS() INTO p_film_count;
END$$

DELIMITER ;

DELIMITER $$


CREATE PROCEDURE film_not_in_stock(
	IN p_film_id INT,
    IN p_store_id INT,
    OUT p_film_count INT
)
	READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND NOT inventory_in_stock(inventory_id);

     SELECT FOUND_ROWS() INTO p_film_count;
END$$

DELIMITER ;

DELIMITER $$


CREATE FUNCTION inventory_held_by_customer(
	p_inventory_id INT
) RETURNS INT

	READS SQL DATA
    
BEGIN
  DECLARE v_customer_id INT;
  DECLARE EXIT HANDLER FOR NOT FOUND RETURN NULL;

  SELECT customer_id INTO v_customer_id
  FROM rental
  WHERE return_date IS NULL
  AND inventory_id = p_inventory_id;

  RETURN v_customer_id;
END$$

DELIMITER ;

DELIMITER $$


CREATE FUNCTION inventory_in_stock(
	p_inventory_id INT
) RETURNS BOOLEAN

	READS SQL DATA
    
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
	FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END$$

DELIMITER ;



-- ################################################################################################################################################################################################################################################
-- ################################################################################################################################################################################################################################################

CREATE  OR REPLACE
VIEW customer_list AS 
	SELECT cu.customer_id AS ID,
		CONCAT(cu.first_name, _utf8' ', cu.last_name) AS name,
		a.address AS address,
		a.postal_code AS zip_code,
		a.phone AS phone,
		city.city AS city,
		country.country AS country,
		IF(cu.active, _utf8'active',_utf8'') AS notes, cu.store_id AS SID 
	FROM customer AS cu
		JOIN address AS a USING (address_id)
        JOIN city USING (city_id)
		JOIN country USING (country_id)
;


CREATE  OR REPLACE 
VIEW film_list AS 
	SELECT film.film_id AS FID,
		film.title AS title,
		film.description AS description,
		category.name AS category,
		film.rental_rate AS price,
		film.length AS length,
		film.rating AS rating,
		GROUP_CONCAT(CONCAT(actor.first_name, _utf8' ', actor.last_name) SEPARATOR ', ') AS actors 
	FROM category LEFT 
		JOIN film_category ON category.category_id = film_category.category_id LEFT JOIN film ON film_category.film_id = film.film_id
        JOIN film_actor ON film.film_id = film_actor.film_id 
		JOIN actor ON film_actor.actor_id = actor.actor_id 
	GROUP BY 
		film.film_id,
        category.name
;


CREATE  OR REPLACE
VIEW nicer_but_slower_film_list AS 
	SELECT film.film_id AS FID,
		film.title AS title,
        film.description AS description,
        category.name AS category,
        film.rental_rate AS price, 
		film.length AS length,
        film.rating AS rating,
        GROUP_CONCAT(
			CONCAT(
				CONCAT(
					UCASE(
						SUBSTR(actor.first_name,1,1)
					),
					LCASE(
						SUBSTR(actor.first_name,2,
                        LENGTH(actor.first_name))
					),
                    _utf8' ',
					CONCAT(
						UCASE(
							SUBSTR(actor.last_name,1,1)
						),
						LCASE(
							SUBSTR(actor.last_name,2,
                            LENGTH(actor.last_name))
						)
					)
				)
			)
		) AS actors 
	FROM category 
		LEFT JOIN film_category USING (category_id) 
		LEFT JOIN film USING (film_id)
		JOIN film_actor USING (film_id)
		JOIN actor USING (actor_id) 
	GROUP BY 
		film.film_id,
        category.name
;


CREATE  OR REPLACE
VIEW staff_list AS 
	SELECT s.staff_id AS ID,
		CONCAT(s.first_name, _utf8' ', s.last_name) AS name,
        a.address AS address,
        a.postal_code AS zip_code,
        a.phone AS phone,
		city.city AS city,
        country.country AS country,
        s.store_id AS SID 
	FROM staff AS s 
		JOIN address AS a USING (address_id)
		JOIN city USING (city_id)
		JOIN country USING (country_id)
;


CREATE  OR REPLACE
VIEW sales_by_store AS 
	SELECT 
		CONCAT(c.city, _utf8',', cy.country) AS store,
        CONCAT(m.first_name, _utf8' ', m.last_name) AS manager,
        SUM(p.amount) AS total_sales
	FROM payment AS p
		INNER JOIN rental AS r USING (rental_id)
		INNER JOIN inventory AS i USING (inventory_id)
		INNER JOIN store AS s USING (store_id)
		INNER JOIN address AS a USING (address_id)
		INNER JOIN city AS c USING (city_id)
		INNER JOIN country AS cy USING (country_id)
		INNER JOIN staff AS m ON s.manager_staff_id = m.staff_id
	GROUP BY s.store_id
	ORDER BY 
		cy.country,
        c.city
;


CREATE  OR REPLACE
VIEW sales_by_film_category AS 
	SELECT 
		c.name AS category,
        SUM(p.amount) AS total_sales
	FROM payment AS p
		INNER JOIN rental AS r USING (rental_id)
		INNER JOIN inventory AS i USING (inventory_id)
		INNER JOIN film AS f USING (film_id)
		INNER JOIN film_category AS fc USING (film_id)
		INNER JOIN category AS c USING (category_id)
	GROUP BY c.name
	ORDER BY total_sales DESC
;


CREATE  OR REPLACE
	DEFINER=CURRENT_USER
    SQL SECURITY INVOKER
VIEW actor_info AS
	SELECT      
		a.actor_id,
		a.first_name,
		a.last_name,
		GROUP_CONCAT(DISTINCT 
			CONCAT(c.name, ': ',
				(SELECT 
					GROUP_CONCAT(f.title ORDER BY f.title)
				FROM film f 
                    INNER JOIN film_category fc USING (film_id)
					INNER JOIN film_actor fa USING (film_id)
                    
				WHERE 
					fc.category_id = c.category_id AND
                    fa.actor_id = a.actor_id ORDER BY c.name 
				)
			)
		) AS film_info
                
	FROM actor a 
		LEFT JOIN film_actor fa USING (actor_id)
		LEFT JOIN film_category fc USING (film_id)
		LEFT JOIN category c USING (category_id)
	GROUP BY
		a.actor_id,
		a.first_name,
		a.last_name
;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
