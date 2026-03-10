-- =========================================
-- 1. TEAM-SEASON STATISTICS SUMMARY
-- =========================================

CREATE OR REPLACE TABLE `smart-rope-473422-t2.NBA_ANALYSIS.team_season_statistics_summary` AS
SELECT
  team_clean,
  season_start,
  COUNT(DISTINCT gameId) AS games_played,
  SUM(CASE WHEN win = 1 THEN 1 ELSE 0 END) AS wins,
  COUNT(DISTINCT gameId) - SUM(CASE WHEN win = 1 THEN 1 ELSE 0 END) AS losses,
  ROUND(
    SAFE_DIVIDE(SUM(CASE WHEN win = 1 THEN 1 ELSE 0 END), COUNT(DISTINCT gameId)),
    3
  ) AS win_pct,
  ROUND(AVG(teamScore), 2) AS avg_points_scored,
  ROUND(AVG(opponentScore), 2) AS avg_points_allowed,
  ROUND(AVG(teamScore - opponentScore), 2) AS avg_point_differential
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics_clean`
WHERE season_start BETWEEN 2010 AND 2025
  AND team_clean IS NOT NULL
  AND (
    EXTRACT(MONTH FROM DATE(gameDateTimeEst)) BETWEEN 10 AND 12
    OR EXTRACT(MONTH FROM DATE(gameDateTimeEst)) BETWEEN 1 AND 6
  )
GROUP BY team_clean, season_start;

-- View statistics summary
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_season_statistics_summary`
ORDER BY season_start, win_pct DESC, team_clean;

-- Validate statistics summary
SELECT
  MIN(season_start) AS min_season,
  MAX(season_start) AS max_season,
  COUNT(DISTINCT season_start) AS distinct_seasons,
  COUNT(DISTINCT team_clean) AS distinct_teams
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_season_statistics_summary`;


-- =========================================
-- 2. TEAM-SEASON ADVANCED STATISTICS SUMMARY
-- =========================================

CREATE OR REPLACE TABLE `smart-rope-473422-t2.NBA_ANALYSIS.team_season_advanced_summary` AS
SELECT
  team_clean,
  season_start,
  COUNT(*) AS records_count,
  ROUND(AVG(offRating), 2) AS avg_off_rating,
  ROUND(AVG(defRating), 2) AS avg_def_rating,
  ROUND(AVG(netRating), 2) AS avg_net_rating,
  ROUND(AVG(tsPct), 4) AS avg_true_shooting_pct,
  ROUND(AVG(efgPct), 4) AS avg_effective_fg_pct
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics_clean_view`
WHERE season_start BETWEEN 2010 AND 2025
  AND team_clean IS NOT NULL
  AND (
    EXTRACT(MONTH FROM DATE(gameDateTimeEst)) BETWEEN 10 AND 12
    OR EXTRACT(MONTH FROM DATE(gameDateTimeEst)) BETWEEN 1 AND 6
  )
GROUP BY team_clean, season_start;
-- View advanced statistics summary
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_season_advanced_summary`
ORDER BY season_start, avg_net_rating DESC, team_clean;

-- Validate advanced statistics summary
SELECT
  MIN(season_start) AS min_season,
  MAX(season_start) AS max_season,
  COUNT(DISTINCT season_start) AS distinct_seasons,
  COUNT(DISTINCT team_clean) AS distinct_teams
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_season_advanced_summary`;


-- =========================================
-- 3. TEAM-SEASON FOUR FACTORS SUMMARY
-- =========================================

CREATE OR REPLACE TABLE `smart-rope-473422-t2.NBA_ANALYSIS.team_season_four_factors_summary` AS
SELECT
  team_clean,
  season_start,
  COUNT(DISTINCT gameDateTimeEst) AS records_count,
  ROUND(AVG(efgPct), 4) AS avg_efg_pct,
  ROUND(AVG(ftaRate), 4) AS avg_fta_rate,
  ROUND(AVG(orebPct), 4) AS avg_oreb_pct,
  ROUND(AVG(tmTovPct), 4) AS avg_turnover_pct,
  ROUND(AVG(oppEfgPct), 4) AS avg_opp_efg_pct
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors_clean_view`
WHERE season_start BETWEEN 2010 AND 2025
  AND team_clean IS NOT NULL
  AND (
    EXTRACT(MONTH FROM DATE(gameDateTimeEst)) BETWEEN 10 AND 12
    OR EXTRACT(MONTH FROM DATE(gameDateTimeEst)) BETWEEN 1 AND 6
  )
GROUP BY team_clean, season_start;

-- View four factors summary
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_season_four_factors_summary`
ORDER BY season_start, avg_efg_pct DESC, team_clean;

