
/*
RESULT::
Date		Gsearch_Sessions	Bsearch_Sessions	Direct_type_in_Sessions	Organic_Sessions
2012-03-31	1860				2					9						8
2012-04-30	3574				11					71						78
2012-05-31	3410				25					151						150
2012-06-30	3578				25					170						190
2012-07-31	3811				44					187						207
2012-08-31	4877				705					250						265
2012-09-30	4491				1439				285						331
2012-10-31	5534				1781				440						428
2012-11-26	8889				2840				485						536
*/


/* 
MY RESPONSE::
	Here is the monthly trends for Gsearch and all other channels.
    
*/
USE mavenfuzzyfactory;
SHOW TABLES;
 
	

SELECT * FROM website_sessions;

SELECT DISTINCT 
	utm_source,
    utm_campaign,
    http_referer
FROM
	website_sessions
WHERE 
	website_sessions.created_at < '2012-11-27';

SELECT
	MAX(DATE(website_sessions.created_at)) AS Date,
	COUNT(DISTINCT CASE WHEN utm_source  = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS Gsearch_Sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS Bsearch_Sessions,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) AS Direct_type_in_Sessions,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) AS Organic_Sessions
    
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
GROUP BY YEAR(website_sessions.created_at), MONTH(website_sessions.created_at);
    
    
