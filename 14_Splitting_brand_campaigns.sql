
/*
RESULT::

Date		Nonbrand_Sessions	Nonbrand_Orders	Nonbrand_CR	Brand_Sessions	Brand_Orders	Brand_CR
2012-03-31	1852				60				0.0324		8				0				0.0000
2012-04-30	3509				86				0.0245		65				6				0.0923
2012-05-31	3295				91				0.0276		115				6				0.0522
2012-06-30	3439				114				0.0331		139				7				0.0504
2012-07-31	3660				136				0.0372		151				9				0.0596
2012-08-31	4673				174				0.0372		204				10				0.0490
2012-09-30	4227				172				0.0407		264				16				0.0606
2012-10-31	5197				219				0.0421		337				15				0.0445
2012-11-26	8506				356				0.0419		383				17				0.0444
*/


/* 
MY RESPONSE::
	the CEO of the company asked me to pull monthly trends for gsearch sessions and orders same as before but splitting out nonbrand and brand campaigns separately,
	she is wondering if brand is picking up at all.
    
*/
USE mavenfuzzyfactory;
SHOW TABLES;

SELECT * FROM orders;

SELECT
	MAX(DATE(website_sessions.created_at)) AS Date,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) AS Nonbrand_Sessions,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END) AS Nonbrand_Orders,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) AS Nonbrand_CR,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) AS Brand_Sessions,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN orders.order_id ELSE NULL END) AS Brand_Orders,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) AS Brand_CR
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
AND utm_source = 'gsearch'
GROUP BY YEAR(website_sessions.created_at), MONTH(website_sessions.created_at);
    
    
