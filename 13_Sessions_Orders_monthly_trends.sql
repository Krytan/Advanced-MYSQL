
/*
RESULT::

Date		Sessions	Orders	conv_rate
2012-03-19	1860		60		0.0323
2012-04-01	3574		92		0.0257
2012-05-01	3410		97		0.0284
2012-06-01	3578		121		0.0338
2012-07-01	3811		145		0.0380
2012-08-01	4877		184		0.0377
2012-09-01	4491		188		0.0419
2012-10-01	5534		234		0.0423
2012-11-01	8889		373		0.0420
*/


/* 
MY RESPONSE::
	the CEO of the company asked me to pull monthly trends for gsearch sessions and orders,
	to help her showcase their growth there.
    Date the date of the last collected data from the last day of the month.
    Sessions how many sessions we made that month.
    Orders how many orders we made that month.
    conv_rate order to session conversion rates.
    
*/
USE mavenfuzzyfactory;
SHOW TABLES;

SELECT
	MAX(DATE(website_sessions.created_at)) AS Date,
	COUNT(DISTINCT website_sessions.website_session_id) AS Sessions,
    COUNT(DISTINCT order_id) AS Orders,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
AND utm_source = 'gsearch'
GROUP BY YEAR(website_sessions.created_at), MONTH(website_sessions.created_at);
    
    
