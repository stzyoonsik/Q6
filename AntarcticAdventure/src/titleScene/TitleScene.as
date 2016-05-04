package titleScene
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import trolling.component.animation.Animator;
	import trolling.component.animation.State;
	import trolling.core.SceneManager;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.object.Scene;
	
	public class TitleScene extends Scene
	{
		private var _resources:Dictionary = new Dictionary();
		private var _resourceURLs:Vector.<String> = new Vector.<String>();
		private var _loadCount:uint = 0;
		private var _backGround:GameObject;
		private var _backGroundAnimator:Animator;
		private var _filePath:File = File.applicationDirectory;
		
		public function TitleScene()
		{
			_resourceURLs.push("title0.png");
			_resourceURLs.push("title1.png");
			
			var loader:Loader;
			var urlRequest:URLRequest;
			for(var i:int = 0; i < _resourceURLs.length; i++)
			{
				loader = new Loader();
				urlRequest = new URLRequest(_filePath.resolvePath(_resourceURLs[i]).url);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
				loader.load(urlRequest);
			}
		}
		
		private function uncaughtError(event:Event):void
		{
			trace("Please Check " + LoaderInfo(event.currentTarget).url);
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onCompleteLoad);
			LoaderInfo(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
			_loadCount++;
		}
		
		private function onCompleteLoad(event:Event):void
		{
			trace("ddd = " + LoaderInfo(event.currentTarget).url);
			_resources[LoaderInfo(event.currentTarget).url.replace(_filePath.url.toString(), "")] = LoaderInfo(event.currentTarget).loader.content;
			
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onCompleteLoad);
			LoaderInfo(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
			_loadCount++;
			
			if(_resourceURLs.length <= _loadCount)
			{
				_resourceURLs.splice(0, _resourceURLs.length);
				//				_resourceURLs = null;
				loadComplete();
			}
		}
		
		private function loadComplete():void
		{
			_backGround = new GameObject();
			_backGround.addEventListener(TrollingEvent.TOUCH_BEGAN, onTouch);
			_backGroundAnimator = new Animator();
			var state:State = new State("title");
			state.addFrame(_resources["title0.png"]);
			state.addFrame(_resources["title1.png"]);
			state.interval = 20;
			
			_backGroundAnimator.addState(state);
			
			_backGround.addComponent(_backGroundAnimator);
			_backGround.width = Screen.mainScreen.bounds.width;
			_backGround.height = Screen.mainScreen.bounds.height;
			
			addChild(_backGround);
		}
		
		private function onTouch(event:TrollingEvent):void
		{
			SceneManager.switchScene("Game");
		}
	}
}