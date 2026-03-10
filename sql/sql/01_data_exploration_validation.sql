-- =========================================
-- 1. CHECK TOTAL ROWS FOR EACH TABLE
-- =========================================

SELECT 'games' AS table_name, COUNT(*) AS total_rows
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games`

UNION ALL

SELECT 'statistics' AS table_name, COUNT(*) AS total_rows
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics`

UNION ALL

SELECT 'advanced_statistics' AS table_name, COUNT(*) AS total_rows
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`

UNION ALL

SELECT 'four_factors' AS table_name, COUNT(*) AS total_rows
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors`;

-- Expected results:
-- games = 72,906
-- statistics = 145,814
-- advanced_statistics = 10,258
-- four_factors = 10,258


-- =========================================
-- 2. PREVIEW EACH TABLE
-- =========================================

-- Preview statistics table
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics`
LIMIT 10;

-- Preview advanced_statistics table
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`
LIMIT 10;

-- Preview four_factors table
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors`
LIMIT 10;

-- Preview games table
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games`
LIMIT 10;


-- =========================================
-- 3. CHECK FOR NULL VALUES
-- =========================================

-- NULL check for games table
SELECT
  COUNTIF(gameId IS NULL) AS null_gameId,
  COUNTIF(gameDateTimeEst IS NULL) AS null_gameDateTimeEst,
  COUNTIF(hometeamCity IS NULL) AS null_homeTeamCity,
  COUNTIF(hometeamName IS NULL) AS null_homeTeamName,
  COUNTIF(awayteamCity IS NULL) AS null_awayTeamCity,
  COUNTIF(awayteamName IS NULL) AS null_awayTeamName
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games`;

-- Result: 0 NULL values in all checked columns


-- NULL check for statistics table
SELECT
  COUNTIF(teamCity IS NULL) AS null_teamCity,
  COUNTIF(teamName IS NULL) AS null_teamName,
  COUNTIF(teamScore IS NULL) AS null_teamScore,
  COUNTIF(opponentScore IS NULL) AS null_opponentScore,
  COUNTIF(win IS NULL) AS null_win,
  COUNTIF(gameDateTimeEst IS NULL) AS null_gameDateTimeEst
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics`;

-- Result: 2 NULL values in teamCity, teamName, and win


-- NULL check for advanced_statistics table
SELECT
  COUNTIF(offRating IS NULL) AS null_offRating,
  COUNTIF(defRating IS NULL) AS null_defRating,
  COUNTIF(netRating IS NULL) AS null_netRating,
  COUNTIF(tsPct IS NULL) AS null_tsPct,
  COUNTIF(efgPct IS NULL) AS null_efgPct
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`;

-- Result: 0 NULL values in all checked columns


-- NULL check for four_factors table
SELECT
  COUNTIF(efgPct IS NULL) AS null_efgPct,
  COUNTIF(ftaRate IS NULL) AS null_ftaRate,
  COUNTIF(orebPct IS NULL) AS null_orebPct,
  COUNTIF(tmTovPct IS NULL) AS null_tmTovPct,
  COUNTIF(oppEfgPct IS NULL) AS null_oppEfgPct
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors`;

-- Result: 746 NULL values in orebPct


-- =========================================
-- 4. REMOVE NULL VALUES 
-- =========================================
--Clean statistics table by removing rows with critical NULLs
CREATE OR REPLACE TABLE `smart-rope-473422-t2.NBA_ANALYSIS.statistics_clean_nulls` AS
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics`
WHERE teamCity IS NOT NULL
  AND teamName IS NOT NULL
  AND win IS NOT NULL;

-- Verify statistics NULLs are removed
SELECT
  COUNTIF(teamCity IS NULL) AS null_teamCity,
  COUNTIF(teamName IS NULL) AS null_teamName,
  COUNTIF(win IS NULL) AS null_win
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics_clean_nulls`;

-- Expected result: all 0

-- Clean four_factors table by removing rows where orebPct is NULL

CREATE OR REPLACE TABLE `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean` AS
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors`
WHERE orebPct IS NOT NULL;

-- Verify NULL values were removed
SELECT
  COUNTIF(orebPct IS NULL) AS null_orebPct
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean`;

-- Result: 0 NULL values remain in orebPct


-- =========================================
-- 5. ADDITIONAL NULL CHECK FOR GAMES SCORES
-- =========================================

SELECT
  COUNTIF(hometeamCity IS NULL) AS null_home_city,
  COUNTIF(awayteamCity IS NULL) AS null_away_city,
  COUNTIF(homeScore IS NULL) AS null_home_score,
  COUNTIF(awayScore IS NULL) AS null_away_score
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games`;

-- Result: 0 NULL values in all checked columns


-- =========================================
-- 6. CHECK FOR DUPLICATES
-- =========================================

-- Duplicate check for statistics table
SELECT
  teamId,
  teamCity,
  teamName,
  gameId,
  COUNT(*) AS duplicate_count
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics_clean_nulls`
GROUP BY teamId, teamCity, teamName, gameId
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Result: 0 duplicates

