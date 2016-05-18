package Select.Load
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.ICipher;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
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
		
		/**
		 * 
		 * @param event 터치이벤트
		 * 로드 버튼을 클릭하면 호출되는 콜백 메소드
		 */
		private function onClickLoad(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_loadButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("loadButton");
				loadJSON();				
			}	
		}
		
		/**
		 * 
		 * json 파일을 선택하여 열도록 하는 메소드
		 */
		private function loadJSON():void
		{
			var file:File = File.applicationDirectory;
			var filter:FileFilter = new FileFilter("JSON", "*.json"); 
			file.browseForOpen("select json file", [filter]);
			file.addEventListener(flash.events.Event.SELECT, onFileSelected);	
		}
		
		/**
		 * 
		 * @param event
		 * 선택된 파일을 로딩하는 콜백 메소드
		 */
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
		
		/**
		 * 
		 * @param event
		 * 선택된 JSON파일의 로딩이 끝났을때 호출되는 콜백 메소드
		 */
		private function onCompleteLoadJSON(event:flash.events.Event):void
		{
			var loader:URLLoader = URLLoader(event.target);		
			
			var decryptData:String = AesCrypto.decrypt(loader.data, "jiminhyeyunyoonsik");
			var data:Object = JSON.parse(decryptData);
			trace(decryptData);
			dispatchEvent(new starling.events.Event("load", false, data));
		}
		
		
//		private function decrypt(data):String
//		{
//			
//			var result:String;
//			//var result:ByteArray = new ByteArray();
//			
//			var key:ByteArray = new ByteArray();
//			key.writeUTF("abcd");
//			var aes:ICipher = Crypto.getCipher("blowfish-ecb", key, Crypto.getPad("pkcs5"));
//			
//			//result.writeUTFBytes(str);
//			aes.decrypt(data);	
//			
//			result = data;
//			
//			return result;
//			
//		}
		


		
	}
}