-- Validate four factors summary
SELECT
  MIN(season_start) AS min_season,
  MAX(season_start) AS max_season,
  COUNT(DISTINCT season_start) AS distinct_seasons,
  COUNT(DISTINCT team_clean) AS distinct_teams
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_season_four_factors_summary`;


-- =========================================
-- 4. TEAM-SEASON GAMES SUMMARY
-- =========================================

CREATE OR REPLACE TABLE `smart-rope-473422-t2.NBA_ANALYSIS.team_season_games_summary` AS
WITH home_games AS (
  SELECT
    home_team_clean AS team_clean,
    season_start,
    COUNT(DISTINCT gameId) AS home_games,
    SUM(CASE WHEN homeScore > awayScore THEN 1 ELSE 0 END) AS home_wins,
    ROUND(AVG(homeScore), 2) AS avg_home_points_scored,
    ROUND(AVG(awayScore), 2) AS avg_home_points_allowed
  FROM `smart-rope-473422-t2.NBA_ANALYSIS.games_clean`
  WHERE season_start BETWEEN 2010 AND 2025
    AND home_team_clean IS NOT NULL
    AND (
      EXTRACT(MONTH FROM DATE(gameDateTimeEst)) BETWEEN 10 AND 12
      OR EXTRACT(MONTH FROM DATE(gameDateTimeEst)) BETWEEN 1 AND 6
    )
  GROUP BY home_team_clean, season_start
),
away_games AS (
  SELECT
    away_team_clean AS team_clean,
    season_start,
    COUNT(DISTINCT gameId) AS away_games,
    SUM(CASE WHEN awayScore > homeScore THEN 1 ELSE 0 END) AS away_wins,
    ROUND(AVG(awayScore), 2) AS avg_away_points_scored,
    ROUND(AVG(homeScore), 2) AS avg_away_points_allowed
  FROM `smart-rope-473422-t2.NBA_ANALYSIS.games_clean`
  WHERE season_start BETWEEN 2010 AND 2025
    AND away_team_clean IS NOT NULL
    AND (
      EXTRACT(MONTH FROM DATE(gameDateTimeEst)) BETWEEN 10 AND 12
      OR EXTRACT(MONTH FROM DATE(gameDateTimeEst)) BETWEEN 1 AND 6
    )
  GROUP BY away_team_clean, season_start
)
SELECT
  h.team_clean,
  h.season_start,
  h.home_games,
  h.home_wins,
  h.avg_home_points_scored,
  h.avg_home_points_allowed,
  a.away_games,
  a.away_wins,
  a.avg_away_points_scored,
  a.avg_away_points_allowed
FROM home_games h
LEFT JOIN away_games a
  ON h.team_clean = a.team_clean
 AND h.season_start = a.season_start;

-- View games summary
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_season_games_summary`
ORDER BY season_start, team_clean;

-- Validate games summary
SELECT
  MIN(season_start) AS min_season,
  MAX(season_start) AS max_season,
  COUNT(DISTINCT season_start) AS distinct_seasons,
  COUNT(DISTINCT team_clean) AS distinct_teams
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_season_games_summary`;


-- =========================================
-- 5. COMBINE ALL TEAM-SEASON TABLES
-- =========================================

CREATE OR REPLACE TABLE `smart-rope-473422-t2.NBA_ANALYSIS.team_season_analysis_final` AS
SELECT
  s.team_clean,
  s.season_start,
  s.games_played,
  s.wins,
  s.losses,
  s.win_pct,
  s.avg_points_scored,
  s.avg_points_allowed,
  s.avg_point_differential,
  a.avg_off_rating,
  a.avg_def_rating,
  a.avg_net_rating,
  a.avg_true_shooting_pct,
  a.avg_effective_fg_pct,
  f.avg_efg_pct,
  f.avg_fta_rate,
  f.avg_oreb_pct,
  f.avg_turnover_pct,
  f.avg_opp_efg_pct,
  g.home_games,
  g.home_wins,
  g.avg_home_points_scored,
  g.avg_home_points_allowed,
  g.away_games,
  g.away_wins,
  g.avg_away_points_scored,
  g.avg_away_points_allowed
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_season_statistics_summary` s
LEFT JOIN `smart-rope-473422-t2.NBA_ANALYSIS.team_season_advanced_summary` a
  ON s.team_clean = a.team_clean
 AND s.season_start = a.season_start
