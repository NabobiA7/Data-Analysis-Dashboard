USE finetech_dataset; 
# looking for duplicates
SELECT brand, count, percentage, state, year, quarter, COUNT(*) 
FROM final_agg_user_csv
GROUP BY  brand, count, percentage, state, year, quarter
HAVING COUNT(*) > 1; 
SELECT * FROM final_agg_user_csv;
# Analyze
SELECT brand, state ,SUM(count) AS total_count FROM final_agg_user_csv GROUP BY brand, state ORDER BY total_count DESC LIMIT 10;
SELECT brand, state ,AVG (percentage) AS average_percentage FROM final_agg_user_csv GROUP BY brand, state ORDER BY average_percentage DESC LIMIT 10; 
SELECT brand ,MAX(count)AS max_count, CONCAT(year, 'Q', quarter) AS year_quarter FROM final_agg_user_csv  GROUP BY brand , year_quarter ORDER BY max_count DESC LIMIT 10;
SELECT year, quarter FROM final_agg_user_csv WHERE brand= 'Xiaomi' GROUP BY year,quarter ORDER BY year,quarter;
SELECT year, SUM(count) AS total_count, SUM(SUM(count)) OVER (ORDER BY year) AS cumulative_count FROM final_agg_user_csv GROUP BY year ORDER BY year;
SELECT brand,state, MIN(count) AS min_count FROM final_agg_user_csv GROUP BY brand,state ORDER BY min_count ASC LIMIT 10; 
SELECT brand, year, SUM(percentage) AS total_percentage ,LAG(SUM(percentage)) OVER (ORDER BY year) AS previous_year_percentage, (SUM(percentage) - LAG(SUM(percentage)) OVER (ORDER BY year)) / LAG(SUM(percentage)) OVER (ORDER BY year) * 100 AS percentage_growt FROM final_agg_user_csv WHERE brand='Xiaomi' GROUP BY brand, year;
# alternative way in case MySQL doesn't support window function
WITH CTE AS ( SELECT year, 
        SUM(percentage) AS total_percentage,
        LAG(SUM(percentage)) OVER (ORDER BY year) AS previous_year_percentage
    FROM final_agg_user_csv 
    GROUP BY year)
SELECT year,
    ROUND(total_percentage, 2) AS total_percentage,
    ROUND(previous_year_percentage, 2) AS previous_year_percentage,
    ROUND((total_percentage - previous_year_percentage) / previous_year_percentage * 100, 2) AS percentage_growth
FROM CTE ;

