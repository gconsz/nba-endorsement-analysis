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
