package scene.gameScene.object.crater
{
	import flash.events.Event;
	
	import scene.gameScene.MainStage;
	import scene.gameScene.ObjectTag;
	import scene.gameScene.object.Objects;
	import loading.Resources;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.utils.PivotType;
	
	public class RectangleCrater extends Objects
	{
		
		private var _left:GameObject = new GameObject();
		private var _right:GameObject = new GameObject();
		private var _middle:GameObject = new GameObject();
		
		private var _leftCollider:Collider = new Collider();
		private var _rightCollider:Collider = new Collider();
		private var _middleCollider:Collider = new Collider();		
		
		public function RectangleCrater(resource:Resources, direction)
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			var image:Image = new Image(resource.getSubTexture("MainStageSprite0.png", "rectCrater0"));
			this.pivot = PivotType.CENTER;
			addComponent(image);
			
			_direction = direction;			
			
			_left.pivot = PivotType.CENTER;
			_right.pivot = PivotType.CENTER;
			_middle.pivot = PivotType.CENTER;
			
			initPosition();			
			
			this.width = _stageWidth * 0.025;
			this.height = this.width;
			
			initCollider();			
			
			_left.addComponent(_leftCollider);
			_middle.addComponent(_middleCollider);
			_right.addComponent(_rightCollider);
			
			addChild(_left);
			addChild(_middle);
			addChild(_right);
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			addEventListener("fall", onFall);
		}
		
		private function initPosition():void
		{
			if(_direction == 0)
				this.x = _stageWidth * 0.475;
			else
				this.x = _stageWidth * 0.525;
			
			this.y = _stageHeight * 0.4;
		}
		
		private function initCollider():void
		{
			_middle.tag = ObjectTag.ENEMY;
			_middle.name = "middle";
			_middle.width = width / 2;
			_middle.height = height / 9;
			_middle.x = 0;
			_middle.y = 0;
			_middleCollider.setRect(1,1);
			
			_left.tag = ObjectTag.ENEMY;
			_left.name = "left";
			_left.width = width / 5;
			_left.height = height / 8;
			_left.x = -((_middle.width/2)+(_left.width/2));
			_left.y = 0;
			_leftCollider.setRect(1, 1);
			
			_right.tag = ObjectTag.ENEMY;
			_right.name = "right";
			_right.width = width / 5;
			_right.height = height / 8;
			_right.x = ((_middle.width/2)+(_right.width/2));
			_right.y = 0;
			_rightCollider.setRect(1,1);
			
			//_left.colliderRender = true; 
			//_middle.colliderRender = true;
			//_right.colliderRender = true;
			//colliderRender = true;
		}
		 
		private function onEnterFrame(event:TrollingEvent):void
		{           
			if(this.y > _stageHeight)
			{               
				dispose();
				removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
				removeEventListener("fall", onFall);
			}			
			
			//trace(_addY);
			if(MainStage.speed != 0)
			{
				this.scaleY += setScale(0.07);
				this.scaleX = this.scaleY;
				
				this._addY += y / 2400;
				this.y += (MainStage.speed + this._addY);
				
				switch(_direction)
				{
					//왼쪽
					case 0:
						this.x -= (MainStage.speed + this._addY) * 0.6;
						break;
					//오른쪽
					case 1:
						this.x += (MainStage.speed + this._addY) * 0.6;
						break;
					
					default:
						break;
				}
			}
		}
		
		/**
		 *  플레이어와 깃발이 충돌했을때 콜라이더를 지워줌
		 * 
		 */
		private function onFall(event:Event):void		
		{
			_leftCollider.isActive = false;
			_middleCollider.isActive = false;
			_rightCollider.isActive = false;
			removeEventListener("fall", onFall);			
		}
		
	}
}