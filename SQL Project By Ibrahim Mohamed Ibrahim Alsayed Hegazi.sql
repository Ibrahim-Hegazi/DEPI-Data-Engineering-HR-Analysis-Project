-- HR Analysis By Ibrahim Mohamed Ibrahim Alsayed Hegazi
-- Lets start with the most know workforce demographics :
--		1)Age Distribution : Analyzing the age range of employees to understand the generational mix within the organization.
--		2)Gender Distribution : Examining the ratio of male to female employees.
--		3)Marital Status : Analyzing the marital status and family composition of employees, which can inform benefits and work-life balance programs
--		4)Ethnicity and race : Assessing the diversity of employees in terms of ethnicity and race.
--		5)Educational levels : Understanding the educational background of employees.
--		6)Tenure : Analyzing how long employees have been with the organization.
--		7)Job Roles (Departments) : Examining the distribution of employees across different job roles and hierarchical levels.
--		8)Geographic Distribution : Understanding where employees are located, especially for organizations with multiple offices or remote workers.

--Importance of Understanding Workforce Demographics :
--		1)Diversity and Inclusion: Helps identify areas where diversity can be improved and supports the development of inclusive policies and practices.
--		2)Talent Management: Informs recruitment and retention strategies by understanding the demographic makeup of the workforce.
--		3)Training and Development: dentifies the need for targeted training programs based on the educational background, career aspirations of employees, sales , and shift hours
--		4)Succession Planning: Supports succession planning by analyzing the age distribution and tenure of employees, ensuring that there are plans for key roles as employees retire or move on.
--		5)Employee Engagement: Enhances employee engagement by addressing the specific needs and preferences of different demographic groups within the workforce.



--بسم الله الرحمان الرحيم
--1) Age Distribution : Analyzing the age range of employees to understand the generational mix within the organization.
--		Step 1.1: Find the minimum and maximum ages
--		Step 1.2: Calculate the age ranges
--		Step 1.3: Assign employees to age groups and determine age ranges for each group
--		Step 1.4: Calculate the starting and ending ages for each quarter
--		Step 1.5: Count the number of employees in each age group and display the age ranges


-- Step 1.0:Exploring the table to see if i would need to clean up the data
select *
from HumanResources.Employee;

-- Step 1.1: Find the minimum and maximum ages
WITH MinMaxAges AS (
    SELECT 
        MIN(YEAR(GETDATE()) - YEAR(e.BirthDate)) AS MinAge,
        MAX(YEAR(GETDATE()) - YEAR(e.BirthDate)) AS MaxAge
    FROM 
        HumanResources.Employee e
),

-- Step 1.2: Calculate the age ranges
AgeRanges AS (
    SELECT 
        YEAR(GETDATE()) - YEAR(e.BirthDate) AS Age
    FROM 
        HumanResources.Employee e
),

-- Step 1.3: Assign employees to age groups and determine age ranges for each group
AgeGroups AS (
    SELECT 
        Age,
        CASE 
            WHEN Age BETWEEN MinAge AND MinAge + (MaxAge - MinAge) / 4 THEN 'Q1'
            WHEN Age BETWEEN MinAge + (MaxAge - MinAge) / 4 + 1 AND MinAge + (MaxAge - MinAge) / 2 THEN 'Q2'
            WHEN Age BETWEEN MinAge + (MaxAge - MinAge) / 2 + 1 AND MinAge + 3 * (MaxAge - MinAge) / 4 THEN 'Q3'
            ELSE 'Q4'
        END AS AgeGroup
    FROM 
        AgeRanges,
        MinMaxAges
),

-- Step 1.4: Calculate the starting and ending ages for each quarter
QuarterRanges AS (
    SELECT 
        'Q1' AS AgeGroup, 
        MinAge AS StartAge, 
        MinAge + (MaxAge - MinAge) / 4 AS EndAge
    FROM MinMaxAges
    UNION ALL
    SELECT 
        'Q2' AS AgeGroup, 
        MinAge + (MaxAge - MinAge) / 4 + 1 AS StartAge, 
        MinAge + (MaxAge - MinAge) / 2 AS EndAge
    FROM MinMaxAges
    UNION ALL
    SELECT 
        'Q3' AS AgeGroup, 
        MinAge + (MaxAge - MinAge) / 2 + 1 AS StartAge, 
        MinAge + 3 * (MaxAge - MinAge) / 4 AS EndAge
    FROM MinMaxAges
    UNION ALL
    SELECT 
        'Q4' AS AgeGroup, 
        MinAge + 3 * (MaxAge - MinAge) / 4 + 1 AS StartAge, 
        MaxAge AS EndAge
    FROM MinMaxAges
)

-- Step 1.5: Count the number of employees in each age group and display the age ranges
SELECT 
    q.AgeGroup,
    q.StartAge,
    q.EndAge,
    COUNT(a.Age) AS NumberOfEmployees
FROM 
    QuarterRanges q
LEFT JOIN 
    AgeGroups a
ON 
    q.AgeGroup = a.AgeGroup
GROUP BY 
    q.AgeGroup, q.StartAge, q.EndAge
ORDER BY 
    q.AgeGroup;

-- CONCULUSION FROM The Age Distribution Analysis
-- 1) The Distribution of Employees Across Different Age Groups?
-- 2) What Are the Predominant Age Groups in the Organization?
--A follow up question has appeared : What is the Agverage years of experience in each age distribution?


-- Answering The follow up question  : What is the Agverage years of experience in each age distribution?
-- Step 1: Find the minimum and maximum ages
WITH MinMaxAges AS (
    SELECT 
        MIN(YEAR(GETDATE()) - YEAR(e.BirthDate)) AS MinAge,
        MAX(YEAR(GETDATE()) - YEAR(e.BirthDate)) AS MaxAge
    FROM 
        HumanResources.Employee e
),

-- Step 2: Calculate the age and years of experience for each employee
AgeExperience AS (
    SELECT 
        YEAR(GETDATE()) - YEAR(e.BirthDate) AS Age,
        YEAR(GETDATE()) - YEAR(e.HireDate) AS YearsOfExperience
    FROM 
        HumanResources.Employee e
),

