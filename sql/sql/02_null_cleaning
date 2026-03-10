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
