package gameScene.object.item
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import gameScene.MainStage;
	
	import trolling.component.ComponentType;
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	public class Flag extends GameObject
	{
		[Embed(source="blueFlag.png")]
		public static const blueFlag:Class;
		
		[Embed(source="greenFlag.png")]
		public static const greenFlag:Class;
		
		[Embed(source="redFlag.png")]
		public static const redFlag:Class;
		
		[Embed(source="yellowFlag.png")]
		public static const yellowFlag:Class;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _direction:int;
		private var _collider:Collider;
		
		public function Flag(stageWidth:int, stageHeight:int, direction)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			//var color:int = initRandomColor();
			var bitmap:Bitmap = initRandomColor(bitmap);
			
			
			var image:Image = new Image(new Texture(bitmap));	
			
			pivot = PivotType.CENTER;
			addComponent(image);
			
			_direction = direction;
			
			x = _stageWidth / 2;
			y = _stageHeight * 0.4;
			
			width = _stageWidth / 20;
			height = width;
			
			_collider = new Collider();
//			var rect:Rectangle = new Rectangle();
//			rect.width = width / 4;
//			rect.height = height / 3;
//			rect.x = (width / 2) - (rect.width / 2);
//			rect.y = (height / 2) - (rect.y / 2);
			_collider.setRect(0.25, 0.33);
			addComponent(_collider);
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			
			addEventListener("collideFlag", onCollidePlayer);
			
		}
		
		private function initRandomColor(bitmap:Bitmap):Bitmap
		{
			var randomNum:Number = Math.random();
			
			if(randomNum < 0.25)
				bitmap = new blueFlag() as Bitmap;
			else if(randomNum < 0.5)
				bitmap = new greenFlag() as Bitmap;
			else if(randomNum < 0.75)
				bitmap = new redFlag() as Bitmap;
			else
				bitmap = new yellowFlag() as Bitmap;
			
			return bitmap;
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{			
			if(y > _stageHeight)
			{
				//initSize();
				//x = _stageWidth / 2;
				//y = _stageHeight /2;
				//_position = initRandomPosition();
			

				dispose();
				removeFromParent();
				removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
				removeEventListener("collideFlag", onCollidePlayer);
			}
					
			
			scaleY = (y - (_stageHeight / 3)) / 100;
			scaleX = scaleY;
			
			y += MainStage.speed;
			
			switch(_direction)
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
		
		
//		public function initRandomPosition():int
//		{			
//			var randomNum:Number = Math.random();
//			
//			if(randomNum < 0.5)
//				return 0;
//			else
//				return 1;			
//		}
		
		/**
		 *  플레이어와 깃발이 충돌했을때 깃발을 지워줌
		 * 
		 */
		private function onCollidePlayer(event:Event):void
		{
//			trace("aa");
//			dispose();
//			removeComponent(ComponentType.COLLIDER);
//			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
//			removeEventListener("collideFlag", onCollidePlayer);
//			removeFromParent();
			
		}
	}
}