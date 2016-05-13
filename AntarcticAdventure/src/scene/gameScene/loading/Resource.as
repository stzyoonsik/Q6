package scene.gameScene.loading
{
	import flash.utils.Dictionary;
	
	import trolling.object.GameObject;
	import flash.events.Event;

	public class Resource extends GameObject
	{
		private var _resourceLoader:ResourceLoader;
		private static var _imageDic:Dictionary;
		
		public static function get imageDic():Dictionary { return _imageDic; }
		
		
		public function Resource()
		{
			_resourceLoader = new ResourceLoader(onLoadImageComplete);
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
			if(_resourceLoader.isLoadedImageAll)
			{
				_imageDic = clone(_resourceLoader.bitmapDic);
				
				dispatchEvent(new Event("loadedAllImages"));
			}
		}
	}
}