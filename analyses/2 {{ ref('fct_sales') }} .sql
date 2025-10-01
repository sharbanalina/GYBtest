-- 2. Для кожного агента визначте його середній дохід, к-ть продажів, а також середнє значення запропонованих знижок на кожну покупку. 
--Посортуйте по загальній сумі дохідності, та розставте рангові місця: 1, 2, 3, …, n 


--під питанням ще буде, бо є замовлення в яких вказано декілька агентів, як це включити? 
--!поки прибрала з розрахунку

SELECT 

--rank — місце в рейтингу по доходу
RANK() OVER (ORDER BY SUM(total_revenue) DESC) AS rank,

--agent_name
sales_agent_name AS agent_name,

--заг кількість продажів
COUNT(*) AS total_sales,

--загальний та середній дохід
SUM(total_revenue) AS total_revenue,
AVG(total_revenue) AS avg_revenue,

--середня знижка
AVG(discount_amount) AS avg_discount

FROM {{ ref('fct_sales') }}

WHERE sales_agent_name != 'N/A' AND sales_agent_name NOT LIKE '%,%'
GROUP BY sales_agent_name
ORDER BY rank
