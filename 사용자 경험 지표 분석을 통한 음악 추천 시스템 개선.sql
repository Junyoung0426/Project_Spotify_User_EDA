-- 사용자들의 음악 추천 시스템에 대한 평점 분포
SELECT music_recc_rating, COUNT(*) AS RatingCount
FROM Spotify
GROUP BY music_recc_rating
ORDER BY music_recc_rating;

-- 평점과 선호하는 음악 장르
SELECT 
    rating_category,
    fav_music_genre,
    COUNT(*) AS genre_count
FROM (
    SELECT 
        fav_music_genre,
        CASE 
            WHEN music_recc_rating > (SELECT AVG(music_recc_rating) FROM Spotify) THEN 'High Rating'
            ELSE 'Low Rating'
        END AS rating_category
    FROM Spotify
) AS genre_ratings
GROUP BY rating_category, fav_music_genre
ORDER BY rating_category, genre_count DESC;

-- 선호하는 음악 장르와 평점 평균
SELECT
    fav_music_genre,
    AVG(music_recc_rating) AS avg_rating
FROM spotify
GROUP BY fav_music_genre
ORDER BY avg_rating DESC;

-- 평점과 음악 감상 시간대
SELECT 
    rating_category,
    music_time_slot,
    COUNT(*) AS time_count
FROM (
    SELECT 
        music_time_slot,
        CASE 
            WHEN music_recc_rating > (SELECT AVG(music_recc_rating) FROM Spotify) THEN 'High Rating'
            ELSE 'Low Rating'
        END AS rating_category
    FROM Spotify
) AS ratings
GROUP BY rating_category, music_time_slot
ORDER BY rating_category, time_count DESC;

-- 음악 감상 시간대와 평점 평균
SELECT
    music_time_slot,
    AVG(music_recc_rating) AS avg_rating
FROM spotify
GROUP BY music_time_slot
ORDER BY music_time_slot DESC;

-- 평점과 음악 감상 시 감정
WITH RatingAvg AS (
    SELECT 
        AVG(music_recc_rating) AS avg_rating
    FROM spotify
)

SELECT 
    CASE 
        WHEN music_recc_rating >= (SELECT avg_rating FROM RatingAvg) THEN 'High Rating'
        ELSE 'Low Rating'
    END AS rating_category,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 ELSE 0 END) AS Relaxation,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 ELSE 0 END) AS Uplifting,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS Sadness,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 ELSE 0 END) AS Party
FROM spotify
GROUP BY rating_category
ORDER BY rating_category;

-- 평점과 음악 감상 시 상황
WITH RatingAvg AS (
    SELECT 
        AVG(music_recc_rating) AS avg_rating
    FROM spotify
)

SELECT 
    CASE 
        WHEN music_recc_rating >= (SELECT avg_rating FROM RatingAvg) THEN 'High Rating'
        ELSE 'Low Rating'
    END AS rating_category,
    SUM(CASE WHEN music_lis_frequency LIKE '%Workout session%' THEN 1 ELSE 0 END) AS Workout,
    SUM(CASE WHEN music_lis_frequency LIKE '%leisure time%' THEN 1 ELSE 0 END) AS Leisure,
    SUM(CASE WHEN music_lis_frequency LIKE '%While Traveling%' THEN 1 ELSE 0 END) AS Traveling,
    SUM(CASE WHEN music_lis_frequency LIKE '%Study Hours%' THEN 1 ELSE 0 END) AS Study
FROM spotify
GROUP BY rating_category
ORDER BY rating_category;

-- 음악 탐색 방법과 평점 평균
SELECT
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(music_expl_method, ',', numbers.n), ',', -1)) AS method,
    AVG(music_recc_rating) AS avg_rating
FROM
    spotify
JOIN
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) numbers
    ON CHAR_LENGTH(music_expl_method)
       - CHAR_LENGTH(REPLACE(music_expl_method, ',', '')) >= numbers.n - 1
GROUP BY
    method;
    
-- recommendations 사용자의 선호 음악 장르
SELECT
  fav_music_genre,
  COUNT(*) as Count
FROM spotify
WHERE music_expl_method LIKE '%recommendations%'
GROUP BY fav_music_genre
ORDER BY Count DESC;

-- Playlists 사용자의 선호 음악 장르
SELECT
  fav_music_genre,
  COUNT(*) as Count
FROM spotify
WHERE music_expl_method LIKE '%Playlists%'
GROUP BY fav_music_genre
ORDER BY Count DESC;

-- Radio 사용자의 선호 음악 장르
SELECT
  fav_music_genre,
  COUNT(*) as Count
FROM spotify
WHERE music_expl_method LIKE '%Radio%'
GROUP BY fav_music_genre
ORDER BY Count DESC;