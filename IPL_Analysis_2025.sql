-- =====================================================
-- IPL Project SQL Analysis Queries
-- Database: ipl
-- Table: matches
-- Purpose: Perform analytical queries on IPL match data
-- =====================================================

CREATE DATABASE IPL_ANALYSIS_2025

USE IPL_ANALYSIS_2025;

-- IMPORTING THE DATASET .CSV

SELECT * FROM ipl2025batters;
SELECT * FROM ipl2025bowlers;

--Check NULL / Missing Values

select
sum( case when player_name is null then 1 else 0 end ) as name_count ,
sum( case when Team is null then 1 else 0 end ) as Team_count,
sum (case when Matches is null then 1 else 0 end ) as match_count
from ipl2025batters;


select
sum( case when player_name is null then 1 else 0 end ) as name_count ,
sum( case when Team is null then 1 else 0 end ) as Team_count,
sum (case when wkt is null then 1 else 0 end ) as wkt_count
from ipl2025bowlers;

--Remove Duplicate Records

SELECT *
From IPL2025Batters
WHERE Player_Name IS NULL
   OR Team IS NULL
   OR Runs IS NULL
   OR Matches IS NULL
   OR Inn IS NULL
   OR AVG IS NULL
   OR SR IS NULL; 

-- data cleaning trim and convert to lower case

UPDATE IPL2025Batters
SET Player_Name = TRIM(Player_Name),
    Team = TRIM(Team);

UPDATE IPL2025Bowlers
SET Player_Name = TRIM(Player_Name),
    Team = TRIM(Team);

UPDATE IPL2025Batters
SET Player_Name = LOWER(Player_Name),
    Team = LOWER(Team);

UPDATE IPL2025Bowlers
SET Player_Name = LOWER(Player_Name),
    Team = LOWER(Team);

--Check Numeric Columns

SELECT *
FROM IPL2025Batters
WHERE Runs < 0
   OR Matches < 0
   OR SR< 0;

 SELECT *
FROM IPL2025Bowlers
WHERE WKT < 0
   OR Mat < 0
   OR Eco < 0; 

-- Checking Dimensions

select count(*) from ipl2025batters;
select count(*) from IPL2025Bowlers;

--Total number of batters and bolwers 
 
SELECT COUNT(*) AS Total_Batters
FROM IPL2025Batters;

SELECT COUNT(*) AS Total_Bowlers
FROM IPL2025Bowlers;

/*

Total_Batters       Total_Bowlers
  156                 108

*/


--Number of teams

SELECT COUNT(DISTINCT Team) AS Total_Teams
FROM IPL2025Batters;

/*
Total_Teams
     10
*/


--Players by team

SELECT
    Team,
    COUNT(*) AS Total_Players
FROM IPL2025Batters
GROUP BY Team
ORDER BY Total_Players DESC;

/*
Team         Total_Players
CSK              19
DC               17
RR	             17
MI               16
PBKS	         15
KKR	             15
LSG	             15
GT	             14
RCB	             14
SRH	             14

*/

--Batting EDA--

--Total runs scored

SELECT
    SUM(Runs) AS Total_Runs
FROM IPL2025Batters;

/* Total_Runs
    25166
*/

--Highest run scorer

SELECT TOP 1
    Player_Name,
    Team,
    Runs
FROM IPL2025Batters
ORDER BY Runs DESC;

/*
Player_Name       Team        Runs
Sai Sudharsan      GT         759
*/

--Highest individual score

SELECT TOP 10
    Player_Name,
    Team,
    HS
FROM IPL2025Batters
ORDER BY TRY_CAST(REPLACE(HS ,'*','') AS INT) DESC;

/*
Player_Name         Team     HS
Abhishek Sharma	     SRH	141
Rishabh Pant	     LSG	118*
Mitchell Marsh	     LSG	117
K L Rahul	         DC	    112*
Sai Sudharsan	     GT	    108*
Ishan Kishan	     SRH	106*
Heinrich Klaasen	 SRH	105*
Priyansh Arya	     PBKS	103
Vaibhav Suryavanshi	 RR	    101
Jos Buttler          GT     97*
*/

--Best batting average

SELECT TOP 10
    Player_Name,
    Team,
    Avg
FROM IPL2025Batters
WHERE Avg IS NOT NULL
ORDER BY Avg DESC;

/*
Player_Name         Team      Avg
Surya Kumar Yadav	MI	      65.1800003051758
Tim David	        RCB	      62.3300018310547
Jos Buttler	        GT        59.7799987792969
Virat Kohli	        RCB       54.75
Sai Sudharsan	    GT	      54.2099990844727
K L Rahul	        DC        53.9000015258789
Shreyas Iyer	    PBKS      50.3300018310547
Shubman Gill	    GT	      50
Shashank Singh	    PBKS	  50
Tristan Stubbs	    DC	      50

*/

--Highest strike rate

SELECT TOP 10
    Player_Name,
    Team,
    SR
FROM IPL2025Batters
WHERE BF >= 100
ORDER BY SR DESC;

/*
  Player_Name            Team       SR
  Vaibhav Suryavanshi	  RR	    206.550003051758
Nicholas Pooran	          LSG	    196.25
Abhishek Sharma           SRH	    193.389999389648
Ayush Mhatre	          CSK	    188.970001220703
Tim David	              RCB	    185.139999389648
Naman Dhir	              MI	    182.600006103516
Dewald Brevis	          CSK	    180
Priyansh Arya	          PBKS	    179.240005493164
Shahrukh Khan	          GT	    179
Jitesh Sharma	          RCB	    176.350006103516
*/

