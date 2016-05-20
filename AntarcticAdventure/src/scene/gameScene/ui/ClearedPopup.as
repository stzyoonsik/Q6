package scene.gameScene.ui
{
	import loading.Resources;
	import loading.SpriteSheet;
	
	import scene.gameScene.MainStage;
	import scene.stageSelectScene.StageSelectScene;
	
	import trolling.component.graphic.Image;
	import trolling.core.SceneManager;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	
	import ui.Popup;
	import ui.button.Button;

	public class ClearedPopup extends Popup
	{
		private const REPLAY:int = 0;
		private const MENU:int = 1;
		private const NEXT:int = 2;
		
		/**
		 * 스테이지 성공 시 표시되는 팝업입니다. 
		 * @author user
		 * 
		 */
		public function ClearedPopup(canvas:Texture)
		{
			super(canvas);
		}
		
		public override function dispose():void
		{
			var child:GameObject = getChild(REPLAY);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedReplay);
			
			child = getChild(MENU);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedMenu);
			
			child = getChild(NEXT);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedNext);
			
			super.dispose();
		}
		
		public function initialize(resources:Resources):void
		{
			var stageButtonX:Number = this.width / 8;
			// REPLAY
			var replay:Button = new Button(
				resources.getSubTexture(UIResource.SPRITE, UIResource.REPLAY));
			replay.x = -stageButtonX;
			replay.y = this.height / 3.5;
			replay.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedReplay); 
			//
			
			var margin:Number = 3;
			// MENU
			var menu:Button = new Button(
				resources.getSubTexture(UIResource.SPRITE, UIResource.MENU));
			menu.y = replay.y + margin;
			menu.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedMenu);
			//
			
			// NEXT
			var next:Button;
			// 마지막 스테이지일 경우 버튼을 비활성화 처리
			if (MainStage.currentStage < StageSelectScene.LAST_STAGE_ID)
			{
				next = new Button(
					resources.getSubTexture(UIResource.SPRITE, UIResource.NEXT_WHITE));
				next.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedNext);
			}
			else
			{
				next = new Button(
					resources.getSubTexture(UIResource.SPRITE, UIResource.NEXT_GRAY));
			}
			
			next.x = stageButtonX;
			next.y = replay.y + margin;
			//
			
			addChild(replay);
			addChild(menu);
			addChild(next);
			
			var spriteSheet:SpriteSheet = resources.getSpriteSheet(UIResource.SPRITE);
			spriteSheet.removeSubTexture(UIResource.NEXT_WHITE);
			spriteSheet.removeSubTexture(UIResource.NEXT_GRAY);
		}
		
		/**
		 * Player가 획득한 깃발 정보를 토대로 별점을 계산하고 결과를 Popup에 표시합니다. 
		 * @param totalFlag 해당 스테이지의 총 깃발 수입니다.
		 * @param obtainedFlag Player가 획득한 깃발 수입니다.
		 * @param resources 별과 숫자 Texture가 저장된 Resources입니다.
		 * 이전에 클리어한 정보가 없거나 이전보다 높은 별점을 획득했을 경우 PlayData를 추가합니다.
		 */
		public function setResult(totalFlag:int, obtainedFlag:int, resources:Resources):void
		{
			var ratio:Number = obtainedFlag / totalFlag * 100; 
			var numStar:int = 1;
			if (ratio <= 50)		numStar = 1;
			else if (ratio <= 80)	numStar = 2;
			else					numStar = 3;
			
			// 클리어 데이터 저장
			var prevStar:int = StageSelectScene.playData.getData(MainStage.currentStage);
			if (numStar > prevStar)
			{
				StageSelectScene.playData.addData(MainStage.currentStage, numStar);
			}
			
			var child:GameObject;
			var childX:Number = -(this.width / 4.19);
			var scale:Number = 0.8;
			var margin:Number = 30;
			
			// star
			for (var i:int = 0; i < 3; i++)
			{
				child = new GameObject;
				if (i < numStar)
				{
					child.addComponent(new Image(resources.getSubTexture(UIResource.SPRITE, UIResource.FILLED_STAR)));
				}
				else
				{
					child.addComponent(new Image(resources.getSubTexture(UIResource.SPRITE, UIResource.STAR)));
				}
				child.x = childX + child.width * i - margin * i;
				child.y = -(this.height / 6.4);
				child.width *= scale;
				child.height *= scale;
				addChild(child);
			}
			
			// flag
			var strTotalFlag:String = totalFlag.toString();
			var strObtainedFlag:String = obtainedFlag.toString();
			var totalFlagIndex:int = strTotalFlag.length - 1;
			var obtainedFlagIndex:int = strObtainedFlag.length - 1;
			childX = -8;
			scale = 0.5;
			margin = 5;
			
			for (i = strTotalFlag.length * 2; i >= 0; i--)
			{
				child = new GameObject();
				if (i < strTotalFlag.length)
				{
					if (obtainedFlagIndex >= 0)
					{
						child.addComponent(new Image(
							resources.getSubTexture(UIResource.SPRITE, strObtainedFlag.charAt(obtainedFlagIndex) + "_white")));
						obtainedFlagIndex--;	
					}
					else
					{
						child.addComponent(new Image(
							resources.getSubTexture(UIResource.SPRITE, "0_white")));
					}
				}
				else if (i > strTotalFlag.length)
				{
					child.addComponent(new Image(
						resources.getSubTexture(UIResource.SPRITE, strTotalFlag.charAt(totalFlagIndex) + "_white")));
					totalFlagIndex--;
				}
				else
				{
					child.addComponent(new Image(
						resources.getSubTexture(UIResource.SPRITE, UIResource.SLASH)));
				}
				child.width *= scale;
				child.height *= scale;  
				child.x = childX + child.width * i + margin * i;
				child.y = this.height / 10.5;
				addChild(child);
			}
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
		
		/**
		 * 다음 스테이지를 시작합니다. 
		 * @param event TrollingEvent.TOUCH_ENDED
		 * 
		 */
		private function onEndedNext(event:TrollingEvent):void
		{
			SceneManager.restartScene(MainStage, "Game", MainStage.currentStage + 1); 
		}
	}
}