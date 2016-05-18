package loading
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import trolling.media.Sound;
	import trolling.media.SoundManager;
	import trolling.rendering.Texture;
	
	public class Resources extends EventDispatcher
	{	
		private var _spriteSheetDic:Dictionary;
		private var _soundDic:Dictionary;
		private var _imageDic:Dictionary;
		
		private var _spriteName:Vector.<String>;
		private var _soundName:Vector.<String>;
		private var _imageName:Vector.<String>;

		private var _spriteDir:File;
		private var _soundDir:File;
		private var _imageDir:File;
		
		private var _loadedCount:uint;
		
		public function Resources(spriteDirectory:File = null, soundDirectory:File = null, imageDirectory:File = null)
		{
			_spriteSheetDic = new Dictionary();
			_soundDic = new Dictionary();
			_imageDic = new Dictionary();
			
			_spriteName = new Vector.<String>();
			_soundName = new Vector.<String>();
			_imageName = new Vector.<String>();
			
			_loadedCount = 0;
			
			_spriteDir = spriteDirectory;
			_soundDir = soundDirectory;
			_imageDir = imageDirectory;
		}
		
		public function loadResource():void
		{
			if (_spriteDir) trace(_spriteDir.url);
			if (_soundDir)	trace(_soundDir.url);
			
			if(_spriteDir != null)
			{
				var spriteLoader:SpriteLoader;
				for(var i:int = 0; i < _spriteName.length; i++)
				{
					spriteLoader = new SpriteLoader(onCompleteSpriteLoad, onFaildSpriteLoad);
					spriteLoader.loadSprite(_spriteDir.resolvePath(_spriteName[i]).url, _spriteName[i]);
				}
				spriteLoader = null;
			}
			
			if(_imageDir != null)
			{
				var imageLoader:Loader;
				var imageURLRequest:URLRequest;
				for(var j:int = 0; j < _imageName.length; j++)
				{
					imageURLRequest = new URLRequest(_imageDir.resolvePath(_imageName[j]).url);
					imageLoader = new Loader();
					imageLoader.loaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
					imageLoader.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadedFailed);
					imageLoader.load(imageURLRequest);
				}
				imageLoader = null;
				imageURLRequest = null;
			}
			
			if(_soundDir != null)
			{
				var sound:Sound;
				var soundURLRequest:URLRequest;
				for(var k:int = 0; k < _soundName.length; k++)
				{
					soundURLRequest = new URLRequest(_soundDir.resolvePath(_soundName[k]).url);
					sound = new Sound();
					sound.addEventListener(Event.COMPLETE, onSoundLoaded);
					sound.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadFailed);
					sound.load(soundURLRequest);
				}
				sound = null;
				soundURLRequest = null;
			}
		}
		
		private function onImageLoaded(event:Event):void
		{
			var imageFileName:String = LoaderInfo(event.currentTarget).url.replace(_imageDir.url.toString()+"/", "");
			trace(imageFileName);
			var imageBitmap:Bitmap = LoaderInfo(event.currentTarget).loader.content as Bitmap;
			var imageTexture:Texture = new Texture(imageBitmap);
			_imageDic[imageFileName] = imageTexture;
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onImageLoaded);
			LoaderInfo(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadedFailed);
			
			_loadedCount++;
			checkLoadComplete(imageFileName);
		}
		
		private function onImageLoadedFailed(event:IOErrorEvent):void
		{
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onImageLoaded);
			LoaderInfo(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadedFailed);
			
			dispatchEvent(new LoadingEvent(LoadingEvent.FAILED, event.text));
		}
		
		private function onSoundLoaded(event:Event):void
		{
			trace(Sound(event.currentTarget).url.replace(_soundDir.url.toString()+"/", ""));
			var soundFileName:String = Sound(event.currentTarget).url.replace(_soundDir.url.toString()+"/", "");
			_soundDic[soundFileName] = event.currentTarget as Sound;
			Sound(event.currentTarget).removeEventListener(Event.COMPLETE, onSoundLoaded);
			Sound(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadFailed);
			
			SoundManager.addSound(soundFileName, _soundDic[soundFileName]);
			
			_loadedCount++;
			checkLoadComplete(soundFileName);
		}
		
		private function onSoundLoadFailed(event:IOErrorEvent):void
		{
			Sound(event.currentTarget).removeEventListener(Event.COMPLETE, onSoundLoaded);
			Sound(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadFailed);
			
			dispatchEvent(new LoadingEvent(LoadingEvent.FAILED, event.text));
		}
		
		private function onCompleteSpriteLoad(name:String, spriteBitmap:Bitmap, xml:XML):void
		{
			var spriteSheet:SpriteSheet = new SpriteSheet(name, spriteBitmap, xml);
			_spriteSheetDic[name] = spriteSheet;
			trace(spriteSheet.name);
			_loadedCount++;
			checkLoadComplete(name);
		}
		
		private function onFaildSpriteLoad(message:String):void
		{
			dispatchEvent(new LoadingEvent(LoadingEvent.FAILED, message));
		}
		
		private function checkLoadComplete(fileName:String):void
		{
			dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, fileName));
			trace("_spriteName.length + _soundName.length + _imageName.length = " + (_spriteName.length + _soundName.length + _imageName.length));
			trace("_loadedCount = " + _loadedCount);
			if(_loadedCount >= (_spriteName.length + _soundName.length + _imageName.length))
			{
				_spriteName.splice(0, _spriteName.length);
				_soundName.splice(0, _soundName.length);
				_imageName.splice(0, _imageName.length);
				
				dispatchEvent(new LoadingEvent(LoadingEvent.COMPLETE));
			}
		}
		
		public function addImageName(imageFileName:String):void
		{
			_imageName.push(imageFileName);
		}
		
		public function addSpriteName(spriteFileName:String):void
		{
			_spriteName.push(spriteFileName);
		}
		
		public function addSoundName(soundFileName:String):void
		{
			_soundName.push(soundFileName);
		}
		
		public function getImageFile(imageFileName:String):Texture
		{
			return (_imageDic[imageFileName] as Texture);
		}
		
		public function getSoundFile(soundFileName:String):Sound
		{
			return (_soundDic[soundFileName] as Sound);
		}
		
		public function getSubTexture(spriteFileName:String, subTextureName:String):Texture
		{
			return (SpriteSheet(_spriteSheetDic[spriteFileName]).subTextures[subTextureName] as Texture);
		}
		
		public function getSpriteSheet(spriteFileName:String):SpriteSheet
		{
			return (_spriteSheetDic[spriteFileName] as SpriteSheet);
		}
	}
}