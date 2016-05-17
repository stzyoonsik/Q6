package scene.loading
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import trolling.media.Sound;
	import trolling.media.SoundManager;
	import trolling.rendering.Texture;
	
	public class Resources
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
		
		public function Resources(spriteDirectory:File = null, soundDirectory:File = null)
		{
			_spriteSheetDic = new Dictionary();
			_soundDic = new Dictionary();
			
			_spriteName = new Vector.<String>();
			_soundName = new Vector.<String>();
			
			_loadedCount = 0;
			
			_spriteDir = spriteDirectory;
			_soundDir = soundDirectory;
		}
		
		public function loadResource(callbackFunction:Function, faildFunction:Function):void
		{
			_callbackFunc = callbackFunction;
			_faildFunc = faildFunction;
			
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
					soundURLRequest = new URLRequest(_soundDir.resolvePath(_soundName[j]).url);
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
			var soundFileName:String = Sound(event.currentTarget).url.replace(_soundDir.url.toString()+"/", "");
			_soundDic[soundFileName] = event.currentTarget as Sound;
			Sound(event.currentTarget).removeEventListener(Event.COMPLETE, onSoundLoaded);
			Sound(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadFaild);
			
			SoundManager.addSound(soundFileName, _soundDic[soundFileName]);
			
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
		
		public function addSpriteName(spriteFileName:String):void
		{
			_spriteName.push(spriteFileName);
		}
		
		public function addSoundName(soundFileName:String):void
		{
			_soundName.push(soundFileName);
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