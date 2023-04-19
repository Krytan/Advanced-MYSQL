
/*
week_start		bsearch			gsearch_sessions
'2012-08-22',	'197',			'590'
'2012-08-26',	'343',			'1056'
'2012-09-02',	'290',			'925'
'2012-09-09',	'329',			'951'
'2012-09-16',	'365',			'1151'
'2012-09-23',	'321',			'1050'
'2012-09-30',	'316',			'999'
'2012-10-07',	'330',			'1002'
'2012-10-14',	'420',			'1257'
'2012-10-21',	'431',			'1302'
'2012-10-28',	'384',			'1211'
'2012-11-04',	'429',			'1350'
'2012-11-11',	'438',			'1246'
'2012-11-18',	'1093',			'3508'
'2012-11-25',	'774',			'2286'

*/

USE mavenfuzzyfactory;

SELECT * FROM orders;
SHOW TABLES;

-- All this query is arbitrary is just for learning.
SELECT
	utm_content,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conversion_rate
FROM website_sessions
LEFT JOIN orders
	ON orders.website_session_id = website_sessions.website_session_id


WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- arbitrary
GROUP BY 1
ORDER BY sessions DESC;


-- Here is the query for the result

SELECT 
	MIN(DATE(created_at)) AS week_start,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id END) AS bsearch_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id END) AS gsearch_sessions
FROM website_sessions
WHERE created_at > '2012-08-22'
    AND created_at < '2012-11-29'
    AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at), WEEK(created_at)



