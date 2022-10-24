
-- Landing 


USE mavenfuzzyfactory;

-- first lander-1 id is 23504 and date is 2012-06-19

SELECT * FROM website_pageviews;
SELECT * FROM website_sessions;

SELECT 
	MIN(created_at) AS min_date,
	MIN(website_pageview_id) AS min_id
FROM website_pageviews
	WHERE pageview_url = '/lander-1';

-- finding the first page view 
CREATE TEMPORARY TABLE first_page_and_pageview_count
SELECT
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview,
    COUNT(website_pageviews.website_pageview_id) AS count_pageviews
    
FROM website_pageviews
LEFT JOIN website_sessions
ON	website_sessions.website_session_id = website_pageviews.website_session_id

WHERE website_sessions.created_at > '2012-06-01'
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
    AND website_pageviews.created_at < '2012-10-31'
GROUP BY website_pageviews.website_session_id;

-- CREATE temporary table with /lander-1 and /home
CREATE TEMPORARY TABLE counts_lander_and_create_at
SELECT
	first_page_and_pageview_count.website_session_id,
    first_page_and_pageview_count.min_pageview,
    first_page_and_pageview_count.count_pageviews,
    website_pageviews.pageview_url AS landing_page,
    website_pageviews.created_at AS session_created_at
FROM first_page_and_pageview_count
	LEFT JOIN website_pageviews
		ON first_page_and_pageview_count.min_pageview = website_pageviews.website_pageview_id;
        
SELECT 
	-- YEARWEEK(session_created_at) AS year_week,
    MIN(DATE(session_created_at)) AS week_start_date,
    -- COUNT(DISTINCT website_session_id) AS total_sessions,
    -- COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END) AS bounced_sessions,
    COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END )* 1.0/COUNT(DISTINCT website_session_id) AS bounce_rate,
    COUNT(DISTINCT CASE WHEN landing_page = '/home' THEN website_session_id ELSE NULL END) AS home_sessions,
    COUNT(DISTINCT CASE WHEN landing_page = '/lander-1' THEN website_session_id ELSE NULL END) AS lander_sessions
    
    FROM counts_lander_and_create_at
    
    GROUP BY 
		YEARWEEK(session_created_at)









	
