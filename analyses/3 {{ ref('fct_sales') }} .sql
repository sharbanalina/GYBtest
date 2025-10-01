-- визначте агентів, які надають знижки вище загального середнього рівня

--теж під питанням замовлення де в стричці декілька агентів..
--!теж не включила з розрахунок

--ккількість продажів по агенту та його середня знижка
WITH agent_discount AS (
SELECT 
sales_agent_name,
COUNT(*) AS total_sales,
AVG(discount_amount) AS avg_discount
FROM {{ ref('fct_sales') }}
WHERE sales_agent_name != 'N/A' AND sales_agent_name NOT LIKE '%,%'
GROUP BY sales_agent_name
)

--середня знижка по компанії
SELECT 
sales_agent_name,
total_sales,
avg_discount,
(SELECT AVG(discount_amount) FROM {{ ref('fct_sales') }}) AS company_avg

FROM agent_discount

--порівняння середню знижку агента з середньою знижкою компанії
WHERE avg_discount > (SELECT AVG(discount_amount) FROM {{ ref('fct_sales') }})
ORDER BY avg_discount DESC
