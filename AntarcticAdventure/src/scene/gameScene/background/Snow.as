package scene.gameScene.background
{
	import flash.events.Event;
	
	import loading.Resources;
	
	import scene.gameScene.MainStage;
	
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.utils.PivotType;

	public class Snow extends GameObject
	{
		private var _stageWidth:int;
		private var _stageHeight:int;
			
		
		public function Snow(resource:Resources)
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			pivot = PivotType.CENTER;
			
			var image:Image = new Image(resource.getSubTexture("MainStageSprite0.png", "snow0"));	
			addComponent(image);
			
			initRandomPosAndSize();			
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
		}
		
		
		private function onEnterFrame(event:TrollingEvent):void
		{		
			if(this.y > _stageHeight)
			{
				this.y = 0;
				//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}	
			
			this.y += _stageHeight * 0.001;
		}
		
		/**
		 * 구름의 초기 좌표를 랜덤하게 생성해주는 메소드 
		 * @return 
		 * 
		 */
		private function initRandomPosAndSize():void
		{
			var randomNum:Number = Math.random();						
			
			this.x = randomNum * _stageWidth;
			this.y = 0;
			
			
			while(randomNum != 0)
			{
				randomNum = Math.random();
				this.width = randomNum * _stageWidth * 0.1;
				this.height = this.width;
			}
		}
	}
}