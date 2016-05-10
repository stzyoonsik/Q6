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
	import trolling.media.Sound;
	import trolling.media.SoundManager;
	import trolling.object.GameObject;
	import trolling.object.Scene;
	import trolling.rendering.Texture;
	
	public class TitleScene extends Scene
	{
		private var _imageDic:Dictionary = new Dictionary();
		private var _imageURLVector:Vector.<String> = new Vector.<String>();
		private var _soundDic:Dictionary = new Dictionary();
		private var _soundURLVector:Vector.<String> = new Vector.<String>();
		private var _imageLoadCount:uint = 0;
		private var _soundLoadCount:uint = 0;
		private var _backGround:GameObject;
		private var _backGroundAnimator:Animator;
		private var _filePath:File = File.applicationDirectory;
		
		public function TitleScene()
		{
			this.addEventListener(TrollingEvent.START_SCENE, onInit);
		}
		
		private function onInit(event:Event):void
		{
			_imageURLVector.push("title0.png");
			_imageURLVector.push("title1.png");
			_soundURLVector.push("Opening.mp3");
			
			var loader:Loader;
			var urlRequest:URLRequest;
			for(var i:int = 0; i < _imageURLVector.length; i++)
			{
				loader = new Loader();
				urlRequest = new URLRequest(_filePath.resolvePath(_imageURLVector[i]).url);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
				loader.load(urlRequest);
			}
			
			for(i = 0; i < _soundURLVector.length; i++)
			{
				urlRequest = new URLRequest(_filePath.resolvePath(_soundURLVector[i]).url); 
				var sound:Sound = new Sound();
				sound.load(urlRequest);
				sound.addEventListener(Event.COMPLETE, onSoundLoaded);
				sound.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadFaild);        
			}
		}
		
		private function onSoundLoaded(event:Event):void
		{
			
			//_soundDic
			_soundLoadCount++;
			trace("*******************************");
			trace(event.currentTarget.url);
			_soundDic[event.currentTarget.url.replace(_filePath.url.toString(), "")] = event.currentTarget as Sound;
			
			if(_soundLoadCount >= _soundURLVector.length)
			{
				_soundURLVector.splice(0, _soundURLVector.length);
				completeLoadSound();
			}
		}
		
		private function completeLoadSound():void
		{
			SoundManager.addSound("Opening", _soundDic["Opening.mp3"]);
			
			var sound:Sound = _soundDic["Opening.mp3"]; 
			sound.volume = 0.5;
			sound.loops = Sound.INFINITE;
			
			SoundManager.play("Opening");
		}
		
		private function onSoundLoadFaild(event:IOErrorEvent):void
		{
			trace(event.text);
		}
		
		private function uncaughtError(event:Event):void
		{
			trace("Please Check " + LoaderInfo(event.currentTarget).url);
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onCompleteLoad);
			LoaderInfo(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
			_imageLoadCount++;
		}
		
		private function onCompleteLoad(event:Event):void
		{
			trace("ddd = " + LoaderInfo(event.currentTarget).url);
			_imageDic[LoaderInfo(event.currentTarget).url.replace(_filePath.url.toString(), "")] = LoaderInfo(event.currentTarget).loader.content;
			
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onCompleteLoad);
			LoaderInfo(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
			_imageLoadCount++;
			
			if(_imageURLVector.length <= _imageLoadCount)
			{
				_imageURLVector.splice(0, _imageURLVector.length);
				completeLoadImage();
			}
		}
		
		private function completeLoadImage():void
		{
			_backGround = new GameObject();
			_backGround.addEventListener(TrollingEvent.TOUCH_BEGAN, onTouch);
			_backGroundAnimator = new Animator();
			var state:State = new State("title");
			state.addFrame(new Texture(_imageDic["title0.png"]));
			state.addFrame(new Texture(_imageDic["title1.png"]));
			state.isLoop = true;
			state.interval = 20;
			
			_backGroundAnimator.addState(state);
			
			_backGround.addComponent(_backGroundAnimator);
			_backGround.width = Screen.mainScreen.bounds.width;
			_backGround.height = Screen.mainScreen.bounds.height;
			
			addChild(_backGround);
		}
		
		private function onTouch(event:TrollingEvent):void
		{
			SoundManager.dispose();
			SceneManager.switchScene("Game");
		}
	}
}