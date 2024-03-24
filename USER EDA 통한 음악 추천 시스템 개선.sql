# 0.기준 대상 범위 선정
# 1) 음악 선호 사용자들의 평점 분포
WITH musiclovers AS (
    SELECT music_recc_rating
    FROM spotify
    WHERE preferred_listening_content = 'Music'
)
SELECT music_recc_rating, COUNT(*) AS user_count
FROM musiclovers
GROUP BY 1
ORDER BY 1

# 2) target 테이블 생성
CREATE TABLE target AS
SELECT *
FROM spotify
WHERE preferred_listening_content = 'Music' AND music_recc_rating BETWEEN 1 AND 3;

# 2. 사용자 분석
# 1-1) Age 단일 컬럼
SELECT age, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM target)), 2), '%') AS percentage
FROM target
GROUP BY 1
ORDER BY case age
	when '6-12' then 1
	when '12-20' then 2
	when '20-35' then 3
	ELSE 4
END

# 1-2) 젊은 층의 성별
SELECT age, gender,COUNT(*) AS cnt, 
    CONCAT(ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()), 2), '%') AS percentage
FROM target
WHERE age = '20-35'
GROUP BY 1, 2
ORDER BY 2

# 1-3) 젊은 층의 성별에 따른 frequency
# 여성
SELECT 'leisure time' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%leisure time%' AND age = '20-35' AND gender = 'Female' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'While Traveling' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%While Traveling%' AND age = '20-35' AND gender = 'Female' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Workout session' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Workout session%' AND age = '20-35' AND gender = 'Female' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Office hours' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Office hours%' AND age = '20-35' AND gender = 'Female' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Study Hours' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Study Hours%' AND age = '20-35' AND gender = 'Female' THEN 1 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 DESC
# 남성
SELECT 'leisure time' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%leisure time%' AND age = '20-35' AND gender = 'Male' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'While Traveling' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%While Traveling%' AND age = '20-35' AND gender = 'Male' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Workout session' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Workout session%' AND age = '20-35' AND gender = 'Male' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Office hours' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Office hours%' AND age = '20-35' AND gender = 'Male' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Study Hours' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Study Hours%' AND age = '20-35' AND gender = 'Male' THEN 1 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 DESC

# 1-4) 젊은 층 성별에 따른 mood
# 여성
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' AND age = '20-35' AND gender = 'Female'
		  THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' AND age = '20-35' AND gender = 'Female'
		  THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' AND age = '20-35' AND gender = 'Female'
		  THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' AND age = '20-35' AND gender = 'Female'
		  THEN 1 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 DESC
# 남성
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' AND age = '20-35' AND gender = 'Male'
		  THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' AND age = '20-35' AND gender = 'Male'
		  THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' AND age = '20-35' AND gender = 'Male'
		  THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' AND age = '20-35' AND gender = 'Male'
		  THEN 1 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 DESC

# 2) Gender
SELECT gender, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM target)), 2), '%') AS percentage
FROM target
GROUP BY 1
ORDER BY 1

# 3) spotify 사용 기간
SELECT spotify_usage_period, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM target)), 2), '%') AS percentage
FROM target
GROUP BY 1
ORDER BY 2 DESC

# 4) spotify 사용 기기
SELECT 'Computer or laptop' AS devices,
       SUM(CASE WHEN spotify_listening_device LIKE '%Computer or laptop%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Smart speakers or voice assistants' AS devices,
       SUM(CASE WHEN spotify_listening_device LIKE '%Smart speakers or voice assistants%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Smartphone' AS devices,
       SUM(CASE WHEN spotify_listening_device LIKE '%Smartphone%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Wearable devices' AS devices,
       SUM(CASE WHEN spotify_listening_device LIKE '%Wearable devices%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 DESC

# 5-1) 선호 장르 단일 컬럼
SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM target)), 2), '%') AS percentage
FROM target
GROUP BY 1
ORDER BY 2 DESC

# 5-2) 'Melody' 장르의 mood / frequency
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM target
WHERE fav_music_genre = 'Melody'
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM target
WHERE fav_music_genre = 'Melody'
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
WHERE fav_music_genre = 'Melody'
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM target
WHERE fav_music_genre = 'Melody'
ORDER BY 2 DESC