-- Advanced statistics duplicate check
-- Better to check by team and date/game level instead of COUNT(*) > 100
SELECT
  teamCity,
  teamName,
  gameDateTimeEst,
  COUNT(*) AS duplicate_count
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`
GROUP BY teamCity, teamName, gameDateTimeEst
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

---- Result: duplicate group(s) found, caused by rows with NULL key fields

-- Remove invalid rows with NULL values in duplicate key fields from advanced_statistics
CREATE OR REPLACE TABLE `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics_clean` AS
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`
WHERE NOT (
  teamCity IS NULL
  AND teamName IS NULL
  AND gameDateTimeEst IS NULL
);
-- Verify if there are any duplicates in New Table
SELECT
  teamCity,
  teamName,
  gameDateTimeEst,
  COUNT(*) AS duplicate_count
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics_clean`
GROUP BY teamCity, teamName, gameDateTimeEst
HAVING COUNT(*) > 1;
-- Result: 0 duplicate groups returned

-- Four Factors Duplicate Check
SELECT
  teamCity,
  teamName,
  gameDateTimeEst,
  COUNT(*) AS duplicate_count
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean`
GROUP BY teamCity, teamName, gameDateTimeEst
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
-- -- Result: duplicate group(s) found, caused by rows with NULL key fields
-- Remove invalid rows with NULL values in duplicate key fields from four_factors_clean
CREATE OR REPLACE TABLE `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean_v2` AS
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean`
WHERE NOT (
  teamCity IS NULL
  AND teamName IS NULL
  AND gameDateTimeEst IS NULL
);

--Verify Duplicates

SELECT
  teamCity,
  teamName,
  gameDateTimeEst,
  COUNT(*) AS duplicate_count
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean_v2`
GROUP BY teamCity, teamName, gameDateTimeEst
HAVING COUNT(*) > 1;
-- Result: 0 duplicates returned

-- Games table duplicate check
SELECT
  gameId,
  gameDateTimeEst,
  hometeamCity,
  hometeamName,
  awayteamCity,
  awayteamName,
  COUNT(*) AS duplicate_count
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games`
GROUP BY gameId, gameDateTimeEst, hometeamCity, hometeamName, awayteamCity, awayteamName
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
-- Returned 0 duplicates
-- =========================================



-- =========================================
-- DISTINCT TEAMS AND DISTINCT SEASONS
-- RESTRICTED TO NBA SEASONS 2010-2025
-- =========================================


-- =========================================
-- 1. STATISTICS TABLE
-- =========================================

-- Check raw distinct team names in statistics table
SELECT DISTINCT
  teamCity,
  teamName
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics`
ORDER BY teamCity, teamName;

-- Result: 71 team names including historical and current franchises


-- Create cleaned statistics view with standardized franchise names
-- and a season_start field for NBA season logic
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
  END AS team_clean,
  CASE
    WHEN EXTRACT(MONTH FROM DATE(gameDateTimeEst)) >= 10
      THEN EXTRACT(YEAR FROM DATE(gameDateTimeEst))
    ELSE EXTRACT(YEAR FROM DATE(gameDateTimeEst)) - 1
  END AS season_start
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics_clean_nulls`;

-- Check distinct cleaned teams in statistics table for seasons 2010-2025
SELECT
  COUNT(DISTINCT team_clean) AS distinct_teams_2010_2025
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics_clean`
WHERE team_clean IS NOT NULL
  AND season_start BETWEEN 2010 AND 2025;

-- Expected result: 30 teams


-- Check distinct seasons in statistics table for seasons 2010-2025
SELECT
  COUNT(DISTINCT season_start) AS distinct_seasons_2010_2025
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics_clean`
WHERE season_start BETWEEN 2010 AND 2025;

-- Expected result: 16 seasons


-- List seasons in statistics table for verification
SELECT DISTINCT
  season_start
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics_clean`
WHERE season_start BETWEEN 2010 AND 2025
ORDER BY season_start;


-- =========================================
-- 2. ADVANCED_STATISTICS TABLE
-- =========================================

-- Check raw distinct team names in advanced_statistics table
SELECT DISTINCT
  teamCity,
  teamName
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`
ORDER BY teamCity, teamName;

-- Result: 42 teams includes historical and current franchise names


-- Create cleaned advanced_statistics view
CREATE OR REPLACE VIEW `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics_clean_view` AS
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
  END AS team_clean,
  CASE
    WHEN EXTRACT(MONTH FROM DATE(gameDateTimeEst)) >= 10
      THEN EXTRACT(YEAR FROM DATE(gameDateTimeEst))
    ELSE EXTRACT(YEAR FROM DATE(gameDateTimeEst)) - 1
  END AS season_start
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics_clean`;

