package gameScene.object.crater
{
	import flash.display.Bitmap;
	
	import gameScene.MainStage;
	import gameScene.object.Objects;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	public class RectangleCrater extends Objects
	{
		[Embed(source="rectCrater0.png")]
		public static const rectangleCrater:Class;
		
		private var _left:GameObject = new GameObject();
		private var _right:GameObject = new GameObject();
		private var _middle:GameObject = new GameObject();
		
		private var _leftCollider:Collider = new Collider();
		private var _rightCollider:Collider = new Collider();
		private var _middleCollider:Collider = new Collider();		
		
		public function RectangleCrater(direction)
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			var bitmap:Bitmap = new rectangleCrater() as Bitmap;
			var image:Image = new Image(new Texture(bitmap));
			
			this.pivot = PivotType.CENTER;
			addComponent(image);
			
			_direction = direction;
			
			
			_left.pivot = PivotType.CENTER;
			_right.pivot = PivotType.CENTER;
			_middle.pivot = PivotType.CENTER;
			
			if(_direction == 0)
				this.x = _stageWidth * 0.475;
			else
				this.x = _stageWidth * 0.525;
			this.y = _stageHeight * 0.4;
			
			
			this.width = _stageWidth * 0.05;
			this.height = this.width;
			
			_middle.name = "middle";
			_middle.width = width / 2;
			_middle.height = height / 9;
			_middle.x = 0;
			_middle.y = 0;
			_middleCollider.setRect(1,1);
			
			_left.name = "left";
			_left.width = width / 5;
			_left.height = height / 8;
			_left.x = -((_middle.width/2)+(_left.width/2));
			_left.y = 0;
			_leftCollider.setRect(1, 1);
			
			_right.name = "right";
			_right.width = width / 5;
			_right.height = height / 8;
			_right.x = ((_middle.width/2)+(_right.width/2));
			_right.y = 0;
			_rightCollider.setRect(1,1);
			
			_left.colliderRender = false; 
			_middle.colliderRender = false;
			_right.colliderRender = false;
			
			_left.addComponent(_leftCollider);
			_middle.addComponent(_middleCollider);
			_right.addComponent(_rightCollider);
			
			//colliderRender = true;
			addChild(_left);
			addChild(_middle);
			addChild(_right);
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			
			//this.scaleY = 0.5;
			//this.scaleX = scaleY;
			
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{           
			if(this.y > _stageHeight)
			{               
				dispose();
				removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			}			
			
			this.scaleY += 0.03 * MainStage.speed;
			this.scaleX = this.scaleY;
			
			this.y += MainStage.speed;
			
			
			switch(_direction)
			{
				//왼쪽
				case 0:
					this.x -= MainStage.speed * 0.5;
					break;
				//오른쪽
				case 1:
					this.x += MainStage.speed * 0.5;
					break;
				
				default:
					break;
			}
		}		
	}
}