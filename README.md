# NBA Team Endorsement Analysis

## Acknowledgements 
The dataset is made by Eoin A Moore and is made available on [Kaggle](https://www.kaggle.com/datasets/eoinamoore/historical-nba-data-and-player-box-scores)


## Table of Contents

####  [Ask](#step-1-ask)
#### [Prepare](#step-2-prepare)
####  [Process](#step-3-process)
####  [Analyze](#step-4-analyze)
####  [Share](#step-5-share)
####  [Act](#step-6-act)

## Introduction

This project analyzes NBA team performance data to identify teams that demonstrate the strongest potential for brand endorsements. Sports marketing agencies often partner with teams that consistently perform well, maintain strong efficiency metrics, and show high visibility throughout the season.

Using historical NBA datasets, this project evaluates team performance trends using SQL in BigQuery and visualizes insights through Tableau dashboards. The goal is to determine which NBA teams offer the strongest endorsement opportunities based on team success, efficiency, and consistency across seasons.

Tools used in this project include:

* BigQuery for data storage, data cleaning, and analysis.

* Tableau for data visualization and dashboards.

* GitHub for project documentation and version control.


## Step 1: Ask

## Business Task

A sports marketing agency wants to identify NBA teams that present the strongest opportunities for brand endorsements. Teams that consistently perform well, maintain efficient offensive and defensive performance, and demonstrate early-season success tend to generate greater media exposure and fan engagement.

The objective of this analysis is to identify NBA teams that demonstrate the highest endorsement potential using historical team performance data.

## Stakeholders

Sports marketing agencies

Brand partnership managers

Sponsorship and endorsement decision-makers

## Step 2: Prepare

### Datasets
* [Games.csv](data/raw/Games.csv)
* [TeamStatistics.csv](data/raw/TeamStatistics.csv)
* [TeamStatisticsAdvanced.csv](data/raw/TeamStatisticsAdvanced.csv)
* [TeamStatisticsFourFactors.csv](data/raw/TeamStatisticsFourFactors.csv)

These datasets provide both game-level and team-level statistics that allow for analysis of performance trends and efficiency metrics. I will be using these 4 datasets to upload on Google BigQuery where I will perform SQL queries are used for data cleaning, transformation, and analysis. 

### Licensing
The license on this dataset is a CC0:Public Domain. This means that the author has waived his rights. 

## Step 3: Process

### Tools

In this section I will be using sql to:

* Inspecting dataset structure and column data types

* Standardizing team names across datasets 

* Checking for missing or duplicate values

* Ensuring consistent season formats across tables

* Removing NULLS from important columns 

* Creating cleaned tables for analysis

SQL scripts used for processing are located in the [sql](sql) folder of this repository.

### Data Cleaning
The NBA datasets were cleaned and prepared to ensure they were reliable for analysis. First, the tables (games, statistics, advanced_statistics, and four_factors) were reviewed to understand their structure and total row counts. Missing values were then identified, revealing a small number of NULL values in the statistics table and 746 NULL values in orebPct within the four_factors table. These incomplete records were removed by creating cleaned tables.

Next, duplicate checks were performed using key fields such as team name and game date. While the statistics and games tables contained no duplicates, duplicate groups appeared in the advanced_statistics and four_factors tables due to rows with NULL key fields. These invalid rows were removed to ensure the datasets were consistent and reliable.

Team names were then standardized across all datasets to resolve historical franchise name variations (e.g., New Jersey Nets to Brooklyn Nets, Seattle SuperSonics to Oklahoma City Thunder). This normalization reduced the team count to the modern NBA structure of 30 franchises. Finally, a season_start field was created to correctly represent NBA seasons spanning two calendar years, and the data was filtered to include seasons from 2010 to 2025. After validation, each cleaned dataset contained 30 teams and consistent season coverage, resulting in a standardized dataset ready for analysis.

## Step 4: Analyze

### Analysis summary

In the Analyze phase, the cleaned NBA datasets were transformed into team-season summary tables to evaluate endorsement potential based on performance, efficiency, and long-term consistency. The statistics_clean table was used to calculate games played, wins, losses, win percentage, scoring averages, and point differential. The advanced_statistics_clean_view table was used to summarize offensive and defensive efficiency through offensive rating, defensive rating, net rating, true shooting percentage, and effective field goal percentage. The four_factors_clean_view table was used to measure the statistical drivers of winning, including effective field goal percentage, free throw rate, offensive rebounding percentage, turnover percentage, and opponent effective field goal percentage. The games_clean table was used as supporting analysis to capture home and away performance.

All summaries were filtered to seasons 2010 through 2025 and the requested month window of October–December and January–June. After the individual summaries were created, they were combined into a final team-season analysis table keyed by team_clean and season_start. This final table was then aggregated into an endorsement potential summary and a final endorsement score. The endorsement score provides a business-focused ranking of teams by combining performance, efficiency, and stability, making it easier to identify the franchises with the strongest endorsement potential for sports marketing agencies, sponsorship managers, and brand partnership teams.
