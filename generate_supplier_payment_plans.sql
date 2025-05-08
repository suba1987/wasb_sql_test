USE memory.default

------------------------------
/* 
This SQL file displays payment plans for each of the suppliers. It consists of three 
CTEs. 
supplier_invoice finds the latest due date per supplier and calculates the sum of all 
invoices for each of them. 
monthly_payment_amount calculates number of monthly payments remaining based off the 
latest due date. It also calculates monthly payment amount and the last month amount 
(monthly payment plus the remainder).
balance generates a sequence (extra rows) for each of the months we have until due 
date to cover our expenses. It also displays balance left for each month. 

The query was formatted using https://poorsql.com/ formatter. 
*/
------------------------------

WITH supplier_invoice
AS (
	SELECT s.supplier_id
		,s.name AS supplier_name
		,SUM(i.invoice_amount) AS total_invoice_amount
		,MAX(i.due_date) latest_due_date
	FROM INVOICE i
	LEFT JOIN SUPPLIER s ON i.supplier_id = s.supplier_id
	GROUP BY s.supplier_id
		,s.name
	),
monthly_payment_amount
AS (
	SELECT supplier_id
		,supplier_name
		,total_invoice_amount
		,latest_due_date
		,DATE_DIFF('month', CURRENT_DATE, latest_due_date) + 1 AS number_of_payments -- added +1 because we want to start payments at the end of the current month, this creates that extra month for payment
		,FLOOR(total_invoice_amount / (DATE_DIFF('month', CURRENT_DATE, latest_due_date) + 1)) AS monthly_amount -- total amount divided by number of months to pay rounded to nearest integer
        ,total_invoice_amount % (DATE_DIFF('month', CURRENT_DATE, latest_due_date) + 1) AS last_month_remainder -- remainder from the monthly amount, to be added for the last month of payment
	FROM supplier_invoice
	),
balance
AS (
	SELECT supplier_id
		,supplier_name
		,CASE 
			WHEN seq < number_of_payments - 1
				THEN monthly_amount
			ELSE last_month_remainder + monthly_amount
			END AS payment_amount -- these are monthly payments which are all the same except last one that includes the remainder
		,seq
		,total_invoice_amount - sum(CASE 
				WHEN seq < number_of_payments - 1
					THEN monthly_amount
				ELSE last_month_remainder + monthly_amount
				END) OVER (
			PARTITION BY supplier_id ORDER BY seq
			) AS balance_outstanding -- calculates the balance remaining
		,
		LAST_DAY_OF_MONTH(date_add('month', seq, CURRENT_DATE)) AS payment_date
	FROM monthly_payment_amount
	CROSS JOIN UNNEST(sequence(0, number_of_payments - 1)) AS t(seq) -- generating a sequence of months for each supplier based on the latest due date
	)
SELECT supplier_id
	,supplier_name
	,payment_amount
	,balance_outstanding
	,payment_date
FROM balance
ORDER BY supplier_id
	,payment_date;
