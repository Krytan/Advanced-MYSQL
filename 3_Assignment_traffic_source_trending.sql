/*
OUTPUT
		"week_start" : "2012-03-19",
		"sessions" : 896
		"week_start" : "2012-03-25",
		"sessions" : 956
		"week_start" : "2012-04-01",
		"sessions" : 1152
		"week_start" : "2012-04-08",
		"sessions" : 983
		"week_start" : "2012-04-15",
		"sessions" : 621
		"week_start" : "2012-04-22",
		"sessions" : 594
		"week_start" : "2012-04-29",
		"sessions" : 681
		"week_start" : "2012-05-06",
		"sessions" : 399

        this is the result after biding down gsearch nonbrand, it caused a big impact in the volume
        we want big volumes but not spending more than he can afford.  

*/

 
USE mavenfuzzyfactory;

SELECT
MIN(DATE(created_at)) AS week_start,
COUNT(DISTINCT website_session_id) AS sessions

FROM website_sessions 
WHERE created_at < '2012-05-10'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at), WEEK(created_at)
