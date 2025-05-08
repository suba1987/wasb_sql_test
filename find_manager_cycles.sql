USE memory.default

WITH RECURSIVE employee_manager (
	employee_id
	,manager_id
	,loop
	)
AS (
    -- base query, selects all employees
	SELECT employee_id
		,manager_id
		,ARRAY [employee_id] AS loop
	FROM EMPLOYEE
	
	UNION ALL
	
    -- recursive query, continuously joins to the base query
	SELECT em.employee_id
		,e.manager_id
		,em.loop || e.employee_id
	FROM employee_manager em
	INNER JOIN EMPLOYEE e ON em.manager_id = e.employee_id
	WHERE NOT CONTAINS (
			em.loop
			,e.employee_id
			) -- breaks the recursion, makes sure that the employee is not already in the loop
	)
-- final result, selects only those employees who are a part of the cycle
SELECT employee_id
	,loop
FROM employee_manager
WHERE manager_id = employee_id;
