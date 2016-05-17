package Select.Save
{
	import flash.events.Event;
	import flash.filesystem.File;
	
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
		
		private function onClickSave(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_saveButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("saveButton");
				dispatchEvent(new starling.events.Event("save"));
			}	
		}
		
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
			file.save(str);
		}
		
		private function fileSaved(event:flash.events.Event):void 
		{ 
			trace("Done."); 
		}
	}
}