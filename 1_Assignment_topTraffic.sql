
/*
OUTPUT

utm_source  utm_campaign  http_referer          sessions

'gsearch','nonbrand','https://www.gsearch.com', '3613'
NULL,NULL,NULL,                                 '28'
NULL,NULL,'https://www.gsearch.com',            '27'
'gsearch','brand','https://www.gsearch.com',    '26'
NULL,NULL,'https://www.bsearch.com',            '7'
'bsearch','brand','https://www.bsearch.com',    '7'

Top traffic is gsearch 
*/



USE mavenfuzzyfactory;

SELECT utm_source,
		utm_campaign,
        http_referer,
        COUNT(DISTINCT website_sessions.website_session_id) AS sessions
FROM website_sessions
WHERE website_sessions.created_at < '2012-04-12'
GROUP BY 1,2,3
ORDER BY 4 DESC

