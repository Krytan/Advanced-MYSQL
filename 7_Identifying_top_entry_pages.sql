
/*

OUTPUT:

"landing_page_url" : "/home",
	"sessions_hitting_page" : 10714



*/

USE mavenfuzzyfactory;

-- Analyzing landing pages 

CREATE TEMPORARY TABLE first_pv_per_session
/*
	Took me a while to completly understand this select query but here is how it works 
	if you try to group by website_session_id without website_pageview_id having min or max is not gonna work 
    because session id has a many to one relation ship 
    when we try to group it all together it gives a error cus it actually tries to group ids that have multiple values
    like 6 can have 5, 4 8 but when I say that I wan't to grab the min value from page view id it returns the lowest number 
	the session id have meaning it will work because now session ids have only one value instead of multiple values 
    it also works for max meaning the highest number from pageview id.
*/
select
	website_session_id,
    max(website_pageview_id) AS first_pv

 from website_pageviews
 WHERE created_at < '2012-06-12'
 GROUP BY website_session_id;

 SELECT
	website_pageviews.pageview_url AS landing_page_url,
    COUNT(DISTINCT first_pv_per_session.website_session_id) AS sessions_hitting_page
FROM first_pv_per_session
	LEFT JOIN website_pageviews
		ON first_pv_per_session.first_pv = website_pageviews.website_pageview_id
GROUP BY website_pageviews.pageview_url
 
 