-- Step 3: Assign employees to age groups and determine age ranges for each group
AgeGroups AS (
    SELECT 
        Age,
        YearsOfExperience,
        CASE 
            WHEN Age BETWEEN MinAge AND MinAge + (MaxAge - MinAge) / 4 THEN 'Q1'
            WHEN Age BETWEEN MinAge + (MaxAge - MinAge) / 4 + 1 AND MinAge + (MaxAge - MinAge) / 2 THEN 'Q2'
            WHEN Age BETWEEN MinAge + (MaxAge - MinAge) / 2 + 1 AND MinAge + 3 * (MaxAge - MinAge) / 4 THEN 'Q3'
            ELSE 'Q4'
        END AS AgeGroup
    FROM 
        AgeExperience,
        MinMaxAges
),

-- Step 4: Calculate the starting and ending ages for each quarter
QuarterRanges AS (
    SELECT 
        'Q1' AS AgeGroup, 
        MinAge AS StartAge, 
        MinAge + (MaxAge - MinAge) / 4 AS EndAge
    FROM MinMaxAges
    UNION ALL
    SELECT 
        'Q2' AS AgeGroup, 
        MinAge + (MaxAge - MinAge) / 4 + 1 AS StartAge, 
        MinAge + (MaxAge - MinAge) / 2 AS EndAge
    FROM MinMaxAges
    UNION ALL
    SELECT 
        'Q3' AS AgeGroup, 
        MinAge + (MaxAge - MinAge) / 2 + 1 AS StartAge, 
        MinAge + 3 * (MaxAge - MinAge) / 4 AS EndAge
    FROM MinMaxAges
    UNION ALL
    SELECT 
        'Q4' AS AgeGroup, 
        MinAge + 3 * (MaxAge - MinAge) / 4 + 1 AS StartAge, 
        MaxAge AS EndAge
    FROM MinMaxAges
)

-- Step 5: Calculate the average years of experience for each age group
SELECT 
    q.AgeGroup,
    q.StartAge,
    q.EndAge,
    COUNT(a.Age) AS NumberOfEmployees,
    AVG(a.YearsOfExperience) AS AverageYearsOfExperience
FROM 
    QuarterRanges q
LEFT JOIN 
    AgeGroups a
ON 
    q.AgeGroup = a.AgeGroup
GROUP BY 
    q.AgeGroup, q.StartAge, q.EndAge
ORDER BY 
    q.AgeGroup;


-- Testing the validity of the averages based on ages
SELECT 
    AVG(YEAR(GETDATE()) - YEAR(HireDate)) AS AverageYearsOfExperience
FROM 
    HumanResources.Employee
WHERE 
    YEAR(GETDATE()) - YEAR(BirthDate) BETWEEN 64 AND 73;



--2)Gender Distribution : Examining the ratio of male to female employees.
--		Step 2.1: Extract the count of male and female employees:
--		Step 2.2: Calculate Ratios


-- Step 2.0:Exploring the table to see if i would need to clean up the data
select *
from HumanResources.Employee;

--Step 2.1: Extract the count of male and female employees:
select gender,count(e.BusinessEntityID) Number
from HumanResources.Employee AS e
group by e.Gender;

--Step 2.2: Calculate Ratios
WITH GenderCounts AS (
    SELECT 
        Gender,
        COUNT(*) AS NumberOfEmployees
    FROM 
        HumanResources.Employee
    GROUP BY 
        Gender
),
TotalEmployees AS (
    SELECT 
        SUM(NumberOfEmployees) AS Total
    FROM 
        GenderCounts
)
SELECT 
    g.Gender,
    g.NumberOfEmployees,
    (g.NumberOfEmployees * 1.0 / t.Total) * 100 AS Percentage
FROM 
    GenderCounts g, 
    TotalEmployees t;




-- Rounding the numbers more
WITH GenderCounts AS (
    SELECT 
        Gender,
        COUNT(*) AS NumberOfEmployees
    FROM 
        HumanResources.Employee
    GROUP BY 
        Gender
),
TotalEmployees AS (
    SELECT 
        SUM(NumberOfEmployees) AS Total
    FROM 
        GenderCounts
)
SELECT 
    g.Gender,
    g.NumberOfEmployees,
    FORMAT((g.NumberOfEmployees * 1.0 / t.Total) * 100, '0.##') AS Percentage
FROM 
    GenderCounts g, 
    TotalEmployees t;




-- CONCULUSION FROM The Gender Distribution Analysis
-- 1) What is the percentage or the ratio of males and females?

--The follow up question : Compare between hiring percentage of males and females between each two years ,Starting from the first year of hirings till the last year of hirings?


-- Answering the follow up question : Compare between hiring percentage of males and females between each two years ,Starting from the first year of hirings till the last year of hirings?
	-- Step 0:Exploring the table to see if i would need to clean up the data
	-- Step 1: Extract the hiring year and gender for each employee
	-- Step 2: Calculate the total number of hires for each year
	-- Step 3: Calculate the number of hires for each gender per year
	-- Step 4: Pivot the gender hire counts into separate columns for male and female hires
	-- Step 5: Combine the total hires, male hires, female hires, and calculate the hire percentages for males and females
	-- Step 6: Add columns for the previous year's total hires and the difference in hires between the current and previous year using the LAG window function
	-- Step 7: Select and display the desired columns with the specified calculations and formatting
	

-- Step 0:Exploring the table to see if i would need to clean up the data
select *
from HumanResources.Employee;

-- Step 1: Extract the hiring year and gender for each employee
WITH EmployeeHires AS (
    SELECT 
        YEAR(HireDate) AS HireYear,
        Gender
    FROM 
        HumanResources.Employee
),

-- Step 2: Calculate the total number of hires for each year
TotalHiresPerYear AS (
    SELECT 
        HireYear,
        COUNT(*) AS TotalHires
    FROM 
        EmployeeHires
    GROUP BY 
        HireYear
),

-- Step 3: Calculate the number of hires for each gender per year
GenderHiresPerYear AS (
    SELECT 
        HireYear,
        Gender,
        COUNT(*) AS GenderHires
    FROM 
        EmployeeHires
    GROUP BY 
        HireYear, Gender
),

