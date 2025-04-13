use netflix_db;
-- What is the ratio of Movies to TV Shows in the Netflix catalog?"
select
round (
       (select count(*) from netflix_db.netflix_titles where type='movie')*1.0/
(select count(*) from netflix_db.netflix_titles where type='TV Show'),
2) 
as movie_to_tvshow;
-- "How many titles were added to Netflix in 2020?"
select count(title) from netflix_db.netflix_titles
where release_year="2020";
-- "How many titles are missing director or cast information?"
SELECT 
    COUNT(*) AS missing_metadata_count
FROM netflix_db.netflix_titles
WHERE director IS NULL OR director = ''
   OR cast IS NULL OR cast = '';

-- "What are the most common genres across Netflix content?"
select listed_in, count(*) as count  from netflix_db.netflix_titles
group by listed_in
order by count desc
limit 5;

-- "Which countries are producing the most content on Netflix?"
select country, count(*) as count
from  netflix_db.netflix_titles
WHERE country IS NOT NULL AND country != ''
group by country
order by count desc
limit 5;

-- "Which is the longest movie currently listed on Netflix?"
SELECT 
    title, duration
FROM netflix_db.netflix_titles
WHERE type = 'Movie' AND duration LIKE '%min%'
ORDER BY CONVERT(SUBSTRING_INDEX(duration, ' ', 1), SIGNED) DESC
LIMIT 1;

-- "What kind of content is consistently created by specific directors like 'Rajiv Chilaka'?"
select type, title, count(*) as count from netflix_db.netflix_titles
where director='Rajiv Chilaka'
GROUP BY type, title
LIMIT 10;

-- "How many documentary films are available for viewers?"
select count(*) as documentary_count
from netflix_db.netflix_titles
where listed_in like'%documentaries%';
-- "What percentage of content has no director listed?"
select count(*) as no_director from netflix_db.netflix_titles
where director is null or director='';

-- "What is the yearly trend of Netflix content being released in India? Which 5 years had the highest average releases?"
select release_year, count(*) as yearly_trend
from netflix_db.netflix_titles
where country like '%INDIA%'
group by release_year
order by yearly_trend desc;

-- "Can we identify and label potentially disturbing content by detecting words like 'kill' or 'violence' in descriptions?"
SELECT title, description 
FROM netflix_db.netflix_titles
WHERE description LIKE '%Violent%' 
   OR description LIKE '%kill%' 
   OR description LIKE '%murder%' 
   OR description LIKE '%death%' 
   OR description LIKE '%crime%';


-- "How many movies has Salman Khan been featured in the last 10 years?"
select count(*) as salman_movie from netflix_db.netflix_titles
where cast like '%Salman Khan%' and release_year >= YEAR(CURDATE()) - 10;

-- "Who are the top 10 actors most frequently featured in Indian-produced movies?"
select cast as actor, count(*) as top10 from netflix_db.netflix_titles
where country like '%India%' and type='movie' and cast is not null 
group by cast
order by top10 desc;
-- "How long does it take on average from a title's release year to its Netflix release (date_added)?"
SELECT AVG(DATEDIFF(date_added, STR_TO_DATE(CONCAT(CAST(release_year AS CHAR), '-01-01'), '%Y-%m-%d'))) AS avg_days
FROM netflix_db.netflix_titles
WHERE date_added IS NOT NULL
  AND release_year IS NOT NULL
  AND release_year > 1990
  AND STR_TO_DATE(CONCAT(CAST(release_year AS CHAR), '-01-01'), '%Y-%m-%d') IS NOT NULL
  AND STR_TO_DATE(date_added, '%Y-%m-%d') IS NOT NULL;
