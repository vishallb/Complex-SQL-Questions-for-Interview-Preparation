/*Give the input below (DDL statement) , derive the following output
+------------+------------+--------+
| start_date | end_date   | state  |
+------------+------------+--------+
| 2019-01-01 | 2019-01-03 | success |
| 2019-01-04 | 2019-01-05 | fail    |
| 2019-01-06 | 2019-01-06 | success |
+------------+------------+--------+
*/

-- DDL Statement
create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success')

--- solution
WITH all_dates as (
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY state ORDER BY date_value) rn,
		date_add(date_value, INTERVAL -1.0 * ROW_NUMBER() OVER(PARTITION BY state ORDER BY date_value) DAY) da
	FROM
		tasks
)
SELECT
    MIN(date_value) as start_date,
    MAX(date_value) as end_date,
    state
FROM
	all_dates
GROUP BY da, state
ORDER BY start_date;
