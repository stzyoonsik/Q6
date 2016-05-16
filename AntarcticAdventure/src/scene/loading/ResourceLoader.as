package scene.loading
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import trolling.media.Sound;
	import trolling.media.SoundManager;

	public class ResourceLoader
	{

		public function get isLoadedSoundAll():Boolean
		{
			return _isLoadedSoundAll;
		}

		private var _completeFunc:Function;
		private var _imageDirectory:File;
		private var _imageArray:Array;
		
		private var _imageFileCount:int;		
		private var _bitmapDic:Dictionary = new Dictionary();
		
		private var _isLoadedImageAll:Boolean;
		
		
		
		private var _soundDirectory:File;
		private var _soundArray:Array;
		
		private var _soundFileCount:int;
		private var _soundDic:Dictionary = new Dictionary();
		
		private var _isLoadedSoundAll:Boolean;
		
		public function get isLoadedImageAll():Boolean {	return _isLoadedImageAll; }
		public function get bitmapDic():Dictionary { return _bitmapDic; }
		
		public function ResourceLoader(cFunc:Function)
		{
			_completeFunc = cFunc;
			_imageDirectory = File.applicationDirectory.resolvePath("scene").resolvePath("gameScene").resolvePath("image");
			_imageArray = _imageDirectory.getDirectoryListing();
			
			_soundDirectory = File.applicationDirectory.resolvePath("scene").resolvePath("gameScene").resolvePath("sound");
			_soundArray = _soundDirectory.getDirectoryListing();
			
			//trace("asdfasdfasdf" + _soundArray[0].url);
			
			buildImageLoader();
			buildSoundLoader();
		}
		

		private function buildImageLoader():void
		{
			for(var i:int = 0; i < _imageArray.length; i++)
			{
				var file:File = _imageArray[i] as File;
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadImage);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onCatchError);
				loader.load(new URLRequest(file.url));
			}
		}
		
		private function onCompleteLoadImage(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			var fileName:String = loaderInfo.url.replace(_imageDirectory.url + "/", "")			
			fileName = fileName.replace(".png", "");
			//trace(fileName);
			_bitmapDic[fileName] = loaderInfo.loader.content as Bitmap;
			
			loaderInfo.removeEventListener(Event.COMPLETE, onCompleteLoadImage);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onCatchError);
			loaderInfo.loader.unload();
			loaderInfo = null; 
			
			_imageFileCount++;
			
			
			if (_imageArray.length <= _imageFileCount)
			{
				//trace("파일 카운트 = " + _fileCount);
				for (var i:int = 0; i < _imageArray.length; i++)
				{
					_imageArray[i] = null;
				}
				_imageArray = null;
				
				_imageDirectory = null;
				_imageFileCount = 0;
				
				_isLoadedImageAll = true;
			}
			
			_completeFunc();
		}
		
		private function onCatchError(event:IOErrorEvent):void
		{
			trace("onCatchError : Please Check " + LoaderInfo(event.currentTarget).url + ".");
			
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onCompleteLoadImage);
			LoaderInfo(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onCatchError);
		
		}

		
		/**
		 * 푸쉬된 사운드 파일들을 로드하는 메소드 
		 * 
		 */
		private function buildSoundLoader():void
		{
			for(var i:int = 0; i<_soundArray.length; ++i)
			{
				var url:URLRequest = new URLRequest(_soundArray[i].url);
				//trace(url.url);
				var sound:Sound = new Sound();
				sound.load(url);
				sound.addEventListener(Event.COMPLETE, onCompleteLoadSound);
				sound.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadFailed);			
				
			}
		}
		
		/**
		 * 로드에 성공한 사운드 파일을 딕셔너리에 추가하는 메소드 
		 * @param event
		 * 
		 */		
		private function onCompleteLoadSound(event:Event):void
		{
			_soundFileCount++;
			//trace("URL : " + event.currentTarget.url);
			var temp:String = event.currentTarget.url;
			temp = temp.replace(_soundDirectory.url + "/", "");
			//trace("temp = " + temp);
			_soundDic[temp] = event.currentTarget as Sound;
			
			if(_soundFileCount >= _soundArray.length)
			{
				_soundArray.splice(0, _soundArray.length);
				loadComplete();
			}
			_completeFunc();
		}
		
		/**
		 * 모든 사운드가 로드됬을때 매니저에 등록하는 메소드 
		 * 
		 */
		private function loadComplete():void
		{
			
			SoundManager.addSound("MainBgm", _soundDic["MainBgm.mp3"]);
			SoundManager.addSound("jump", _soundDic["jump.mp3"]);
			SoundManager.addSound("crashed0", _soundDic["crashed0.mp3"]);
			SoundManager.addSound("crashed1", _soundDic["crashed1.mp3"]);
			SoundManager.addSound("fish", _soundDic["fish.mp3"]);
			SoundManager.addSound("flag", _soundDic["flag.mp3"]);
			SoundManager.addSound("fall", _soundDic["fall.mp3"]);
			SoundManager.addSound("stageFailed", _soundDic["die.mp3"]);
			SoundManager.addSound("stageCleared", _soundDic["stageCleared.mp3"]);
			
			var sound:Sound = _soundDic["MainBgm.mp3"]; 
			sound.volume = 0.5;
			sound.loops = Sound.INFINITE;
			SoundManager.play("MainBgm");
			
			sound = _soundDic["stageFailed.mp3"]; 
			sound.loops = Sound.INFINITE;
			
			sound = _soundDic["stageCleared.mp3"]; 
			sound.loops = Sound.INFINITE;
			
			_isLoadedSoundAll = true;
		}
		
		/**
		 * 사운드 로드에 실패했을때 호출되는 콜백 메소드
		 * @param event
		 * 
		 */
		private function onSoundLoadFailed(event:IOErrorEvent):void
		{
			trace(event.text);
		}
	}	
}