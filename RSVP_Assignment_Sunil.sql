-- I Have used SQL Formatter for better aesthetics and readability 

USE imdb;

-- Checking the tables
SHOW TABLES;

/* TABLES_IN_IMBD
director_mapping
genre
movie
names
ratings
role_mapping
*/

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

DESCRIBE movie;

-- Viewing the table
SELECT *
FROM   movie
LIMIT  5; 

-- Viewing the table
SELECT *
FROM   genre
LIMIT  5; 

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT table_name AS 'Table_Name',
       table_rows AS 'Number_of_Rows'
FROM   information_schema.tables
WHERE  table_schema = 'IMDB'; 

-- Answer
/*Table_Name           Number_of_Rows
director_mapping	      3867
genre	                  14662
movie	                  9121
names	                  25371
ratings	                  8230
role_mapping	          15163
*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT Count(id)                    AS id_count,
       Count(title)                 AS title_count,
       Count(year)                  AS year_count,
       Count(date_published)        AS date_count,
       Count(duration)              AS duration_count,
       Count(country)               AS country_count,
       Count(worlwide_gross_income) AS worl_count,
       Count(languages)             AS lang_count,
       Count(production_company)    AS prod_count
FROM   movie; 

/* 
id_count   title_count   year_count   date_count  duration_count   country_count   worl_count   lang_count   prod_count
7997	   7997	          7997	       7997	         7997	         7977	        4273	     7803	      7469

we see that there are null values in columns of
1 Country
2 Worlwode_gross_income
3 Languages
4 Prduction_Company
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year,
       Count(*) AS number_of_movies
FROM   movie
GROUP  BY year; 

/* Output :
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|	2944			|
|	2019		|	2001			|
+---------------+-------------------+

Highest number of movies are released in the year 2017
*/

SELECT Month(date_published) AS month_num,
       Count(*) AS number_of_movies
FROM   movie
GROUP  BY Month(date_published)
ORDER  BY Month(date_published); 

/* Output:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 804			|
|	2			|	 640			|
|	3   		|	 824			|
|	4			|	 680			|
|	5			|	 625			|
|	6   		|	 580			|
|	7			|	 493			|
|	8			|	 678			|
|	9   		|	 809			|
|	10			|	 801			|
|	11			|	 625			|
|	12   		|	 438			|
+---------------+-------------------+ 
Highest number of movies is released in the month of March and lowest in the month of december
*/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

/* 
select Year, count(id) as number_of_movies
from movie
where (country = "India" or country = "USA") and year =2019;
*/

SELECT Count(DISTINCT id) AS number_of_movies
FROM   movie
WHERE  ( country LIKE "%india%"
          OR country LIKE "%usa%" )
       AND year = 2019; 

-- 1059 movies are produced by USA or India in the last year

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM   genre; 

/* Unique Genre
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others
*/


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT g.genre,
       Count(g.genre) AS number_of_movies
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
WHERE  Year(m.date_published) = 2019
GROUP  BY g.genre
ORDER  BY number_of_movies DESC
LIMIT  1; 

-- 1078 Movies are released in the year 2019 0n Drama Genre.

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

/*SELECT movie_id,
COUNT(genre) AS number_of_movies
FROM genre
group by movie_id;
*/

WITH count_genre_summary AS 
(
		SELECT movie_id,
                Count(genre) AS number_of_movies
         FROM   genre
         GROUP  BY movie_id
         HAVING number_of_movies = 1
)
SELECT Count(movie_id) AS number_of_movies
FROM   count_genre_summary; 

-- 3289 movies belong to only one genre


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:
+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre,
       Round(Avg(m.duration), 2) AS avg_duration
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
GROUP  BY g.genre
ORDER  BY avg_duration DESC; 

/* Drama Genre Avg_duration
select  g.genre, round(avg(duration),2) as avg_duration from movie m
inner join genre g 
on m.id = g.movie_id
where g.genre ="drama"
group by g.genre
order by avg_duration desc;
*/


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

/* 
select genre, count( movie_id ) as movie_count,
rank() over(order by count( distinct movie_id ) desc) as genre_rank
from genre 
group by genre;
*/

