/* Given the table on friend and person, output the name of the personid, name, no of friends and friend score for persons who's friend score is more than 100*/

-- DDL 
-- Create the Person table
CREATE TABLE Person (
    PersonID INT PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255),
    Score INT
);

-- Insert data into the Person table
INSERT INTO Person (PersonID, Name, Email, Score) VALUES
(1, 'Alice', 'alice2018@hotmail.com', 88),
(2, 'Bob', 'bob2018@hotmail.com', 11),
(3, 'Davis', 'davis2018@hotmail.com', 27),
(4, 'Tara', 'tara2018@hotmail.com', 45),
(5, 'John', 'john2018@hotmail.com', 63);

-- Create the Friend table
CREATE TABLE Friend (
    PersonID INT,
    FriendID INT,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (FriendID) REFERENCES Person(PersonID)
);

-- Insert data into the Friend table
INSERT INTO Friend (PersonID, FriendID) VALUES
(1, 2),
(1, 3),
(2, 1),
(2, 3),
(3, 5),
(4, 2),
(4, 3),
(4, 5);

-- Output
/*+------------+--------+--------------+-------------------+
| person_id  |  name  | no_of_friend | total_friend_score|
+------------+--------+--------------+-------------------+
|     2      |  Bob   |      2       |        115        |
|     4      |  Tara  |      3       |        101        |
+------------+--------+--------------+-------------------+*/

# solution
SELECT
	p.personid,
    p.name,
    COUNT(f.FriendID) as no_of_friends,
    SUM(q.score) as total_friendscore
FROM
	person p
INNER JOIN friend f 
ON p.personid = f.personid
INNER JOIN person q
ON f.FriendID = q.PersonID
GROUP BY 1, 2
HAVING SUM(q.score) > 100;
