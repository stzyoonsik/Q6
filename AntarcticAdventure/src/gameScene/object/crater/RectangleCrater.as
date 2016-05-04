package gameScene.object.crater
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import gameScene.MainStage;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	public class RectangleCrater extends GameObject
	{
		[Embed(source="crater_rect_0.png")]
		public static const rectangleCrater:Class;
		
		private var _left:GameObject = new GameObject();
		private var _right:GameObject = new GameObject();
		private var _middle:GameObject = new GameObject();
		
		private var _leftCollider:Collider = new Collider();
		private var _rightCollider:Collider = new Collider();
		private var _middleCollider:Collider = new Collider();
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _position:int;
		//private var _collider:Collider;
		
		public function RectangleCrater(stageWidth:int, stageHeight:int)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			var bitmap:Bitmap = new rectangleCrater() as Bitmap;
			var image:Image = new Image(new Texture(bitmap));
			
			pivot = PivotType.CENTER;
			addComponent(image);
			
			_position = initRandomPosition();
			
			
			_left.pivot = PivotType.CENTER;
			_right.pivot = PivotType.CENTER;
			_middle.pivot = PivotType.CENTER;
			
			x = _stageWidth / 2;
			y = _stageHeight * 0.4;
			
			
			width = _stageWidth / 10;
			height = width;
			
			_left.width = width / 4;
			_left.height = height / 8;
			_left.x = _left.width*scaleX/2;
			_left.y = height*scaleY/2;
			_leftCollider.setRect(1, 1);
			
			_middle.width = width / 2;
			_middle.height = height / 9;
			_middle.x = (_left.width*scaleX)+(_middle.width*scaleX/2);
			_middle.y = height*scaleY/2;			
			_middleCollider.setRect(1,1);
			
			_right.width = width / 4;
			_right.height = height / 8;
			_right.x = (_left.width*scaleX)+(_middle.width*scaleX)+(_right.width*scaleX/2);
			_right.y = height*scaleY/2;			
			_rightCollider.setRect(1,1);
			
			_left.colliderRender = true; 
			_middle.colliderRender = true;
			_right.colliderRender = true;
			
			_left.addComponent(_leftCollider);
			_middle.addComponent(_middleCollider);
			_right.addComponent(_rightCollider);
			
			colliderRender = true;
			addChild(_left);
			addChild(_middle);
			addChild(_right);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			//trace(_left.getGlobalPoint());
		}
		
		public function get middle():GameObject
		{
			return _middle;
		}
		
		public function get right():GameObject
		{
			return _right;
		}
		
		public function get left():GameObject
		{
			return _left;
		}
		
		private function onEnterFrame(event:Event):void
		{			
			if(y > _stageHeight)
			{				
				dispose();
				removeFromParent();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				//trace(_left.getGlobalPoint());
			}
			
			//width = (y) - (_stageWidth / 10);
			//height = width;
			
			scaleY = (y - (_stageHeight / 3)) / 100;
			scaleX = scaleY;
			
			_left.scaleY = scaleY;
			_left.scaleX = scaleX;
			_left.x = _left.width*_left.scaleX/2;
			_left.y = height*scaleY/2;
			
			_middle.scaleY = scaleY;
			_middle.scaleX = scaleX;
			_middle.x = (_left.width*_left.scaleX)+(_middle.width*_middle.scaleX/2);
			_middle.y = height*scaleY/2;
			
			_right.scaleY = scaleY;
			_right.scaleX = scaleX;
			_right.x = (_left.width*left.scaleX)+(_middle.width*_middle.scaleX)+(_right.width*_right.scaleX/2);
			_right.y = height*scaleY/2;
			
			y += MainStage.speed;
			
			//			_left.y = y;
			//			_right.y = y;
			//			_middle.y = y;
			//			trace(_left.y);
			//			trace(_left.x);
			
			//			trace("parent.y = " + y);
			//			trace("parent.x = " + x);
			
			switch(_position)
			{
				//왼쪽
				case 0:
					x -= MainStage.speed * 0.5;
					break;
				//오른쪽
				case 1:
					x += MainStage.speed * 0.5;
					break;
				
				default:
					break;
			}
		}
		
		public function initRandomPosition():int
		{			
			var randomNum:Number = Math.random();
			
			if(randomNum < 0.5)
				return 0;
			else
				return 1;			
		}
	}
}