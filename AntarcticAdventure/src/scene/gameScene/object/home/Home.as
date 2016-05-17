package scene.gameScene.object.home
{
	import scene.gameScene.MainStage;
	import scene.gameScene.object.Objects;
	import scene.gameScene.util.PlayerState;
	import scene.loading.ResourceLoad;
	
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import scene.loading.Resource;
	
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	public class Home extends Objects
	{		
		public function Home(resource:ResourceLoad)
		private var _nationFlag:GameObject = new GameObject();
		
		public function Home()
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			initNationFlag();
			
			this.pivot = PivotType.CENTER;
			
			this.x = _stageWidth / 2;
			this.y = _stageHeight * 0.35;
			
			this.width = _stageWidth * 0.1;
			this.height = this.width;
			
			_image = new Image(resource.getSubTexture("MainStageSprite0.png", "home0"));
			
			addComponent(_image);
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function initNationFlag():void
		{
			_nationFlag.pivot = PivotType.CENTER;
			_image = new Image(Resource.spriteSheet.subTextures["nationFlag0"]);
			_nationFlag.width = 16;
			_nationFlag.height = 12;
			_nationFlag.x = 9;
			_nationFlag.y = -15;
			_nationFlag.addComponent(_image);
			
			addChild(_nationFlag);
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{	
			this.scaleY += 0.025 * MainStage.speed;
			this.scaleX = this.scaleY;
			this.y += MainStage.speed / 2;
			
			if(this.y > _stageHeight * 0.475)
			{
				//removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
				dispatchEvent(new TrollingEvent(PlayerState.ARRIVE));
				if(_nationFlag.y > -20)
				{
					_nationFlag.y -= 0.05;
				}
				
			}
		}
	}
}