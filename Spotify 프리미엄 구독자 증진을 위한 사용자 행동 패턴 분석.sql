-- < 비구독자 vs 현구독자 사용자 행동 패턴 탐색 > --

-- 비구독자 --
-- 1. 성별
SELECT
    Gender,premium_sub_willingness,
    COUNT(*) AS user_count
FROM spotify
WHERE spotify_subscription_plan = 'Free (ad-supported)'
GROUP BY 1,2
ORDER BY 1;

-- 2. 연령
SELECT
    AGE,premium_sub_willingness,
    COUNT(*) AS user_count
FROM spotify
WHERE spotify_subscription_plan = 'Free (ad-supported)'
GROUP BY 1,2
ORDER BY 1;

-- 3. spotify_usage_period
SELECT
    spotify_usage_period,premium_sub_willingness,
    COUNT(*) AS user_count
FROM spotify
WHERE spotify_subscription_plan = 'Free (ad-supported)'
GROUP BY 1,2
ORDER BY 1;

-- 4. preffered_premium_plan 
SELECT
    preffered_premium_plan, premium_sub_willingness,
    COUNT(*) AS user_count
FROM spotify
WHERE spotify_subscription_plan = 'Free (ad-supported)'
GROUP BY 1,2
ORDER BY 1;

-- 5. music_time_slot
SELECT
   music_time_slot, premium_sub_willingness,
    COUNT(*) AS user_count
FROM spotify
WHERE spotify_subscription_plan = 'Free (ad-supported)'
GROUP BY 1,2
ORDER BY 1;

-- 6. music_recc_rating
SELECT
    premium_sub_willingness,
    AVG(CAST(music_recc_rating AS DECIMAL(5, 2))) AS avg_music_recc_rating
FROM spotify
WHERE spotify_subscription_plan = 'Free (ad-supported)'
GROUP BY premium_sub_willingness;

-- 7. pod_variety_satisfaction

SELECT
    pod_variety_satisfaction, premium_sub_willingness,
    COUNT(*) AS user_count
FROM spotify
WHERE spotify_subscription_plan = 'Free (ad-supported)'
GROUP BY 1,2
ORDER BY 1;

-- 현구독자 --
-- 1. 성별
SELECT
    Gender,premium_sub_willingness,
    COUNT(*) AS user_count
FROM spotify
WHERE spotify_subscription_plan = 'Premium (paid subscription)'
GROUP BY 1,2
ORDER BY 1;

-- 2. 연령
SELECT
    AGE,premium_sub_willingness,
    COUNT(*) AS user_count
FROM spotify
WHERE spotify_subscription_plan = 'Premium (paid subscription)'
GROUP BY 1,2
ORDER BY 1;

-- 3. spotify_usage_period
SELECT
    spotify_usage_period,premium_sub_willingness,
    COUNT(*) AS user_count
FROM spotify
WHERE spotify_subscription_plan = 'Premium (paid subscription)'
GROUP BY 1,2
ORDER BY 1;

-- 4. preffered_premium_plan 
SELECT
    preffered_premium_plan, premium_sub_willingness,
    COUNT(*) AS user_count
FROM spotify
GROUP BY 1,2
ORDER BY 3 desc;

-- 5. music_time_slot
SELECT
   music_time_slot, premium_sub_willingness,
    COUNT(*) AS user_count
FROM spotify
WHERE spotify_subscription_plan = 'Premium (paid subscription)'
GROUP BY 1,2
ORDER BY 1;

-- 6. music_recc_rating
SELECT
    premium_sub_willingness,
    AVG(CAST(music_recc_rating AS DECIMAL(5, 2))) AS avg_music_recc_rating
FROM spotify
WHERE spotify_subscription_plan = 'Premium (paid subscription)'
GROUP BY premium_sub_willingness;

-- 7. pod_variety_satisfaction

SELECT
    pod_variety_satisfaction, premium_sub_willingness,
    COUNT(*) AS user_count
FROM spotify
WHERE spotify_subscription_plan = 'Premium (paid subscription)'
GROUP BY 1,2
ORDER BY 1;

-- < 마켓팅 전략 > --

-- 비구독자 --
-- 1. 구독료 plan
SELECT
if(preffered_premium_plan= 'None','None', 'prefering')as prf,premium_sub_willingness,
COUNT(*) AS user_count
FROM spotify
Where spotify_subscription_plan = 'Free (ad-supported)'
GROUP BY 1,2
ORDER BY 1,3 desc;

