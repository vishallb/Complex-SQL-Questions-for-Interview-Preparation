/* Write a SQL query to find for each seller, whether the brand of the second item (by date) they sold is their favorite brand.
If a seller sold less than two items, report the answer for that seller as no. o/p */

-- DDL
 CREATE TABLE users (
    user_id         INT,
    join_date       DATE,
    favorite_brand  VARCHAR(50)
);

CREATE TABLE orders (
    order_id       INT,
    order_date     DATE,
    item_id        INT,
    buyer_id       INT,
    seller_id      INT
);

CREATE TABLE items (
    item_id        INT,
    item_brand     VARCHAR(50)
);

INSERT INTO users (user_id, join_date, favorite_brand)
VALUES
    (1, '2019-01-01', 'Lenovo'),
    (2, '2019-02-09', 'Samsung'),
    (3, '2019-01-19', 'LG'),
    (4, '2019-05-21', 'HP');

INSERT INTO items (item_id, item_brand)
VALUES
    (1, 'Samsung'),
    (2, 'Lenovo'),
    (3, 'LG'),
    (4, 'HP');

INSERT INTO orders (order_id, order_date, item_id, buyer_id, seller_id)
VALUES
    (1, '2019-08-01', 4, 1, 2),
    (2, '2019-08-02', 2, 1, 3),
    (3, '2019-08-03', 3, 2, 3),
    (4, '2019-08-04', 1, 4, 2),
    (5, '2019-08-04', 1, 3, 4),
    (6, '2019-08-05', 2, 2, 4);

-- Solution
WITH cte as (
	SELECT
		o.order_date,
		o.seller_id,
		u.favorite_brand,
		o.item_id,
		i.item_brand as item_sold,
		ROW_NUMBER() OVER(PARTITION BY o.seller_id ORDER BY order_date) as rn
	FROM
		orders o
	INNER JOIN users u 
	ON o.seller_id = u.user_id
	INNER JOIN items i
	ON i.item_id = o.item_id
)

SELECT
	user_id,
	CASE
        WHEN c.favorite_brand = c.item_sold THEN 'Yes' 
		ELSE 'No'
	END as '2nd_item_fav_brand'
FROM
	users u 
LEFT JOIN cte c
ON u.user_id = c.seller_id AND rn = 2;
