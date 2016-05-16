package scene.loading
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class ResourceLoad
	{	
		private var _spriteSheetDic:Dictionary;
		private var _soundDic:Dictionary;
		
		private var _spriteName:Vector.<String>;
		private var _soundName:Vector.<String>;
		
		private var _callbackFunc:Function;
		private var _faildFunc:Function;
		
		private var _spriteDir:File;
		private var _soundDir:File;
		
		private var _loadedCount:uint;
		
		public function ResourceLoad(callbackFunction:Function, faildFunction:Function)
		{
			_spriteSheetDic = new Dictionary();
			_soundDic = new Dictionary();
			
			_spriteName = new Vector.<String>();
			_soundName = new Vector.<String>();
			
			_loadedCount = 0;
			
			_callbackFunc = callbackFunction;
			_faildFunc = faildFunction;
		}
		
		public function loadResource(spriteDirectory:File = null, soundDirectory:File = null):void
		{
			_spriteDir = spriteDirectory;
			_soundDir = soundDirectory;
			
			trace(_spriteDir.url);
			trace(_soundDir.url);
			
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
			
			if(_soundDir != null)
			{
				var sound:Sound;
				var soundURLRequest:URLRequest;
				for(var j:int = 0; j < _soundName.length; j++)
				{
					soundURLRequest = new URLRequest(_soundDir.resolvePath(_soundName[i]).url);
					sound = new Sound();
					sound.addEventListener(Event.COMPLETE, onSoundLoaded);
					sound.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadFaild);
					sound.load(soundURLRequest);
				}
				sound = null;
				soundURLRequest = null;
			}
		}
		
		private function onSoundLoaded(event:Event):void
		{
			trace(Sound(event.currentTarget).url.replace(_soundDir.url.toString()+"/", ""));
			_soundDic[Sound(event.currentTarget).url.replace(_soundDir.url.toString()+"/", "")] = event.currentTarget as Sound;
			Sound(event.currentTarget).removeEventListener(Event.COMPLETE, onSoundLoaded);
			Sound(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadFaild);
			_loadedCount++;
			checkLoadComplete();
		}
		
		private function onSoundLoadFaild(event:IOErrorEvent):void
		{
			_faildFunc(event.text);
		}
		
		private function onCompleteSpriteLoad(name:String, spriteBitmap:Bitmap, xml:XML):void
		{
			var spriteSheet:SpriteSheet = new SpriteSheet(name, spriteBitmap, xml);
			_spriteSheetDic[name] = spriteSheet;
			trace(spriteSheet.name);
			_loadedCount++;
			checkLoadComplete();
		}
		
		private function onFaildSpriteLoad(message:String):void
		{
			_faildFunc(message);
		}
		
		private function checkLoadComplete():void
		{
			trace("_loadedCount = " + _loadedCount);
			if(_loadedCount >= (_spriteName.length + _soundName.length))
			{
				_spriteName.splice(0, _spriteName.length);
				_soundName.splice(0, _soundName.length);
				
				_callbackFunc();
			}
		}
		
		public function get soundDic():Dictionary
		{
			return _soundDic;
		}
		
		public function set soundDic(value:Dictionary):void
		{
			_soundDic = value;
		}
		
		public function get spriteSheetDic():Dictionary
		{
			return _spriteSheetDic;
		}
		
		public function set spriteSheetDic(value:Dictionary):void
		{
			_spriteSheetDic = value;
		}
		
		public function get soundName():Vector.<String>
		{
			return _soundName;
		}
		
		public function set soundName(value:Vector.<String>):void
		{
			_soundName = value;
		}
		
		public function get spriteName():Vector.<String>
		{
			return _spriteName;
		}
		
		public function set spriteName(value:Vector.<String>):void
		{
			_spriteName = value;
		}
	}
}