
/*

RESULT::

device_type		utm_source		sessions	orders		sessions_to_orders_cvr		
'desktop',		'bsearch',		'1162',		'44',		'0.0379'
'desktop',		'gsearch',		'3011',		'136',		'0.0452'
'mobile',		'bsearch',		'130',		'1',		'0.0077'
'mobile',		'gsearch',		'1015',		'13',		'0.0128'

*/




USE mavenfuzzyfactory;

SELECT * FROM website_sessions;
SHOW TABLES;


SELECT
	website_sessions.device_type,
	website_sessions.utm_source,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions, -- sessions
    COUNT(DISTINCT orders.order_id) AS orders,-- orders
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS sessions_to_orders_cvr -- conversion rate
FROM website_sessions
LEFT JOIN orders
	ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-08-22' AND '2012-09-19'
	AND	website_sessions.utm_source IN ('bsearch','gsearch')
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 1,2
-- ORDER BY sessions DESC;



