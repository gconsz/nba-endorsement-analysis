-- Preview for each table, check the total rows

SELECT COUNT(*) AS total_rows
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games`;

SELECT COUNT(*) AS total_rows
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics`;

SELECT COUNT(*) AS total_rows
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`;

SELECT COUNT(*) AS total_rows
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors`;

Row	table_name	total_rows
1	games	72906
2	statistics	145814
3	advanced_statistics	10258
4	four_factors	10258
-- Preview statistics table
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics`
LIMIT 10;

-- Preview columns advanced statistics
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`
LIMIT 10;

-- Preview columns for four factors
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors`
LIMIT 10;

-- Preview colums for games
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games`
LIMIT 10;

-- Check tables for NULL

-- Check NULL for games table
SELECT
COUNTIF(gameId IS NULL) AS null_gameId,
COUNTIF(gameDateTimeEst IS NULL) AS null_date,
COUNTIF(hometeamCity IS NULL) AS null_home_city,
COUNTIF(hometeamName IS NULL) AS null_home_name,
COUNTIF(awayteamCity IS NULL) AS null_away_city,
COUNTIF(awayteamName IS NULL) AS null_away_name
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games`;

-- Returned 0 for each column

--Check NULL for statistics table

SELECT
COUNTIF(teamCity IS NULL) AS null_teamCity,
COUNTIF(teamName IS NULL) AS null_teamName,
COUNTIF(teamScore IS NULL) AS null_teamScore,
COUNTIF(opponentScore IS NULL) AS null_opponentScore,
COUNTIF(win IS NULL) AS null_win,
COUNTIF(gameDateTimeEst IS NULL) AS null_gameDate
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics`;

-- Returned 2 NULL under teamCity, teamName, and win

-- Check NULL for advanced statistics table

SELECT
COUNTIF(offRating IS NULL) AS null_offRating,
COUNTIF(defRating IS NULL) AS null_defRating,
COUNTIF(netRating IS NULL) AS null_netRating,
COUNTIF(tsPct IS NULL) AS null_tsPct,
COUNTIF(efgPct IS NULL) AS null_efgPct
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`;

-- Returned 0 in statistics table

-- Check NULL for four factors table
SELECT
COUNTIF(efgPct IS NULL) AS null_efgPct,
COUNTIF(ftaRate IS NULL) AS null_ftaRate,
COUNTIF(orebPct IS NULL) AS null_orebPct,
COUNTIF(tmTovPct IS NULL) AS null_tmTovPct,
COUNTIF(oppEfgPct IS NULL) AS null_oppEfgPct
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors`;

-- There were 746 NULL values under orebPct

-- Remove NULL Values
CREATE OR REPLACE TABLE 
`smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean` AS
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors`
WHERE orebPct IS NOT NULL;

-- Verify NULLs are gone

SELECT
COUNTIF(orebPct IS NULL) AS null_orebPct
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean`;

-- Returned 0 NULLS


-- Check for NULL in games table
 SELECT
COUNTIF(hometeamCity IS NULL) AS null_home_city,
COUNTIF(awayteamCity IS NULL) AS null_away_city,
COUNTIF(homeScore IS NULL) AS null_home_score,
COUNTIF(awayScore IS NULL) AS null_away_score
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games`;

-- Returned 0 in games table

-- Check for duplicate team record
-- Statistics table
SELECT
teamId,
teamCity,
teamName,
gameId,
COUNT(*) AS duplicate_count
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics`
GROUP BY teamId, teamCity, teamName, gameId
HAVING COUNT(*) > 1;

-- 0 duplicates

-- advanced statistics table
SELECT
teamCity,
teamName,
COUNT(*) AS record_count
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`
GROUP BY teamCity, teamName
HAVING COUNT(*) > 100;

-- 32 Teams accounted for

-- four factors table
SELECT
teamCity,
teamName,
COUNT(*) AS record_count
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors`
GROUP BY teamCity, teamName
HAVING COUNT(*) > 100;

-- 32 Teams Accounted for

-- Check for Distinct Teams and Seasons

-- Statistics Table

