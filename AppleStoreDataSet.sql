--Our data set 
--Table 1
SELECT *
FROM AppleStore;

--Table 2
SELECT *
FROM Descriptions;

----------------------------------------------------------------------------
--Exploratory Data Analysis--


--Check number of unique apps in both Apple Store Tables

SELECT COUNT(DISTINCT id) as UniqueAppIDs
FROM AppleStore;

SELECT COUNT(DISTINCT id) as UniqueAppIDs
FROM Descriptions;

--Check for missing values in key fieldsAppledStore

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL;

SELECT COUNT(*) AS MissingValues
FROM Descriptions
WHERE app_desc IS NULL;


--Find out the number of apps per genre

SELECT prime_genre, COUNT(*) as NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

--Get an overview of the apps' ratings

SELECT MIN(user_rating) as MinRating,
		MAX(user_rating) as MaxRating,
		AVG(user_rating) as AvgRating
FROM AppleStore;

----------------------------------------------------------------------------
--Finding Insights--

--Determine whether paid apps have higher ratings than free apps

WITH cte as (SELECT CASE WHEN price > 0 THEN 'Paid' ELSE 'Free' END AS App_Type, 
	user_rating
FROM AppleStore)

SELECT App_Type,
	AVG(user_rating) as Avg_Rating
FROM cte
GROUP BY App_Type;

--Check if apps with more supported languages have higher ratings
WITH cte as(SELECT 
	CASE 
		WHEN lang_num < 10 THEN '<10 languages'
		WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
		ELSE '>30 languages'
	END as language_bucket,
	user_rating
FROM AppleStore)

SELECT language_bucket,
	AVG(user_rating) as Avg_Rating
FROM cte
GROUP BY language_bucket;

--Check genres with low ratings

SELECT prime_genre,
	AVG(user_rating) as Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

--Check if there is correlation between the length of the app description and the user rating

WITH cte as (SELECT 
	CASE 
		WHEN LEN(d.app_desc) < 500 THEN 'Short'
		WHEN LEN(d.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
		ELSE 'Long'
	END as Len_desc_bucket,
	user_rating
FROM AppleStore as a
JOIN Descriptions as d
ON a.id = d.id)

SELECT Len_desc_bucket,
		AVG(user_rating) as Avg_Rating
FROM cte
GROUP BY Len_desc_bucket;

--Check the top-rated apps for each genre 

WITH cte as(SELECT 
	prime_genre,
	track_name,
	user_rating,
	RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) as rank

FROM AppleStore)

SELECT
	prime_genre,
	track_name,
	user_rating
FROM cte
WHERE rank = 1;