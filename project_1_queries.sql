# Ashely Luk, Emily Brown, and Angela Hong

CREATE TABLE seattle_combined AS
SELECT
    ss.attendance AS stadium_attendance,
    ss.date AS stadium_date,
    ss.start_time AS stadium_start_time,
    ss.weather AS stadium_weather,
    ss.wind AS stadium_wind,
    wd.temp AS weather_temp,
    wd.dew AS weather_dew,
    wd.windspeed AS weather_windspeed,
    wd.conditions AS weather_conditions,
    wd.description AS weather_description,
    ws.Date AS game_date,
    ws.`W/L` AS game_result,
    ws.`Attendance` AS game_attendance,
    ws.`Location` AS game_location
FROM
    seattle_stadium ss
JOIN
    weather_data wd ON ss.date = wd.`ï»¿datetime`
JOIN
    wlseattle ws ON ss.date = ws.Date;
    
select * from seattle_combined;
#Average home game attendance for the Seattle Marniers 2015 season
SELECT AVG(stadium_attendance) FROM seattle_combined;

# number of games the Seattle Marniers won in the 2015 seasom
SELECT COUNT(*) AS total_wins FROM seattle_combined
WHERE game_result = 'W' OR 'W-wo';

# Home day conditions where it was raining
SELECT COUNT(*) AS weather_description FROM seattle_combined
WHERE weather_description = 'Rain' or 'rain';

SELECT AVG(weather_windspeed) FROM seattle_combined;
# this query is comparing the average stadium attendance across the 2015 season to the weather conditions that day
SELECT
    game_date,
    stadium_attendance AS attendance,
    weather_description AS weather
FROM
    seattle_combined s
JOIN
    weather_data w ON s.stadium_date = w.`ï»¿datetime`
WHERE
    (s.stadium_attendance) < (SELECT AVG(stadium_attendance) FROM seattle_combined);

# This query is finding what weather conditions invoked a less than average stadium attendance
SELECT
    weather_description AS weather,
    COUNT(*) AS day_count
FROM
(
    SELECT
        game_date,
        stadium_attendance,
        weather_description
    FROM
        seattle_combined s
    JOIN
        weather_data w ON s.stadium_date = `ï»¿datetime`
    WHERE
        (s.stadium_attendance) < (SELECT AVG(stadium_attendance) FROM seattle_combined)
    ) AS subquery
WHERE
    weather_description IN ('rain', 'partly-cloudy-day', 'clear-day')
GROUP BY 
	weather_description;



