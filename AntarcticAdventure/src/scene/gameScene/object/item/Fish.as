package scene.gameScene.object.item
{
	import flash.events.Event;
	
	import scene.gameScene.MainStage;
	import scene.gameScene.ObjectTag;
	import scene.gameScene.object.Objects;
	import scene.loading.Resource;
	import scene.loading.ResourceLoad;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	public class Fish extends Objects
	{		
		private var _imageIndex:int;
		
		private var _jumpSpeed:int;
		private var _jumpHeight:int;
		private var _jumpTheta:Number = 0;
		
		private var _resource:ResourceLoad;
		
		public function Fish(resource:ResourceLoad, direction:int)
		{
			this.tag = ObjectTag.ITEM;
			
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			_direction = direction;
			
			_jumpSpeed = 6;
			_jumpHeight = _stageHeight / 30;			
			
			//_image = new Image(null);
			
			_resource = resource;
			if(direction == 0)
				_image = new Image(resource.getSubTexture("MainStageSprite0.png", "leftFish0"));
			else
				_image = new Image(resource.getSubTexture("MainStageSprite0.png", "rightFish0"));
			
			initRandomColor();			
			
			
			addComponent(_image);
			
			this.pivot = PivotType.CENTER;			
			
			this.x = 0;
			this.y = 0;
			
			this.width = _stageWidth * 0.01;
			this.height = this.width;
			
			_collider = new Collider();
			_collider.setRect(0.5, 0.5);
			//colliderRender = true;
			addComponent(_collider);			
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			addEventListener("collideFish", onCollidePlayer);
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{
			changeImage();			
			
			var degree:Number = _jumpTheta * Math.PI / 180;
			this.y = -(Math.sin(degree) * _jumpHeight);
			
			if(_direction == 0)
				this.x -= _stageWidth / 700;
			else
				this.x += _stageWidth / 700;
			
			_jumpTheta += _jumpSpeed;
			
			if(_jumpTheta > 180)
			{
				trace("생선 삭제");
				dispose();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				removeEventListener("collideFish", onCollidePlayer);
			}
		}
		
		private function changeImage():void
		{
			if(_jumpTheta < 60)
			{
				if(_imageIndex == 0)
				{
					_imageIndex++;
				}
			}
			else if(_jumpTheta < 120)
			{				
				if(_imageIndex == 1)
				{
					if(_direction == 0)
						_image.texture = _resource.getSubTexture("MainStageSprite0.png", "leftFish1");
					else
						_image.texture = _resource.getSubTexture("MainStageSprite0.png", "rightFish1");
					
					_imageIndex++;
				}			
			}			
			else
			{
				if(_imageIndex == 2)
				{
					if(_direction == 0)
						_image.texture = _resource.getSubTexture("MainStageSprite0.png", "leftFish2");
					else
						_image.texture = _resource.getSubTexture("MainStageSprite0.png", "leftFish2");
					
					_imageIndex++;
				}				
			}
		}
		
		/**
		 *  플레이어와 생선이 충돌했을때 생선을 지워줌
		 * 
		 */
		private function onCollidePlayer(event:Event):void
		{
			dispose();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener("collideFish", onCollidePlayer);			
		}
	}
}

