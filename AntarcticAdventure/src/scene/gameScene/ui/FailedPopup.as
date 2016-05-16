package scene.gameScene.ui
{
	import flash.utils.Dictionary;
	
	import scene.gameScene.MainStage;
	
	import trolling.core.SceneManager;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	
	import ui.Popup;
	import ui.button.Button;

	public class FailedPopup extends Popup
	{
		private const REPLAY:int = 0;
		private const MENU:int = 1;
		
		public function FailedPopup(canvas:Texture)
		{
			super(canvas);
		}
		
		public override function dispose():void
		{
			var child:GameObject = getChild(REPLAY);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedReplay);
			
			child = getChild(MENU);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedMenu);
			
			super.dispose();
		}
		
		public function initialize(bitmaps:Dictionary):void
		{
			var stageButtonX:Number = this.width / 10;
			// REPLAY
			var replay:Button = new Button(new Texture(bitmaps[UIResource.REPLAY]));
			replay.x = -stageButtonX;
			replay.y = this.height / 3.5;
			replay.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedReplay);
			
			delete bitmaps[UIResource.REPLAY];
			//
			
			// MENU
			var menu:Button = new Button(new Texture(bitmaps[UIResource.MENU]));
			menu.x = stageButtonX;
			menu.y = replay.y + 3;
			menu.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedMenu);
			
			delete bitmaps[UIResource.MENU];
			//
			
			addChild(replay);
			addChild(menu);
		}
		
		private function onEndedReplay(event:TrollingEvent):void
		{
			trace("다시하긔");
			SceneManager.restartScene(MainStage, "Game", MainStage.currentStage);
		}
		
		private function onEndedMenu(event:TrollingEvent):void
		{
			SceneManager.switchScene("stageSelect", MainStage.currentStage);
			SceneManager.deleteScene("Game");
		}
	}
}