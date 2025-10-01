{{ config(materialized='table') }} 

SELECT

"Reference ID" AS reference_id,
COALESCE(MAX("Product Name"), 'N/A') AS product_name, 

--STRING_AGG для об'єднання всіх агентів одного id замовлення через кому!

COALESCE(STRING_AGG(NULLIF("Sales Agent Name", ''), ', '),'N/A') AS sales_agent_name,
COALESCE(MAX("Country"), 'N/A') AS country, 
COALESCE(STRING_AGG(NULLIF("Campaign Name", ''), ', '),'N/A') AS campaign_name, 
COALESCE(STRING_AGG(NULLIF("Source", ''), ', '),'N/A') AS source,

COALESCE(MAX("Total Amount ($)"),0) + COALESCE(MAX("Total Rebill Amount"),0) - COALESCE(MAX("Returned Amount ($)"),0) AS total_revenue, 
COALESCE(MAX("Total Rebill Amount"),0) AS rebill_amount, 
COALESCE(MAX("Number Of Rebills"),0) AS number_rebills,
COALESCE(MAX("Discount Amount ($)"),0) AS discount_amount, 
COALESCE(MAX("Returned Amount ($)"),0) AS returned_amount,

MAX("Return Date Kyiv") AS return_date_kyiv,
CAST(MAX("Return Date Kyiv") AT TIME ZONE 'Europe/Kyiv' AT TIME ZONE 'UTC' AS TIMESTAMP) AS return_date_utc,
CAST(MAX("Return Date Kyiv") AT TIME ZONE 'Europe/Kyiv' AT TIME ZONE 'America/New_York' AS TIMESTAMP) AS return_date_new_york,

CASE WHEN MAX("Return Date Kyiv") IS NOT NULL THEN (MAX("Return Date Kyiv") - MAX("Order Date Kyiv")) ELSE NULL END AS days_btw_returnorder, 

MAX("Order Date Kyiv") AS order_date_kyiv,
CAST(MAX("Order Date Kyiv") AT TIME ZONE 'Europe/Kyiv' AT TIME ZONE 'UTC' AS TIMESTAMP) AS order_date_utc,
CAST(MAX("Order Date Kyiv") AT TIME ZONE 'Europe/Kyiv' AT TIME ZONE 'America/New_York' AS TIMESTAMP) AS order_date_new_york

FROM {{ ref('sales_data') }}

GROUP BY "Reference ID"