-- Step 4: Pivot the gender hire counts into separate columns for male and female hires
PivotedGenderHires AS (
    SELECT 
        HireYear,
        SUM(CASE WHEN Gender = 'M' THEN GenderHires ELSE 0 END) AS MaleHires,
        SUM(CASE WHEN Gender = 'F' THEN GenderHires ELSE 0 END) AS FemaleHires
    FROM 
        GenderHiresPerYear
    GROUP BY 
        HireYear
),

-- Step 5: Combine the total hires, male hires, female hires, and calculate the hire percentages for males and females
CombinedData AS (
    SELECT 
        t.HireYear,
        t.TotalHires,
        p.MaleHires,
        p.FemaleHires,
        (p.MaleHires * 1.0 / t.TotalHires) * 100 AS MaleHirePercentage,
        (p.FemaleHires * 1.0 / t.TotalHires) * 100 AS FemaleHirePercentage
    FROM 
        TotalHiresPerYear t
    JOIN 
        PivotedGenderHires p ON t.HireYear = p.HireYear
),

-- Step 6: Add columns for the previous year's total hires and the difference in hires between the current and previous year using the LAG window function
FinalData AS (
    SELECT 
        HireYear,
        TotalHires,
        MaleHires,
        ROUND(MaleHirePercentage, 2) AS MaleHirePercentage,
        FemaleHires,
        ROUND(FemaleHirePercentage, 2) AS FemaleHirePercentage,
        LAG(TotalHires, 1) OVER (ORDER BY HireYear) AS PreviousYearHires,
        TotalHires - LAG(TotalHires, 1) OVER (ORDER BY HireYear) AS HireDifference
    FROM 
        CombinedData
)

-- Step 7: Select and display the desired columns with the specified calculations and formatting
SELECT 
    HireYear,
    TotalHires,
    MaleHires,
    MaleHirePercentage,
    FemaleHires,
    FemaleHirePercentage,
    PreviousYearHires,
    HireDifference
FROM 
    FinalData
ORDER BY 
    HireYear;





-- Rounding the number even more
-- Step 1: Extract the hiring year and gender for each employee
WITH EmployeeHires AS (
    SELECT 
        YEAR(HireDate) AS HireYear,
        Gender
    FROM 
        HumanResources.Employee
),

-- Step 2: Calculate the total number of hires for each year
TotalHiresPerYear AS (
    SELECT 
        HireYear,
        COUNT(*) AS TotalHires
    FROM 
        EmployeeHires
    GROUP BY 
        HireYear
),

-- Step 3: Calculate the number of hires for each gender per year
GenderHiresPerYear AS (
    SELECT 
        HireYear,
        Gender,
        COUNT(*) AS GenderHires
    FROM 
        EmployeeHires
    GROUP BY 
        HireYear, Gender
),

-- Step 4: Pivot the gender hire counts into separate columns for male and female hires
PivotedGenderHires AS (
    SELECT 
        HireYear,
        SUM(CASE WHEN Gender = 'M' THEN GenderHires ELSE 0 END) AS MaleHires,
        SUM(CASE WHEN Gender = 'F' THEN GenderHires ELSE 0 END) AS FemaleHires
    FROM 
        GenderHiresPerYear
    GROUP BY 
        HireYear
),

-- Step 5: Combine the total hires, male hires, female hires, and calculate the hire percentages for males and females
CombinedData AS (
    SELECT 
        t.HireYear,
        t.TotalHires,
        p.MaleHires,
        p.FemaleHires,
        (p.MaleHires * 1.0 / t.TotalHires) * 100 AS MaleHirePercentage,
        (p.FemaleHires * 1.0 / t.TotalHires) * 100 AS FemaleHirePercentage
    FROM 
        TotalHiresPerYear t
    JOIN 
        PivotedGenderHires p ON t.HireYear = p.HireYear
),

-- Step 6: Add columns for the previous year's total hires and the difference in hires between the current and previous year using the LAG window function
FinalData AS (
    SELECT 
        HireYear,
        TotalHires,
        MaleHires,
        FORMAT(ROUND(MaleHirePercentage, 2), '0.##') AS MaleHirePercentage,
        FemaleHires,
        FORMAT(ROUND(FemaleHirePercentage, 2), '0.##') AS FemaleHirePercentage,
        LAG(TotalHires, 1) OVER (ORDER BY HireYear) AS PreviousYearHires,
        TotalHires - LAG(TotalHires, 1) OVER (ORDER BY HireYear) AS HireDifference
    FROM 
        CombinedData
)

-- Step 7: Select and display the desired columns with the specified calculations and formatting
SELECT 
    HireYear,
    TotalHires,
    MaleHires,
    MaleHirePercentage,
    FemaleHires,
    FemaleHirePercentage,
    PreviousYearHires,
    HireDifference
FROM 
    FinalData
ORDER BY 
    HireYear;


--CONCLUSION OF THE FOLLOW UP Question
	-- The hiring rates of the females are rising linearly while the hiring dates of the males are decreasing non-linearly throughout the years





-- 3)Marital Status : Analyzing the marital status and family composition of employees, which can inform benefits and work-life balance programs
--		Step 0:Exploring the table to see if i would need to clean up the data
--		Step 1: Extract Marital Status Data
--		Step 2: Extract Marital Status and Gender Data
--		Step 3: Extract Marital Status and Gender Data with Percentages
--		Step 4: Search for dependents data , so that you can decide which employee is needs our work life balance program

--Step 0:Exploring the table to see if i would need to clean up the data
select *
from HumanResources.Employee;

--Step 1: Extract Marital Status Data
SELECT 
    MaritalStatus,
    COUNT(*) AS NumberOfEmployees
FROM 
    HumanResources.Employee
GROUP BY 
    MaritalStatus;

--Step 2: Extract Marital Status and Gender Data
SELECT 
    MaritalStatus,
    Gender,
    COUNT(*) AS NumberOfEmployees
FROM 
    HumanResources.Employee
GROUP BY 
    MaritalStatus, Gender;


-- Step 3: Extract Marital Status and Gender Data with Percentages
WITH TotalEmployeeCount AS (
    SELECT COUNT(*) AS TotalEmployees
    FROM HumanResources.Employee
),

