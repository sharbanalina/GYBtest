-- розрахуйте відсоткове зростання доходу від місяця до місяця

SELECT 

--DATE TRUNC- дату обрізає до початку місяця, TO CHAR перетворює дату у вказаний формат!!
TO_CHAR(DATE_TRUNC('month', order_date_kyiv), 'YYYY-MM') AS month,

SUM(total_revenue) AS revenue,
    
-- LAG- бере попередній ряд
LAG(SUM(total_revenue)) OVER (ORDER BY DATE_TRUNC('month', order_date_kyiv)) AS previous_month_revenue,

-- % = (поточний -попередній)/попредній * 100
((SUM(total_revenue) - LAG(SUM(total_revenue)) OVER (ORDER BY DATE_TRUNC('month', order_date_kyiv))) 
/ LAG(SUM(total_revenue)) OVER (ORDER BY DATE_TRUNC('month', order_date_kyiv)) * 100) AS growth_percent

FROM {{ ref('fct_sales') }}

GROUP BY DATE_TRUNC('month', order_date_kyiv)
ORDER BY month
