/*
1. <ON> runs before two tables are joined
    VS <WHERE> runs after two tables are joined 

2. <WHERE> filters out NULL values!!

3. 

*/

/*
Write a query that lists investors based on the number of companies
in which they are invested. Include a row for companies with no investor,
and order from most companies to least.

tutorial.crunchbase_investments
tutorial.crunchbase_companies
*/

SELECT CASE WHEN investments.investor_name IS NULL THEN 'No Investors'
            ELSE investments.investor_name END AS investor,
       COUNT(DISTINCT companies.permalink) AS companies_invested_in
       
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments investments
  ON investments.company_permalink = companies.permalink
  GROUP BY 1
  

/*
What’s happening above is that the conditional statement AND... is evaluated before the join occurs.
 You can think of it as a WHERE clause that only applies to one of the tables. 
 You can tell that this is only happening in one of the tables because the 1000memories
 permalink is still displayed in the column that pulls from the other table:
*/
-- 最重要的是就是 acquisitions.company_permalink 这个条件 只apply在于 acquisitions这个table

SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
   AND acquisitions.company_permalink != '/company/1000memories'
 ORDER BY 1

/*
Filtering in the WHERE clause
If you move the same filter to the WHERE clause, 
you will notice that the filter happens after the tables are joined. 
The result is that the 1000memories row is joined onto the original table, 
but then it is filtered out entirely (in ***BOTH*** tables) in the WHERE clause 
before displaying results.

*/

 SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
 WHERE acquisitions.company_permalink != '/company/1000memories'
    OR acquisitions.company_permalink IS NULL
 ORDER BY 1
