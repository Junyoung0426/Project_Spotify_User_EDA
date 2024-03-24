-- 칼럼들의 평균 평점 및 평점 갯수 카운트
-- 구독 의향, 현재 구독 상태 비교
select spotify_subscription_plan, premium_sub_willingness, count(1) as cnt 
from spotify
where music_recc_rating <8
group by 1,2
order by 1,2

-- 음악 분위기와 평점 (카운트)
SELECT
    music_recc_rating,music_expl_method, COUNT(1) AS cnt
FROM
    spotify
JOIN
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) numbers
    ON CHAR_LENGTH(music_expl_method)
       - CHAR_LENGTH(REPLACE(music_expl_method, ',', '')) >= numbers.n - 1
WHERE
    music_expl_method LIKE '%recommendations%' 
    AND music_recc_rating >3
GROUP BY 1, 2;


-- 평점과 선호하는 컨텐츠
SELECT
    preferred_listening_content,
    AVG(CASE WHEN music_recc_rating <= (SELECT AVG(music_recc_rating) FROM spotify) THEN music_recc_rating END) AS avg_rating_below_avg,
    AVG(CASE WHEN music_recc_rating > (SELECT AVG(music_recc_rating) FROM spotify) THEN music_recc_rating END) AS avg_rating_above_avg
FROM
    spotify
GROUP BY
    preferred_listening_content;

-- 나이별 평점 
SELECT
    Age,
    avg(music_recc_rating) as avg_rating
FROM
    spotify
GROUP BY
    Age;

-- 사용기간에 따른 평점
SELECT
    spotify_usage_period,
    AVG(music_recc_rating) AS avg_rating
FROM
    spotify
GROUP BY
    spotify_usage_period;

-- 6개월~1년 사용한 고객들만 모아보기
SELECT *
FROM
    spotify
WHERE
    spotify_usage_period like '%6 months to 1 year%';

-- 사용 기기에 따른 평점
SELECT
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(spotify_listening_device, ',', numbers.n), ',', -1)) AS listening_device,
    AVG(music_recc_rating) AS avg_rating
FROM
    spotify
JOIN
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) numbers
    ON CHAR_LENGTH(spotify_listening_device)
       - CHAR_LENGTH(REPLACE(spotify_listening_device, ',', '')) >= numbers.n - 1
GROUP BY
    listening_device;


-- 구독상태에 따른 평점
SELECT
    spotify_subscription_plan,
    AVG(music_recc_rating) AS avg_rating
FROM
    spotify
GROUP BY
    spotify_subscription_plan;



-- 구독 의향에 따른 평점
SELECT
    premium_sub_willingness,
    AVG(music_recc_rating) AS avg_rating
FROM
    spotify
GROUP BY
    premium_sub_willingness;


-- 현재 구독하고있는 요금제와 평점
SELECT
    preffered_premium_plan,
    AVG(music_recc_rating) AS avg_rating
FROM
    spotify
GROUP BY
    preffered_premium_plan;

-- 장르와 평점 관계
SELECT
    fav_music_genre,
    AVG(music_recc_rating) AS avg_rating
FROM
    spotify
GROUP BY
    fav_music_genre;

--  ' , ' 중복응답 분리해서 평균구하기
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