# 6-1) 시간대 단일 컬럼
SELECT music_time_slot, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM target)), 2), '%') AS percentage
FROM target
GROUP BY 1
ORDER BY 2 DESC

# 6-2) 시간대 별 frequency
# Night
SELECT 'leisure time' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%leisure time%' AND music_time_slot = 'night' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'While Traveling' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%While Traveling%' AND music_time_slot = 'night' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Workout session' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Workout session%' AND music_time_slot = 'night' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Office hours' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Office hours%' AND music_time_slot = 'night' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Study Hours' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Study Hours%' AND music_time_slot = 'night' THEN 1 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 DESC
#Afternoon
SELECT 'leisure time' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%leisure time%' AND music_time_slot = 'Afternoon' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'While Traveling' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%While Traveling%' AND music_time_slot = 'Afternoon' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Workout session' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Workout session%' AND music_time_slot = 'Afternoon' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Office hours' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Office hours%' AND music_time_slot = 'Afternoon' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Study Hours' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Study Hours%' AND music_time_slot = 'Afternoon' THEN 1 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 DESC
# Morning
SELECT 'leisure time' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%leisure time%' AND music_time_slot = 'Morning' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'While Traveling' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%While Traveling%' AND music_time_slot = 'Morning' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Workout session' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Workout session%' AND music_time_slot = 'Morning' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Office hours' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Office hours%' AND music_time_slot = 'Morning' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Study Hours' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Study Hours%' AND music_time_slot = 'Morning' THEN 1 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 DESC

# 6-3) 시간대 별 mood
# Night
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' AND music_time_slot = 'Night' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' AND music_time_slot = 'Night' THEN 1 
       ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' AND music_time_slot = 'Night' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' AND music_time_slot = 'Night' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 desc
# Afternoon
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' AND music_time_slot = 'Night' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' AND music_time_slot = 'Night' THEN 1 
       ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' AND music_time_slot = 'Night' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' AND music_time_slot = 'Night' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 desc
# Morning
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' AND music_time_slot = 'Morning' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' AND music_time_slot = 'Morning' THEN 1 
       ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' AND music_time_slot = 'Morning' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' AND music_time_slot = 'Morning' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 DESC

# 7-1) mood 단일 컬럼
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 DESC

# 7-2) mood 별 선호하는 장르
# Relaxation and stress relief
SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM relax)), 2), '%') AS percentage
FROM relax
GROUP BY 1
ORDER BY 2 DESC
# Uplifting and motivational
SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM uplift)), 2), '%') AS percentage
FROM uplift
GROUP BY 1
ORDER BY 2 DESC
# Sadness and melancholy
SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sadness)), 2), '%') AS percentage
FROM sadness
GROUP BY 1
ORDER BY 2 DESC
# Social gatherings and parties
SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM party)), 2), '%') AS percentage
FROM party
GROUP BY 1
ORDER BY 2 DESC

# 8-1) frequency 단일 컬럼
SELECT 'leisure time' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%leisure time%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'While Traveling' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%While Traveling%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Workout session' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Workout session%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Office hours' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Office hours%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Study Hours' AS frequency,
       SUM(CASE WHEN music_lis_frequency LIKE '%Study Hours%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 DESC

# 8-2) frequency 별 mood
# leisure time
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM leisure
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM leisure
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM leisure
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM leisure
ORDER BY 2 desc
# While Traveling
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM traveling
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM traveling
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM traveling
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM traveling
ORDER BY 2 desc
# Workout Session
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM workout
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM workout
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM workout
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM workout
ORDER BY 2 desc
# Office hours
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM office
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM office
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM office
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM office
ORDER BY 2 desc
# Study hours
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM study
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM study
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM study
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 
		 ELSE 0 END) AS user_cnt
FROM study
ORDER BY 2 desc