SELECT preffered_premium_plan, COUNT(*) AS user_count
FROM spotify
WHERE premium_sub_willingness = 'Yes' AND spotify_subscription_plan = 'Free (ad-supported)' 
GROUP BY preffered_premium_plan
ORDER BY 2 DESC;

-- 2. 연령대가 타겟일 경우
SELECT AGE, preffered_premium_plan, COUNT(*) AS user_count
FROM spotify
WHERE premium_sub_willingness = 'Yes' AND spotify_subscription_plan = 'Free (ad-supported)'
GROUP BY preffered_premium_plan, AGE
ORDER BY 1,3 DESC;

-- 3. 이용 기간이 타겟일 경우
SELECT
    spotify_usage_period,
    preffered_premium_plan,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY spotify_usage_period), 4) AS willingness_percentage
FROM
    spotify
WHERE premium_sub_willingness = 'Yes' AND spotify_subscription_plan = 'Free (ad-supported)'
GROUP BY
    spotify_usage_period,
    preffered_premium_plan
ORDER BY
    1,3 DESC;
    
-- 현구독자 --
-- 1. 구독료 plan
SELECT
     if(preffered_premium_plan= 'None','None', 'prefering')as prf,premium_sub_willingness,
    COUNT(*) AS user_count
FROM spotify
Where spotify_subscription_plan = 'Premium (paid subscription)' 
GROUP BY 1,2
ORDER BY 1,3 desc;

SELECT preffered_premium_plan, COUNT(*) AS user_count
FROM spotify
WHERE premium_sub_willingness = 'Yes' AND spotify_subscription_plan = 'Premium (paid subscription)' 
GROUP BY preffered_premium_plan
ORDER BY 2 DESC;

-- 2. 연령대가 타겟일 경우
-- 사용 나이별 어느 plan에 promotion을 주면 될지 타겟 가능
SELECT AGE, preffered_premium_plan, COUNT(*) AS user_count
FROM spotify
WHERE premium_sub_willingness = 'Yes' AND spotify_subscription_plan = 'Premium (paid subscription)' 
GROUP BY preffered_premium_plan, AGE
ORDER BY 1,3 DESC;

-- 3. 이용 기간이 타겟일 경우
SELECT
    spotify_usage_period,
    preffered_premium_plan,
    COUNT(*) AS user_count
FROM
    spotify
WHERE premium_sub_willingness = 'Yes' AND spotify_subscription_plan = 'Premium (paid subscription)' 
GROUP BY
    preffered_premium_plan, spotify_usage_period, premium_sub_willingness
ORDER BY
    1,3 DESC;
    
-- 4. 시간대가 타겟일 경우
SELECT
    music_time_slot,
    premium_sub_willingness,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY music_time_slot), 2) AS willingness_percentage_music_time_slot,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS willingness_percentage_total
FROM
    spotify
WHERE spotify_subscription_plan = 'Premium (paid subscription)'
GROUP BY
    music_time_slot, premium_sub_willingness
ORDER BY
    1, 3 DESC;

-- < 잠재고객 탐색 > --

-- 1. 가입기간 변수에서의 잠재고객 탐색
SELECT
    premium_sub_willingness,
    spotify_usage_period,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY premium_sub_willingness), 2) AS preference_percentage_by_group,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS preference_percentage_total
FROM
    spotify
WHERE
    (premium_sub_willingness = 'Yes' AND spotify_subscription_plan = 'Free (ad-supported)')
    OR (premium_sub_willingness = 'Yes' AND spotify_subscription_plan = 'Premium (paid subscription)')
GROUP BY
    premium_sub_willingness, spotify_usage_period
ORDER BY
    1, 4 DESC;
    
-- 2. 선호하는 구독료 변수에서의 잠재고객 탐색
SELECT
    premium_sub_willingness,
    preffered_premium_plan,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY premium_sub_willingness), 2) AS preference_percentage_by_group,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS preference_percentage_total
FROM
    spotify
WHERE
    (premium_sub_willingness = 'Yes' AND spotify_subscription_plan = 'Free (ad-supported)')
    OR (premium_sub_willingness = 'Yes' AND spotify_subscription_plan = 'Premium (paid subscription)')
GROUP BY
    premium_sub_willingness, preffered_premium_plan
ORDER BY
    1, 4 DESC;