MaritalStatusGenderCounts AS (
    SELECT 
        MaritalStatus,
        Gender,
        COUNT(*) AS NumberOfEmployees
    FROM 
        HumanResources.Employee
    GROUP BY 
        MaritalStatus, Gender
)

SELECT 
    m.MaritalStatus,
    m.Gender,
    m.NumberOfEmployees,
    ROUND((m.NumberOfEmployees * 1.0 / t.TotalEmployees) * 100, 2) AS PercentageOfTotal
FROM 
    MaritalStatusGenderCounts m
JOIN 
    TotalEmployeeCount t
ON 
    1 = 1  -- Cartesian join to get the total employee count for percentage calculation
ORDER BY 
    m.MaritalStatus, m.Gender;



-- Rounding the percentages
WITH TotalEmployeeCount AS (
    SELECT COUNT(*) AS TotalEmployees
    FROM HumanResources.Employee
),

MaritalStatusGenderCounts AS (
    SELECT 
        MaritalStatus,
        Gender,
        COUNT(*) AS NumberOfEmployees
    FROM 
        HumanResources.Employee
    GROUP BY 
        MaritalStatus, Gender
)

SELECT 
    m.MaritalStatus,
    m.Gender,
    m.NumberOfEmployees,
    FORMAT(ROUND((m.NumberOfEmployees * 1.0 / t.TotalEmployees) * 100, 2), '0.##') AS PercentageOfTotal
FROM 
    MaritalStatusGenderCounts m
JOIN 
    TotalEmployeeCount t
ON 
    1 = 1  -- Cartesian join to get the total employee count for percentage calculation
ORDER BY 
    m.MaritalStatus, m.Gender;


-- CONCULUSION FROM The Marital Distribution Analysis
-- Marital Status by Gender:
		--Male Employees:
			--Married: 97 out of 149 male employees are married, which is approximately 65%.
			--Single: 52 out of 149 male employees are single, which is approximately 35%.
		--Female Employees:
			--Married: 49 out of 84 female employees are married, which is approximately 58%.
			--Single: 35 out of 84 female employees are single, which is approximately 42%

-- Recommendation
-- I want to know which employees needed the work-life balance program because i didnt find the needed data like a table for the employee's dependants ,and this table could could have helped us extract other information like:
		--1)Average Number of Dependents
		--2)Gender and Family Composition
		--3)Trends Over Time :The percentage of single employees has increased by 10% over the past five years






--4)	e : Assessing the diversity of employees in terms of ethnicity and race.
-- while searching for people ethnicity and race i found Sales.SalesTerritory table connected with Person.Country Region Table
-- That show to us that only the salespersons are the ones whom we access details about their working location

--Step 1: exploring the needed tables : Sales.SalesTerritory 
select *
from Sales.SalesTerritory;

--Step 2: Counting the number of the sales person from each territory
SELECT 
    st.Name AS TerritoryName, st.CountryRegionCode,
    COUNT(sp.BusinessEntityID) AS NumberOfSalespersons
FROM 
    Sales.SalesPerson sp
JOIN 
    Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
GROUP BY 
    st.Name,st.CountryRegionCode
ORDER BY 
    NumberOfSalespersons DESC;

--Step 3: Finding the region with the most SalesPersons
select max(CountryRegionCode)
from sales.SalesTerritory;


--CONCULUSION : i can notice that most of our salesPersons are mostly working at the USA ,
--				so it is predicted that most of our sales that came through the salesperson would be from the USA due to the number of sales persons there,
--				But we should assume any thing so we gonna find the Country with the most revenue

-- Follow up question : What is the country with the maximum revenue from the SalesPersons Work
SELECT 
    st.CountryRegionCode,
    SUM(soh.TotalDue) AS TotalRevenue
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN 
    Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
GROUP BY 
    st.CountryRegionCode
ORDER BY 
    TotalRevenue DESC;

-- CONCULUSION for the follow up question, my predictions was right and the region with the most revenue through SalesPersons is the USA 
-- Recommendation : We should consider adding tables all of the employees about their salaries 




--5)Educational levels : Understanding the educational background of employees.
--Conculusion After searching the database for data related to our employees education, sadly no data found
--Based on that missing data we could have provided some internal training for our employees to boost the career and performance inside our organization






--6)Tenure : Analyzing how long employees have been with the organization.
--		Step 1: Calculate Tenure for Each Employee
--		Step 2: Calculate Average Tenure
--		Step 3: Group Employees by Tenure Ranges
--		Step 4: Identify Employees with Longest and Shortest Tenures

--Step 6.0: Exploring the tables for possible data cleaning (Exploratory Data Analysis)
--Step 6.0.1 : Exploring  HumanResources.Employee
SELECT *
FROM HumanResources.Employee;

--Step6.0.2:
SELECT *
FROM HumanResources.EmployeeDepartmentHistory;
--		From this query i noticed the EndDate feild which means i have to put into consideration this table in my calculation


-- Step 1: Calculate Tenure for Each Employee
SELECT 
    e.BusinessEntityID,
    DATEDIFF(YEAR, e.HireDate, ISNULL(edh.EndDate, GETDATE())) AS Tenure
FROM 
    HumanResources.Employee e
LEFT JOIN 
    HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
WHERE 
    edh.ShiftID = (SELECT MAX(ShiftID) FROM HumanResources.EmployeeDepartmentHistory WHERE BusinessEntityID = e.BusinessEntityID);

	--In this query i notice a strange output where the employee with busineesEntityID 250 has 3 tenures
	--which mean that he/she might have changed their positions inside the organization multiple times

--Step 1:Modified Query : solved the issue
SELECT 
    e.BusinessEntityID,
    sum(DATEDIFF(YEAR, e.HireDate, ISNULL(edh.EndDate, GETDATE()))) AS Tenure
FROM 
    HumanResources.Employee e
LEFT JOIN 
    HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
WHERE 
    edh.ShiftID = (SELECT MAX(ShiftID) FROM HumanResources.EmployeeDepartmentHistory WHERE BusinessEntityID = e.BusinessEntityID)
GROUP BY  e.BusinessEntityID;



