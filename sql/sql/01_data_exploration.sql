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