LEFT JOIN `smart-rope-473422-t2.NBA_ANALYSIS.team_season_four_factors_summary` f
  ON s.team_clean = f.team_clean
 AND s.season_start = f.season_start
LEFT JOIN `smart-rope-473422-t2.NBA_ANALYSIS.team_season_games_summary` g
  ON s.team_clean = g.team_clean
 AND s.season_start = g.season_start;

-- View final combined analysis table
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_season_analysis_final`
ORDER BY season_start, win_pct DESC, team_clean;

-- Validate final combined table
SELECT
  MIN(season_start) AS min_season,
  MAX(season_start) AS max_season,
  COUNT(DISTINCT season_start) AS distinct_seasons,
  COUNT(DISTINCT team_clean) AS distinct_teams
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_season_analysis_final`;

-- Check important nulls in final combined table
SELECT
  COUNTIF(team_clean IS NULL) AS null_team_clean,
  COUNTIF(season_start IS NULL) AS null_season_start,
  COUNTIF(win_pct IS NULL) AS null_win_pct,
  COUNTIF(avg_off_rating IS NULL) AS null_avg_off_rating,
  COUNTIF(avg_def_rating IS NULL) AS null_avg_def_rating,
  COUNTIF(avg_efg_pct IS NULL) AS null_avg_efg_pct
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_season_analysis_final`;

-- Result: 0 Nulls Found


-- =========================================
-- 6. TEAM ENDORSEMENT POTENTIAL SUMMARY
-- =========================================

CREATE OR REPLACE TABLE `smart-rope-473422-t2.NBA_ANALYSIS.team_endorsement_potential_summary` AS
SELECT
  team_clean,
  COUNT(DISTINCT season_start) AS seasons_covered,
  ROUND(AVG(win_pct), 3) AS avg_win_pct,
  ROUND(AVG(avg_point_differential), 2) AS avg_point_differential,
  ROUND(AVG(avg_off_rating), 2) AS avg_off_rating,
  ROUND(AVG(avg_def_rating), 2) AS avg_def_rating,
  ROUND(AVG(avg_net_rating), 2) AS avg_net_rating,
  ROUND(AVG(avg_true_shooting_pct), 4) AS avg_true_shooting_pct,
  ROUND(AVG(avg_effective_fg_pct), 4) AS avg_effective_fg_pct,
  ROUND(AVG(avg_efg_pct), 4) AS avg_team_efg_pct,
  ROUND(AVG(avg_turnover_pct), 4) AS avg_turnover_pct,
  ROUND(AVG(avg_opp_efg_pct), 4) AS avg_opp_efg_pct
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_season_analysis_final`
GROUP BY team_clean;

-- View endorsement potential summary
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_endorsement_potential_summary`
ORDER BY avg_win_pct DESC, avg_net_rating DESC;


-- =========================================
-- 7. TEAM ENDORSEMENT SCORE
-- =========================================

CREATE OR REPLACE TABLE `smart-rope-473422-t2.NBA_ANALYSIS.team_endorsement_score` AS
SELECT
  team_clean,
  seasons_covered,
  avg_win_pct,
  avg_point_differential,
  avg_off_rating,
  avg_def_rating,
  avg_net_rating,
  avg_true_shooting_pct,
  avg_effective_fg_pct,
  avg_team_efg_pct,
  avg_turnover_pct,
  avg_opp_efg_pct,
  ROUND(
    (avg_win_pct * 40) +
    (avg_net_rating * 3) +
    (avg_true_shooting_pct * 20) +
    (avg_effective_fg_pct * 20) -
    (avg_turnover_pct * 10),
    2
  ) AS endorsement_score
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_endorsement_potential_summary`;

-- View endorsement score
SELECT *
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_endorsement_score`
ORDER BY endorsement_score DESC;


-- =========================================
-- 8. TOP TEAMS BY ENDORSEMENT SCORE
-- =========================================

SELECT
  team_clean,
  endorsement_score,
  avg_win_pct,
  avg_net_rating,
  avg_true_shooting_pct,
  avg_effective_fg_pct,
  avg_turnover_pct
FROM `smart-rope-473422-t2.NBA_ANALYSIS.team_endorsement_score`
ORDER BY endorsement_score DESC
LIMIT 10;
