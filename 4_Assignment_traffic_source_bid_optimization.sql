/*
    OUTPUT:

        "device_type" : "mobile",
		"sessions" : 2492,
		"orders" : 24,
		"session_to_order_conv_rate" : 0.0096
	 ,
		"device_type" : "desktop",
		"sessions" : 3911,
		"orders" : 146,
		"session_to_order_conv_rate" : 0.0373

    Based on the output we can see that desktop generate way more orders and CVR than mobile
    Recommend encrease bids on Desktop.

*/


USE mavenfuzzyfactory;

SELECT device_type,
		COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
        COUNT(DISTINCT order_id) AS orders,
        COUNT(DISTINCT order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rate
        
        
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-05-11' 
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY 1 
ORDER BY 4 ASC

