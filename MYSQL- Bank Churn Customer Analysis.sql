SELECT *
FROM churn_modelling;

-- What are the main factors affecting customer churn?

SELECT Geography, 
Gender,
SUM(exited) AS Churned_Users,
(SUM(exited)/COUNT(*) *100) AS Churn_Rate
FROM churn_modelling
GROUP BY Geography, Gender
ORDER BY (SUM(exited)/COUNT(*) *100) DESC;			-- People from Germany are more typical to churn. Females also are more likely to close off their bank accounts.

SELECT 
Geography,
Gender,
AVG(tenure) AS AvgTenure,
AVG(creditscore) AS AvgCreditScore,
AVG(balance) AS AvgBalance,
AVG(EstimatedSalary) AS AvgEstimatedSalary
FROM churn_modelling
GROUP BY Geography, Gender
ORDER BY AVG(balance) DESC;			-- Germans have the highest average balance, which is the clearest differentiator between the groups.

SELECT 
Exited,
AVG(tenure) AS AvgTenure,
AVG(creditscore) AS AvgCreditScore,
AVG(balance) AS AvgBalance,
AVG(EstimatedSalary) AS AvgEstimatedSalary
FROM churn_modelling				-- People with higher balances are more typical to churn which is interesting. Maybe due to the bank not being engaging enough-
GROUP BY exited						-- These customers need to be our primary focus in order to lower the churn rate. We can do this by offering better interest rates,-
ORDER BY AVG(balance) DESC;		    -- low investment portfolios or personalised benefits.

SELECT
Exited,
MIN(Age) AS MinAge,
MAX(Age) AS MaxAge,
AVG(AGE) AS AvgAge,
MIN(BALANCE) AS MinBalance,
MAX(BALANCE) AS MaxBalance,
AVG(BALANCE)  AS AvgBalance
FROM churn_modelling			-- The average age and average balance is higher in people that have churned, meaning that we need to shift our focus in retaining our-
GROUP BY Exited;				-- older audience in order to reduce churn. This can be done by providing retirement-based products or financial advisors.

-- How does customer churn vary across different demographics?

SELECT 
Geography, 
SUM(Exited) AS Churned_Users,
(SUM(Exited)/count(Customerid)*100) AS Percentage_Churn_Rate
FROM churn_modelling										-- Germans are most likely to close their banks. We could shift our focus to retaining German customers.
GROUP BY Geography											-- We can do this by offering more competitive prices with local German banks and offering better promotions.
ORDER BY (SUM(Exited)/count(customerid)*100) DESC;			-- Or collaborate with local banks in Germany as a means to expand in popularity.

SELECT
Gender, 
SUM(exited) AS Churned_Users,
(SUM(Exited)/count(customerid)*100) AS Churn_Rate
FROM churn_modelling
GROUP BY Gender
ORDER BY (SUM(Exited)/count(customerid)*100) DESC;			-- Females are more likely to churn. Personalised products could help prevent this.
 
SELECT 
CASE
WHEN Age BETWEEN 18 AND 30 THEN "18-30"
WHEN Age BETWEEN 31 AND 50 THEN "31-50"
WHEN Age BETWEEN 51 AND 70 THEN "51-70"
ELSE "70+"
END AS Age_Group,
SUM(exited) AS Churned_Users,
(SUM(Exited)/count(*) *100) AS Churn_Rate
FROM churn_modelling
GROUP BY AGE_GROUP
ORDER BY (SUM(Exited)/count(customerid)*100) DESC;			-- People aged between 51-70 are most likely to close their banks. Solution mentioned prior.

SELECT Geography,
Gender,
Age_Group,
Users,
Churn_Rate,
RANK() OVER (ORDER BY Churn_Rate DESC) AS Ranking
FROM 
(SELECT 
CASE
WHEN Age BETWEEN 18 AND 30 THEN "18-30"
WHEN Age BETWEEN 31 AND 50 THEN "31-50"
WHEN Age BETWEEN 51 AND 70 THEN "51-70"
ELSE "70+"
END AS Age_Group,
Geography,
Gender,
COUNT(*) AS Users,
SUM(exited) AS Churned_Users,
(SUM(Exited)/count(customerid)*100) AS Churn_Rate
FROM churn_modelling
GROUP BY Age_Group, Geography, Gender						-- A ranking system was implemented to see which demographic was most likely to churn thus, shift our focus-
ORDER BY (SUM(Exited)/count(customerid)*100) DESC			-- towards these groups. German females aged between 51-70 are the demographic that are most likely to churn.-
) AS CustomerChurn;											-- However, Spanish and German users over the age of 70 are least likely to churn.

-- Does the number of products bought have anything to do with customers churning?

SELECT NumOfProducts,
((SUM(Exited)/count(*))*100) AS Churn_Rate
FROM churn_modelling
GROUP BY NumOfProducts			-- The more the number of products a user purchases, the more likely they are to churn. This can be prevented by introducing loyalty bonuses-
ORDER BY COUNT(*) DESC;			-- or product discounts.

-- Is there a correlation between the number of products sold and the duration of the user's tenure?

SELECT Tenure, AVG(NumOfProducts) AS AvgProductSale
FROM churn_modelling
GROUP BY Tenure
ORDER BY Tenure DESC;			-- Values in average product usage is too similar across tenures so can not be used as an indicator.

-- There seems to be a correlation between the users with the highest balance (Germans) and the churn rate.

-- Is there a correlation between balance and churn rate in Germany?

SELECT CustomerId,
Geography,
Balance,
Exited
FROM churn_modelling
WHERE Geography = 'Germany'
GROUP BY CustomerId, Balance, Exited			-- (Code used to find evidence in visualisations)- People with balances between 120k-140k-
ORDER BY CustomerId DESC;						-- were seen to churn the most. However it is difficult to tell whether there is an actual correlation.