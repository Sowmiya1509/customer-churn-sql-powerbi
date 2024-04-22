#1.Identify the total number of customers and the churn rate
SELECT COUNT(*) AS total_customers
FROM customer_churn_dataset;
       # TOTAL NO OF CUSTOMERS = 500

SELECT 
    SUM(CASE WHEN churn_status = 'yes' THEN 1 ELSE 0 END) AS churned_customers,
    (SUM(CASE WHEN churn_status = 'yes' THEN 1 ELSE 0 END) * 1.0 / (SELECT COUNT(*) FROM customer_churn_dataset)) * 100 AS churn_rate_percentage
FROM customer_churn_dataset;
       # NO OF CHURNED CUSTOMER = 105, CHURN RATE PERCENTAGE = 21% 

#2.Find the average age of churned customers
SELECT AVG(age) AS average_age
FROM customer_churn_dataset
WHERE churn_status = 'yes';
      #AVERAGE AGE OF CHURNED CUSTOMER = 50.8952
      
#3.	Discover the most common contract types among churned customers      
SELECT contract_type, COUNT(*) AS num_churned_customers
FROM customer_churn_dataset
WHERE churn_status = 'yes'
GROUP BY contract_type
ORDER BY num_churned_customers DESC
LIMIT 1;
        #THE MOST COMMON CONTRACT TYPE AMONG CHURNED CUSTOMERS = MONTHLY WITH 56 CHURNED CUSTOMERS
        
#4.	Analyze the distribution of monthly charges among churned customers

SELECT
    SUM(monthly_charges) AS total_monthly_charges_churned,
    AVG(monthly_charges) AS avg_monthly_charges_churned
FROM customer_churn_dataset
WHERE churn_status = 'yes';
         # THE DISTRIBUTION OF MONTHLY CHARGES AMONG EACH CHURNED CUSTOMERS = 52.49

#5.	Create a query to identify the contract types that are most prone to churn
SELECT
    contract_type,
    COUNT(*) AS num_churned_customers
FROM customer_churn_dataset
WHERE churn_status = 'yes'
GROUP BY contract_type
ORDER BY num_churned_customers DESC;
         # THE CONTRACT TYPE THAT ARE MOST PRONE TO CHURN IS MONTHLY CONTRACT TYPE

#6.	Identify customers with high total charges who have churned
SELECT *
FROM customer_churn_dataset
WHERE churn_status = 'yes'
AND total_charges >= 999.56;

SELECT *
FROM customer_churn_dataset
WHERE churn_status = 'yes'
ORDER BY total_charges DESC
LIMIT 4;

#7.	Calculate the total charges distribution for churned and non-churned customers
SELECT
    SUM(total_charges) AS sum_total_charges_churned,
    AVG(total_charges) AS avg_total_charges_churned
FROM customer_churn_dataset
WHERE churn_status = 'yes';
         #TOTAL CHARGES FOR CHURNED = 56781, CHARGES FOR EACH = 540
         
SELECT
    SUM(total_charges) AS sum_total_charges_churned,
    AVG(total_charges) AS avg_total_charges_churned
FROM customer_churn_dataset
WHERE churn_status = 'no';
		#TOTAL CHARGES FOR NON CHURNED = 204809, CHARGES FOR EACH = 518
        
 #8.	Calculate the average monthly charges for different contract types among churned customers      
SELECT 
     contract_type,
     AVG(monthly_charges) AS avg_monthly_charges_churned
     FROM customer_churn_dataset
     where churn_status = 'yes'
     group by contract_type;
       # avg monthly charges for monthly contract type = 52.2476, yearly contract type = 52.7708
       
 #9.	Identify customers who have both online security and online backup services and have not churned
SELECT *
FROM customer_churn_dataset
WHERE online_security = 'YES'
AND online_backup = 'YES'
AND churn_status = 'NO';
		  
SELECT customer_id, online_security,online_backup,churn_status
FROM customer_churn_dataset
WHERE online_security = 'YES'
AND online_backup = 'YES'
AND churn_status = 'NO';