# 8-3) frequency 별 선호 장르
# leisure time
SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM leisure)), 2), '%') AS percentage
FROM leisure
GROUP BY 1
ORDER BY 2 desc
# While Traveling
SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM traveling)), 2), '%') AS percentage
FROM traveling
GROUP BY 1
ORDER BY 2 desc
# Workout Session
SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM workout)), 2), '%') AS percentage
FROM workout
GROUP BY 1
ORDER BY 2 desc
# Office hours
SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM office)), 2), '%') AS percentage
FROM office
GROUP BY 1
ORDER BY 2 desc
# Study hours
SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM study)), 2), '%') AS percentage
FROM study
GROUP BY 1
ORDER BY 2 desc

# 8-4) frequency 별 집계 평균 이상 mood 기준 top / worst 장르
# leisure time
CREATE TEMPORARY TABLE leisure_mood_cnt AS
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM leisure
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM leisure
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM leisure
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM leisure;

CREATE TABLE leisure_mood AS
SELECT l.*
FROM leisure l
INNER JOIN (
    SELECT mood
    FROM leisure_mood_cnt
    WHERE user_cnt > (SELECT AVG(user_cnt) FROM leisure_mood_cnt)
) high_mood ON l.music_Influencial_mood LIKE CONCAT('%', high_mood.mood, '%');

SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM leisure_mood)), 2), '%') AS percentage
FROM leisure_mood
GROUP BY 1
ORDER BY 2 desc
LIMIT 5

SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM leisure_mood)), 2), '%') AS percentage
FROM leisure_mood
GROUP BY 1
ORDER BY 2
LIMIT 3
# While Traveling
CREATE TEMPORARY TABLE traveling_mood_cnt AS
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM traveling
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM traveling
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM traveling
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM traveling;

CREATE TABLE traveling_mood AS
SELECT t.*
FROM traveling t
INNER JOIN (
    SELECT mood
    FROM traveling_mood_cnt
    WHERE user_cnt > (SELECT AVG(user_cnt) FROM traveling_mood_cnt)
) high_mood ON t.music_Influencial_mood LIKE CONCAT('%', high_mood.mood, '%');

SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM traveling_mood)), 2), '%') AS percentage
FROM traveling_mood
GROUP BY 1
ORDER BY 2 desc
LIMIT 5

SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM traveling_mood)), 2), '%') AS percentage
FROM traveling_mood
GROUP BY 1
ORDER BY 2
LIMIT 3
# Workout Session
CREATE TEMPORARY TABLE workout_mood_cnt AS
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM workout
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM workout
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM workout
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM workout;

CREATE TABLE workout_mood AS
SELECT w.*
FROM workout w
INNER JOIN (
    SELECT mood
    FROM workout_mood_cnt
    WHERE user_cnt > (SELECT AVG(user_cnt) FROM workout_mood_cnt)
) high_mood ON w.music_Influencial_mood LIKE CONCAT('%', high_mood.mood, '%');

SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM workout_mood)), 2), '%') AS percentage
FROM workout_mood
GROUP BY 1
ORDER BY 2 desc
LIMIT 5

SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM workout_mood)), 2), '%') AS percentage
FROM workout_mood
GROUP BY 1
ORDER BY 2
LIMIT 3
# Office hours
CREATE TEMPORARY TABLE office_mood_cnt AS
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM office
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM office
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM office
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM office;

CREATE TABLE office_mood AS
SELECT o.*
FROM office o
INNER JOIN (
    SELECT mood
    FROM office_mood_cnt
    WHERE user_cnt > (SELECT AVG(user_cnt) FROM office_mood_cnt)
) high_mood ON o.music_Influencial_mood LIKE CONCAT('%', high_mood.mood, '%');

SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM office_mood)), 2), '%') AS percentage
FROM office_mood
GROUP BY 1
ORDER BY 2 desc
LIMIT 5

SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM office_mood)), 2), '%') AS percentage
FROM office_mood
GROUP BY 1
ORDER BY 2
LIMIT 3
# Study hours
CREATE TEMPORARY TABLE study_mood_cnt AS
SELECT 'Relaxation and stress relief' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM study
UNION ALL
SELECT 'Uplifting and motivational' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM study
UNION ALL
SELECT 'Sadness or melancholy' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM study
UNION ALL
SELECT 'Social gatherings or parties' AS mood,
       SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 
       ELSE 0 END) AS user_cnt
