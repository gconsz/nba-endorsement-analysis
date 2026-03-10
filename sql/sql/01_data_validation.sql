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