--Step 6.2: Calculate Average Tenure
WITH EmployeeTenure AS (
    SELECT 
        e.BusinessEntityID,
        SUM(DATEDIFF(YEAR, edh.StartDate, ISNULL(edh.EndDate, GETDATE()))) AS Tenure
    FROM 
        HumanResources.Employee e
    JOIN 
        HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
    GROUP BY 
        e.BusinessEntityID
)
SELECT 
    AVG(Tenure) AS AverageTenure
FROM 
    EmployeeTenure;




--Step 6.3: Group Employees by Tenure Ranges
SELECT 
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, ISNULL(edh.EndDate, GETDATE())) BETWEEN 0 AND 5 THEN '0-5 years'
        WHEN DATEDIFF(YEAR, e.HireDate, ISNULL(edh.EndDate, GETDATE())) BETWEEN 6 AND 10 THEN '6-10 years'
        WHEN DATEDIFF(YEAR, e.HireDate, ISNULL(edh.EndDate, GETDATE())) BETWEEN 11 AND 15 THEN '11-15 years'
        WHEN DATEDIFF(YEAR, e.HireDate, ISNULL(edh.EndDate, GETDATE())) BETWEEN 16 AND 20 THEN '16-20 years'
        ELSE '21+ years'
    END AS TenureRange,
    COUNT(*) AS NumberOfEmployees
FROM 
    HumanResources.Employee e
LEFT JOIN 
    HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
WHERE 
    edh.ShiftID = (SELECT MAX(ShiftID) FROM HumanResources.EmployeeDepartmentHistory WHERE BusinessEntityID = e.BusinessEntityID)
GROUP BY 
    CASE 
        WHEN DATEDIFF(YEAR, e.HireDate, ISNULL(edh.EndDate, GETDATE())) BETWEEN 0 AND 5 THEN '0-5 years'
        WHEN DATEDIFF(YEAR, e.HireDate, ISNULL(edh.EndDate, GETDATE())) BETWEEN 6 AND 10 THEN '6-10 years'
        WHEN DATEDIFF(YEAR, e.HireDate, ISNULL(edh.EndDate, GETDATE())) BETWEEN 11 AND 15 THEN '11-15 years'
        WHEN DATEDIFF(YEAR, e.HireDate, ISNULL(edh.EndDate, GETDATE())) BETWEEN 16 AND 20 THEN '16-20 years'
        ELSE '21+ years'
    END
ORDER BY 
    TenureRange;

--Modified Query after noticing the logical error that the duplicated rows 
--Now the old query might answer the following question: group up the employees by tenure ranges of each employee at each position or department ? 
-- Not sure about that query yet needs to be revised
-- Step 6.3: Group Employees by Tenure Ranges
WITH EmployeeTenure AS (
    SELECT 
        e.BusinessEntityID,
        SUM(DATEDIFF(YEAR, edh.StartDate, ISNULL(edh.EndDate, GETDATE()))) AS Tenure
    FROM 
        HumanResources.Employee e
    JOIN 
        HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
    GROUP BY 
        e.BusinessEntityID
)
SELECT 
    CASE 
        WHEN Tenure BETWEEN 0 AND 5 THEN '0-5 years'
        WHEN Tenure BETWEEN 6 AND 10 THEN '6-10 years'
        WHEN Tenure BETWEEN 11 AND 15 THEN '11-15 years'
        WHEN Tenure BETWEEN 16 AND 20 THEN '16-20 years'
        ELSE '21+ years'
    END AS TenureRange,
    COUNT(*) AS NumberOfEmployees
FROM 
    EmployeeTenure
GROUP BY 
    CASE 
        WHEN Tenure BETWEEN 0 AND 5 THEN '0-5 years'
        WHEN Tenure BETWEEN 6 AND 10 THEN '6-10 years'
        WHEN Tenure BETWEEN 11 AND 15 THEN '11-15 years'
        WHEN Tenure BETWEEN 16 AND 20 THEN '16-20 years'
        ELSE '21+ years'
    END
ORDER BY 
    TenureRange;




-- Step 6.4: Identify employees with the longest and shortest tenure
-- Step 6.4.1: Define a CTE to calculate tenure for each employee
WITH EmployeeTenure AS (
    SELECT 
        e.BusinessEntityID,
        sum(DATEDIFF(YEAR, e.HireDate, ISNULL(edh.EndDate, GETDATE()))) AS Tenure
    FROM 
        HumanResources.Employee e
    LEFT JOIN 
        HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
    WHERE 
        edh.ShiftID = (SELECT MAX(ShiftID) FROM HumanResources.EmployeeDepartmentHistory WHERE BusinessEntityID = e.BusinessEntityID)
	GROUP BY  e.BusinessEntityID
)

-- Step 6.4.2: Select the employee with the maximum tenure
-- This step will ensure the CTE is used properly by enclosing the second query in a separate CTE
, MaxTenureEmployee AS (
    SELECT 
        TOP 1 BusinessEntityID, Tenure
    FROM 
        EmployeeTenure
    ORDER BY 
        Tenure DESC
)

-- Step 6.4.3: Select the employee with the minimum tenure
, MinTenureEmployee AS (
    SELECT 
        TOP 1 BusinessEntityID, Tenure
    FROM 
        EmployeeTenure
    ORDER BY 
        Tenure ASC
)

-- Step 6.4.4: Final SELECT statement to get results from both CTEs
SELECT * FROM MaxTenureEmployee
UNION ALL
SELECT * FROM MinTenureEmployee;






--FOLLOW UP Question: What is the average tenure for each of our age groups in our organization
-- Step 1: Calculate the age ranges and assign employees to age groups
WITH MinMaxAges AS (
    SELECT 
        MIN(YEAR(GETDATE()) - YEAR(e.BirthDate)) AS MinAge,
        MAX(YEAR(GETDATE()) - YEAR(e.BirthDate)) AS MaxAge
    FROM 
        HumanResources.Employee e
),

-- Step 2: Calculate the age and years of experience for each employee
AgeExperience AS (
    SELECT 
        YEAR(GETDATE()) - YEAR(e.BirthDate) AS Age,
        YEAR(GETDATE()) - YEAR(e.HireDate) AS YearsOfExperience
    FROM 
        HumanResources.Employee e
),