# 10.Determine the most common combinations of services among churned customers
SELECT
    CONCAT_WS(', ', 
        CASE WHEN online_security = 'Yes' THEN 'Online Security' ELSE NULL END,
        CASE WHEN online_backup = 'Yes' THEN 'Online Backup' ELSE NULL END,
        CASE WHEN device_protection = 'Yes' THEN 'Device Protection' ELSE NULL END,
        CASE WHEN tech_support = 'Yes' THEN 'Tech Support' ELSE NULL END,
        CASE WHEN streaming_tv = 'Yes' THEN 'Streaming TV' ELSE NULL END,
        CASE WHEN streaming_movies = 'Yes' THEN 'Streaming Movies' ELSE NULL END
    ) AS service_combination,
    COUNT(*) AS num_customers
FROM customer_churn_dataset
WHERE churn_status = 'Yes'
GROUP BY service_combination
ORDER BY num_customers DESC;

#11.Identify the average total charges for customers grouped by gender and marital status
  SELECT
    gender,
    marital_status,
    AVG(total_charges) AS avg_total_charges
FROM customer_churn_dataset
GROUP BY gender, marital_status;

#12.Calculate the average monthly charges for different age groups among churned customers      
SELECT
    CASE
       WHEN age BETWEEN 18 AND 29 THEN '18-29'
       WHEN age BETWEEN 30 AND 39 THEN '30-39'
       WHEN age BETWEEN 40 AND 49 THEN '40-49'
       WHEN age BETWEEN 50 AND 59 THEN '50-59'
       WHEN age BETWEEN 60 AND 69 THEN '60-69'
       ELSE'70+'
       END AS age_group,
       avg(monthly_charges) AS avg_monthly_charges
FROM customer_churn_dataset
WHERE churn_status = 'YES'
GROUP BY age_group;

#13.	Determine the average age and total charges for customers with multiple lines and online backup
SELECT
	AVG(age) AS avg_age,
    SUM(total_charges) AS total_charges_with_multiple_lines_and_backup
FROM customer_churn_dataset
  WHERE multiple_lines = 'YES'
  AND online_backup = 'YES';
  
#14.	Identify the contract types with the highest churn rate among senior citizens (age 65 and over)
SELECT
    contract_type,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_status = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN churn_status = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS churn_rate
FROM customer_churn_dataset
WHERE age >= 65
GROUP BY contract_type
ORDER BY churn_rate DESC;

#15.	Calculate the average monthly charges for customers who have multiple lines and streaming TV
SELECT
	AVG(monthly_charges) AS avg_monthly_charges
FROM customer_churn_dataset
  WHERE multiple_lines = 'YES'
  AND streaming_tv = 'YES';
  
#16.	Identify the customers who have churned and used the most online services
SELECT *
FROM customers
WHERE churn_status = 'Yes'
ORDER BY (
    CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN online_backup = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN device_protection = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN tech_support = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN streaming_tv = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN streaming_movies = 'Yes' THEN 1 ELSE 0 END
) DESC
LIMIT 1;

#17.	Calculate the average age and total charges for customers with different combinations of streaming services
SELECT
    CONCAT_WS(', ',
        CASE WHEN streaming_tv = 'Yes' THEN 'Streaming TV' ELSE NULL END,
        CASE WHEN streaming_movies = 'Yes' THEN 'Streaming Movies' ELSE NULL END
    ) AS streaming_services_combination,
    AVG(age) AS avg_age,
    SUM(total_charges) AS total_charges
FROM customer_churn_dataset
GROUP BY streaming_services_combination;

#18.	Identify the gender distribution among customers who have churned and are on yearly contracts
SELECT
    gender,
    COUNT(*) AS num_customers
FROM customer_churn_dataset
WHERE churn_status = 'Yes'
    AND contract_type = 'Yearly'
GROUP BY gender;

#19.	Calculate the average monthly charges and total charges for customers who have churned, grouped by contract type and internet service type
SELECT
    contract_type,
    internet_service,
    AVG(monthly_charges) AS avg_monthly_charges,
    SUM(total_charges) AS total_charges
FROM customer_churn_dataset
WHERE churn_status = 'Yes'
GROUP BY contract_type, internet_service;

#20.	Find the customers who have churned and are not using online services, and their average total charges
SELECT
    AVG(total_charges) AS avg_total_charges
FROM customer_churn_dataset
WHERE churn_status = 'Yes'
  AND online_security = 'No'
  AND online_backup = 'No'
  AND device_protection = 'No'
  AND tech_support = 'No'
  AND streaming_tv = 'No'
  AND streaming_movies = 'No';
  
