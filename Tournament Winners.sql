/* Write a SQL query to find the winner in each group.

The winner in each group is the player who scored the maximum total points within the group. In the case of a tie, the lowest player_id wins. */

-- DDL
-- Create the "players" table
CREATE TABLE players (
    player_id INT,
    group_id INT
);

-- Insert data into the "players" table
INSERT INTO players VALUES (15, 1);
INSERT INTO players VALUES (25, 1);
INSERT INTO players VALUES (30, 1);
INSERT INTO players VALUES (45, 1);
INSERT INTO players VALUES (10, 2);
INSERT INTO players VALUES (35, 2);
INSERT INTO players VALUES (50, 2);
INSERT INTO players VALUES (20, 3);
INSERT INTO players VALUES (40, 3);

-- Create the "matches" table
CREATE TABLE matches (
    match_id INT,
    first_player INT,
    second_player INT,
    first_score INT,
    second_score INT
);

-- Insert data into the "matches" table
INSERT INTO matches VALUES (1, 15, 45, 3, 0);
INSERT INTO matches VALUES (2, 30, 25, 1, 2);
INSERT INTO matches VALUES (3, 30, 15, 2, 0);
INSERT INTO matches VALUES (4, 40, 20, 5, 2);
INSERT INTO matches VALUES (5, 35, 50, 1, 1);


-- Solution
WITH all_players as (
	SELECT first_player, first_score as score FROM matches
		UNION ALL
	SELECT second_player, second_score as score FROM matches
),
players_group as (
	SELECT
		*
	FROM all_players a
    INNER JOIN players p
    ON a.first_player = p.player_id
),
total_scores as (
	SELECT
		first_player as player_id,
        group_id,
        SUM(score) as total_score,
        RANK() OVER(PARTITION BY group_id ORDER BY SUM(score) DESC, first_player ASC) as dr
	FROM
		players_group
	GROUP BY 1, 2
)
SELECT 
	player_id,
    group_id,
    total_score
FROM
	total_scores
WHERE dr = 1;
