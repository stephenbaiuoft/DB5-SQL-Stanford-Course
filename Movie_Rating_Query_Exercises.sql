
-- SQL Movie-Rating Query Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_core/

/*
Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 
*/

-- Question 1:
-- Find the titles of all movies directed by Steven Spielberg.
SELECT title 
FROM Movie
WHERE director = 'Steven Spielberg';

-- Question 2:
-- Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT DISTINCT year
FROM Movie
WHERE mID IN (
        SELECT mID FROM Rating
        WHERE stars >= 4
        )
ORDER BY year ASC;  

-- Question 3:
-- Find the titles of all movies that have no ratings.
SELECT title
FROM Movie
LEFT OUTER JOIN Rating
ON Movie.mid = Rating.mid
WHERE stars IS NULL;

-- Question 4:
-- Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings
-- with a NULL value for the date.
SELECT DISTINCT name
FROM Rating 
JOIN Reviewer
ON Rating.rID = Reviewer.rID
WHERE ratingDate IS NULL; 

-- Question 5:
-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and
-- ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
SELECT name, title, stars, ratingDate
FROM Rating JOIN Reviewer JOIN Movie
ON Rating.rID = Reviewer.rID AND Rating.mID = Movie.mID
ORDER BY name, title, stars ASC; 

-- Question 6:
-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time,
-- return the reviewer's name and the title of the movie.
SELECT name, title
FROM 
(SELECT r1.rID, r1.mID
FROM
Rating r1, Rating r2
WHERE r1.rID = r2.rID 
AND r2.mID = r1.mID 
AND r2.ratingDate > r1.ratingDate 
AND r2.stars > r1.stars) 
AS v1 JOIN
Reviewer JOIN Movie
WHERE v1.rID = Reviewer.rID AND v1.mID = Movie.mID; 

-- Question 7:
-- For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie
-- title and number of stars. Sort by movie title.
SELECT title, v1.hRate
FROM
(SELECT mID, MAX(stars) AS hRate
FROM Rating
GROUP BY mID
HAVING MAX(stars) > 0) AS v1
JOIN Movie
ON Movie.mID = v1.mID
ORDER BY title; 

-- Question 8:
-- For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings
-- given to that movie. Sort by rating spread from highest to lowest, then by movie title.
SELECT title, r.rating_spread
FROM
(SELECT MAX(stars) - MIN(stars) AS rating_spread, mID
FROM Rating
GROUP BY mID) AS r 
JOIN Movie
WHERE Movie.mID = r.mID
ORDER BY rating_spread DESC, title; 


-- Question 9:
-- Find the difference between the average rating of movies released before 1980 and the average rating of movies released
-- after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies
-- before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)
/*
Key Idea:
1. Join without any condition --> Cartesion Product <=> Cross Product
2. the result table with columsn of: early_avgs.avg, later_avgs.avg, the AVG is still accurate

Following Sample Data:
col:    early_avgs.avg  later_avgs.avg
        3.0	            2.5
        3.0	            4.0
        3.0	            3.33333333333
        2.5	            2.5
        2.5	            4.0
        2.5	            3.33333333333
        4.5	            2.5
        4.5	            4.0
        4.5	            3.33333333333
(
// Avg for early_avgs.avg(all rows) = Avg for non-duplicate rows of the following values
                                      3.0
                                      2.5
                                      4.5

*/
SELECT AVG(early_avgs.avgs) - AVG(later_avgs.avgs)
FROM
  (
    SELECT AVG(r.stars) AS avgs
    FROM rating AS r,
      (
        SELECT m.mid
        FROM movie AS m
        WHERE m.year < 1980
      ) AS m1
    WHERE m1.mid = r.mid
    GROUP BY m1.mid
  ) AS early_avgs,
  (
    SELECT AVG(r.stars) AS avgs
  	FROM rating AS r,
      (
        SELECT m.mid
        FROM movie AS m
        WHERE m.year >= 1980
      ) AS m1
    WHERE m1.mid = r.mid
    GROUP BY m1.mid
  ) AS later_avgs;