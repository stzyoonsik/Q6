package
{
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	import Select.Select;
	
	import View.View;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		private var _select:Select = new Select();
		private var _view:View = new View();
		
		public function Main()
		{
			addChild(_select);
			
			_view.x = 500;
			addChild(_view);
			
			_select.addEventListener("object", onClickObject);
			_select.addEventListener("save", onClickSave);
			_select.addEventListener("curve", onClickCurve);
			_select.addEventListener("color", onClickColor);
		}
		
		private function onClickObject(event:starling.events.Event):void
		{			
			_view.dispatchEvent(new starling.events.Event("object", false, event.data));		
		}
		
		private function onClickSave(event:starling.events.Event):void
		{				
			_select.exportJSON(_view.stageNum, _view.color, _view.curveDataVector, _view.objectDataVector);			
		}
		
		private function onClickCurve(event:starling.events.Event):void
		{
			_view.dispatchEvent(new starling.events.Event("curve", false, event.data));
		}
		
		private function onClickColor(event:starling.events.Event):void
		{
			_view.dispatchEvent(new starling.events.Event("color", false, event.data));
		}
		
		
	}
}