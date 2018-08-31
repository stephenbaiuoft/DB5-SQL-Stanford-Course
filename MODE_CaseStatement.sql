/*
https://community.modeanalytics.com/sql/tutorial/sql-case/
*/


/*
Write a query that calculates the combined weight of all underclass players (FR/SO) 
in California as well as the combined weight of all upperclass players (JR/SR) in California.
*/

SELECT
    CASE WHEN year IN ('FR', 'SO') THEN 'underclass'
        ELSE 'upperclass' END,
    SUM(weight) as combined_weight
  FROM benn.college_football_players
  WHERE state = 'CA'
GROUP BY 1 
 

/*
Write a query that counts the number of 300lb+ players for each of the following regions:
 West Coast (CA, OR, WA), Texas, and Other (Everywhere else).
*/

SELECT 
    CASE WHEN state in ('CA', 'OR', 'WA') THEN 'west coast'
         WHEN state = 'TX' THEN 'Texas'
         ELSE 'Other states' END AS case_state_definition,
    COUNT(1) as players
  FROM benn.college_football_players
  WHERE weight >= 300
GROUP BY 1



/*
Write a query that shows the number of players at schools with names that start with A through M, 
and the number at schools with names starting with N - Z.
*/
SELECT 
  CASE WHEN school_name < 'N' THEN 'A-M group' 
     ELSE 'N-Z group' END  AS case_school_name_col,
  COUNT(student_name) AS count
FROM benn.college_football_players
-- group by the CASE STATEMENT!!! HOW I defined case_school_name_col 
GROUP BY 1



/*
Write a query that displays the number of players in each state, 
with FR, SO, JR, and SR players in separate columns and another column 
for the total number of players. 

Order results such that states with the most players come first.
*/

SELECT state,
       COUNT(CASE WHEN year = 'FR' THEN 'anything' ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count,
       COUNT(1) AS total_players
  FROM benn.college_football_players
 GROUP BY state
 ORDER BY total_players DESC



-- aggregation function COUNT 和 case 是同一层的时候 
-- 那么结果就是
SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(1) AS count
  FROM benn.college_football_players
 GROUP BY 1

/*
year_group count
JR	       5665
FR	       9665
SO	       5881
SR	       5087
*/

-- 但如果你想 horizontally 把每一个list出来
SELECT COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count
  FROM benn.college_football_players

/*
fr_count so_count jr_count  sr_count
1	9665	5881	5665	5
/*