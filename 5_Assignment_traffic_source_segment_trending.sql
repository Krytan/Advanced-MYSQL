/*

OUTPUT:

		"week_start_date" : "2012-04-15",
		"desktop_sessions" : 383,
		"mobile_sessions" : 238
	,
		"week_start_date" : "2012-04-22",
		"desktop_sessions" : 360,
		"mobile_sessions" : 234
	,
		"week_start_date" : "2012-04-29",
		"desktop_sessions" : 425,
		"mobile_sessions" : 256
	,
		"week_start_date" : "2012-05-06",
		"desktop_sessions" : 430,
		"mobile_sessions" : 282
	,
		"week_start_date" : "2012-05-13",
		"desktop_sessions" : 403,
		"mobile_sessions" : 214
	,
		"week_start_date" : "2012-05-20",
		"desktop_sessions" : 661,
		"mobile_sessions" : 190
	,
		"week_start_date" : "2012-05-27",
		"desktop_sessions" : 585,
		"mobile_sessions" : 183
	,
		"week_start_date" : "2012-06-03",
		"desktop_sessions" : 582,
		"mobile_sessions" : 157

        The company fallowed my previous recomendention to bid down on mobile and bid up on desktop 
        since desktop gives more orders and CVR.
        
        On this currently analysys we can see that Desktop session has significantly encreased in sessions
        and where mobile dropped by around 40% which is good because mobile is not giving much profit.

*/

USE mavenfuzzyfactory;
-- COUNT(DISTINCT CASE WHEN items_purchased = 1 THEN order_id ELSE NULL END) AS orders_w_1_item,
-- COUNT(DISTINCT CASE WHEN items_purchased = 2 THEN order_id ELSE NULL END) AS orders_w_2_items,

SELECT MIN(DATE(created_at)) AS week_start_date,
		COUNT(DISTINCT CASE WHEN device_type = 'desktop'THEN website_session_id END ) AS desktop_sessions,
        COUNT(DISTINCT CASE WHEN device_type = 'mobile'THEN website_session_id END) AS mobile_sessions
FROM website_sessions
WHERE created_at < '2012-06-09' AND website_sessions.created_at > '2012-04-15'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at), WEEK(created_at)