/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy company_dim FROM 'C:\Users\bhrag\SQL_Project_Data_Job_Analysis\csv_files\company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_dim FROM 'C:\Users\bhrag\SQL_Project_Data_Job_Analysis\csv_files\skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy job_postings_fact FROM 'C:\Users\bhrag\SQL_Project_Data_Job_Analysis\csv_files\job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_job_dim FROM 'C:\Users\bhrag\SQL_Project_Data_Job_Analysis\csv_files\skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/

-- NOTE: This has been updated from the video to fix issues with encoding

COPY company_dim
FROM 'C:\Users\bhrag\SQL_Project_Data_Job_Analysis\csv_files\company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim
FROM 'C:\Users\bhrag\SQL_Project_Data_Job_Analysis\csv_files\job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact
FROM 'C:\Users\bhrag\SQL_Project_Data_Job_Analysis\csv_files\skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim
FROM 'C:\Users\bhrag\SQL_Project_Data_Job_Analysis\csv_files\skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
/*
SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;

SELECT '2023-10-19'::DATE,
'123'::INTEGER,
'true'::BOOLEAN,
'3.14'::REAL;

SELECT 
     job_title_short AS title,
     job_location AS location,
     job_posted_date  AS date 
     FROM
     job_postings_fact

-- if I want to select only the date and not the time stamp
SELECT 
     job_title_short AS title,
     job_location AS location,
     job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS DATE
     FROM
     job_postings_fact
LIMIT 5;

-- IF I WANT TO EXTRACT YEAR OR MONTH 

SELECT 
    COUNT(job_id) AS job_posted_count,
     EXTRACT (MONTH FROM job_posted_date) AS month_mine

     FROM

     job_postings_fact
      WHERE 
          job_title_short = 'Data Analyst'
     GROUP BY
     month_mine
     ORDER BY
     job_posted_count
LIMIT 5;

SELECT  
   AVG(salary_hour_avg) AS average_hourly_salary,
   AVG(salary_year_avg) AS average_yearly_salary
FROM 
   job_postings_fact
WHERE 
    job_posted_date > '2023-06-01'
GROUP BY
   job_schedule_type

LIMIT 5;

SELECT 
      COUNT(job_id)  as job_postings,
   
     EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') as month_mine
FROM 
job_postings_fact

GROUP BY 
   month_mine
ORDER BYjob_id
  month_mine
LIMIT 5;
*/
CREATE TABLE january_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE
    EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE
    EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE
    EXTRACT(MONTH FROM job_posted_date) = 3;


 SELECT job_posted_date FROM march_jobs;

 -- lebeling and using the conditional statements when then just like if else statements

  
   SELECT
       COUNT(job_id) AS number_of_jobs,
      CASE  
           WHEN job_location = 'Anywhere' THEN 'Remote'
           WHEN job_location = 'New York, NY' THEN 'Local'
           ELSE 'Onsite'
       END AS location_catagory
    FROM 
         job_postings_fact
    WHERE 
       job_title_short = 'Data Analyst'
    GROUP BY
         location_catagory;

 SELECT *
 FROM(
    SELECT * 
    FROM job_postings_fact 
    WHERE  
    EXTRACT(MONTH FROM job_posted_date) = 1
 ) AS january_jobs;

 -- CTE'S MEANS CommON Table Expressions 
 WITH january_jobs AS(
    SELECT *
    FROM 
    job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    ORDER BY
    job_posted_date
 )
 SELECT * FROM january_jobs;

 -- Let's say If I want to find the job woth no degree
 SELECT NAME AS company_name ,
 company_id
 FROM 
 company_dim
 WHERE
 company_id IN(
    SELECT
    company_id
   
    FROM
    job_postings_fact
    WHERE
    job_no_degree_mention = true
 )
 WITH company_job_count AS(
 SELECT company_id,
        COUNT(*)
 FROM
      job_postings_fact
GROUP BY
     company_id
 )
 SELECT name FROM company_job_count
LEFT JOIN company_job_count ON company_job_count.company_id  = company_dim.company_id;

SELECT 
        skill_id
FROM
 skills_job_dim



