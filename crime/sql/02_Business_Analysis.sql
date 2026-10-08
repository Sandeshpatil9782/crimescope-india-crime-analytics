-- ===========================================
-- District-wise IPC Crime Analysis (2001–2012)
-- Business Analysis
-- ===========================================
# Dataset Overview
-- 1. Total Records
SELECT COUNT(*) AS total_records
FROM crime_data;

-- 2. Total States
SELECT COUNT(DISTINCT STATE_UT) AS total_states
FROM crime_data;

-- 3. Total Districts
SELECT COUNT(DISTINCT DISTRICT) AS total_districts
FROM crime_data;

-- 4. Year Range
SELECT
    MIN(`YEAR`) AS start_year,
    MAX(`YEAR`) AS end_year
FROM crime_data;

-- 5. Average Crime Rate
SELECT	STATE_UT, AVG(TOTAL_IPC_CRIMES) AS avg_crimes
	FROM crime_data
	GROUP BY STATE_UT;
    
-- 6 No.Of Years
SELECT COUNT(DISTINCT `YEAR`) AS total_years
	FROM crime_data;
# State Analysis

-- 1. Top 10 States by Total IPC Crimes
SELECT STATE_UT, SUM(TOTAL_IPC_CRIMES) AS total_crimes
FROM crime_data
GROUP BY STATE_UT
ORDER BY total_crimes DESC
LIMIT 10;

-- 2. Bottom 10 States by Total IPC Crimes
SELECT STATE_UT,SUM(TOTAL_IPC_CRIMES) AS total_crimes
FROM crime_data
GROUP BY STATE_UT
ORDER BY total_crimes DESC
LIMIT 10;

-- 3. State-wise crime percentage
SELECT
    STATE_UT,
    SUM(TOTAL_IPC_CRIMES) AS total_crimes,
    ROUND(
        SUM(TOTAL_IPC_CRIMES) * 100 /
        (SELECT SUM(TOTAL_IPC_CRIMES) FROM crime_data),
        2
    ) AS crime_percentage
FROM crime_data
GROUP BY STATE_UT
ORDER BY total_crimes DESC;

-- 4. Top 5 States for Murder
SELECT
    STATE_UT,
    SUM(MURDER) AS total_murders
FROM crime_data
GROUP BY STATE_UT
ORDER BY total_murders DESC
LIMIT 5;

-- 5. Top 5 States for Theft
SELECT
    STATE_UT,
    SUM(THEFT) AS total_thefts
FROM crime_data
GROUP BY STATE_UT
ORDER BY total_thefts DESC
LIMIT 5;

-- Top 5 States for Rape
SELECT
    STATE_UT,
    SUM(RAPE) AS total_rape_cases
FROM crime_data
GROUP BY STATE_UT
ORDER BY total_rape_cases DESC
LIMIT 5;

# District Analysis

-- 1. Top 10 Districts by Total IPC Crimes
SELECT DISTRICT, SUM(TOTAL_IPC_CRIMES) AS total_crimes
FROM crime_data
GROUP BY DISTRICT
ORDER BY total_crimes DESC
LIMIT 10;

-- 2. Bottom 10 Districts by Total IPC Crimes
SELECT DISTRICT, SUM(TOTAL_IPC_CRIMES) AS total_crimes
FROM crime_data
GROUP BY DISTRICT
ORDER BY total_crimes ASC
LIMIT 10;

# Year-wise Trend

-- 1. Year-wise Total IPC Crimes
SELECT `YEAR`, SUM(TOTAL_IPC_CRIMES) AS total_crimes
FROM crime_data
GROUP BY `YEAR`
ORDER BY `YEAR`;

-- Crime Category Analysis
SELECT
    SUM(MURDER) AS total_murders,
    SUM(RAPE) AS total_rapes,
    SUM(THEFT) AS total_thefts,
    SUM(BURGLARY) AS total_burglaries
FROM crime_data;

-- Filtering By State
SELECT * FROM crime_data
WHERE STATE_UT = 'MAHARASHTRA';

SELECT *
FROM crime_data
WHERE STATE_UT = 'KARNATAKA';

-- HAVING 50000 And Above Crimes
SELECT	STATE_UT, SUM(TOTAL_IPC_CRIMES) AS total_crimes
	FROM crime_data
	GROUP BY STATE_UT
	HAVING SUM(TOTAL_IPC_CRIMES) > 50000;

-- HAVING 5000 And Less Crimes
SELECT	STATE_UT, SUM(TOTAL_IPC_CRIMES) AS total_crimes
	FROM crime_data
	GROUP BY STATE_UT
	HAVING SUM(TOTAL_IPC_CRIMES) < 5000;

-- Crime Category Classification (CASE WHEN)
SELECT STATE_UT, SUM(TOTAL_IPC_CRIMES) AS total_crimes,
    CASE
        WHEN SUM(TOTAL_IPC_CRIMES) > 1000000 THEN 'High'
        WHEN SUM(TOTAL_IPC_CRIMES) > 500000 THEN 'Medium'
        ELSE 'Low'
    END AS crime_level
FROM crime_data
GROUP BY STATE_UT
ORDER BY total_crimes DESC;

-- Subquery
SELECT STATE_UT, total_crimes
	FROM (
		SELECT STATE_UT, SUM(TOTAL_IPC_CRIMES) AS total_crimes
			FROM crime_data
			GROUP BY STATE_UT ) AS state_summary
			WHERE total_crimes >
	( SELECT AVG(total_crimes)
		FROM (	
			SELECT SUM(TOTAL_IPC_CRIMES) AS total_crimes
				FROM crime_data
				GROUP BY STATE_UT
			 ) AS avg_summary
	);

-- Window Function 
SELECT STATE_UT, SUM(TOTAL_IPC_CRIMES) AS total_crimes,
    RANK() OVER (ORDER BY SUM(TOTAL_IPC_CRIMES) DESC) AS state_rank
	FROM crime_data
	GROUP BY STATE_UT;

/* Find the year in which each state recorded its highest
    total IPC crimes during 2001–2012. */
SELECT * FROM (
			SELECT	STATE_UT, `YEAR`,
				SUM(TOTAL_IPC_CRIMES) AS total_crimes,
				RANK() OVER ( PARTITION BY STATE_UT 
								ORDER BY SUM(TOTAL_IPC_CRIMES) DESC 
							) AS rn
			FROM crime_data
			GROUP BY STATE_UT, `YEAR`
	) t;
    
SELECT * FROM (
			SELECT	STATE_UT, `YEAR`,
				SUM(TOTAL_IPC_CRIMES) AS total_crimes,
				RANK() OVER ( PARTITION BY STATE_UT 
								ORDER BY SUM(TOTAL_IPC_CRIMES) DESC 
							) AS rn
			FROM crime_data
			GROUP BY STATE_UT, `YEAR`
	) t
    where rn=1;
    