FROM study;

CREATE TABLE study_mood AS
SELECT s.*
FROM study s
INNER JOIN (
    SELECT mood
    FROM study_mood_cnt
    WHERE user_cnt > (SELECT AVG(user_cnt) FROM study_mood_cnt)
) high_mood ON s.music_Influencial_mood LIKE CONCAT('%', high_mood.mood, '%');

SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM study_mood)), 2), '%') AS percentage
FROM study_mood
GROUP BY 1
ORDER BY 2 desc
LIMIT 5

SELECT fav_music_genre, COUNT(*) AS cnt, 
CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM study_mood)), 2), '%') AS percentage
FROM study_mood
GROUP BY 1
ORDER BY 2
LIMIT 3

# 8-5) frequency 별 시간대에 따른 mood
# leisure time
SELECT 
    music_time_slot AS time_slot,
    'Relaxation and stress relief' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 ELSE 0 END) AS user_cnt
FROM leisure
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Uplifting and motivational' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 ELSE 0 END) AS user_cnt
FROM leisure
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Sadness or melancholy' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM leisure
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Social gatherings or parties' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 ELSE 0 END) AS user_cnt
FROM leisure
GROUP BY 1 DESC
ORDER BY 1, 3 DESC
# While Traveling
SELECT 
    music_time_slot AS time_slot,
    'Relaxation and stress relief' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 ELSE 0 END) AS user_cnt
FROM traveling
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Uplifting and motivational' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 ELSE 0 END) AS user_cnt
FROM traveling
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Sadness or melancholy' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM traveling
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Social gatherings or parties' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 ELSE 0 END) AS user_cnt
FROM traveling
GROUP BY 1 DESC
ORDER BY 1, 3 DESC
# Workout Session
SELECT 
    music_time_slot AS time_slot,
    'Relaxation and stress relief' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 ELSE 0 END) AS user_cnt
FROM workout
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Uplifting and motivational' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 ELSE 0 END) AS user_cnt
FROM workout
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Sadness or melancholy' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM workout
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Social gatherings or parties' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 ELSE 0 END) AS user_cnt
FROM workout
GROUP BY 1 DESC
ORDER BY 1, 3 DESC
# Office hours
SELECT 
    music_time_slot AS time_slot,
    'Relaxation and stress relief' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 ELSE 0 END) AS user_cnt
FROM office
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Uplifting and motivational' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 ELSE 0 END) AS user_cnt
FROM office
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Sadness or melancholy' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM office
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Social gatherings or parties' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 ELSE 0 END) AS user_cnt
FROM office
GROUP BY 1 DESC
ORDER BY 1, 3 DESC
# Study hours
SELECT 
    music_time_slot AS time_slot,
    'Relaxation and stress relief' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Relaxation and stress relief%' THEN 1 ELSE 0 END) AS user_cnt
FROM study
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Uplifting and motivational' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Uplifting and motivational%' THEN 1 ELSE 0 END) AS user_cnt
FROM study
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Sadness or melancholy' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Sadness or melancholy%' THEN 1 ELSE 0 END) AS user_cnt
FROM study
GROUP BY 1
UNION ALL
SELECT 
    music_time_slot AS time_slot,
    'Social gatherings or parties' AS mood,
    SUM(CASE WHEN music_Influencial_mood LIKE '%Social gatherings or parties%' THEN 1 ELSE 0 END) AS user_cnt
FROM study
GROUP BY 1 DESC
ORDER BY 1, 3 DESC

# 9) 새로운 음악 찾는 방식
SELECT 'recommendations' AS frequency,
       SUM(CASE WHEN music_expl_method LIKE '%recommendations%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Playlists' AS frequency,
       SUM(CASE WHEN music_expl_method LIKE '%Playlists%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Others' AS frequency,
       SUM(CASE WHEN music_expl_method LIKE '%Others%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
UNION ALL
SELECT 'Radio' AS frequency,
       SUM(CASE WHEN music_expl_method LIKE '%Radio%' THEN 1 ELSE 0 END) AS user_cnt
FROM target
ORDER BY 2 DESC