--Most sixes

SELECT TOP 10
    Player_Name,
    Team,
  _6s
FROM IPL2025Batters
ORDER BY _6s DESC;

/*
  Player_Name        Team       _6s
Nicholas Pooran	     LSG	     40
Shreyas Iyer	     PBKS	     39
Surya Kumar Yadav	   MI	     38
Mitchell Marsh	      LSG	     37
Prabhsimran Singh	   PBKS	     30
Yashasvi Jaiswal	   RR	     28
Abhishek Sharma	       SRH	     28
Riyan Parag	           RR	     27
Heinrich Klaasen	   SRH	     25
Priyansh Arya	       PBKS	     25
*/


--Most fours

SELECT TOP 10
    Player_Name,
    Team,
    _4s
FROM IPL2025Batters
ORDER BY _4s

/*
Player_Name        Team       _6s
Mohd Arshad Khan	GT	       0
Sediqullah Atal	    DC	       0
Harshal Patel	    SRH	       0
Ravi Bishnoi	    LSG	       0
Harpreet Brar	    PBKS	   0
Dushmantha Chameera	DC	       0
Maheesh Theekshana	RR	       0
Kagiso Rabada	    GT	       0
Wanindu Hasaranga	RR	       0
Raj Angad Bawa	    MI	       0
*/

--Total boundaries

SELECT
    SUM(_4s) AS Total_Fours,
    SUM(_6s) AS Total_Sixes,
    SUM(_4s)+ SUM(_6s) AS Total_Boundaries
FROM IPL2025Batters;

/*
Total_Fours     Total_Sixes    Total_Boundaries
   2245	            1294	      3539
   */

    
--Bowling EDA--

--Total wickets

SELECT
    SUM(WKT) AS Total_Wickets
FROM IPL2025Bowlers;

--Highest wicket takers

SELECT TOP 10
    Player_Name,
    Team,
    WKT
FROM IPL2025Bowlers
ORDER BY WKT DESC;

--Best economy

SELECT TOP 10
    Player_Name,
    Team,
    Eco
FROM IPL2025Bowlers
WHERE OVR >= 20
ORDER BY Eco ASC;

--Best bowling average

SELECT TOP 10
    Player_Name,
    Team,
     AVG
FROM IPL2025Bowlers
WHERE WKT >= 10
ORDER BY Avg ASC;

--Most 4-wicket hauls

SELECT TOP 10
    Player_Name,
    Team,
    _4W
FROM IPL2025Bowlers
ORDER BY _4W DESC;

--Most 5-wicket hauls

SELECT TOP 10
    Player_Name,
    Team,
     _5W
FROM IPL2025Bowlers
ORDER BY _5W DESC;

--Team-Level EDA--

--Team batting performance

SELECT
    Team,
    SUM(Runs) AS Total_Runs,
    AVG(Avg) AS Average_Batting_Avg,
    AVG(SR) AS Average_Strike_Rate,
    SUM(_4s) AS Total_Fours,
    SUM(_6s) AS Total_Sixes
FROM IPL2025Batters
GROUP BY Team
ORDER BY Total_Runs DESC;

--Team bowling performance

SELECT
    Team,
    SUM(Wkt) AS Total_Wickets,
    AVG(Eco) AS Average_Economy,
    AVG(Avg) AS Average_Bowling_Avg
FROM IPL2025Bowlers
GROUP BY Team
ORDER BY Total_Wickets DESC;

--Top 3 batters from every team

WITH Ranked_Batters AS
(
    SELECT
        Player_Name,
        Team,
        Runs,
        RANK() OVER
        (
            PARTITION BY Team
            ORDER BY Runs DESC
        ) AS Rank_No
    FROM IPL2025Batters
)
SELECT
    Player_Name,
    Team,
    Runs,
    Rank_No
FROM Ranked_Batters
WHERE Rank_No <= 3
ORDER BY Team, Rank_No;

--Top 3 bowlers from every team

WITH Ranked_Bowlers AS
(
    SELECT
        Player_Name,
        Team,
        WKT,
        RANK() OVER
        (
            PARTITION BY Team
            ORDER BY WKT DESC
        ) AS Rank_No
    FROM IPL2025Bowlers
)
SELECT
    Player_Name,
    Team,
    WKT,
    Rank_No
FROM Ranked_Bowlers
WHERE Rank_No <= 3
ORDER BY Team, Rank_No;

--Batting performance classification

SELECT
    Player_Name,
    Team,
    Runs,
    SR,
    CASE
        WHEN Runs >= 500 AND SR >= 140 THEN 'Outstanding'
        WHEN Runs >= 400 AND SR >= 125 THEN 'Excellent'
        WHEN Runs >= 250 THEN 'Good'
        ELSE 'Average'
    END AS Performance_Category
FROM IPL2025Batters
ORDER BY Runs DESC;

--Bowling performance classification

SELECT
    Player_Name,
    Team,
    WKT,
    Eco,
    CASE
        WHEN WKT  >= 20 AND Eco <= 9 THEN 'Outstanding'
        WHEN WKT >= 15 AND Eco <= 10 THEN 'Excellent'
        WHEN Wkt  >= 10 THEN 'Good'
        ELSE 'Average'
    END AS Performance_Category
FROM IPL2025Bowlers
ORDER BY Wkt  DESC;