Google Analytics tracking for desktop Air projects
--------------------------------------------------

This class abstracts the various hassles around pushing data from a desktop air project to the Google Analytics servers. The present solutions are all geared towards either mobile apps or in-browser solutions, and there's a gap in there for desktop apps. This leverages the new [Measurement Protocol](https://developers.google.com/analytics/devguides/collection/protocol/v1/), which gets around needing a browser or javascript engine. 

### How-To
Simply instantiate a new GA object and pass in both your google analytics id and site (even though it's a desktop app, google still requires a website be attached to the account). Like this:

	ga = new GA(GA_ID, GA_SITE_CONTEXT);

Then, whenever you want to add an event, do this:
	
	ga.addEvent("click", "user_interaction", "click_story", "mainPage/", "Main Page");

or, track a pageview:
	
	ga.addPageView("mainPage/", "Main Page");

Honestly, the only classes you need here are **com.mrballistic.utils.GA** and **com.facebook.utils.GUID**

Easy!

