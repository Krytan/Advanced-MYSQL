/*
RESULT::

billing_version		sessions	total_orders	revenue_per_billing_page	billing_to_order_rate
'/billing',			'657',		'300',			'22.826484',				'0.4566'
'/billing-2',		'654',		'410',			'31.339297',				'0.6269'


billing_sessions_past_month
1193

*/


/* 
MY RESPONSE::
	Pretty simple here just a session to orders conversion rate.
    
*/
USE mavenfuzzyfactory;

SHOW TABLES;

SELECT * FROM website_sessions;
SELECT pageview_url FROM website_pageviews GROUP BY 1;
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
	billing_version,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(price_usd)/COUNT(DISTINCT website_session_id) AS revenue_per_billing_page,
    COUNT(DISTINCT order_id) / COUNT(DISTINCT website_session_id) AS billing_to_order_rate
FROM(
SELECT
	website_pageviews.website_session_id,
    orders.order_id,
    website_pageviews.created_at,
    website_pageviews.pageview_url AS billing_version,
    orders.price_usd,
    CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing2_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page
    
FROM 
	website_pageviews
LEFT JOIN orders
ON	orders.website_session_id = website_pageviews.website_session_id
WHERE
	website_pageviews.created_at >= '2012-09-10'
    AND website_pageviews.created_at < '2012-11-10'
    AND website_pageviews.pageview_url IN ('/billing','/billing-2')
    ) AS billing_session_w_orders
    group by 1;

SELECT
	COUNT(website_session_id) AS billing_sessions_past_month
FROM website_pageviews
WHERE website_pageviews.pageview_url IN ('/billing','/billing-2')
	AND created_at BETWEEN '2012-10-27' AND '2012-11-27' -- past month