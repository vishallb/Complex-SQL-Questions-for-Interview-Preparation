/*Given is the input table
+-----------+-------------+------------------+---------+------------+
|   Name    |   Address   |      Email       |  Floor  | Resources  |
+-----------+-------------+------------------+---------+------------+
|     A     |  Bangalore  |   A@gmail.com   |    1    |    CPU     |
|     A     |  Bangalore  |  A1@gmail.com   |    1    |    CPU     |
|     A     |  Bangalore  |  A2@gmail.com   |    2    |  DESKTOP   |
|     B     |  Bangalore  |   B@gmail.com   |    2    |  DESKTOP   |
|     B     |  Bangalore  |  B1@gmail.com   |    2    |  DESKTOP   |
|     B     |  Bangalore  |  B2@gmail.com   |    1    |  MONITOR   |
+-----------+-------------+------------------+---------+------------+

Each employee is allowed only to visit the office once a day. But the loop hole is, using a different mail id, a person can enter the building. Given the input above, give the following output
+------+--------------------+------------------------+-------------------+
| Name | Most Visited Floor | Total Number of Visits | Resources Used    |
+------+--------------------+------------------------+-------------------+
| A    | 1                  | 3                      | CPU, DESKTOP      |
| B    | 2                  | 3                      | DESKTOP, MONITOR |
+------+--------------------+------------------------+-------------------+
*/

--- DDL for the question
CREATE TABLE entries (
    name VARCHAR(20),
    address VARCHAR(20),
    email VARCHAR(20),
    floor INT,
    resources VARCHAR(10)
);

INSERT INTO entries (name, address, email, floor, resources)
VALUES
    ('A', 'Bangalore', 'A@gmail.com', 1, 'CPU'),
    ('A', 'Bangalore', 'A1@gmail.com', 1, 'CPU'),
    ('A', 'Bangalore', 'A2@gmail.com', 2, 'DESKTOP'),
    ('B', 'Bangalore', 'B@gmail.com', 2, 'DESKTOP'),
    ('B', 'Bangalore', 'B1@gmail.com', 2, 'DESKTOP'),
    ('B', 'Bangalore', 'B2@gmail.com', 1, 'MONITOR');


# solution
WITH floor_visit as (
	SELECT
		name,
        floor,
        COUNT(name) as no_of_floor_visit,
        RANK() OVER(PARTITION BY name ORDER BY COUNT(name) DESC) as rn
	FROM
		entries
	GROUP BY name, floor),

total_number_of_visits as (
	SELECT
		name,
        COUNT(name) as total_number_of_visits,
        GROUP_CONCAT(DISTINCT resources SEPARATOR ', ') as resources_used
	FROM
		entries
	GROUP BY name)
SELECT
	fv.name,
    fv.floor as most_visited_floor,
    tv.total_number_of_visits,
    tv.resources_used
FROM 
	floor_visit fv
INNER JOIN total_number_of_visits tv
ON fv.name=tv.name
WHERE rn=1;
