/*
RESULT::

landing_page	total_sessions	total_orders	session_to_orders_CVR
/home			2261			72				0.0318
/lander-1		2316			94				0.0406

*/


/* 
MY RESPONSE::
	Pretty simple here just a session to orders conversion rate.
    
*/
USE mavenfuzzyfactory;
SHOW TABLES;
 
	

SELECT * FROM website_sessions;
-- Here I use this query to find the first time lander-1 was up and running
SELECT 
	MIN(created_at) AS First_appear_time,
	pageview_url

FROM 
	website_pageviews

WHERE 
	created_at < '2012-11-27'
    AND pageview_url = '/lander-1';

CREATE TEMPORARY TABLE first_test_pageviews
SELECT
	website_pageviews.website_session_id AS sessions,
    MIN(website_pageviews.website_pageview_id) AS Min_pageview_id
    
FROM website_pageviews
INNER JOIN website_sessions
ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-6-19' AND '2012-7-28'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY website_pageviews.website_session_id;

CREATE TEMPORARY TABLE nonbrand_test_sessions_w_landing_pages
SELECT 
	first_test_pageviews.sessions,
    website_pageviews.pageview_url AS landing_page
FROM
	first_test_pageviews
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = first_test_pageviews.Min_pageview_id
WHERE website_pageviews.pageview_url IN ('/home','/lander-1');

SELECT * FROM nonbrand_test_sessions_w_landing_pages;

CREATE TEMPORARY TABLE nonbrand_test_sessions_w_orders
SELECT
	nonbrand_test_sessions_w_landing_pages.sessions,
	nonbrand_test_sessions_w_landing_pages.landing_page,
	orders.order_id AS order_id
FROM 
	nonbrand_test_sessions_w_landing_pages
    LEFT JOIN orders
    ON orders.website_session_id = nonbrand_test_sessions_w_landing_pages.sessions;
    
SELECT 
	landing_page,
    COUNT(DISTINCT sessions) AS total_sessions,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT sessions) AS session_to_orders_CVR
FROM nonbrand_test_sessions_w_orders
GROUP BY 1;
    
    
    


    
    