WITH genre_rank AS 
(
		SELECT genre,
                Count(movie_id) AS movie_count,
                Rank() OVER( ORDER BY Count( DISTINCT movie_id ) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre
)
SELECT *
FROM   genre_rank
WHERE  genre = "thriller"; 


-- Top Genre is drama, followed by comedy and Thriller.


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Viewing the ratings table

DESCRIBE ratings;

SELECT *
FROM   ratings
LIMIT  5; 

-- Segment 2:
-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings; 

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT     m.title,
           r.avg_rating,
           Dense_rank() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM       ratings r
INNER JOIN movie m
ON         r.movie_id = m.id 
LIMIT 10;

-- Top spot is shared by kirket and Love in Kilnerry with avg_rating of 10 

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating; 

-- Median_rating 7 has the maximum movie count of 2257, median_rating 1 has the minimum movie_count of 94


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company,
       Count(r.movie_id) AS movie_count,
       Dense_rank() OVER( ORDER BY Count(r.movie_id) DESC ) AS prod_company_rank
FROM   ratings r
       INNER JOIN movie m
               ON r.movie_id = m.id
WHERE  r.avg_rating > 8
       AND m.production_company IS NOT NULL
GROUP  BY m.production_company
ORDER  BY movie_count DESC; 

/*
RSVP Movies can Partner with Top production house has produced the most number of hit movies are
Dream Warrior Pictures
National Theatre Live
*/


-- Removed the null values in production house.
-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre,
       Count(r.movie_id) AS movie_count
FROM   ratings r
       INNER JOIN genre g
               ON r.movie_id = g.movie_id
       INNER JOIN movie m
               ON g.movie_id = m.id
WHERE  m.country = "usa"
       AND r.total_votes > 1000
       AND m.year = 2017
       AND Month(m.date_published) = 3
GROUP  BY g.genre
ORDER  BY movie_count DESC; 

-- Drama genre movies released during march 2017 in USA has 16 movies with more than 1000 votes


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title,
       r.avg_rating,
       g.genre
FROM   ratings r
       INNER JOIN genre g
               ON r.movie_id = g.movie_id
       INNER JOIN movie m
               ON g.movie_id = m.id
WHERE  m.title LIKE 'The%'
       AND r.avg_rating > 8
ORDER  BY r.avg_rating DESC; 

-- The Brighton Miracle has avg_rating has maximum 9.5 from genre drama
-- 8 movies starting with "The" has avg rating of more than 8


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT r.median_rating,
       Count(r.movie_id) AS movie_count
FROM   ratings r
       INNER JOIN movie m
               ON r.movie_id = m.id
WHERE  r.median_rating = 8
       AND m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP  BY r.median_rating; 

-- 361 are given median rating of 8 which released between 1 April 2018 and 1 April 2019


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

/*SELECT (r.total_votes),
       m.languages
FROM   ratings r
       INNER JOIN movie m
               ON  r.movie_id = m.id
WHERE  m.languages LIKE 'Italian' or m.languages LIKE 'German'
GROUP  BY m.languages
ORDER  BY sum(r.total_votes) DESC; 
*/

SELECT 
	   (SELECT Sum(total_votes)
        FROM   ratings r
               INNER JOIN movie m
                       ON r.movie_id = m.id
        WHERE  m.languages LIKE '%Italian%') AS Italian_Total_Votes,
       (SELECT Sum(r.total_votes)
        FROM   ratings r
               INNER JOIN movie m
                       ON r.movie_id = m.id
        WHERE  m.languages LIKE '%German%')  AS Germany_Total_Votes; 
        
-- German movies have total_votes of 44 Lakh Votes , Italian Movies have total_vote of 25 Lakh Votes

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

DESCRIBE names;

SELECT *
FROM   names
LIMIT  5; 


-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- First find top 3 genre with avg_rating >8
/*
SELECT g.genre, COUNT(g.movie_id) AS movie_count
FROM genre AS g
INNER JOIN ratings AS r
ON g.movie_id = r.movie_id
WHERE avg_rating > 8
GROUP BY g.genre
ORDER BY movie_count desc
LIMIT 3;
*/

WITH genre_selection AS 
	(WITH top_genre AS 
			(SELECT g.genre,
					Count(m.title) AS movie_count,
					Rank() OVER( ORDER BY Count(m.title) DESC) AS genre_rank
			 FROM   movie m
			 INNER JOIN ratings r
						ON r.movie_id = m.id
			 INNER JOIN genre g
						ON g.movie_id = m.id
			 WHERE  r.avg_rating > 8
			 GROUP  BY g.genre)
	SELECT genre
	FROM   top_genre WHERE  genre_rank < 4
),
top_directors AS 
      (SELECT n.NAME AS director_name,
			  Count(g.movie_id) AS movie_count,
			  Rank() OVER(ORDER BY Count(g.movie_id) DESC) AS director_rank
	   FROM   names n
	   INNER JOIN director_mapping dm
				ON n.id = dm.name_id
		INNER JOIN genre g
				ON dm.movie_id = g.movie_id
		INNER JOIN ratings r
				ON r.movie_id = g.movie_id,
		genre_selection
         WHERE  g.genre IN ( genre_selection.genre )
                AND r.avg_rating > 8
         GROUP  BY director_name
         ORDER  BY movie_count DESC)
SELECT *
FROM   top_directors
WHERE  director_rank <= 3; 

/*  Top director based on number of movies in top genre
James Mangold
Anthony Russo
Joe Russo
Soubin Shahir
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT DISTINCT n.name AS actor_name,
                Count(r.movie_id) AS movie_count
FROM   names n
		INNER JOIN role_mapping rm
					ON n.id = rm.name_id
		INNER JOIN ratings r
					ON rm.movie_id = r.movie_id
WHERE  median_rating >= 8
       AND category = 'actor'
GROUP  BY n.name
ORDER  BY movie_count DESC
LIMIT  2; 

/* Top two actors with movies having a median rating >= 8
Mammootty
Mohanlal
*/

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     m.production_company ,
           Sum(r.total_votes) AS vote_count,
           Rank() OVER (ORDER BY Sum(r.total_votes) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id = r.movie_id
GROUP BY   m.production_company 
LIMIT 3;

/* Top 3 Prodction Hoses
Marvel Studios
Twentieth Century Fox
Warner Bros.
*/


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS actor_name,
       Sum(r.total_votes) AS total_votes,
       Count(m.id) as movie_count,
       Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actor_avg_rating,
       Rank() OVER( ORDER BY r.avg_rating DESC) AS actor_rank
FROM   names n
       INNER JOIN role_mapping rm
               ON n.id = rm.name_id
       INNER JOIN movie m
               ON m.id = rm.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  rm.category = 'actor'
       AND m.country = 'india'
GROUP  BY n.name
HAVING movie_count >= 5; 

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT     n.name AS actress_name,
           r.total_votes,
           Count(m.id) AS movie_count,
           Round(Sum(r.avg_rating*r.total_votes)/Sum(r.total_votes),2) AS actress_avg_rating,
           Rank() OVER(ORDER BY r.avg_rating DESC) AS actress_rank
FROM       names n
INNER JOIN role_mapping rm
ON         n.id = rm.name_id
INNER JOIN movie m
ON         m.id = rm.movie_id
INNER JOIN ratings r
ON         m.id = r.movie_id
WHERE      rm.category='actress'
AND        m.country='india'
AND        m.languages='hindi'
GROUP BY   n.name
HAVING     movie_count>=3 
LIMIT 5;

/* Top five actresses in Hindi movies based on their average ratings
Taapsee Pannu
Divya Dutta
Kriti Kharbanda
Sonakshi Sinha
*/


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title,
       r.avg_rating,
       CASE
         WHEN r.avg_rating > 8 THEN 'Superhit movies'
         WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         WHEN r.avg_rating < 5 THEN 'Flop movies'
       END AS avg_rating_category
FROM   movie AS m
       INNER JOIN genre AS g
               ON m.id = g.movie_id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  g.genre = 'thriller'; 

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT g.genre,
		ROUND(AVG(m.duration),2) AS avg_duration,
        SUM(ROUND(AVG(m.duration),2)) OVER(ORDER BY g.genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        ROUND(AVG(AVG(m.duration)) OVER(ORDER BY g.genre ROWS 1 PRECEDING),2) AS moving_avg_duration
        -- ROUND(AVG(AVG(m.duration)) OVER(ORDER BY g.genre ROWS UNBOUNDED PRECEDING),2) AS moving_avg_duration1
FROM movie m 
INNER JOIN genre g 
ON m.id= g.movie_id
GROUP BY g.genre
ORDER BY g.genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH genre_selection AS 
	(WITH top_genre AS 
		(SELECT g.genre,
				Count(m.title)AS movie_count,
				Rank() OVER( ORDER BY Count(m.title) DESC) AS genre_rank
		  FROM   movie m
		  INNER JOIN ratings r
		  ON r.movie_id = m.id
		  INNER JOIN genre g
		  ON g.movie_id = m.id
		  GROUP  BY genre)
                 SELECT genre
				 FROM   top_genre
                 WHERE  genre_rank < 4),
-- Top 5 movies based on worlwide gross
top_five AS 
	(SELECT g.genre,
			m.year,
			m.title AS movie_name,
			m.worlwide_gross_income,
			Rank() OVER ( PARTITION BY year ORDER BY m.worlwide_gross_income DESC) AS movie_rank
	FROM   movie AS m
	INNER JOIN genre AS g
	ON m.id = g.movie_id
	WHERE  g.genre IN (SELECT genre FROM   genre_selection))
SELECT *
FROM   top_five
WHERE  movie_rank <= 5; 


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     m.production_company,
           Count(m.id) AS movie_count,
           Row_number() OVER(ORDER BY Count(m.id) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id=r.movie_id
WHERE      r.median_rating>=8
AND        m.production_company IS NOT NULL
AND        position(',' IN languages)>0
GROUP BY   m.production_company 
LIMIT 2;

/* Top 2 Prodction Houses that have produced the highest number of hits among multilingual movies
Star Cinema
Twentieth Century Fox
*/



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 actress based on Number of Super hit Movies 
SELECT     n.name AS actress_name,
           Sum(r.total_votes) AS total_votes,
           Count(r.movie_id) AS movie_count,
           Round(AVG(r.avg_rating),2) as actress_avg_rating,
           DENSE_RANK() OVER(ORDER BY Count(r.movie_id) DESC) AS actress_rank
FROM       names n
INNER JOIN role_mapping rm
ON         n.id = rm.name_id
INNER JOIN ratings r
ON         r.movie_id = rm.movie_id
INNER JOIN genre g
ON         r.movie_id = g.movie_id
WHERE      rm.category = 'actress'
AND        r.avg_rating > 8
AND        g.genre = 'drama'
GROUP BY   n.name
ORDER  BY movie_count DESC, actress_avg_rating DESC
LIMIT 3;

/*
Top 3 actress based on super hit movie count
Parvathy Thiruvothu
Susan Brown
Amanda Lawrence
*/

-- Top 3 actress based on Super Hit movies (average rating >8) 
SELECT     n.name AS actress_name,
           Sum(r.total_votes) AS total_votes,
           Count(r.movie_id) AS movie_count,
           Round(AVG(r.avg_rating),2) as actress_avg_rating,
           DENSE_RANK() OVER(ORDER BY Round(AVG(r.avg_rating),2) DESC) AS actress_rank
FROM       names n
INNER JOIN role_mapping rm
ON         n.id = rm.name_id
INNER JOIN ratings r
ON         r.movie_id = rm.movie_id
INNER JOIN genre g
ON         r.movie_id = g.movie_id
WHERE      rm.category = 'actress'
AND        r.avg_rating > 8
AND        g.genre = 'drama'
GROUP BY   n.name limit 3;

/* Top 3 Actrees based on Super Hit movies (average rating >8)
Sangeetha Bhat
Fatmire Sahiti
Adriana Matoshi
*/


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH Best_directors AS
(
           SELECT     dm.name_id AS director_id,
                      n.NAME  AS director_name,
                      dm.movie_id,
                      m.duration,
                      r. avg_rating ,
                      r.total_votes,
                      r.avg_rating * r.total_votes AS rating_count,
                      m.date_published,
                      Lead(m.date_published, 1) OVER (partition BY NAME ORDER BY m.date_published, NAME) AS next_publish_date
           FROM director_mapping dm
           INNER JOIN names n
           ON dm.name_id = n.id
           INNER JOIN movie m
           ON dm.movie_id = m.id
           INNER JOIN ratings r
           ON m.id = r.movie_id
)
SELECT   director_id,
         director_name,
         Count(movie_id) AS number_of_movies,
         Round(Sum(Datediff(next_publish_date, date_published))/(Count(movie_id)-1)) AS avg_inter_movie_days,
         Cast(Sum(rating_count)/Sum(total_votes)AS DECIMAL(4,2)) AS avg_rating,
         Sum(total_votes) AS total_votes,
         Min(avg_rating) AS min_rating,
         Max(avg_rating) AS max_rating,
         Sum(duration) AS total_duration
FROM Best_directors
GROUP BY director_id
ORDER BY number_of_movies DESC 
LIMIT 9;