-- Step 3: Assign employees to age groups and determine age ranges for each group
AgeGroups AS (
    SELECT 
        Age,
        YearsOfExperience,
        CASE 
            WHEN Age BETWEEN MinAge AND MinAge + (MaxAge - MinAge) / 4 THEN 'Q1'
            WHEN Age BETWEEN MinAge + (MaxAge - MinAge) / 4 + 1 AND MinAge + (MaxAge - MinAge) / 2 THEN 'Q2'
            WHEN Age BETWEEN MinAge + (MaxAge - MinAge) / 2 + 1 AND MinAge + 3 * (MaxAge - MinAge) / 4 THEN 'Q3'
            ELSE 'Q4'
        END AS AgeGroup
    FROM 
        AgeExperience,
        MinMaxAges
),

-- Step 4: Calculate the starting and ending ages for each quarter
QuarterRanges AS (
    SELECT 
        'Q1' AS AgeGroup, 
        MinAge AS StartAge, 
        MinAge + (MaxAge - MinAge) / 4 AS EndAge
    FROM MinMaxAges
    UNION ALL
    SELECT 
        'Q2' AS AgeGroup, 
        MinAge + (MaxAge - MinAge) / 4 + 1 AS StartAge, 
        MinAge + (MaxAge - MinAge) / 2 AS EndAge
    FROM MinMaxAges
    UNION ALL
    SELECT 
        'Q3' AS AgeGroup, 
        MinAge + (MaxAge - MinAge) / 2 + 1 AS StartAge, 
        MinAge + 3 * (MaxAge - MinAge) / 4 AS EndAge
    FROM MinMaxAges
    UNION ALL
    SELECT 
        'Q4' AS AgeGroup, 
        MinAge + 3 * (MaxAge - MinAge) / 4 + 1 AS StartAge, 
        MaxAge AS EndAge
    FROM MinMaxAges
)

-- Step 5: Calculate the number of employees and the average years of experience for each age group
SELECT 
    q.AgeGroup,
    q.StartAge,
    q.EndAge,
    COUNT(a.Age) AS NumberOfEmployees,
    AVG(a.YearsOfExperience) AS AverageYearsOfExperience
FROM 
    QuarterRanges q
LEFT JOIN 
    AgeGroups a ON q.AgeGroup = a.AgeGroup
GROUP BY 
    q.AgeGroup, q.StartAge, q.EndAge
ORDER BY 
    q.AgeGroup;



-- Conculusion : The average years of experience of our employee is 15 years , considering this is a good fact 
--				, but we can notice that we need more junior for our succession plan to be successful






--7)Job Roles (Departments) : Examining the distribution of employees across different job roles and hierarchical levels.
--		Step 7.1: Identify Relevant Tables and Fields
--		Step 7.2: Determine the Current Job Role and Department for Each Employee
--		Step 7.3: Analyze the Distribution by Job Roles
--		Step 7.4: Analyze the Distribution by Department
--		Step 7.5: Analyze Hierarchical Levels
--		Step 7.6: Combine Job Roles and Departments
--		Step 7.7: Calculate Percentages
--		Step 7.8: Analyze Job Roles by Gender
--		Step 7.9:analyze how job roles are related to the marital status
--		Step 7.10: analyzing the salaries of each employee in each department based on the average salary of that department and the average salary of all of the employees
--		Step 7.11:Calculate Absenteeism Rate for Each Employee
--		Step 7.12:Find if there is a relationship of vacation hours and the revenue of each salesperson



--Step 7.1: Identify Relevant Tables and Fields
SELECT *
FROM HumanResources.Employee;

--Notes about this table
		-- The OrganizationNode and Organization level of the JobTitle Chief Executive Officer is NULL , which might cause errors

SELECT *
FROM HumanResources.Department;

SELECT *
FROM HumanResources.EmployeeDepartmentHistory;
--Notes about this table : Take care from the fact that this table might include the same employee in multiple rows which might cause error; the reason behind it is that this table shows us the time that each emoployee spend in each department
-- THERE Is two Chief Officers(Chief Executive Officer-row 1- and Chief Financial Officer-row 234)  one with organizationLevel of null and the other is 1 , so we have to solve this problem

--Step 7.2: Determine the Current Job Role and Department for Each Employee
WITH CurrentEmployeeDepartment AS (
    SELECT 
        edh.BusinessEntityID,
        edh.DepartmentID,
        edh.ShiftID,
        edh.StartDate,
        edh.EndDate,
        e.JobTitle,
        ROW_NUMBER() OVER (PARTITION BY edh.BusinessEntityID ORDER BY edh.StartDate DESC) AS rn
    FROM 
        HumanResources.EmployeeDepartmentHistory edh
    JOIN 
        HumanResources.Employee e ON edh.BusinessEntityID = e.BusinessEntityID
)
SELECT 
    ced.BusinessEntityID,
    ced.DepartmentID,
    ced.JobTitle,
    d.Name AS DepartmentName
FROM 
    CurrentEmployeeDepartment ced
JOIN 
    HumanResources.Department d ON ced.DepartmentID = d.DepartmentID
WHERE 
    ced.rn = 1;




--Step 7.3: Analyze the Distribution by Job Roles
SELECT 
    JobTitle,
    COUNT(*) AS NumberOfEmployees
FROM 
    HumanResources.Employee
GROUP BY 
    JobTitle
ORDER BY 
    NumberOfEmployees DESC;






--Step 7.4: Analyze the Distribution by Department
SELECT 
    d.Name AS DepartmentName,
    COUNT(*) AS NumberOfEmployees
FROM 
    HumanResources.EmployeeDepartmentHistory edh
JOIN 
    HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE 
    edh.EndDate IS NULL
GROUP BY 
    d.Name
ORDER BY 
    NumberOfEmployees DESC;








--Step 7.5: Analyze Hierarchical Levels
SELECT 
    OrganizationLevel,
	COUNT(*) AS NumberOfEmployees
FROM 
    HumanResources.Employee he
GROUP BY 
    OrganizationLevel
ORDER BY 
    OrganizationLevel;

-- I noticed that we have a null value as mentioned earlier
-- So i concluded without that the chief executive officer is the big boss of the company 

SELECT 
    CASE 
        WHEN OrganizationLevel IS NULL THEN 'BIG BOSS'
        ELSE CAST(OrganizationLevel AS VARCHAR)
    END AS OrganizationLevel,
    COUNT(*) AS NumberOfEmployees
