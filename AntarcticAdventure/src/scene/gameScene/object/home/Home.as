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
		
		public function Home(resource:Resources, ratio:Number)
		{
			_resource = resource;
			
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			initNationFlag(ratio);
			
			this.pivot = PivotType.CENTER;
			
			this.x = _stageWidth / 2;
			this.y = _stageHeight * 0.35;
			
			this.width = _stageWidth * 0.1;
			this.height = this.width;
			
			_image = new Image(_resource.getSubTexture("MainStageSprite0.png", "home0"));
			
			addComponent(_image);
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function initNationFlag(ratio:Number):void
		{
			_nationFlag.pivot = PivotType.CENTER;
			
			if(ratio <= 0.5)
			{
				_image = new Image(_resource.getSubTexture("MainStageSprite0.png", "hmnim0"));
			}
			else if(ratio <= 0.8)
			{
				_image = new Image(_resource.getSubTexture("MainStageSprite0.png", "jmnim0"));
			}
			else
			{
				_image = new Image(_resource.getSubTexture("MainStageSprite0.png", "jynim0"));
			}
			
			_nationFlag.width = _stageWidth / 60;
			_nationFlag.height = _stageHeight / 45;
			_nationFlag.x = _stageWidth / 106;
			_nationFlag.y = -_stageHeight / 36;
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
				
				if(_nationFlag.y > -_stageHeight / 27)
				{
					_nationFlag.y -= _stageHeight * 0.0001;					
				}
				
			}
		}
	}
}