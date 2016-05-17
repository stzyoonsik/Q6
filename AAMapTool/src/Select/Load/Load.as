package Select.Load
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import Asset.Assets;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class Load extends Sprite
	{
		private var _loadButton:Button;
		
		public function Load()
		{
			init();
			pushEvent();
		}
		
		private function init():void
		{
			var texture:Texture = Texture.fromEmbeddedAsset(Assets.Load);
			_loadButton = new Button(texture);
			_loadButton.width = 128;
			_loadButton.height = 128;			
			addChild(_loadButton);
		}
		
		private function pushEvent():void
		{
			_loadButton.addEventListener(TouchEvent.TOUCH, onClickLoad);
		}
		
		private function onClickLoad(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_loadButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("loadButton");
				loadJSON();				
			}	
		}
		
		private function loadJSON():void
		{
			var file:File = File.documentsDirectory;
			file.browseForOpen("");//("select json file");
			file.addEventListener(flash.events.Event.SELECT, onFileSelected);	
		}
		
		private function onFileSelected(event:flash.events.Event):void
		{
			trace(event.target.url);
			var urlRequest:URLRequest = new URLRequest(event.target.url);
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(flash.events.Event.COMPLETE, onCompleteLoadJSON);
			
			try
			{
				urlLoader.load(urlRequest);
			} 
			catch (error:Error)
			{
				trace("Cannot load : " + error.message);
			}
		}
		
		private function onCompleteLoadJSON(event:flash.events.Event):void
		{
			var loader:URLLoader = URLLoader(event.target);			
			
			var data:Object = JSON.parse(loader.data);
			dispatchEvent(new starling.events.Event("load", false, data));
		}
		
	}
}