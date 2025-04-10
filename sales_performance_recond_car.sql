SELECT *
FROM sales_performance;

# Which team had the highest total sales?
SELECT team, SUM(jan + feb + mar) AS total_sales
FROM sales_performance
GROUP BY team
ORDER BY total_sales DESC;

# Who are the top 10 best performing sales advisors overall?
SELECT name, team, (jan + feb + mar) AS total_sales
FROM sales_performance
ORDER BY total_sales DESC
LIMIT 10;

# How does the average sales per advisor compare across different teams?
SELECT team, ROUND(AVG(jan + feb + mar), 0) AS average_sales
FROM sales_performance
GROUP BY team
ORDER BY average_sales DESC;

# Who is the top performer in each team?
SELECT team, name, total
FROM (
    SELECT 
        team,
        name,
        (jan + feb + mar) AS total,
        RANK() OVER (PARTITION BY team ORDER BY (jan + feb + mar) DESC) AS rnk
    FROM sales_performance
) AS ranked
WHERE rnk = 1;

# What is the overall sales trend across the three months - increasing, decreasing, or stable?
SELECT 
    SUM(jan) AS total_jan,
    SUM(feb) AS total_feb,
    SUM(mar) AS total_mar
FROM sales_performance;

# How has each team's contribution to total sales changed over the three months?
-- Team contribution per month in %
SELECT 
    team,
    SUM(jan) * 100.0 / (SELECT SUM(jan) FROM sales_performance) AS jan_pct,
    SUM(feb) * 100.0 / (SELECT SUM(feb) FROM sales_performance) AS feb_pct,
    SUM(mar) * 100.0 / (SELECT SUM(mar) FROM sales_performance) AS mar_pct
FROM sales_performance
GROUP BY team
ORDER BY team;

# Which advisors achieved 5 or more sales in a single month?
SELECT name, team, jan, feb, mar
FROM sales_performance
WHERE jan >= 5 OR feb >= 5 OR mar >= 5;

# Which teams showed the most improvement from January to March?
SELECT team,
		SUM(jan) AS total_sales_jan,
        SUM(mar) AS total_sales_mar,
        (SUM(mar) - SUM(jan)) AS improve_team
FROM sales_performance
GROUP BY team
ORDER BY improve_team DESC;

# What percentage of total company sales did each team contribute?
SELECT 
    team,
    SUM(jan + feb + mar) AS team_total,
        ROUND (100.0 * SUM(jan + feb + mar) / 
        (SELECT SUM(jan + feb + mar) FROM sales_performance), 2) AS percent_contribution
FROM sales_performance
GROUP BY team
ORDER BY percent_contribution DESC;

SELECT COUNT(name) AS total_salesman
FROM sales_performance;

SELECT sum(jan) AS total_sales_jan
FROM sales_performance;

SELECT sum(feb) AS total_sales_feb
FROM sales_performance;

SELECT sum(mar) AS total_sales_mar
FROM sales_performance;

SELECT DISTINCT team
FROM sales_performance;

SELECT 'jan' AS month, SUM(jan) AS total FROM sales_performance
UNION ALL
SELECT 'feb', SUM(feb) FROM sales_performance
UNION ALL
SELECT 'mar', SUM(mar) FROM sales_performance;

