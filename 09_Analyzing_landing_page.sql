

/*
    OUTPUT:

		"pageview_url" : "/home",
		"sessions" : 2261,
		"bouced_sessions" : 1319,
		"bouce_rate" : 0.5834
,
		"pageview_url" : "/lander-1",
		"sessions" : 2315,
		"bouced_sessions" : 1232,
		"bouce_rate" : 0.5322
*/



USE mavenfuzzyfactory;

-- Here I am just looking real quick at the time period where/lander-1 was getting traffic.

SELECT 
    website_pageviews.website_pageview_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at,
    website_pageviews.website_session_id
FROM
    website_pageviews
        LEFT JOIN
    website_sessions ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE
    website_pageviews.pageview_url = '/lander-1'
        OR website_pageviews.pageview_url = '/home'
        AND website_sessions.created_at < '2012-07-28'
        AND website_sessions.created_at > '2012-06-19'
        AND website_sessions.utm_source = 'gsearch'
        AND website_sessions.utm_campaign = 'nonbrand';
        

-- the better way to find first id from url my way was pretty trash to be honest 

SELECT
		pageview_url,
		MIN(created_at) AS first_date,
		MIN(website_pageview_id) AS first_id
FROM website_pageviews
WHERE pageview_url = '/lander-1';

-- finding the first page view   

CREATE TEMPORARY TABLE first_page
SELECT 
		website_pageviews.website_session_id, 
        MIN(website_pageviews.website_pageview_id) as first_page_view 
FROM website_pageviews
INNER JOIN website_sessions
	ON website_sessions.website_session_id = website_pageviews.website_session_id
    AND website_sessions.created_at < '2012-07-28' -- required by the assignment  
    AND website_pageviews.website_pageview_id > 23504 -- the first /lander-1 id created
	AND website_sessions.utm_source = 'gsearch' 
	AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY website_session_id;

 -- DROP temporary table bouced_sessions; -- Arbitary

-- adding pageview url per session id. 
CREATE TEMPORARY TABLE nonbrand_sessions_w_landing_pages
SELECT
		website_pageviews.pageview_url,
		website_pageviews.website_session_id
FROM first_page
LEFT JOIN website_pageviews
	ON website_pageviews.website_pageview_id = first_page.first_page_view
WHERE website_pageviews.pageview_url IN ('/home','/lander-1');

 
CREATE TEMPORARY TABLE bouced_sessions
SELECT 
		nonbrand_sessions_w_landing_pages.website_session_id,
		nonbrand_sessions_w_landing_pages.pageview_url,
        COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
        
FROM nonbrand_sessions_w_landing_pages                                   
	LEFT JOIN website_pageviews
	ON website_pageviews.website_session_id = nonbrand_sessions_w_landing_pages.website_session_id

GROUP BY 
	nonbrand_sessions_w_landing_pages.pageview_url,
	nonbrand_sessions_w_landing_pages.website_session_id
HAVING count_of_pages_viewed = '1';

SELECT * FROM bouced_sessions;

SELECT
	bouced_sessions.pageview_url,
	COUNT(DISTINCT nonbrand_sessions_w_landing_pages.website_session_id) AS sessions,
	COUNT(DISTINCT bouced_sessions.website_session_id) AS bouced_sessions,
    COUNT(DISTINCT bouced_sessions.website_session_id)/COUNT(DISTINCT nonbrand_sessions_w_landing_pages.website_session_id) AS bouce_rate
FROM nonbrand_sessions_w_landing_pages
	LEFT JOIN bouced_sessions
		ON	nonbrand_sessions_w_landing_pages.pageview_url = bouced_sessions.pageview_url
	GROUP BY bouced_sessions.pageview_url
	