
/*

OUTPUT:

		"pageview_url" : "/home",
		"sessions" : 10403
	,
    	"pageview_url" : "/products",
		"sessions" : 4239
	,
		"pageview_url" : "/the-original-mr-fuzzy",
		"sessions" : 3037
	,
		"pageview_url" : "/cart",
		"sessions" : 1306
	,
		"pageview_url" : "/shipping",
		"sessions" : 869
	,
		"pageview_url" : "/billing",
		"sessions" : 716
	,
		"pageview_url" : "/thank-you-for-your-order",
		"sessions" : 306

    Here we can see that home,products and the-origial-mr-fuzzy are top website pages. 
*/




CREATE TEMPORARY TABLE top_website -- Arbitrary
SELECT pageview_url,
		COUNT(DISTINCT website_session_id) AS sessions
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY 1 
ORDER BY sessions DESC;

select * from top_website