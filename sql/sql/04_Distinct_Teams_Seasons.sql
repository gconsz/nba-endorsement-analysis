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

