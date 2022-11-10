
/*
Conversion rate: Definition
The average number of conversions per ad interaction, shown as a percentage.
For example, if you had 50 conversion from 1,000 interactions, your conversion rate would be 5%, since 50 / 1,000 = 5%

OUTPUT 

"sessions" : 3895,
"orders" : 112,
"session_to_order_conv_rate" : 0.0288

Traffic Source Conversion is 2.88% porcent which is below the 4% threshold the company needs to make.
that minds the company is over-spending based on this conversion rate. 
*/

USE mavenfuzzyfactory;

SELECT COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
		COUNT(DISTINCT orders.order_id) AS orders,
        COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rate

FROM website_sessions

LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id

WHERE website_sessions.created_at < '2012-04-14'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'


