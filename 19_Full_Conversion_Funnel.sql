
/*
RESULT::

essions	landing_page	product_page	mr_fuzzy_page	cart_page	shipping_page	billing_page	ty_made
2261	/home	        942	            684	            296	           200	        168	            72
2316	/lander-1	    1083	        772	            348	           231	        197	            94

CLICKTROUGHT RATE RESULT::

landing_page	lander_clickthrough_rt	products_clickthrough_rt	mr_fuzzy_clickthrough_rt	cart_clickthrough_rt	shipping_clickthrough_rt	billing_clickthrough_rt
/home	        0.4166	                0.7261	                    0.4327	                    0.6757	                0.8400	                    0.4286
/lander-1	    0.4676	                0.7128	                    0.4508	                    0.6638	                0.8528	                    0.4772

*/


/* 
MY RESPONSE::

*/

-- Landing 


USE mavenfuzzyfactory;

SELECT
	website_pageviews.website_session_id AS sessions,
    MIN(website_pageviews.website_pageview_id) AS Min_pageview_id
    
FROM website_pageviews
INNER JOIN website_sessions
ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-6-19' AND '2012-7-28'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY website_pageviews.website_session_id;

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
	website_sessions.created_at BETWEEN '2012-6-19' AND '2012-7-28'
    AND website_sessions.utm_source = 'gsearch'
	AND website_sessions.utm_campaign = 'nonbrand'
ORDER BY
	website_sessions.website_session_id,
    website_pageviews.created_at) AS pageview_level
    GROUP BY website_session_id;
    


SELECT 
	COUNT(DISTINCT pages_made_it_flags.website_session_id) AS sessions,
    website_pageviews.pageview_url AS landing_page,
    COUNT(DISTINCT CASE WHEN products_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END) AS product_page,
    COUNT(DISTINCT CASE WHEN mr_fuzzy_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END) AS mr_fuzzy_page,
    COUNT(DISTINCT CASE WHEN cart_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END) AS cart_page,
    COUNT(DISTINCT CASE WHEN shipping_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END) AS shipping_page,
    COUNT(DISTINCT CASE WHEN billing_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END) AS billing_page,
    COUNT(DISTINCT CASE WHEN ty_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END) AS ty_made
FROM pages_made_it_flags
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = pages_made_it_flags.website_session_id
WHERE website_pageviews.pageview_url IN ('/home','/lander-1')
GROUP BY 2;

SELECT
    website_pageviews.pageview_url AS landing_page,
    COUNT(DISTINCT CASE WHEN products_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END)
    /COUNT(DISTINCT pages_made_it_flags.website_session_id) AS lander_clickthrough_rt,
    COUNT(DISTINCT CASE WHEN mr_fuzzy_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END)
    /COUNT(DISTINCT CASE WHEN products_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END) AS products_clickthrough_rt,
    COUNT(DISTINCT CASE WHEN cart_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END)
    /COUNT(DISTINCT CASE WHEN mr_fuzzy_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END) AS mr_fuzzy_clickthrough_rt,
    COUNT(DISTINCT CASE WHEN shipping_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END)
    /COUNT(DISTINCT CASE WHEN cart_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END) AS cart_clickthrough_rt,
    COUNT(DISTINCT CASE WHEN billing_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END)
    /COUNT(DISTINCT CASE WHEN shipping_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END) AS shipping_clickthrough_rt,
    COUNT(DISTINCT CASE WHEN ty_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END)
    /COUNT(DISTINCT CASE WHEN billing_made = 1 THEN pages_made_it_flags.website_session_id ELSE NULL END) AS billing_clickthrough_rt
FROM pages_made_it_flags
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = pages_made_it_flags.website_session_id
WHERE website_pageviews.pageview_url IN ('/home','/lander-1')
GROUP BY 1;








	
