package scene.gameScene.object.item
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import scene.gameScene.MainStage;
	import scene.gameScene.ObjectTag;
	import scene.gameScene.loading.Resource;
	import scene.gameScene.object.Objects;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	public class Flag extends Objects
	{
		public function Flag(direction)
		{
			this.tag = ObjectTag.ITEM;
			
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			initRandomColor();
			
			var bitmap:Bitmap;		
			var image:Image = new Image(new Texture(Resource.imageDic["flag0"]));	
			
			this.pivot = PivotType.CENTER;
			addComponent(image);
			
			_direction = direction;
			
			this.x = _stageWidth / 2;
			this.y = _stageHeight * 0.35;
			
			this.width = _stageWidth * 0.025;
			this.height = width;
			
			_collider = new Collider();
			_collider.setRect(0.25, 0.33);
			//colliderRender = true;
			addComponent(_collider);
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			
			addEventListener("collideFlag", onCollidePlayer);
		}
		
		
		
		private function onEnterFrame(event:TrollingEvent):void
		{			
			if(this.y > _stageHeight)
			{
				dispose();
				removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
				removeEventListener("collideFlag", onCollidePlayer);
			}
			
			
			if(MainStage.speed != 0)
			{
				this.scaleY += setScale(0.025);
				this.scaleX = this.scaleY;
				
				this._addY += y / 2400;
				this.y += (MainStage.speed + this._addY);
				
				switch(_direction)
				{
					//왼쪽
					case 0:
						this.x -= (MainStage.speed + this._addY) * 0.75;
						break;
					//오른쪽
					case 1:
						this.x += (MainStage.speed + this._addY) * 0.75;
						break;
					
					default:
						break;
				}
			}			
			
		}
		
		
		/**
		 *  플레이어와 깃발이 충돌했을때 깃발을 지워줌
		 * 
		 */
		private function onCollidePlayer(event:Event):void
		{
			dispose();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener("collideFlag", onCollidePlayer);
			
		}
	}
}