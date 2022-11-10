USE mavenfuzzyfactory;

SHOW TABLES ;

SELECT * FROM website_sessions WHERE website_session_id = 18244;
SELECT * FROM website_pageviews;

-- We first analyse the data with focus on 3 columns session_id, created_time and pageview_url.
-- now that we have those 3 columns we can start poiting out whenever the user opened the pages or not with cases.
-- Next we create a sub querry to take only the flags from the pages, again whenever the user opened the pages.

-- DROP TEMPORARY TABLE pages_made_it_flags;
CREATE TEMPORARY TABLE pages_made_it_flags
SELECT
	website_session_id,
	MAX(products_page) AS products_made,
	MAX(original_mr_fuzzy_page) AS mr_fuzzy_made,
    MAX(cart_page) AS cart_made,
    MAX(shipping_page) AS shipping_made,
    MAX(billing_page) AS billing_made,
    MAX(ty_page) AS ty_made
FROM(
SELECT 	
	website_sessions.website_session_id,
	website_pageviews.created_at,
    website_pageviews.pageview_url,
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS original_mr_fuzzy_page,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS ty_page
    
FROM website_pageviews
LEFT JOIN website_sessions
ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE
		website_sessions.created_at < '2012-09-05' 
	AND	website_sessions.created_at > '2012-08-05'
    AND website_sessions.utm_source = 'gsearch'
	AND website_sessions.utm_campaign = 'nonbrand'
ORDER BY
	website_sessions.website_session_id,
    website_pageviews.created_at) AS pageview_level
    GROUP BY website_session_id;

SELECT * FROM pages_made_it_flags;

-- we can see how many users in total clicked in each page here. 
SELECT 
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN products_made = 1 THEN website_session_id ELSE NULL END) AS product_page,
    COUNT(DISTINCT CASE WHEN mr_fuzzy_made = 1 THEN website_session_id ELSE NULL END) AS mr_fuzzy_page,
    COUNT(DISTINCT CASE WHEN cart_made = 1 THEN website_session_id ELSE NULL END) AS cart_page,
    COUNT(DISTINCT CASE WHEN shipping_made = 1 THEN website_session_id ELSE NULL END) AS shipping_page,
    COUNT(DISTINCT CASE WHEN billing_made = 1 THEN website_session_id ELSE NULL END) AS billing_page,
    COUNT(DISTINCT CASE WHEN ty_made = 1 THEN website_session_id ELSE NULL END) AS ty_made
FROM pages_made_it_flags;

SELECT 
    COUNT(DISTINCT CASE WHEN products_made = 1 THEN website_session_id ELSE NULL END)
    /COUNT(DISTINCT website_session_id) AS lander_clickthrough_rt,
    COUNT(DISTINCT CASE WHEN mr_fuzzy_made = 1 THEN website_session_id ELSE NULL END)
    /COUNT(DISTINCT CASE WHEN products_made = 1 THEN website_session_id ELSE NULL END) AS products_clickthrough_rt,
    COUNT(DISTINCT CASE WHEN cart_made = 1 THEN website_session_id ELSE NULL END)
    /COUNT(DISTINCT CASE WHEN mr_fuzzy_made = 1 THEN website_session_id ELSE NULL END) AS mr_fuzzy_clickthrough_rt,
    COUNT(DISTINCT CASE WHEN shipping_made = 1 THEN website_session_id ELSE NULL END)
    /COUNT(DISTINCT CASE WHEN cart_made = 1 THEN website_session_id ELSE NULL END) AS cart_clickthrough_rt,
    COUNT(DISTINCT CASE WHEN billing_made = 1 THEN website_session_id ELSE NULL END)
    /COUNT(DISTINCT CASE WHEN shipping_made = 1 THEN website_session_id ELSE NULL END) AS shipping_clickthrough_rt,
    COUNT(DISTINCT CASE WHEN ty_made = 1 THEN website_session_id ELSE NULL END)
    /COUNT(DISTINCT CASE WHEN billing_made = 1 THEN website_session_id ELSE NULL END) AS billing_clickthrough_rt
FROM pages_made_it_flags
	

