/* Given the input table below for teams in a cricket tournament:

+------------+------------+----------+
|   Team_1   |   Team_2   |  Winner  |
+------------+------------+----------+
|    Aus     |    India   |   India  |
|    Eng     |     NZ     |    NZ    |
|   India    |     SL     |   India  |
|     SA     |    Eng     |    Eng   |
|     SL     |    Aus     |    Aus   |
+------------+------------+----------+

Output the input as shown below:

+------------+----------------+-------------+---------------+
| team_name  | matches_played | no_of_wins  | no_of_losses  |
+------------+----------------+-------------+---------------+
|   India    |       2        |      2      |       0       |
|     SL     |       2        |      0      |       2       |
|     SA     |       1        |      0      |       1       |
|    Eng     |       2        |      1      |       1       |
|    Aus     |       2        |      1      |       1       |
|     NZ     |       1        |      1      |       0       |
+------------+----------------+-------------+---------------+
*/

--- DDL script for the question
create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');


--- Solution
WITH team_names as (
	SELECT team_1 as team_name FROM icc_world_cup
		UNION
	SELECT team_2 FROM icc_world_cup),
    
wins_and_losses as (
	SELECT
		team_name,
		SUM(CASE
			WHEN team_name IN (team_1, team_2) THEN 1 ELSE 0 END) matches_played,
		SUM(CASE WHEN team_name = winner THEN 1 ELSE 0 END) no_of_wins
	FROM
		team_names
	CROSS JOIN icc_world_cup
	GROUP BY team_name)

SELECT
	team_name,
    matches_played,
    no_of_wins,
    matches_played - no_of_wins as no_of_losses
FROM
	wins_and_losses;
