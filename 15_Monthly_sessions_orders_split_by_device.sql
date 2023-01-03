
/*
RESULT::

Date		Mobile_Sessions	Mobile_Orders	Mobile_CR	Mobile_Sessions	Mobile_Orders	Mobile_CR
2012-03-31	724				10				0.0138		1128			50				0.0443
2012-04-30	1370			11				0.0080		2139			75				0.0351
2012-05-31	1019			8				0.0079		2276			83				0.0365
2012-06-30	766				8				0.0104		2673			106				0.0397
2012-07-31	886				14				0.0158		2774			122				0.0440
2012-08-31	1158			9				0.0078		3515			165				0.0469
2012-09-30	1056			17				0.0161		3171			155				0.0489
2012-10-31	1263			18				0.0143		3934			201				0.0511
2012-11-26	2049			33				0.0161		6457			323				0.0500
*/


/* 
MY RESPONSE::
	Here is an analysis of Gsearch nonbrand monthly sessions and orders split by device 
    
*/
USE mavenfuzzyfactory;
SHOW TABLES;

SELECT device_type FROM website_sessions
	GROUP BY 1;

SELECT
	MAX(DATE(website_sessions.created_at)) AS Date,
	COUNT(DISTINCT CASE WHEN device_type  = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS Mobile_Sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN orders.order_id ELSE NULL END) AS Mobile_Orders,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS Mobile_CR,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS Desktop_Sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN orders.order_id ELSE NULL END) AS Desktop_Orders,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS Desktop_CR
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY YEAR(website_sessions.created_at), MONTH(website_sessions.created_at);
    
    
