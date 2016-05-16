package scene.loading
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import trolling.object.GameObject;
	import flash.display.Bitmap;

	public class Resource extends GameObject
	{
		private var _resourceLoader:ResourceLoader;
		private static var _imageDic:Dictionary;
		
		private static var _spriteSheet:SpriteSheet;
		private var _sprite:File = File.applicationDirectory.resolvePath("scene").resolvePath("gameScene").resolvePath("sprite").resolvePath("MainStageSprite1.png");
		
		public static function get imageDic():Dictionary { return _imageDic; }
		
		
		public function Resource()
		{
			_resourceLoader = new ResourceLoader(onLoadImageComplete);
			loadFromSprite(_sprite.url, "MainStageSprite1");
		}		

		private function clone(original:Dictionary):Dictionary
		{
			var cloned:Dictionary = new Dictionary();
			for(var key:Object in original)
			{
				if(original[key] is Dictionary)
					cloned[key] = clone(original[key]);
				else
					cloned[key] = original[key];
			}
			return cloned;
		}
		
		private function onLoadImageComplete():void
		{			
			if(_resourceLoader.isLoadedImageAll && _resourceLoader.isLoadedSoundAll)
			{
				_imageDic = clone(_resourceLoader.bitmapDic);
				
				//dispatchEvent(new Event("loadedAllImages"));
			}
		}
		
		public function loadFromSprite(filePath:String, fileName:String):void
		{
			//trace("Try To Load Sprite");
			var spriteLoader:SpriteLoader = new SpriteLoader(onLoadSpriteComplete, onLoadSpriteFail);
			spriteLoader.loadSprite(filePath, fileName);
		}
		
		private function onLoadSpriteComplete(name:String, spriteBitmap:Bitmap, xml:XML):void
		{
			_spriteSheet = new SpriteSheet(name, spriteBitmap, xml);
			//trace("SPRITE SHEET LOADED" + Resource.spriteSheet.subTextures["topBackground0"]);
			dispatchEvent(new Event("loadedAllImages"));
		}
		
		private function onLoadSpriteFail(errorMessage:String):void
		{
			trace("Sprite Loading Failed" + errorMessage);
		}
		
		public static function get spriteSheet():SpriteSheet
		{
			return _spriteSheet;
		}
		
		public static function set spriteSheet(value:SpriteSheet):void
		{
			_spriteSheet = value;
		}

	}
}