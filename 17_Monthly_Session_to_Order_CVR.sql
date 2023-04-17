/*
RESULT::
Date		sessions	orders	Session_to_order_CVR
2012-03-31	1879		60		0.0319
2012-04-30	3734		99		0.0265
2012-05-31	3736		108		0.0289
2012-06-30	3963		140		0.0353
2012-07-31	4249		169		0.0398
2012-08-31	6097		228		0.0374
2012-09-30	6546		287		0.0438
2012-10-31	8183		371		0.0453
2012-11-26	12750		561		0.0440
*/


/* 
MY RESPONSE::
	Pretty simple here just a session to orders conversion rate.
    
*/

USE mavenfuzzyfactory;
SHOW TABLES;
 
	

SELECT * FROM website_sessions;

SELECT
	MAX(DATE(website_sessions.created_at)) AS Date,
    COUNT(DISTINCT website_sessions.website_session_id)  AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS Session_to_order_CV
    
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
GROUP BY YEAR(website_sessions.created_at), MONTH(website_sessions.created_at);
    
    
