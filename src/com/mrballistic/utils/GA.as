package com.mrballistic.utils
{
	
	// built to use Measurement Protocol
	// documentation here: https://developers.google.com/analytics/devguides/collection/protocol/v1/
	
	import com.facebook.utils.GUID;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class GA extends Object
	{
		
		private var ga_id:String = "";
		private var ga_site_context:String = "";
		private var user_id:String = "";
		private var isSecure:Boolean = true;
		private var url:String = "";
		private var campaign_name:String = "";
		private var debug_app:Boolean = false;
		
		private var urlVars:URLVariables;
		
		private const GA_URL_SSL:String = "https://ssl.google-analytics.com/collect";
		private const GA_URL:String = "http://www.google-analytics.com/collect";

		public function GA(_ga_id:String, _ga_site_context:String, _ga_user:String = "")
		{
			ga_id = _ga_id;
			ga_site_context = _ga_site_context;
			
			// if a user_id wasn't passed along, then create a new one
			if(_ga_user == ""){
				user_id = GUID.create() as String;
			}

			url = GA_URL_SSL;
			
			urlVars = new URLVariables();

		}

		
		/* public getters and setters */

		/* debugging */
		public function set debug(isDebug:Boolean):void {
			debug_app = isDebug;
		}
		
		public function get debug():Boolean {
			return debug_app;
		}
		
		/* ssl? */
		public function set secure(_s:Boolean):void {
			// change transport method from ssl to standard
			// default is ssl
			isSecure = _s;
			
			if(isSecure){
				url = GA_URL_SSL;
			} else {
				url = GA_URL;
			}
		}
		
		public function get secure():Boolean {
			return isSecure;
		}
		
		/* campaign */
		public function set campaign(_campaign:String):void {
			// set an overall campaign name
			// set to empty string to have ga ignore campaign
			campaign_name = _campaign;
		}
		
		public function get campaign():String {
			return campaign_name;
		}
		
		/* user context */
		// use these to retain your user context
		public function set user(_uid:String):void {
			user_id = _uid;
		}
		
		public function get user():String {
			return user_id;
		}
		
		
		/* --------------------------------------------------------------------------------- */
		/* public methods */
		/* --------------------------------------------------------------------------------- */

		public function newUser():void {
			// creates a new, unique user context
			user_id = GUID.create() as String;
		}
		
		public function session(_start:Boolean):void {
			// start or stop a session
			
			// reset the urlVars object
			resetVars();
			
			if(_start){
				urlVars['sc'] = "start";
			} else {
				urlVars['sc'] = "stop";
			}
			
			// send the data to ga
			sendData();
		}
		
		public function addPageView(_pageName, _pageTitle = ""):void {
			// add a pageview to ga
			// pagename is prepended with a leading slash, as per google's rules
			
			// reset the urlVars object
			resetVars();
			
			if(_pageTitle == ""){
				_pageTitle = _pageName;
			} 
			
			// populate the urlvars
			urlVars['dh'] = ga_site_context; 
			urlVars['dp'] = '/' + _pageName;
			urlVars['dt'] = _pageTitle;
			urlVars['t'] = 'pageview';
			
			// send the data to ga
			sendData();

		}
		
		public function addEvent(_eventName, _eventCategory, _eventLabel, _pageName, _pageTitle = ""):void {
			// add an event to ga			
			
			// reset the urlVars object
			resetVars();
			
			if(_pageTitle == ""){
				_pageTitle = _pageName;
			} 

			// add the events
			urlVars['ea'] = _eventName;
			urlVars['ec'] = _eventCategory;
			urlVars['el'] = _eventLabel;
			urlVars['dt'] = _pageTitle;			
			urlVars['dh'] = ga_site_context;
			urlVars['dp'] = '/' + _pageName;
			
			urlVars['t'] = 'event';
			
			// send the data to ga
			sendData();
			
		}
		
		
		/* --------------------------------------------------------------------------------- */
		/* private data */
		/* --------------------------------------------------------------------------------- */
		
		private function resetVars():void {
			
			urlVars.length = 0;

			// set the urlvars we'll send to ga. many are boilerplate.
			urlVars['v'] = '1';
			urlVars['tid'] = ga_id;
			urlVars['cid'] = user_id; 		
			urlVars['ul'] = "en-us";

			if(campaign_name != ""){
				urlVars['cn'] = campaign_name;
			}
		}
		
		private function sendData():void {
			
			// create a URLRequest object with the target URL:
			var urlRequest : URLRequest = new URLRequest(url);

			// add the urlVariables to the urlRequest
			urlRequest.data = urlVars;
			
			// set the method to post (default is GET)
			urlRequest.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			// wrapped up in a try block for safety
			try {
				urlLoader.load(urlRequest);
			} catch (error:Error) {
				trace("Error! - Unable to load requested document. Is the network down?");
			}
			
			if(debug_app){

				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(e:HTTPStatusEvent):void {
					urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, arguments.callee);
					trace(e);
				});
				
				urlLoader.addEventListener(Event.COMPLETE, function(e:Event):void {
					urlLoader.removeEventListener(Event.COMPLETE, arguments.callee);
					trace(e);
				});
				
				trace('sending ', urlVars, 'to ', url);
				
			}
		}
	}
}