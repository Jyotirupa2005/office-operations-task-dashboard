-- Office Operations & Task Management Dashboard
-- Business queries for portfolio analysis

-- 1. Total number of tasks
SELECT COUNT(*) AS total_tasks
FROM office_operations_data;

-- 2. Tasks by status
SELECT Status, COUNT(*) AS task_count
FROM office_operations_data
GROUP BY Status
ORDER BY task_count DESC;

-- 3. Department-wise workload
SELECT Department, COUNT(*) AS total_tasks
FROM office_operations_data
GROUP BY Department
ORDER BY total_tasks DESC;

-- 4. Task type workload
SELECT Task_Type, COUNT(*) AS total_tasks
FROM office_operations_data
GROUP BY Task_Type
ORDER BY total_tasks DESC;

-- 5. Average delay by task type
SELECT Task_Type, ROUND(AVG(Delay_Days), 2) AS average_delay_days
FROM office_operations_data
GROUP BY Task_Type
ORDER BY average_delay_days DESC;

-- 6. Pending and in-progress tasks
SELECT Task_ID, Task_Type, Assigned_To, Priority, Due_Date, Status
FROM office_operations_data
WHERE Status IN ('Pending', 'In Progress')
ORDER BY Due_Date;

-- 7. On-time completion rate
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN Delay_Days <= 0 THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END), 0),
        2
    ) AS on_time_completion_percent
FROM office_operations_data;

-- 8. Communication channel usage
SELECT Communication_Channel, COUNT(*) AS activity_count
FROM office_operations_data
GROUP BY Communication_Channel
ORDER BY activity_count DESC;

-- 9. Issues / blockers requiring follow-up
SELECT Issue_or_Blocker, COUNT(*) AS issue_count
FROM office_operations_data
WHERE Issue_or_Blocker IS NOT NULL
  AND Issue_or_Blocker <> ''
GROUP BY Issue_or_Blocker
ORDER BY issue_count DESC;

-- 10. Monthly activity
SELECT
    EXTRACT(YEAR FROM Request_Date) AS request_year,
    EXTRACT(MONTH FROM Request_Date) AS request_month,
    COUNT(*) AS total_tasks
FROM office_operations_data
GROUP BY EXTRACT(YEAR FROM Request_Date), EXTRACT(MONTH FROM Request_Date)
ORDER BY request_year, request_month;
