package scene.gameScene.object.home
{
	import scene.gameScene.MainStage;
	import scene.gameScene.object.Objects;
	import scene.gameScene.util.PlayerState;
	import scene.loading.ResourceLoad;
	
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.utils.PivotType;
	
	public class Home extends Objects
	{		
		public function Home(resource:ResourceLoad)
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			this.pivot = PivotType.CENTER;
			
			this.x = _stageWidth / 2;
			this.y = _stageHeight * 0.35;
			
			this.width = _stageWidth * 0.1;
			this.height = this.width;
			
			_image = new Image(resource.getSubTexture("MainStageSprite0.png", "home0"));
			
			addComponent(_image);
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{	
			this.scaleY += 0.025 * MainStage.speed;
			this.scaleX = this.scaleY;
			this.y += MainStage.speed / 2;
			
			if(this.y > _stageHeight * 0.475)
			{
				removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
				dispatchEvent(new TrollingEvent(PlayerState.ARRIVE));
			}
		}
	}
}