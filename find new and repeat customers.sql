/* Given the input for a number of orders on each different day with customer_id and amount, find the number of repeat customers and new customers for each day */

-- DDL statement
create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000)
;

# solution
WITH first_visit as (
	SELECT
		customer_id,
        MIN(order_date) as first_visit_date
	FROM
		customer_orders
	GROUP BY 1)

SELECT
	c.order_date,
    COUNT(CASE
			WHEN c.order_date = f.first_visit_date THEN 1 ELSE NULL END) new_customer,
	COUNT(CASE
			WHEN c.order_date != f.first_visit_date THEN 1 ELSE NULL END) repeat_customer
FROM
	customer_orders c
LEFT JOIN first_visit f
ON c.customer_id = f.customer_id
GROUP BY 1;
