package
{

	import com.mrballistic.utils.GA;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class GATracking extends Sprite
	{
		/* replace these */
		private const GA_ID:String = "UA-XXXXXXXX-1"; // replace this with your google analytics id
		private const GA_SITE_CONTEXT:String = "http://www.yoursite.com/"; // replace this with your registered site

		public var ga:GA;

		private const WIDTH:uint = 500;
		private const HEIGHT:uint = 200;	
		
		public var bigButton:Sprite;
		public var bg:Sprite;
		public var mainHolder:Sprite;
		public var timer:Timer;
		public var user_guid:String = new String();

		public function GATracking()
		{
			// put a nice black background behind the whole thing
			bg = new Sprite();
			bg.graphics.beginFill(0x000000, 1.0);
			bg.graphics.drawRect(-1200, -1200, 12000, 12000);
			bg.graphics.endFill();
			addChild(bg);
			
			mainHolder = new Sprite();
			addChild(mainHolder);
			
			// give air a chance to catch up
			timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, function(t:TimerEvent):void{ 
				timer.removeEventListener(TimerEvent.TIMER, arguments.callee);
				initApp();
			});
			timer.start();
		}
		
		private function initApp():void {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageWidth = WIDTH;
			stage.stageHeight = HEIGHT;
			stage.frameRate = 30;
			stage.fullScreenSourceRect = new Rectangle(0,0, WIDTH, HEIGHT); 

			// create a new tracking object by passing in both
			// the GA id (ua-xxxxxxxx-x) and 
			// the GA site context (http://www.yoursite.com)
			ga = new GA(GA_ID, GA_SITE_CONTEXT);
			
			// throw an ugly button on the stage
			// every click registers a hit on google analytics
			bigButton = new Sprite();
			bigButton.graphics.beginFill(0xcccccc, 1.0);
			bigButton.graphics.drawRoundRect(-125,-50,250,100,8.0);
			bigButton.graphics.endFill();			
			bigButton.x = WIDTH/2;
			bigButton.y = HEIGHT/2;			
			mainHolder.addChild(bigButton);
			bigButton.buttonMode = true;
			
			// add in our mouse listeners
			bigButton.addEventListener(MouseEvent.CLICK, onClick);
			bigButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			bigButton.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(e:MouseEvent):void {
			// cheap animation
			bigButton.alpha = 0.5;
			
		}
		
		private function onMouseUp(e:MouseEvent):void {
			bigButton.alpha = 1.0;
		}
		
		private function onClick(e:MouseEvent):void {
			
			// add event takes two bits of data=
			// the event name, then the event category
			ga.addEvent("click", "user_interaction", "click_story", "mainPage/", "Main Page");
		
			// or just add a pageview:
			//ga.addPageView("mainPage/", "Main Page");
			
		}
		
	}
}