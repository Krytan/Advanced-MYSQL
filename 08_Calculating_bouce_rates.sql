
/*

OUTPUT:

		"sessions" : 11048,
		"bouced_sessions" : 6538,
		"bouce_rate" : 0.5918
*/

-- STEP 1: Finding the first website_pageview_id for relevant sessions
-- STEP 2: identifying the landing page of each session
-- STEP 3: counting pageviews for each sessin, to identify "bouces"
-- STEP 4: summarizing by coutig total sessions and bouced sessions


USE mavenfuzzyfactory;

/*

We wanna find the landing page per session here.

*/

CREATE TEMPORARY TABLE first_pageviews
SELECT 
	website_session_id,
	MIN(website_pageview_id) AS first_page_view
FROM website_pageviews
	 WHERE created_at < '2012-06-14'
	GROUP BY website_session_id;

/*

first page view with url names 

*/


CREATE TEMPORARY TABLE sessions_w_landing_pages
SELECT 
    first_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews
	LEFT JOIN website_pageviews
    ON website_pageviews.website_pageview_id = first_pageviews.first_page_view
WHERE website_pageviews.pageview_url = '/home';

/*



*/

CREATE TEMPORARY TABLE bouced_sessions
SELECT 
	sessions_w_landing_pages.website_session_id,
    sessions_w_landing_pages.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
    
    FROM sessions_w_landing_pages
    LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_w_landing_pages.website_session_id
	
    GROUP BY
		sessions_w_landing_pages.landing_page,
        sessions_w_landing_pages.website_session_id
	HAVING
		COUNT(website_pageviews.website_pageview_id) = 1;

SELECT
	COUNT(DISTINCT sessions_w_landing_pages.website_session_id) AS sessions,
    COUNT(DISTINCT bouced_sessions.website_session_id) AS bouced_sessions,
    COUNT(DISTINCT bouced_sessions.website_session_id)/COUNT(DISTINCT sessions_w_landing_pages.website_session_id) AS bouce_rate
    
	
FROM sessions_w_landing_pages
	LEFT JOIN bouced_sessions
		ON sessions_w_landing_pages.landing_page = bouced_sessions.landing_page




