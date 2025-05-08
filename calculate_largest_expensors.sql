USE memory.default

SELECT 
    e.employee_id
    ,CONCAT (e.first_name,' ',e.last_name) AS employee_name
	,e.manager_id
	,CONCAT (m.first_name,' ',m.last_name) AS manager_name
	,SUM(ex.unit_price * ex.quantity) AS total_expensed_amount
FROM EXPENSE ex
INNER JOIN EMPLOYEE e ON ex.employee_id = e.employee_id
LEFT JOIN EMPLOYEE m ON m.employee_id = e.manager_id
GROUP BY e.employee_id
	,e.first_name
	,e.last_name
	,e.manager_id
	,m.first_name
	,m.last_name
HAVING SUM(ex.unit_price * ex.quantity) > 1000
ORDER BY total_expensed_amount DESC;