SELECT DISTINCT
teamCity,
teamName
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics`
ORDER BY teamCity, teamName;
-- 71 Teams that include historic and current
-- Clean to focus on current teams
CREATE OR REPLACE VIEW `smart-rope-473422-t2.NBA_ANALYSIS.statistics_clean` AS
SELECT
  *,
  CASE
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Atlanta Hawks') THEN 'Atlanta Hawks'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Boston Celtics') THEN 'Boston Celtics'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Brooklyn Nets', 'New Jersey Nets') THEN 'Brooklyn Nets'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Charlotte Hornets', 'Charlotte Bobcats') THEN 'Charlotte Hornets'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Chicago Bulls') THEN 'Chicago Bulls'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Cleveland Cavaliers') THEN 'Cleveland Cavaliers'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Dallas Mavericks') THEN 'Dallas Mavericks'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Denver Nuggets') THEN 'Denver Nuggets'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Detroit Pistons') THEN 'Detroit Pistons'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Golden State Warriors') THEN 'Golden State Warriors'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Houston Rockets') THEN 'Houston Rockets'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Indiana Pacers') THEN 'Indiana Pacers'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('LA Clippers', 'Los Angeles Clippers') THEN 'Los Angeles Clippers'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Los Angeles Lakers', 'Minneapolis Lakers') THEN 'Los Angeles Lakers'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Memphis Grizzlies', 'Vancouver Grizzlies') THEN 'Memphis Grizzlies'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Miami Heat') THEN 'Miami Heat'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Milwaukee Bucks') THEN 'Milwaukee Bucks'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Minnesota Timberwolves') THEN 'Minnesota Timberwolves'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('New Orleans Pelicans', 'New Orleans Hornets') THEN 'New Orleans Pelicans'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('New York Knicks') THEN 'New York Knicks'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Oklahoma City Thunder', 'Seattle SuperSonics') THEN 'Oklahoma City Thunder'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Orlando Magic') THEN 'Orlando Magic'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Philadelphia 76ers', 'Syracuse Nationals') THEN 'Philadelphia 76ers'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Phoenix Suns') THEN 'Phoenix Suns'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Portland Trail Blazers') THEN 'Portland Trail Blazers'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Sacramento Kings', 'Kansas City Kings', 'Cincinnati Royals', 'Rochester Royals') THEN 'Sacramento Kings'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('San Antonio Spurs') THEN 'San Antonio Spurs'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Toronto Raptors') THEN 'Toronto Raptors'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Utah Jazz', 'New Orleans Jazz') THEN 'Utah Jazz'
    WHEN TRIM(CONCAT(COALESCE(teamCity, ''), ' ', COALESCE(teamName, ''))) IN ('Washington Wizards', 'Washington Bullets', 'Capital Bullets', 'Baltimore Bullets', 'Chicago Packers', 'Chicago Zephyrs') THEN 'Washington Wizards'
    ELSE NULL
  END AS team_clean
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics`;
-- New table should return 30 NBA Teams
SELECT COUNT(DISTINCT team_clean) AS cleaned_team_count
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics_clean`
WHERE team_clean IS NOT NULL;
-- Returned 30 Teams
-- Check for Distinct Seasons for statistics table
SELECT
COUNT(DISTINCT
CASE
WHEN EXTRACT(MONTH FROM DATE(gameDateTimeEst)) >= 10
THEN EXTRACT(YEAR FROM DATE(gameDateTimeEst))
ELSE EXTRACT(YEAR FROM DATE(gameDateTimeEst)) - 1
END
) AS distinct_seasons
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`;
-- 30 Distinct Seasons
-- Focus on Teams from 2010-2026
SELECT DISTINCT
CASE
WHEN EXTRACT(MONTH FROM DATE(gameDateTimeEst)) >= 10
THEN EXTRACT(YEAR FROM DATE(gameDateTimeEst))
ELSE EXTRACT(YEAR FROM DATE(gameDateTimeEst)) - 1
END AS season_start
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics`
WHERE EXTRACT(YEAR FROM DATE(gameDateTimeEst)) >= 2010
ORDER BY season_start;

-- 17 Seasons (2009-2026)

-- Advanced Statistics Table

SELECT
COUNT(DISTINCT CONCAT(teamCity,' ',teamName)) AS distinct_teams
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`;

-- 41 Teams that include historic and current

SELECT
COUNT(DISTINCT
CASE
WHEN EXTRACT(MONTH FROM DATE(gameDateTimeEst)) >= 10
THEN EXTRACT(YEAR FROM DATE(gameDateTimeEst))
ELSE EXTRACT(YEAR FROM DATE(gameDateTimeEst)) - 1
END
) AS distinct_seasons
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`;
-- 30 Distinct Seasons
-- games table
SELECT
COUNT(DISTINCT CONCAT(hometeamCity,' ',hometeamName)) AS distinct_home_teams,
COUNT(DISTINCT CONCAT(awayteamCity,' ',awayteamName)) AS distinct_away_teams
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games`;

-- 63 Distinct home teams and 67 Distinct away teams
