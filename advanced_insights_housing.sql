-- Questions (Advanced)

-- 1. Which countries showed an improvement in affordability after implementing a housing policy?
DELIMITER //

-- First query
WITH policy_years AS (
    SELECT p.country_id, c.country_name, p.year AS policy_year
    FROM housing_policies p
    JOIN countries c ON p.country_id = c.country_id
),
affordability_change AS (
    SELECT py.country_name,
           g1.`Affordability Ratio` AS before_policy,
           g2.`Affordability Ratio` AS after_policy,
           (g1.`Affordability Ratio` - g2.`Affordability Ratio`) AS affordability_improvement
    FROM policy_years py
    JOIN global_housing_market_reduced g1 
        ON g1.Country = py.country_name AND g1.Year = py.policy_year - 1
    JOIN global_housing_market_reduced g2 
        ON g2.Country = py.country_name AND g2.Year = py.policy_year + 1
)
SELECT *
FROM affordability_change
WHERE affordability_improvement > 0
ORDER BY affordability_improvement DESC;
//

-- 2. Find the top 5 countries where housing policies coincided with a major jump in construction activity
WITH policy_construction_change AS (
    SELECT c.country_name, p.year,
           g2.`Construction Index` - g1.`Construction Index` AS construction_jump
    FROM housing_policies p
    JOIN countries c ON p.country_id = c.country_id
    JOIN global_housing_market_reduced g1 
        ON g1.Country = c.country_name AND g1.Year = p.year - 1
    JOIN global_housing_market_reduced g2 
        ON g2.Country = c.country_name AND g2.Year = p.year + 1
)
SELECT country_name, year, construction_jump
FROM policy_construction_change
ORDER BY construction_jump DESC
LIMIT 5;
//