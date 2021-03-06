package scene.gameScene.object.item
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import scene.gameScene.MainStage;
	import scene.gameScene.util.ObjectTag;
	import scene.gameScene.object.Objects;
	import loading.Resources;
	import loading.Resources;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.utils.PivotType;

	public class Coke extends Objects
	{
		private var _image:Image;
		
		public function Coke(resource:loading.Resources, direction:int)
		{
			this.tag = ObjectTag.ITEM;
			
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;			
			
			
			var bitmap:Bitmap;		
			
			_image = new Image(resource.getSubTexture("MainStageSprite0.png", "coke0"));	
			
			this.pivot = PivotType.CENTER;
			addComponent(_image);
			
			_direction = direction;
			
			initPosition();
			
			this.width = _stageWidth * 0.01;
			this.height = width;
			
			_collider = new Collider();
			_collider.setRect(0.25, 0.33);
			//colliderRender = true;
			addComponent(_collider);
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			
			addEventListener("collideCoke", onCollidePlayer);
		}
		
		private function initPosition():void
		{
			if(_direction == 0)
				this.x = _stageWidth * 0.475;
			else if(_direction == 1)
				this.x = _stageWidth * 0.525;
			else
				this.x = _stageWidth * 0.5;
			
			this.y = _stageHeight * 0.4;
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{			
			if(this.y > _stageHeight)
			{
				dispose();
				removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
				removeEventListener("collideCoke", onCollidePlayer);
			}
			
			
			if(MainStage.speed != 0)
			{
				this.scaleY += setScale(0.03);
				this.scaleX = this.scaleY;
				
				this._addY += y / (_stageHeight * 3.5);
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
			removeEventListener("collideCoke", onCollidePlayer);
			
		}
	}
}