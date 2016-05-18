package scene.titleScene
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import trolling.component.animation.Animator;
	import trolling.component.animation.State;
	import trolling.component.graphic.Image;
	import trolling.core.SceneManager;
	import trolling.event.TrollingEvent;
	import trolling.media.Sound;
	import trolling.media.SoundManager;
	import trolling.object.GameObject;
	import trolling.object.Scene;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	public class TitleScene extends Scene
	{
		//[Embed(source="ic_launcher.png")]
		//private static const notiImage:Class;
		
		private var _imageDic:Dictionary = new Dictionary();
		private var _imageURLVector:Vector.<String> = new Vector.<String>();
		private var _soundDic:Dictionary = new Dictionary();
		private var _soundURLVector:Vector.<String> = new Vector.<String>();
		private var _imageLoadCount:uint = 0;
		private var _soundLoadCount:uint = 0;
		private var _backGround:GameObject;
		private var _backGroundAnimator:Animator;
		private var _filePath:File = File.applicationDirectory.resolvePath("scene/titleScene");
		
		public function TitleScene()
		{
			this.addEventListener(TrollingEvent.START_SCENE, onInit);
		}
		
		private function onInit(event:Event):void
		{
			_imageURLVector.push("title.png");
			_imageURLVector.push("title0.png");
			_imageURLVector.push("title1.png");
			_imageURLVector.push("touchToStart.png");
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
			_soundDic[event.currentTarget.url.replace(_filePath.url.toString() + "/", "")] = event.currentTarget as Sound;
			
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
			
			SoundManager.play("Opening.mp3");
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
			_imageDic[LoaderInfo(event.currentTarget).url.replace(_filePath.url.toString() + "/", "")] = LoaderInfo(event.currentTarget).loader.content;
			
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
			_backGround.addEventListener(TrollingEvent.TOUCH_ENDED, onTouch);
			//_backGroundAnimator = new Animator();

			_backGround.pivot = PivotType.CENTER;
			_backGround.x = this.width / 2;
			_backGround.y = this.height / 2;
			_backGround.addComponent(new Image(new Texture(_imageDic["title.png"])));
			
			// add
			var bitmapData:BitmapData = new BitmapData(10, 10);
			var ct:ColorTransform = new ColorTransform();
			ct.alphaMultiplier = 0; 
			bitmapData.colorTransform(new Rectangle(0, 0, bitmapData.width, bitmapData.height), ct);
			
			var message:GameObject = new GameObject();
			message.pivot = PivotType.CENTER;
			message.y = this.height / 4;
			
			var state:State = new State("title");
			state.addFrame(new Texture(_imageDic["touchToStart.png"]));
			state.addFrame(new Texture(new Bitmap(bitmapData)));
			state.isLoop = true;
			state.interval = 20;
			
			var animator:Animator = new Animator();
			animator.addState(state);
			
			message.addComponent(animator);
			message.width *= 0.7;
			message.height *= 0.7;
			_backGround.addChild(message);
			//
			
//			var state:State = new State("title");
//			state.addFrame(new Texture(_imageDic["title0.png"]));
//			state.addFrame(new Texture(_imageDic["title1.png"]));
//			state.isLoop = true;
//			state.interval = 20;
			
			//_backGroundAnimator.addState(state);
			
			//_backGround.addComponent(_backGroundAnimator);
			_backGround.width = this.width;
			_backGround.height = this.height;
			
			addChild(_backGround);
		}
		
		private function onTouch(event:TrollingEvent):void
		{
			//var image:Bitmap = new notiImage() as Bitmap;
			//trace(image.width);
			
			//var notification:NotificationExtension = new NotificationExtension();
			//notification.setNotification("돌아와요!!", "Notification", 30);
			SceneManager.switchScene("stageSelect");
		}
	}
}