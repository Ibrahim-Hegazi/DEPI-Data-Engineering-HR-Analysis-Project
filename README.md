# **HR Analysis Dashboard**
This project is my first HR Analysis dashboard, built with Microsoft Transact-SQL to uncover insights from employee data. It involved analyzing employee demographics and integrating various HR metrics into a cohesive, data-driven view.

## Project Highlights
Skills Applied: Data cleaning, complex SQL queries, and dashboard development.
Main Focus: Accurate data integration, creating actionable insights, and exploring key HR metrics.
Data Source: AdventureWorks Database ( [https://lnkd.in/daMepSV6](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak))




# HR Analysis Project  
A comprehensive workforce demographics analysis project focused on extracting valuable insights about employee composition, distribution, and trends to inform HR strategies and decision-making.

## Table of Contents
- [Contributors](#contributors)
- [Brief](#brief)
- [Project_Goals](#project_goals)
- [DataSet](#dataset)
- [How_It_Works](#how_it_works)
- [Tech_Stack](#tech_stack)
- [Tools](#tools)
- [Key_Achievements](#key_achievements)
- [Key_Findings](#key_findings)
- [Key_Recommendations](#key_recommendations)
- [Acknowledgments](#acknowledgments)
- [Future_Work](#future_work)
- [Sample_Work](#sample_work)

## Contributors
Ibrahim Mohamed Ibrahim Alsayed Hegazi (Data Analysis & SQL Implementation)

## Brief
This project conducts an in-depth analysis of workforce demographics across multiple dimensions including age, gender, marital status, tenure, and job roles. The analysis provides actionable insights for HR strategy development, talent management, and organizational planning.

## Project_Goals
1. Analyze age distribution to understand generational mix
2. Examine gender ratios and hiring trends
3. Assess marital status distribution
4. Evaluate tenure patterns
5. Map employee distribution across departments and job roles
6. Identify key workforce demographics insights

## DataSet
The analysis uses the AdventureWorks2019 database with focus on:
- HumanResources.Employee
- HumanResources.EmployeeDepartmentHistory
- HumanResources.Department
- Sales.SalesTerritory

## How_It_Works
1. **Data Exploration**: Initial examination of HR tables to identify relevant fields
2. **Age Analysis**: 
   - Calculates min/max ages
   - Groups employees into age quartiles
   - Analyzes experience by age group
3. **Gender Analysis**:
   - Calculates male/female ratios
   - Tracks hiring trends by gender over time
4. **Marital Status Analysis**:
   - Breaks down married vs single employees
   - Cross-analyzes with gender
5. **Tenure Analysis**:
   - Calculates years of service
   - Groups employees by tenure ranges
6. **Job Role Analysis**:
   - Maps employee distribution across departments
   - Analyzes organizational hierarchy levels

## Tech_Stack
- SQL: Data analysis and querying
- T-SQL: Advanced analytical functions

## Tools
- SQL Server Management Studio
- AdventureWorks2019 database

## Key_Achievements
- Developed comprehensive age distribution analysis
- Tracked gender hiring trends over 8 years
- Mapped marital status distribution by gender
- Calculated average tenure by age group
- Analyzed organizational hierarchy distribution

## Key_Findings
### Age Distribution
| AgeGroup | StartAge | EndAge | Employees |
|----------|----------|--------|-----------|
| Q1       | 33       | 43     | 127       |
| Q2       | 44       | 53     | 114       |
| Q3       | 54       | 63     | 29        |
| Q4       | 64       | 73     | 20        |

### Gender Distribution
- Female employees: 84 (28.97%)
- Male employees: 206 (71.03%)

### Marital Status by Gender
- Married Females: 49 (16.9%)
- Married Males: 97 (33.45%)
- Single Females: 35 (12.07%)
- Single Males: 109 (37.59%)

### Tenure by Age Group
| AgeGroup | Avg Experience |
|----------|----------------|
| Q1       | 15 years       |
| Q2       | 14 years       |
| Q3       | 13 years       |
| Q4       | 15 years       |

### Organizational Levels
| Level      | Employees |
|------------|-----------|
| Level 1    | 6         |
| Level 2    | 27        |
| Level 3    | 58        |
| Level 4    | 190       |
| Executives | 9         |

## Key_Recommendations
1. Implement targeted recruitment for younger employees to balance age distribution
2. Develop gender diversity initiatives based on hiring trend analysis
3. Create marital status-specific benefits programs
4. Plan succession strategies considering tenure and age distribution
5. Optimize organizational structure based on hierarchy analysis

## Acknowledgments
Special thanks to the AdventureWorks database team for providing a comprehensive HR dataset that enabled this analysis.

## Future_Work
1. Implement turnover rate calculations
2. Develop employee retention rate tracking
3. Create time-to-fill metrics for open positions
4. Build employee engagement measurement tools
5. Incorporate absenteeism rate analysis

## Sample_Work
```sql
-- Sample Query: Age Distribution Analysis
WITH MinMaxAges AS (
    SELECT 
        MIN(YEAR(GETDATE()) - YEAR(e.BirthDate)) AS MinAge,
        MAX(YEAR(GETDATE()) - YEAR(e.BirthDate)) AS MaxAge
    FROM HumanResources.Employee e
)
SELECT 
    q.AgeGroup,
    q.StartAge,
    q.EndAge,
    COUNT(a.Age) AS NumberOfEmployees
FROM QuarterRanges q
LEFT JOIN AgeGroups a ON q.AgeGroup = a.AgeGroup
GROUP BY q.AgeGroup, q.StartAge, q.EndAge
ORDER BY q.AgeGroup;
