package scene.gameScene.object.home
{
	import scene.gameScene.MainStage;
	import scene.gameScene.object.Objects;
	import scene.gameScene.util.PlayerState;
	import loading.Resources;
	
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.utils.PivotType;
	
	public class Home extends Objects
	{		
		private var _nationFlag:GameObject = new GameObject();
		private var _resource:Resources;
		private var _isArrivedAtHome:Boolean;
		
		public function Home(resource:Resources)
		{
			_resource = resource;
			
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			initNationFlag();
			
			this.pivot = PivotType.CENTER;
			
			this.x = _stageWidth / 2;
			this.y = _stageHeight * 0.35;
			
			this.width = _stageWidth * 0.1;
			this.height = this.width;
			
			_image = new Image(_resource.getSubTexture("MainStageSprite0.png", "home0"));
			
			addComponent(_image);
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function initNationFlag():void
		{
			_nationFlag.pivot = PivotType.CENTER;
			_image = new Image(_resource.getSubTexture("MainStageSprite0.png", "nationFlag0"));
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
				if(!_isArrivedAtHome)
				{
					dispatchEvent(new TrollingEvent(PlayerState.ARRIVE));
					_isArrivedAtHome = true;
				}
				
				if(_nationFlag.y > -20)
				{
					_nationFlag.y -= 0.05;					
				}
				
			}
		}
	}
}