-- Check distinct cleaned teams in advanced_statistics for seasons 2010-2025
SELECT
  COUNT(DISTINCT team_clean) AS distinct_teams_2010_2025
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics_clean_view`
WHERE team_clean IS NOT NULL
  AND season_start BETWEEN 2010 AND 2025;

-- Expected result: 30 teams


-- Check distinct seasons in advanced_statistics for seasons 2010-2025
SELECT
  COUNT(DISTINCT season_start) AS distinct_seasons_2010_2025
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics_clean_view`
WHERE season_start BETWEEN 2010 AND 2025;

-- Expected result: 16 seasons


-- List seasons in advanced_statistics for verification
SELECT DISTINCT
  season_start
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics_clean_view`
WHERE season_start BETWEEN 2010 AND 2025
ORDER BY season_start;


-- =========================================
-- 3. FOUR_FACTORS TABLE
-- =========================================

-- Check raw distinct team names in four_factors table
SELECT DISTINCT
  teamCity,
  teamName
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors`
ORDER BY teamCity, teamName;

-- Result: includes historical and current franchise names


-- Create cleaned four_factors view
CREATE OR REPLACE VIEW `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean_view` AS
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
  END AS team_clean,
  CASE
    WHEN EXTRACT(MONTH FROM DATE(gameDateTimeEst)) >= 10
      THEN EXTRACT(YEAR FROM DATE(gameDateTimeEst))
    ELSE EXTRACT(YEAR FROM DATE(gameDateTimeEst)) - 1
  END AS season_start
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean_v2`;

-- Check distinct cleaned teams in four_factors for seasons 2010-2025
SELECT
  COUNT(DISTINCT team_clean) AS distinct_teams_2010_2025
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean_view`
WHERE team_clean IS NOT NULL
  AND season_start BETWEEN 2010 AND 2025;

-- Expected result: 30 teams


-- Check distinct seasons in four_factors for seasons 2010-2025
SELECT
  COUNT(DISTINCT season_start) AS distinct_seasons_2010_2025
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean_view`
WHERE season_start BETWEEN 2010 AND 2025;

-- Expected result: 16 seasons


-- List seasons in four_factors for verification
SELECT DISTINCT
  season_start
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean_view`
WHERE season_start BETWEEN 2010 AND 2025
ORDER BY season_start;


-- =========================================
-- 4. GAMES TABLE
-- =========================================

