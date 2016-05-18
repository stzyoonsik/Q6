package Select
{
	import Select.Background.Background;
	import Select.Load.Load;
	import Select.Objects.Objects;
	import Select.Save.Save;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class Select extends Sprite
	{
		
		private var _objects:Objects = new Objects();
		private var _background:Background = new Background();
		private var _save:Save = new Save();
		private var _load:Load = new Load();
		
		public function Select()
		{
			_objects.x = 50;
			_objects.y = 50;
			addChild(_objects);
			_objects.addEventListener("object", onClickObject);
			
			_background.y = 500;
			addChild(_background);
			_background.addEventListener("curve", onClickCurve);
			_background.addEventListener("color", onClickColor);
			
			_save.x = 224;
			_save.y = 700;
			addChild(_save);
			_save.addEventListener("save", onClickSave);
			
			_load.x = 32;
			_load.y = 700;
			addChild(_load);
			_load.addEventListener("load", onClickLoad);
		}
		
		private function onClickObject(event:Event):void
		{			
			dispatchEvent(new Event("object", false, event.data));		
		}
		
		private function onClickSave(event:Event):void
		{
			dispatchEvent(new Event("save"));
		}
		
		private function onClickLoad(event:Event):void
		{
			dispatchEvent(new Event("load", false, event.data));			
		}
		
		private function onClickCurve(event:Event):void
		{
			dispatchEvent(new Event("curve", false, event.data));
		}
		
		private function onClickColor(event:Event):void
		{
			dispatchEvent(new Event("color", false, event.data));
		}
		
		public function exportJSON(stageNum:int, backgroundColor:int, curve:Vector.<int>, object:Vector.<int>):void
		{
			_save.exportJSON(stageNum, backgroundColor, curve, object);
		}
	}
}