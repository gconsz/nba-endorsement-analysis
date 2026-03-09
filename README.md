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

* Creating cleaned tables for analysis

SQL scripts used for processing are located in the [sql](sql) folder of this repository.

### Data Cleaning