-- Check raw distinct team names in games table
SELECT
  COUNT(DISTINCT CONCAT(hometeamCity, ' ', hometeamName)) AS distinct_home_teams_raw,
  COUNT(DISTINCT CONCAT(awayteamCity, ' ', awayteamName)) AS distinct_away_teams_raw
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games`;

-- Result: 63 distinct home teams and 67 distinct away teams


-- Create cleaned games view with standardized team names
CREATE OR REPLACE VIEW `smart-rope-473422-t2.NBA_ANALYSIS.games_clean` AS
SELECT
  *,
  CASE
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Atlanta Hawks' THEN 'Atlanta Hawks'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Boston Celtics' THEN 'Boston Celtics'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) IN ('Brooklyn Nets','New Jersey Nets') THEN 'Brooklyn Nets'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) IN ('Charlotte Hornets','Charlotte Bobcats') THEN 'Charlotte Hornets'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Chicago Bulls' THEN 'Chicago Bulls'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Cleveland Cavaliers' THEN 'Cleveland Cavaliers'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Dallas Mavericks' THEN 'Dallas Mavericks'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Denver Nuggets' THEN 'Denver Nuggets'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Detroit Pistons' THEN 'Detroit Pistons'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Golden State Warriors' THEN 'Golden State Warriors'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Houston Rockets' THEN 'Houston Rockets'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Indiana Pacers' THEN 'Indiana Pacers'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) IN ('LA Clippers','Los Angeles Clippers') THEN 'Los Angeles Clippers'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) IN ('Los Angeles Lakers','Minneapolis Lakers') THEN 'Los Angeles Lakers'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) IN ('Memphis Grizzlies','Vancouver Grizzlies') THEN 'Memphis Grizzlies'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Miami Heat' THEN 'Miami Heat'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Milwaukee Bucks' THEN 'Milwaukee Bucks'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Minnesota Timberwolves' THEN 'Minnesota Timberwolves'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) IN ('New Orleans Pelicans','New Orleans Hornets') THEN 'New Orleans Pelicans'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'New York Knicks' THEN 'New York Knicks'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) IN ('Oklahoma City Thunder','Seattle SuperSonics') THEN 'Oklahoma City Thunder'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Orlando Magic' THEN 'Orlando Magic'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) IN ('Philadelphia 76ers','Syracuse Nationals') THEN 'Philadelphia 76ers'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Phoenix Suns' THEN 'Phoenix Suns'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Portland Trail Blazers' THEN 'Portland Trail Blazers'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) IN ('Sacramento Kings','Kansas City Kings','Cincinnati Royals','Rochester Royals') THEN 'Sacramento Kings'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'San Antonio Spurs' THEN 'San Antonio Spurs'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) = 'Toronto Raptors' THEN 'Toronto Raptors'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) IN ('Utah Jazz','New Orleans Jazz') THEN 'Utah Jazz'
    WHEN TRIM(CONCAT(COALESCE(hometeamCity,''), ' ', COALESCE(hometeamName,''))) IN ('Washington Wizards','Washington Bullets','Capital Bullets','Baltimore Bullets','Chicago Packers','Chicago Zephyrs') THEN 'Washington Wizards'
    ELSE NULL
  END AS home_team_clean,
  CASE
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Atlanta Hawks' THEN 'Atlanta Hawks'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Boston Celtics' THEN 'Boston Celtics'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) IN ('Brooklyn Nets','New Jersey Nets') THEN 'Brooklyn Nets'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) IN ('Charlotte Hornets','Charlotte Bobcats') THEN 'Charlotte Hornets'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Chicago Bulls' THEN 'Chicago Bulls'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Cleveland Cavaliers' THEN 'Cleveland Cavaliers'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Dallas Mavericks' THEN 'Dallas Mavericks'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Denver Nuggets' THEN 'Denver Nuggets'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Detroit Pistons' THEN 'Detroit Pistons'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Golden State Warriors' THEN 'Golden State Warriors'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Houston Rockets' THEN 'Houston Rockets'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Indiana Pacers' THEN 'Indiana Pacers'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) IN ('LA Clippers','Los Angeles Clippers') THEN 'Los Angeles Clippers'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) IN ('Los Angeles Lakers','Minneapolis Lakers') THEN 'Los Angeles Lakers'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) IN ('Memphis Grizzlies','Vancouver Grizzlies') THEN 'Memphis Grizzlies'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Miami Heat' THEN 'Miami Heat'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Milwaukee Bucks' THEN 'Milwaukee Bucks'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Minnesota Timberwolves' THEN 'Minnesota Timberwolves'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) IN ('New Orleans Pelicans','New Orleans Hornets') THEN 'New Orleans Pelicans'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'New York Knicks' THEN 'New York Knicks'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) IN ('Oklahoma City Thunder','Seattle SuperSonics') THEN 'Oklahoma City Thunder'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Orlando Magic' THEN 'Orlando Magic'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) IN ('Philadelphia 76ers','Syracuse Nationals') THEN 'Philadelphia 76ers'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Phoenix Suns' THEN 'Phoenix Suns'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Portland Trail Blazers' THEN 'Portland Trail Blazers'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) IN ('Sacramento Kings','Kansas City Kings','Cincinnati Royals','Rochester Royals') THEN 'Sacramento Kings'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'San Antonio Spurs' THEN 'San Antonio Spurs'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) = 'Toronto Raptors' THEN 'Toronto Raptors'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) IN ('Utah Jazz','New Orleans Jazz') THEN 'Utah Jazz'
    WHEN TRIM(CONCAT(COALESCE(awayteamCity,''), ' ', COALESCE(awayteamName,''))) IN ('Washington Wizards','Washington Bullets','Capital Bullets','Baltimore Bullets','Chicago Packers','Chicago Zephyrs') THEN 'Washington Wizards'
    ELSE NULL
  END AS away_team_clean,
  CASE
    WHEN EXTRACT(MONTH FROM DATE(gameDateTimeEst)) >= 10
      THEN EXTRACT(YEAR FROM DATE(gameDateTimeEst))
    ELSE EXTRACT(YEAR FROM DATE(gameDateTimeEst)) - 1
  END AS season_start
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games`;

-- Check distinct cleaned home and away teams for seasons 2010-2025
SELECT
  COUNT(DISTINCT home_team_clean) AS distinct_home_teams_2010_2025,
  COUNT(DISTINCT away_team_clean) AS distinct_away_teams_2010_2025
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games_clean`
WHERE season_start BETWEEN 2010 AND 2025
  AND home_team_clean IS NOT NULL
  AND away_team_clean IS NOT NULL;

-- Expected result: 30 home teams and 30 away teams


-- Check distinct seasons in games table for seasons 2010-2025
SELECT
  COUNT(DISTINCT season_start) AS distinct_seasons_2010_2025
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games_clean`
WHERE season_start BETWEEN 2010 AND 2025;

-- Expected result: 16 seasons


-- List seasons in games table for verification
SELECT DISTINCT
  season_start
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games_clean`
WHERE season_start BETWEEN 2010 AND 2025
ORDER BY season_start;
