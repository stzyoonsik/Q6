package Select.Save
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.ICipher;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import Asset.Assets;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class Save extends Sprite
	{
		private var _saveButton:Button;
		
		public function Save()
		{
			init();
			pushEvent();
		}
		
		private function init():void
		{
			var texture:Texture = Texture.fromEmbeddedAsset(Assets.Save);
			_saveButton = new Button(texture);
			_saveButton.width = 128;
			_saveButton.height = 128;			
			addChild(_saveButton);
		}
		
		private function pushEvent():void
		{
			_saveButton.addEventListener(TouchEvent.TOUCH, onClickSave);
		}
		
		/**
		 * 
		 * @param event 터치이벤트
		 * 세이브 버튼을 클릭했을때 호출되는 콜백 메소드 
		 */
		private function onClickSave(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_saveButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("saveButton");
				dispatchEvent(new starling.events.Event("save"));
			}	
		}
		
		/**
		 * 
		 * @param stageNum 스테이지 번호
		 * @param backgroundColor 배경 색
		 * @param curve 커브길
		 * @param object 오브젝트
		 * 입력 데이터들을 JSON 포맷에 맞게 인코딩 하여 저장하는 메소드
		 */
		public function exportJSON(stageNum:int, backgroundColor:int, curve:Vector.<int>, object:Vector.<int>):void
		{
			var file:File = File.applicationDirectory.resolvePath("stage" + stageNum + ".json");
			
			var stageStr:String = "{\n\t\"stage\" : " + stageNum.toString() + ",\n";
			
			var bgColorStr:String = "\t\"backgroundColor\" : " + backgroundColor.toString() + ",\n";
			
			var curveStr:String = "\t\"curve\" : [";			
			for(var i:int = 0; i<curve.length; ++i)
			{
				if(i == 0)
					curveStr = curveStr.concat(curve[i].toString());
				else
					curveStr = curveStr.concat("," + curve[i].toString());
			}
			curveStr = curveStr.concat("],\n");
			
			var objectStr:String = "\t\"object\" : [";			
			for(i = 0; i<object.length; ++i)
			{
				if(i == 0)
					objectStr = objectStr.concat(object[i].toString());
				else
					objectStr = objectStr.concat("," + object[i].toString());
			}
			objectStr = objectStr.concat("]\n}"); 
			
			var str:String = stageStr + bgColorStr + curveStr + objectStr;
			
			str = AesCrypto.encrypt(str, "jiminhyeyunyoonsik");
//			var strBA:ByteArray = encrypt(str);
			
			file.save(str);
		}
		
//		private function encrypt(str:String):ByteArray
//		{
//			var result:ByteArray = new ByteArray();
//			
//			var key:ByteArray = new ByteArray();
//			key.writeUTF("abcd");
//			var aes:ICipher = Crypto.getCipher("blowfish-ecb", key, Crypto.getPad("pkcs5"));
//			
//			result.writeUTFBytes(str);
//			aes.encrypt(result);			
//			
//			return result;
//		}
		
		/**
		 *  
		 * @param event
		 * 세이브의 성공을 알리는 콜백메소드
		 */
		private function fileSaved(event:flash.events.Event):void 
		{ 
			trace("Saved."); 
		}
	}
}