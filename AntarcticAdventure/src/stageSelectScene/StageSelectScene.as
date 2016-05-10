package stageSelectScene
{
	import flash.events.Event;
	
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.object.Scene;

	public class StageSelectScene extends Scene
	{
		[Embed(source="selectSceneBackGround.jpg")]
		private static const selectSceneBackGround:Class;
		
		private var _backGround:GameObject;
		private var _backGroundImage:Image;
		private var _object:GameObject;
		private var _objectImage:Image;
		
		public function StageSelectScene()
		{
			addEventListener(TrollingEvent.START_SCENE, onInit);
		}
		
		private function onInit(event:Event):void
		{
			
		}
	}
}