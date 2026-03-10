-- Preview for each table, check the total rows

SELECT COUNT(*) AS total_rows
FROM `smart-rope-473422-t2.NBA_ANALYSIS.games`;

SELECT COUNT(*) AS total_rows
FROM `smart-rope-473422-t2.NBA_ANALYSIS.statistics`;

SELECT COUNT(*) AS total_rows
FROM `smart-rope-473422-t2.NBA_ANALYSIS.advanced_statistics`;

SELECT COUNT(*) AS total_rows
FROM `smart-rope-473422-t2.NBA_ANALYSIS.four_factors`;
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



