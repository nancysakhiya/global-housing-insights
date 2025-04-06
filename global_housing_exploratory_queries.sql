-- Questions (Basics)

-- 1. Which country had the highest average House Price Index?
SELECT Country, AVG(`House Price Index`) AS avg_hpi
FROM global_housing_market_reduced
GROUP BY Country
ORDER BY avg_hpi DESC
LIMIT 1;

-- 2. What is the average rent index by continent?
SELECT c.continent, AVG(g.`Rent Index`) AS avg_rent_index
FROM global_housing_market_reduced g
JOIN countries c ON g.Country = c.country_name
GROUP BY c.continent;

-- 3. Top 5 most affordable countries based on average affordability ratio
SELECT Country, AVG(`Affordability Ratio`) AS avg_afford_ratio
FROM global_housing_market_reduced
GROUP BY Country
ORDER BY avg_afford_ratio ASC
LIMIT 5;

-- 4. Show the GDP growth trend for a specific country (e.g., USA) over time
SELECT Year, `GDP Growth (%)`
FROM global_housing_market_reduced
WHERE Country = 'USA'
ORDER BY Year;

-- 5. Compare mortgage rates across income groups
SELECT c.income_group, AVG(g.`Mortgage Rate (%)`) AS avg_mortgage
FROM global_housing_market_reduced g
JOIN countries c ON g.Country = c.country_name
GROUP BY c.income_group;

-- 6. Which year saw the highest global construction activity?
SELECT Year, AVG(`Construction Index`) AS avg_construction
FROM global_housing_market_reduced
GROUP BY Year
ORDER BY avg_construction DESC
LIMIT 1;

-- 7. List all housing policies that had a negative impact
SELECT p.*, c.country_name
FROM housing_policies p
JOIN countries c ON p.country_id = c.country_id
WHERE p.impact = 'negative';

-- 8. Find countries with Rent Control policies and their average rent index
SELECT c.country_name, AVG(g.`Rent Index`) AS avg_rent_index
FROM housing_policies p
JOIN countries c ON p.country_id = c.country_id
JOIN global_housing_market_reduced g ON g.Country = c.country_name AND g.Year = p.year
WHERE p.policy_name = 'Rent Control'
GROUP BY c.country_name;

-- 9. Which countries had housing policies during their highest inflation years?
SELECT DISTINCT c.country_name, p.policy_name, p.year
FROM housing_policies p
JOIN countries c ON p.country_id = c.country_id
JOIN global_housing_market_reduced g 
  ON g.Country = c.country_name AND g.Year = p.year
JOIN (
    SELECT Country, MAX(`Inflation Rate (%)`) AS max_inflation
    FROM global_housing_market_reduced
    GROUP BY Country
) m 
  ON g.Country = m.Country AND g.`Inflation Rate (%)` = m.max_inflation;

-- 10. How does population growth relate to urbanization rate?
SELECT `Population Growth (%)`, `Urbanization Rate (%)`
FROM global_housing_market_reduced;

-- 11. Top 3 countries with the most housing policies implemented
SELECT c.country_name, COUNT(*) AS policy_count
FROM housing_policies p
JOIN countries c ON p.country_id = c.country_id
GROUP BY c.country_name
ORDER BY policy_count DESC
LIMIT 3;

-- 12. Average house price index in countries with “High” income group
SELECT AVG(g.`House Price Index`) AS avg_hpi
FROM global_housing_market_reduced g
JOIN countries c ON g.Country = c.country_name
WHERE c.income_group = 'High';

-- 13. Which countries had a policy and a decrease in affordability in the same year?
SELECT DISTINCT c.country_name, p.year, p.policy_name
FROM housing_policies p
JOIN countries c ON p.country_id = c.country_id
JOIN global_housing_market_reduced g1 ON g1.Country = c.country_name AND g1.Year = p.year
JOIN global_housing_market_reduced g0 ON g0.Country = c.country_name AND g0.Year = p.year - 1
WHERE g1.`Affordability Ratio` < g0.`Affordability Ratio`;

-- 14. Which currency group has the highest average GDP growth?
SELECT c.currency, AVG(g.`GDP Growth (%)`) AS avg_gdp_growth
FROM global_housing_market_reduced g
JOIN countries c ON g.Country = c.country_name
GROUP BY c.currency
ORDER BY avg_gdp_growth DESC;

-- 15. Which countries had more than one policy implemented in the same year?
SELECT c.country_name, p.year, COUNT(*) AS policy_count
FROM housing_policies p
JOIN countries c ON p.country_id = c.country_id
GROUP BY c.country_name, p.year
HAVING COUNT(*) > 1
ORDER BY policy_count DESC;


