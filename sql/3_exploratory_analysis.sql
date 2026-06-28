-- Total rides by user type

SELECT
    usertype,
    COUNT(*) AS total_rides
FROM cyclistic.trips
GROUP BY usertype
ORDER BY total_rides DESC;

-- Finding:
-- Members completed 3,315,774 rides
-- Casual riders completed 929,000 rides


-- Percentage of rides by user type

SELECT
    usertype,
    COUNT(*) AS total_rides,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_rides
FROM cyclistic.trips
GROUP BY usertype
ORDER BY total_rides DESC;

-- Findings:
-- Members = 78.11%
-- Casual = 21.89% 
-- Membership users generated the majority of platform usage.


-- Average ride duration by user type

SELECT
    usertype,
    ROUND(AVG(tripduration_minutes)::numeric, 2) AS avg_ride_duration_minutes
FROM cyclistic.trips
GROUP BY usertype
ORDER BY avg_ride_duration_minutes DESC;

-- Finding:
-- Casual riders average 59.05 minutes per ride.
-- Members average 14.14 minutes per ride.
-- Casual riders ride approximately 4.18 times longer than members.

-- Ride duration distribution by user type

SELECT
    usertype,
    MIN(tripduration_minutes) AS min_duration,
    PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY tripduration_minutes) AS median_duration,
    MAX(tripduration_minutes) AS max_duration
FROM cyclistic.trips
GROUP BY usertype;

-- Finding:
-- Casual median trip duration = 25.6 minutes
-- Member median trip duration = 9.65 minutes
-- Extreme ride-duration outliers exist (100+ day durations)
-- Median is a more reliable measure of central tendency for trip duration

SELECT
    usertype,
    ROUND(AVG(tripduration_minutes)::numeric, 2) AS avg_duration
FROM cyclistic.trips
WHERE tripduration_minutes BETWEEN 1 AND 1440
GROUP BY usertype;

-- Data quality check: rides longer than 24 hours

SELECT
    COUNT(*) AS rides_over_24_hours
FROM cyclistic.trips
WHERE tripduration_minutes > 1440;

-- Finding:
-- 2,138 rides exceeded 24 hours
-- Represents approximately 0.05% of all rides
-- These records are likely anomalies and inflate average ride duration
-- Duration-based analyses should use rides between 1 and 1440 minutes

-- Average ride duration by user type (excluding rides over 24 hours)

SELECT
    usertype,
    ROUND(AVG(tripduration_minutes)::numeric, 2) AS avg_duration_clean
FROM cyclistic.trips
WHERE tripduration_minutes BETWEEN 1 AND 1440
GROUP BY usertype;

-- Finding:
-- Casual riders average 39.46 minutes per ride after removing outliers
-- Member riders average 12.78 minutes per ride after removing outliers
-- Casual riders still ride approximately 3.09 times longer than members
-- Outliers disproportionately affected casual rider averages
-- Duration differences remain significant even after outlier removal


-- Total rides by day of week and user type

SELECT
    day_name,
    usertype,
    COUNT(*) AS total_rides
FROM cyclistic.trips
GROUP BY day_name, usertype
ORDER BY day_name, usertype;

-- Finding:
-- Member rides remain relatively consistent throughout the week
-- Member usage peaks on Tuesday, Wednesday and Thursday
-- Casual rider usage peaks significantly on weekends
-- Saturday records the highest number of casual rides
-- Weekend usage suggests casual riders use bikes more for leisure and recreation
-- Member behavior appears more transportation/commuting oriented


-- Percentage of rides by day of week within each user type

SELECT
    usertype,
    day_name,
    COUNT(*) AS total_rides,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY usertype),
        2
    ) AS percentage_of_user_rides
FROM cyclistic.trips
GROUP BY usertype, day_name
ORDER BY usertype, percentage_of_user_rides DESC;

-- Finding:
-- Casual rider activity is heavily concentrated on weekends
-- Saturday accounts for 23.20% of all casual rides
-- Sunday accounts for 19.92% of all casual rides
-- Nearly 43% of casual rides occur on weekends
-- Member activity is concentrated on weekdays
-- Tuesday, Wednesday and Thursday account for over 50% of member rides
-- Weekend activity represents a much smaller share of member usage
-- Results support the hypothesis that casual riders use bikes primarily for leisure, while members use bikes for transportation and commuting


-- Ride activity by hour and user type

SELECT
    hour,
    usertype,
    COUNT(*) AS total_rides
FROM cyclistic.trips
GROUP BY hour, usertype
ORDER BY hour, usertype;

-- Finding:
-- Members show strong commuter behavior
-- Ride activity peaks during morning (7–9 AM) and evening (4–6 PM) commuting hours
-- Highest member activity occurs at 5 PM (438,905 rides)

-- Casual riders show recreational behavior
-- Ride activity gradually increases throughout the day
-- Highest casual activity occurs between 1 PM and 5 PM
-- Casual riders do not exhibit the sharp commuting peaks seen among members

-- This supports the conclusion that members primarily use bikes for transportation,
-- while casual riders use bikes more frequently for leisure and recreational purposes.


-- Monthly ride trends by user type

SELECT
    month_name,
    month,
    usertype,
    COUNT(*) AS total_rides
FROM cyclistic.trips
GROUP BY month_name, month, usertype
ORDER BY month, usertype;

-- Finding:
-- Both user groups show strong seasonality, with ride activity peaking in summer months.

-- Casual riders are highly seasonal:
-- Usage grows rapidly from spring and peaks in August (186,889 rides).
-- Winter usage is extremely low, suggesting recreational and weather-dependent riding behavior.

-- Members also peak during summer but maintain relatively strong usage throughout the year.
-- August records the highest member activity (403,295 rides).

-- Member usage remains substantially higher during colder months,
-- indicating that members rely on bikes for transportation and commuting.

-- Seasonal trends suggest that casual riders may be more receptive to
-- membership conversion campaigns during spring and summer when engagement is highest.


-- Weekend vs weekday usage by user type

SELECT
    usertype,
    is_weekend,
    COUNT(*) AS total_rides,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY usertype),
        2
    ) AS percentage_of_user_rides
FROM cyclistic.trips
GROUP BY usertype, is_weekend
ORDER BY usertype, is_weekend;



-- =========================================================
-- KEY BUSINESS INSIGHTS
-- =========================================================

-- 1. Members account for 78.11% of all rides.
-- 2. Casual riders account for 21.89% of all rides.
-- 3. Casual riders take significantly longer rides (39.46 mins vs 12.78 mins).
-- 4. Members exhibit strong weekday commuting patterns.
-- 5. Casual riders show stronger weekend and leisure-oriented usage.
-- 6. Member rides peak during morning and evening commute hours.
-- 7. Casual riders peak during afternoon recreational hours.
-- 8. Both groups show seasonality, but casual riders are far more weather-dependent.
-- 9. Summer months present the greatest opportunity for converting casual riders into annual members.