FROM 
    HumanResources.Employee
GROUP BY 
    CASE 
        WHEN OrganizationLevel IS NULL THEN 'BIG BOSS'
        ELSE CAST(OrganizationLevel AS VARCHAR)
    END
ORDER BY 
    OrganizationLevel;



-- Maybe this solution isnt right because of my humble undertanding of the job titles and positions in companys
-- But another remedy is giving the employee that has a job title of "Chief Executive Officer" an organizational level as the other executives in our company which is 1 (Not sure)



--Step 7.6: Combine Job Roles and Departments
SELECT 
    d.Name AS DepartmentName,
    e.JobTitle,
    COUNT(*) AS NumberOfEmployees
FROM 
    HumanResources.Employee e
JOIN 
    HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN 
    HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE 
    edh.EndDate IS NULL
GROUP BY 
    d.Name, e.JobTitle
ORDER BY 
    d.Name, NumberOfEmployees DESC;

-- I feel that the organizational level is needed to solve the null problem and see which of my solutions is the right one


SELECT 
    d.Name AS DepartmentName,
    e.JobTitle,
    CASE 
        WHEN e.OrganizationLevel IS NULL THEN 'BIG BOSS'
        ELSE CAST(e.OrganizationLevel AS VARCHAR)
    END AS OrganizationLevel,
    COUNT(*) AS NumberOfEmployees
FROM 
    HumanResources.Employee e
JOIN 
    HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN 
    HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE 
    edh.EndDate IS NULL
GROUP BY 
    d.Name, e.JobTitle, 
    CASE 
        WHEN e.OrganizationLevel IS NULL THEN 'BIG BOSS'
        ELSE CAST(e.OrganizationLevel AS VARCHAR)
    END
ORDER BY 
    d.Name, NumberOfEmployees DESC;


-- My previous Hypothesis : another remedy is giving the employee that has a job title of "Chief Executive Officer" an organizational level as the other executives in our company which is 1 (Not sure).
-- This hypothesis is WRONG because employee in the same departments have different organizational levels also employess with the same job title have different organizational level 

--Also i have to say that my first solution as previously stated might not be the final and the right solution for this null problem ,but i will go with it 
	--My first solution:
			-- I noticed that we have a null value as mentioned earlier
			-- So i concluded without that the chief executive officer is the big boss of the company 


--Step 7.7: Calculate Percentages
WITH DepartmentEmployeeCounts AS (
    SELECT 
        DepartmentID,
        COUNT(*) AS DepartmentEmployeeCount
    FROM 
        HumanResources.EmployeeDepartmentHistory
    WHERE 
        EndDate IS NULL
    GROUP BY 
        DepartmentID
),
JobRoleCounts AS (
    SELECT 
        d.Name AS DepartmentName,
        e.JobTitle,
        COUNT(*) AS NumberOfEmployees,
        de.DepartmentEmployeeCount,
        (COUNT(*) * 100.0 / de.DepartmentEmployeeCount) AS PercentageOfDepartment
    FROM 
        HumanResources.Employee e
    JOIN 
        HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
    JOIN 
        HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
    JOIN 
        DepartmentEmployeeCounts de ON edh.DepartmentID = de.DepartmentID
    WHERE 
        edh.EndDate IS NULL
    GROUP BY 
        d.Name, e.JobTitle, de.DepartmentEmployeeCount
)
SELECT 
    DepartmentName,
    JobTitle,
    NumberOfEmployees,
    PercentageOfDepartment
FROM 
    JobRoleCounts
ORDER BY 
    DepartmentName, PercentageOfDepartment DESC;


--To validate this query i would use the running percentage windows function to get sure from the outputs

