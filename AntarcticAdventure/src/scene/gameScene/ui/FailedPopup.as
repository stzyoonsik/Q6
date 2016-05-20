package scene.gameScene.ui
{
	import scene.gameScene.MainStage;
	import loading.Resources;
	import loading.SpriteSheet;
	
	import trolling.core.SceneManager;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	
	import ui.Popup;
	import ui.button.Button;

	/**
	 * 스테이지 실패 시 표시되는 팝업입니다. 
	 * @author user
	 * 
	 */
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
		
		public function initialize(resources:Resources):void
		{
			var stageButtonX:Number = this.width / 10;
			// REPLAY
			var replay:Button = new Button(
				resources.getSubTexture(UIResource.SPRITE, UIResource.REPLAY));
			replay.x = -stageButtonX;
			replay.y = this.height / 3.5;
			replay.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedReplay);
			//
			
			// MENU
			var menu:Button = new Button(
				resources.getSubTexture(UIResource.SPRITE, UIResource.MENU));
			menu.x = stageButtonX;
			menu.y = replay.y + 3;
			menu.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedMenu);
			//
			
			addChild(replay);
			addChild(menu);
			
			var spriteSheet:SpriteSheet = resources.getSpriteSheet(UIResource.SPRITE);
			spriteSheet.removeSubTexture(UIResource.REPLAY);
			spriteSheet.removeSubTexture(UIResource.MENU);
		}
		
		/**
		 * 해당 스테이지를 다시 시작합니다. 
		 * @param event TrollingEvent.TOUCH_ENDED
		 * 
		 */
		private function onEndedReplay(event:TrollingEvent):void
		{
			SceneManager.restartScene(MainStage, "Game", MainStage.currentStage);
		}
		
		/**
		 * 스테이지 선택 씬으로 돌아갑니다. 
		 * @param event TrollingEvent.TOUCH_ENDED
		 * 
		 */
		private function onEndedMenu(event:TrollingEvent):void
		{
			SceneManager.outScene(MainStage.currentStage);
		}
	}
}