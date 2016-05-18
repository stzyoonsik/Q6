package scene.gameScene.object.enemy  
{
	import scene.gameScene.MainStage;
	import scene.gameScene.ObjectTag;
	import scene.gameScene.object.Objects;
	import loading.Resources;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.utils.PivotType;
	
	public class Enemy extends Objects
	{		
		private var _imageIndex:int;
		private var _resource:Resources;
		
		public function Enemy(resource:Resources)
		{
			this.tag = ObjectTag.ENEMY;
			
			_stageWidth = MainStage.stageWidth; 
			_stageHeight = MainStage.stageHeight;
			
			_resource = resource;
			
			_image = new Image(_resource.getSubTexture("MainStageSprite0.png", "enemy0"));
			addComponent(_image);
			
			this.pivot = PivotType.CENTER;			
			
			this.x = 0;
			this.y = -this.height * 0.03;			
			
			this.width = _stageWidth * 0.02;
			this.height = this.width;				
			
			_collider = new Collider();
			_collider.setRect(0.4, 0.4);
			//colliderRender = true;
			addComponent(_collider);
			
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{
			if(this.parent.y < _stageHeight * 0.6)
			{
				if(_imageIndex == 0)
				{
					_imageIndex++;
				}
			}
			else if(this.parent.y < _stageHeight * 0.7)
			{				
				if(_imageIndex == 1)
				{
					_image.texture = _resource.getSubTexture("MainStageSprite0.png", "enemy1");
					_imageIndex++;
				}			
			}			
			else
			{
				if(_imageIndex == 2)
				{
					_image.texture = _resource.getSubTexture("MainStageSprite0.png", "enemy2");
					_imageIndex++;
				}				
			}
			
		}
	}
}