WITH DepartmentEmployeeCounts AS (
    SELECT 
        DepartmentID,
        COUNT(*) AS DepartmentEmployeeCount
    FROM 
        HumanResources.EmployeeDepartmentHistory
    WHERE 
        EndDate IS NULL
    GROUP BY 
        DepartmentID
),
JobRoleCounts AS (
    SELECT 
        d.Name AS DepartmentName,
        e.JobTitle,
        COUNT(*) AS NumberOfEmployees,
        de.DepartmentEmployeeCount,
        (COUNT(*) * 100.0 / de.DepartmentEmployeeCount) AS PercentageOfDepartment
    FROM 
        HumanResources.Employee e
    JOIN 
        HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
    JOIN 
        HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
    JOIN 
        DepartmentEmployeeCounts de ON edh.DepartmentID = de.DepartmentID
    WHERE 
        edh.EndDate IS NULL
    GROUP BY 
        d.Name, e.JobTitle, de.DepartmentEmployeeCount
)
SELECT 
    DepartmentName,
    JobTitle,
    NumberOfEmployees,
    PercentageOfDepartment,
    SUM(PercentageOfDepartment) OVER (
        PARTITION BY DepartmentName 
        ORDER BY PercentageOfDepartment DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotalPercentage
FROM 
    JobRoleCounts
ORDER BY 
    DepartmentName, PercentageOfDepartment DESC;








--Step 7.8: Analyze Job Roles by Gender
WITH DepartmentEmployeeCounts AS (
    SELECT 
        DepartmentID,
        COUNT(*) AS DepartmentEmployeeCount
    FROM 
        HumanResources.EmployeeDepartmentHistory
    WHERE 
        EndDate IS NULL
    GROUP BY 
        DepartmentID
),
JobRoleGenderCounts AS (
    SELECT 
        d.Name AS DepartmentName,
        e.JobTitle,
        e.Gender,
        COUNT(*) AS NumberOfEmployees
    FROM 
        HumanResources.Employee e
    JOIN 
        HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
    JOIN 
        HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
    JOIN 
        DepartmentEmployeeCounts de ON edh.DepartmentID = de.DepartmentID
    WHERE 
        edh.EndDate IS NULL
    GROUP BY 
        d.Name, e.JobTitle, e.Gender, de.DepartmentEmployeeCount
)
SELECT 
    DepartmentName,
    JobTitle,
    Gender,
    NumberOfEmployees
FROM 
    JobRoleGenderCounts
ORDER BY 
    DepartmentName, JobTitle, Gender;





--Step 7.9:analyze how job roles are related to the marital status
SELECT 
    e.JobTitle,
    e.MaritalStatus,
    COUNT(*) AS NumberOfEmployees
FROM 
    HumanResources.Employee e
JOIN 
    HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
WHERE 
    edh.EndDate IS NULL
GROUP BY 
    e.JobTitle, e.MaritalStatus
ORDER BY 
    e.JobTitle, e.MaritalStatus;



--


--Step 7.10: analyzing the salaries of each employee in each department based on the average salary of that department and the average salary of all of the employees

		--sadly i couldnt find the data that would help me get the needed insights







--Step 7.11:Calculate Absenteeism Rate for Each Employee
WITH EmployeeWorkdays AS (
    SELECT 
        e.BusinessEntityID,
        e.JobTitle,
        d.Name AS DepartmentName,
        e.VacationHours,
        e.SickLeaveHours,
        s.StartTime,
        s.EndTime,
        DATEDIFF(HOUR, s.StartTime, s.EndTime) AS ShiftHours,
        e.SalariedFlag,
        (e.SickLeaveHours + e.VacationHours) / 8.0 AS DaysAbsent -- Assuming an 8-hour workday
    FROM 
        HumanResources.Employee e
    JOIN 
        HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
    JOIN 
        HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
    JOIN 
        HumanResources.Shift s ON edh.ShiftID = s.ShiftID
    WHERE 
        e.CurrentFlag = 1 -- Only consider active employees
        AND edh.EndDate IS NULL -- Only consider current department assignments
),
TotalWorkdays AS (
    SELECT 
        e.BusinessEntityID,
        DATEDIFF(DAY, e.HireDate, GETDATE()) AS TotalWorkdays -- Total days from hire date to today
    FROM 
        HumanResources.Employee e
    WHERE 
        e.CurrentFlag = 1 -- Only consider active employees
)
SELECT 
    ew.BusinessEntityID,
    ew.JobTitle,
    ew.DepartmentName,
    ew.SalariedFlag,
    ew.DaysAbsent,
    tw.TotalWorkdays,
    (ew.DaysAbsent / tw.TotalWorkdays) * 100 AS AbsenteeismRate
FROM 
    EmployeeWorkdays ew
JOIN 
    TotalWorkdays tw ON ew.BusinessEntityID = tw.BusinessEntityID
ORDER BY 
    AbsenteeismRate DESC;





--Step 7.12:Find if there is a relationship of vacation hours and the revenue of each salesperson
WITH SalespersonData AS (
    SELECT 
        e.BusinessEntityID,
        e.JobTitle,
        e.VacationHours,
        sp.SalesYTD
    FROM 
        HumanResources.Employee e
    JOIN 
        Sales.SalesPerson sp ON e.BusinessEntityID = sp.BusinessEntityID
    WHERE 
        e.CurrentFlag = 1 -- Only consider active employees
)
SELECT 
    JobTitle,
    VacationHours,
    SalesYTD
FROM 
    SalespersonData
ORDER BY SalesYTD desc;


--What are the best successors for each job title?
WITH EmployeeData AS (
    SELECT 
        BusinessEntityID, 
        NationalIDNumber, 
        LoginID, 
        OrganizationNode, 
        OrganizationLevel, 
        JobTitle, 
        BirthDate, 
        MaritalStatus, 
        Gender, 
        HireDate, 
        SalariedFlag, 
        VacationHours, 
        SickLeaveHours, 
        CurrentFlag, 
        rowguid, 
        ModifiedDate,
        DATEDIFF(YEAR, HireDate, GETDATE()) AS Tenure,
        VacationHours + SickLeaveHours AS WorkHours
    FROM [AdventureWorks2019].[HumanResources].[Employee]
    WHERE CurrentFlag = 1
),
PotentialSuccessors AS (
    SELECT
        E1.JobTitle AS Role,
        E2.BusinessEntityID AS SuccessorID,
        E2.LoginID AS SuccessorLoginID,
        E2.Tenure AS SuccessorTenure,
        E2.WorkHours AS SuccessorWorkHours
    FROM
        EmployeeData E1
        JOIN EmployeeData E2
        ON E1.OrganizationNode = E2.OrganizationNode OR E1.JobTitle = E2.JobTitle
    WHERE
        E1.BusinessEntityID != E2.BusinessEntityID
)
SELECT
    Role,
    SuccessorID,
    SuccessorLoginID,
    SuccessorTenure,
    SuccessorWorkHours,
    (SuccessorTenure * 0.6 + SuccessorWorkHours * 0.4) AS Score
FROM (
    SELECT
        Role,
        SuccessorID,
        SuccessorLoginID,
        SuccessorTenure,
        SuccessorWorkHours,
        ROW_NUMBER() OVER (PARTITION BY Role ORDER BY (SuccessorTenure * 0.6 + SuccessorWorkHours * 0.4) DESC) AS rn
    FROM PotentialSuccessors
) RankedSuccessors
WHERE rn = 1;






























-- FUTURE WORK


--Common KPIs for HR Analysis
--		1)Turnover Rate:
			--Measures the percentage of employees leaving the organization over a specified period.
			--Formula: (Number of Separations / Average Number of Employees) * 100
--		2)Employee Retention Rate:
			--Indicates the percentage of employees who remain with the organization over a specified period.
			--Formula: (Number of Employees at End of Period / Number of Employees at Start of Period) * 100
--		3)Time to Fill:
			--Measures the average time taken to fill open positions.
			--Formula: Total Days to Fill Positions / Number of Positions Filled
--		4)Employee Engagement:
			--Assesses the level of employee commitment and satisfaction, often measured through surveys.
--		5)Absenteeism Rate:
		--Tracks the percentage of workdays missed due to unplanned absences.
		--Formula: (Number of Days Absent / Total Workdays) * 100
--		6)Training Effectiveness:
			--Evaluates the impact of training programs on employee performance and development.
--		7)Diversity and Inclusion Metrics:
			--Analyzes the composition of the workforce in terms of gender, age, ethnicity, etc.
--		8)Performance Metrics:
			--Measures individual and team performance through performance ratings, goal achievement, and productivity metrics.