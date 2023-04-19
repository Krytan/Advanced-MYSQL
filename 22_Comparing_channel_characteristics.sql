
/*

RESULT::

utm_source		sessions	mobile_sessions		pct_sessions	
'gsearch',		'20073',	'4921',				'0.2452'
'bsearch',		'6522',		'562',				'0.0862'
*/

USE mavenfuzzyfactory;

SELECT * FROM website_sessions;
SHOW TABLES;


SELECT
	utm_source,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS pct_sessions
FROM website_sessions
WHERE website_sessions.created_at BETWEEN '2012-8-22' AND '2012-11-30' -- arbitrary
	AND	utm_source IN ('bsearch','gsearch')
    AND utm_campaign = 'nonbrand'
GROUP BY 1
ORDER BY sessions DESC;



