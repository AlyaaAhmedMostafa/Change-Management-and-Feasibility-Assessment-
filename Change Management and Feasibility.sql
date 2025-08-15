SELECT *
FROM [Healthcare].[dbo].[management_records]

--Distribution of Change Projects by Readiness Level
SELECT ReadinessLevel, COUNT(*) AS Count
FROM [Healthcare].[dbo].[management_records]
GROUP BY ReadinessLevel
ORDER BY Count DESC;

--Projects by Status (In Progress, Approved, Deferred, etc.)
SELECT Status, COUNT(*) AS Count
FROM [Healthcare].[dbo].[management_records]
GROUP BY Status;

--Counts by Change Type and Status
SELECT ChangeType, Status, COUNT(*) AS Count 
FROM [Healthcare].[dbo].[management_records]
GROUP BY ChangeType, Status
ORDER BY ChangeType, Status;

--Change Distribution by Feasibility Assessment
SELECT FeasibilityAssessment, COUNT(*) AS Count
FROM [Healthcare].[dbo].[management_records]
GROUP BY FeasibilityAssessment;

--Feasibility by Department
SELECT Department, COUNT(*) AS Total, 
       SUM(CASE WHEN FeasibilityAssessment = 'Low Feasibility' THEN 1 ELSE 0 END) AS LowFeas
FROM [Healthcare].[dbo].[management_records]
GROUP BY Department;

--Top Risk Factors by Frequency
SELECT RiskFactor, COUNT(*) AS Occurrences
FROM [Healthcare].[dbo].[management_records]
GROUP BY RiskFactor
ORDER BY Occurrences DESC;

--Projects with Highest Estimated Cost (Top 10)
SELECT TOP 10 ChangeID, Department, EstimatedCostUSD
FROM [Healthcare].[dbo].[management_records]
ORDER BY EstimatedCostUSD DESC;

--Average and Total Cost by Feasibility Level
SELECT FeasibilityAssessment, AVG(EstimatedCostUSD) AS AvgCost, SUM(EstimatedCostUSD) AS TotalCost
FROM [Healthcare].[dbo].[management_records]
GROUP BY FeasibilityAssessment;

--Cost Burden by Owner
SELECT Owner, SUM(EstimatedCostUSD) AS Total_Cost
FROM [Healthcare].[dbo].[management_records]
GROUP BY Owner
ORDER BY Total_Cost DESC;

--Distribution by Risk Level
SELECT RiskLevel, COUNT(*) AS Count
FROM [Healthcare].[dbo].[management_records]
GROUP BY RiskLevel;

--Potential Benefit Types by Change Type
SELECT ChangeType, PotentialBenefit, COUNT(*) AS Count
FROM [Healthcare].[dbo].[management_records]
GROUP BY ChangeType, PotentialBenefit
ORDER BY  COUNT DESC, ChangeType;

--Impact Score Analysis (Avg, Max, Min)
SELECT 
  AVG([ImpactScore(1-10)]) AS AvgScore,
  MAX([ImpactScore(1-10)]) AS MaxScore,
  MIN([ImpactScore(1-10)]) AS MinScore
FROM [Healthcare].[dbo].[management_records];

--Top 5 Highest-Impact In-Progress Changes
SELECT TOP 5 ChangeID, Department, Status, [ImpactScore(1-10)]
FROM [Healthcare].[dbo].[management_records]
WHERE Status = 'In Progress'
ORDER BY [ImpactScore(1-10)] DESC;

--Upcoming Implementations (Next 90 Days)
SELECT ChangeID, Department, TargetImplementationDate
FROM [Healthcare].[dbo].[management_records]
WHERE TargetImplementationDate BETWEEN GETDATE() AND DATEADD(day,90,GETDATE())
ORDER BY TargetImplementationDate;

--Changes Past Due That Are Not Completed
SELECT ChangeID, Department, Status, TargetImplementationDate
FROM [Healthcare].[dbo].[management_records]
WHERE TargetImplementationDate < GETDATE()
      AND Status NOT IN ('Completed', 'Deferred')
ORDER BY TargetImplementationDate;

--Average Readiness By Status
SELECT Status, AVG(CASE 
                   WHEN ReadinessLevel='Fully Ready' THEN 3
                   WHEN ReadinessLevel='Partially Ready' THEN 2
                   WHEN ReadinessLevel='Not Ready' THEN 1
                   ELSE 0 END) AS AvgReadiness
FROM [Healthcare].[dbo].[management_records]
GROUP BY Status;

--Change Count by Owner
SELECT Owner, COUNT(*) AS Owned_Changes
FROM [Healthcare].[dbo].[management_records]
GROUP BY Owner
ORDER BY Owned_Changes DESC;

--Projects with both High Risk and Low Feasibility
SELECT *
FROM [Healthcare].[dbo].[management_records]
WHERE RiskLevel in ('Critical','High')
  AND FeasibilityAssessment = 'Low Feasibility';

--Ratio of Approved vs Deferred
SELECT 
    SUM(CASE WHEN Status = 'Approved' THEN 1 ELSE 0 END) AS Approved,
    SUM(CASE WHEN Status = 'Deferred' THEN 1 ELSE 0 END) AS Deferred,
    CAST(SUM(CASE WHEN Status = 'Approved' THEN 1 ELSE 0 END) AS float)/
    NULLIF(SUM(CASE WHEN Status = 'Deferred' THEN 1 ELSE 0 END),0) AS ApproveToDeferRatio
FROM [Healthcare].[dbo].[management_records];

--Most Common Reasons (Risk Factors) for Deferred or Not Ready Changes
SELECT RiskFactor, COUNT(*) AS Deferred_Count
FROM [Healthcare].[dbo].[management_records]
WHERE Status = 'Deferred' OR ReadinessLevel = 'Not Ready'
GROUP BY RiskFactor
ORDER BY Deferred_Count DESC;


