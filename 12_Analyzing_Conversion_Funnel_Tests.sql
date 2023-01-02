
-- Analyze of what % of sessions on billing, billing-2 end up placing an order.
/*
    OUTPUT:

pageview_url	sessions	total_orders	billing_to_order_rate
/billing	    657	        300	            0.4566
/billing-2	    654	        410	            0.6269

*/

-- Quick note here I was thinking about the last assigment so some things has no use for example the cases.
-- STEP 1 find out when billing-2 was first created for a fair comparasion.
-- STEP 2 take a look on billing, billing-2 sessions with orders.
-- STEP 3 use previous step to create the final output showing total session, orders and billing to order rates.

USE mavenfuzzyfactory;

SHOW TABLES;

SELECT * FROM website_sessions;
SELECT * FROM website_pageviews;
SELECT * FROM orders;

SELECT 
	min(website_session_id) AS min_session_id,
	min(created_at) AS min_created_at,
    pageview_url

FROM 
	website_pageviews 
WHERE 
	pageview_url = '/billing-2';

SELECT
	pageview_url,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT order_id) / COUNT(DISTINCT website_session_id) AS billing_to_order_rate
FROM(
SELECT
	website_pageviews.website_session_id,
    orders.order_id,
    website_pageviews.created_at,
    pageview_url,
    CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing2_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page
    
FROM 
	website_pageviews
LEFT JOIN orders
ON	orders.website_session_id = website_pageviews.website_session_id
WHERE
	website_pageviews.created_at >= '2012-09-10'
    AND website_pageviews.created_at < '2012-11-10'
    AND pageview_url IN ('/billing','/billing-2')
    ) AS billing_session_w_orders
    group by pageview_url;