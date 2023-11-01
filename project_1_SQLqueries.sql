# Ashely Luk, Emily Brown, and Angela Hong
CREATE schema baseball; 
CREATE TABLE baseball.seattle_stadium (
	`attendance` int DEFAULT NULL,
	`date` text,
	`start_time` text,
	`weather` text,
	`wind` text
);

CREATE TABLE baseball.weather_data (`ï»¿datetime` text,
  `tempmax` double DEFAULT NULL,
  `tempmin` double DEFAULT NULL,
  `temp` double DEFAULT NULL,
  `feelslikemax` double DEFAULT NULL,
  `feelslikemin` double DEFAULT NULL,
  `feelslike` double DEFAULT NULL,
  `dew` double DEFAULT NULL,
  `humidity` double DEFAULT NULL,
  `precip` double DEFAULT NULL,
  `precipprob` int DEFAULT NULL,
  `precipcover` double DEFAULT NULL,
  `preciptype` text,
  `snow` int DEFAULT NULL,
  `snowdepth` int DEFAULT NULL,
  `windgust` text,
  `windspeed` double DEFAULT NULL,
  `winddir` double DEFAULT NULL,
  `pressure` double DEFAULT NULL,
  `cloudcover` double DEFAULT NULL,
  `visibility` double DEFAULT NULL,
  `solarradiation` double DEFAULT NULL,
  `solarenergy` double DEFAULT NULL,
  `uvindex` int DEFAULT NULL,
  `severerisk` text,
  `sunrise` text,
  `sunset` double DEFAULT NULL,
  `moonphase` text,
  `conditions` text,
  `description` text,
  `icon` text,
  `stations` text,
  `source` text,
  `name` text
);

CREATE TABLE `wlseattle` (
  `ï»¿` int DEFAULT NULL,
  `Date` text,
  `W/L` text,
  `Attendance` int DEFAULT NULL,
  `Location` text
);

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



