package scene.gameScene.loading
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class ResourceLoader
	{

	

		private var _completeFunt:Function;
		private var _imageDirectory:File;
		private var _imageArray:Array;
		
		private var _fileCount:int;
		
		private var _bitmapDic:Dictionary = new Dictionary();
		
		private var _isLoadedImageAll:Boolean;
		
		public function get isLoadedImageAll():Boolean {	return _isLoadedImageAll; }
		public function get bitmapDic():Dictionary { return _bitmapDic; }
		
		public function ResourceLoader(cFunc:Function)
		{
			_completeFunt = cFunc;
			_imageDirectory = File.applicationDirectory.resolvePath("scene").resolvePath("gameScene").resolvePath("loading").resolvePath("image");
			_imageArray = _imageDirectory.getDirectoryListing();
			
			buildLoader();
		}
		

		private function buildLoader():void
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
			trace(fileName);
			_bitmapDic[fileName] = loaderInfo.loader.content as Bitmap;
			
			loaderInfo.removeEventListener(Event.COMPLETE, onCompleteLoadImage);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onCatchError);
			loaderInfo.loader.unload();
			loaderInfo = null; 
			
			_fileCount++;
			
			
			if (_imageArray.length <= _fileCount)
			{
				//trace("파일 카운트 = " + _fileCount);
				for (var i:int = 0; i < _imageArray.length; i++)
				{
					_imageArray[i] = null;
				}
				_imageArray = null;
				
				_imageDirectory = null;
				_fileCount = 0;
				
				_isLoadedImageAll = true;
			}
			
			_completeFunt();
		}
		
		private function onCatchError(event:IOErrorEvent):void
		{
			trace("onCatchError : Please Check " + LoaderInfo(event.currentTarget).url + ".");
			
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onCompleteLoadImage);
			LoaderInfo(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onCatchError);
		
		}
	}	
}