#21.	Calculate the average monthly charges and total charges for customers who have churned, grouped by the number of dependents
SELECT
	dependents,
    AVG(total_charges) AS avg_total_charges,
    SUM(total_charges) AS total_charges
FROM customer_churn_dataset
WHERE churn_status = 'YES'
GROUP BY dependents;

#22.	Identify the customers who have churned, and their contract duration in months (for monthly contracts)
SELECT
    customer_id
FROM customer_churn_dataset
WHERE churn_status = 'Yes'
  AND contract_type = 'Monthly';
  
#23.	Determine the average age and total charges for customers who have churned, grouped by internet service and phone service
SELECT
    internet_service,
    phone_service,
    AVG(age) AS avg_age,
    SUM(total_charges) AS total_charges
FROM customer_churn_dataset
WHERE churn_status = 'Yes'
GROUP BY internet_service, phone_service;

#24.	Create a view to find the customers with the highest monthly charges in each contract type
CREATE VIEW highest_monthly_charges_per_contract_type AS
SELECT
    contract_type,
    customer_id,
    MAX(monthly_charges) AS highest_monthly_charge
FROM customer_churn_dataset
GROUP BY contract_type, customer_id; -- Include all non-aggregated columns in GROUP BY

SELECT * FROM highest_monthly_charges_per_contract_type;

#25.	Create a view to identify customers who have churned and the average monthly charges compared to the overall average
CREATE VIEW churned_customers_avg_monthly_charges AS
SELECT
    customer_id,
    AVG(monthly_charges) AS avg_monthly_charges,
    (SELECT AVG(monthly_charges) FROM customer_churn_dataset WHERE churn_status = 'Yes') AS overall_avg_monthly_charges
FROM customer_churn_dataset
WHERE churn_status = 'Yes'
GROUP BY customer_id;

SELECT * FROM churned_customers_avg_monthly_charges;

#26.	Create a view to find the customers who have churned and their cumulative total charges over time
CREATE VIEW churned_customers_cumulative_total_charges AS
SELECT
    customer_id,
    total_charges,
    churn_status,
    SUM(total_charges) OVER (PARTITION BY customer_id) AS cumulative_total_charges
FROM customer_churn_dataset
WHERE churn_status = 'Yes';

SELECT * FROM churned_customers_cumulative_total_charges;

#27.	Stored Procedure to Calculate Churn Rate
DELIMITER //

CREATE PROCEDURE CalculateChurnRate()
BEGIN
    DECLARE total_customers INT;
    DECLARE churned_customers INT;
    DECLARE churn_rate DECIMAL(5, 2);

    -- Count total customers
    SELECT COUNT(*) INTO total_customers FROM customer_churn_dataset;

    -- Count churned customers
    SELECT COUNT(*) INTO churned_customers FROM customer_churn_dataset WHERE churn_status = 'Yes';

    -- Calculate churn rate
    IF total_customers > 0 THEN
        SET churn_rate = (churned_customers / total_customers) * 100;
    ELSE
        SET churn_rate = 0;
    END IF;

    -- Output the churn rate
    SELECT churn_rate AS 'Churn Rate (%)';
END//

DELIMITER ;

CALL CalculateChurnRate();

#28.	Stored Procedure to Identify High-Value Customers at Risk of Churning

DELIMITER //

CREATE PROCEDURE IdentifyHighValueCustomersAtRisk()
BEGIN
    DECLARE high_value_threshold DECIMAL(10, 2);
    DECLARE total_customers INT;
    DECLARE high_value_customers INT;
    DECLARE high_value_customers_at_risk INT;

    -- Define the threshold for high-value customers
    SET high_value_threshold = 1000; -- Adjust this threshold as needed

    -- Count total customers
    SELECT COUNT(*) INTO total_customers FROM customer_churn_dataset;

    -- Count high-value customers
    SELECT COUNT(*) INTO high_value_customers FROM customer_churn_dataset WHERE total_charges > high_value_threshold;

    -- Count high-value customers at risk of churning
    SELECT COUNT(*) INTO high_value_customers_at_risk FROM customer_churn_dataset WHERE total_charges > high_value_threshold AND churn_status = 'Yes';

    -- Output the results
    SELECT high_value_customers AS 'High_Value_Customers', high_value_customers_at_risk AS 'High_Value_Customers_at_Risk';
END//

DELIMITER ;

CALL IdentifyHighValueCustomersAtRisk();

