-- Last Check for each table:
-- =========================================
-- CHECK TEAM AND SEASON ALIGNMENT
-- =========================================

SELECT
  'statistics_clean' AS table_name,
  COUNT(DISTINCT team_clean) AS distinct_teams,
  COUNT(DISTINCT season_start) AS distinct_seasons
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics_clean`
WHERE team_clean IS NOT NULL
  AND season_start BETWEEN 2010 AND 2025

UNION ALL

SELECT
  'advanced_statistics_clean_view' AS table_name,
  COUNT(DISTINCT team_clean) AS distinct_teams,
  COUNT(DISTINCT season_start) AS distinct_seasons
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics_clean_view`
WHERE team_clean IS NOT NULL
  AND season_start BETWEEN 2010 AND 2025

UNION ALL

SELECT
  'four_factors_clean_view' AS table_name,
  COUNT(DISTINCT team_clean) AS distinct_teams,
  COUNT(DISTINCT season_start) AS distinct_seasons
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean_view`
WHERE team_clean IS NOT NULL
  AND season_start BETWEEN 2010 AND 2025;

--Result: distinct_teams = 30 , distinct_seasons = 16

--Check games_clean home and away team alignment plus seasons

SELECT
  'games_clean' AS table_name,
  COUNT(DISTINCT CASE WHEN home_team_clean IS NOT NULL THEN home_team_clean END) AS distinct_home_teams,
  COUNT(DISTINCT CASE WHEN away_team_clean IS NOT NULL THEN away_team_clean END) AS distinct_away_teams,
  COUNT(DISTINCT season_start) AS distinct_seasons
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games_clean`
WHERE season_start BETWEEN 2010 AND 2025;

-- Result:distinct_home_teams = 30, distinct_away_teams = 30, distinct_seasons = 16
