-- Roll-up: Aggregate student counts from destination cities to countries 
SELECT  
destination_country, 
COUNT(*) AS total_students, 
AVG(CAST(starting_salary_usd AS FLOAT)) AS avg_salary, 
AVG(gpa_or_score) AS avg_gpa 
FROM global_student_migration 
GROUP BY destination_country 
ORDER BY total_students DESC;

-- Roll-up: Group detailed courses into broader field categories 
SELECT  
field_of_study, 
COUNT(*) AS total_students, 
COUNT(CASE WHEN placement_status = 'Placed' THEN 1 END) AS 
placed_students, 
ROUND((COUNT(CASE WHEN placement_status = 'Placed' THEN 1 END) * 100.0 / 
COUNT(*)), 2 
) AS placement_rate_percentage 
FROM global_student_migration 
GROUP BY field_of_study 
ORDER BY total_students DESC;

-- Drill-down: From country level to city level analysis 
SELECT  
destination_country, 
destination_city, 
COUNT(*) AS student_count, 
AVG(CAST(starting_salary_usd AS FLOAT)) AS avg_salary 
FROM global_student_migration 
WHERE destination_country IN ('Germany', 'UK', 'Canada') 
GROUP BY destination_country, destination_city 
ORDER BY destination_country, student_count DESC;

-- Slice: Students who enrolled in 2021 only 
SELECT  
origin_country, 
destination_country, 
field_of_study, 
COUNT(*) AS student_count, 
AVG(gpa_or_score) AS avg_gpa 
FROM global_student_migration 
WHERE year_of_enrollment = 2021 
GROUP BY origin_country, destination_country, field_of_study 
ORDER BY student_count DESC;

-- Slice: Only placed students analysis 
SELECT  
field_of_study, 
destination_country, 
COUNT(*) AS placed_students, 
AVG(CAST(starting_salary_usd AS FLOAT)) AS avg_salary, 
MIN(starting_salary_usd) AS min_salary, 
MAX(starting_salary_usd) AS max_salary 
FROM global_student_migration 
WHERE placement_status = 'Placed' AND starting_salary_usd > 0 
GROUP BY field_of_study, destination_country 
ORDER BY avg_salary DESC; 

-- Dice: Students from specific countries, specific years, and specific fields 
SELECT  
origin_country, 
destination_country, 
field_of_study, 
year_of_enrollment, 
COUNT(*) AS student_count, 
AVG(gpa_or_score) AS avg_gpa, 
COUNT(CASE WHEN scholarship_received = 1 THEN 1 END) AS 
scholarship_recipients 
FROM global_student_migration 
WHERE  
origin_country IN ('India', 'UK', 'Canada')  
AND destination_country IN ('Germany', 'USA', 'UK') 
AND year_of_enrollment IN (2021, 2022) 
AND field_of_study IN ('Engineering', 'Computer Science', 'Business') 
GROUP BY origin_country, destination_country, field_of_study, 
year_of_enrollment
ORDER BY student_count DESC;

-- Dice: High-performing students with scholarships 
SELECT  
destination_country, 
field_of_study, 
placement_status, 
COUNT(*) AS student_count, 
AVG(gpa_or_score) AS avg_gpa, 
AVG(CAST(starting_salary_usd AS FLOAT)) AS avg_salary 
FROM global_student_migration 
WHERE  
gpa_or_score >= 3.5  
AND scholarship_received = 1  -- Changed from 'Yes' to 1 
AND graduation_year BETWEEN 2022 AND 2024 
GROUP BY destination_country, field_of_study, placement_status 
ORDER BY avg_salary DESC;

-- Pivot: Countries as columns, fields as rows 
SELECT  
field_of_study, 
SUM(CASE WHEN destination_country = 'Germany' THEN 1 ELSE 0 
END) AS Germany, 
SUM(CASE WHEN destination_country = 'UK' THEN 1 ELSE 0 END) 
AS UK, 
SUM(CASE WHEN destination_country = 'Canada' THEN 1 ELSE 0 
END) AS Canada, 
SUM(CASE WHEN destination_country = 'USA' THEN 1 ELSE 0 END) 
AS USA, 
SUM(CASE WHEN destination_country = 'India' THEN 1 ELSE 0 END) 
AS India, 
COUNT(*) AS Total 
FROM global_student_migration 
GROUP BY field_of_study 
ORDER BY Total DESC;

-- Pivot: Years as columns, countries as rows 
SELECT  
destination_country, 
SUM(CASE WHEN year_of_enrollment = 2019 THEN 1 ELSE 0 END) 
AS Year_2019, 
SUM(CASE WHEN year_of_enrollment = 2020 THEN 1 ELSE 0 END) 
AS Year_2020, 
SUM(CASE WHEN year_of_enrollment = 2021 THEN 1 ELSE 0 END) 
AS Year_2021, 
SUM(CASE WHEN year_of_enrollment = 2022 THEN 1 ELSE 0 END) 
AS Year_2022, 
SUM(CASE WHEN year_of_enrollment = 2023 THEN 1 ELSE 0 END) 
AS Year_2023, 
COUNT(*) AS Total_Students 
FROM global_student_migration 
GROUP BY destination_country 
ORDER BY Total_Students DESC; 