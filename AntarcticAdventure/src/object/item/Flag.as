package object.item
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import trolling.component.ComponentType;
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.object.GameObject;
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
		
		private var _position:int;
		private var _collider:Collider;
		
		public function Flag(stageWidth:int, stageHeight:int)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			//var color:int = initRandomColor();
			var bitmap:Bitmap = initRandomColor(bitmap);
			
			
			var image:Image = new Image(bitmap);
			
			pivot = PivotType.CENTER;
			addComponent(image);
			
			_position = initRandomPosition();
			
			x = _stageWidth / 2;
			y = _stageHeight / 2;
			
			width = y / 2;
			height = width;
			
			_collider = new Collider();
			var rect:Rectangle = new Rectangle();
			rect.width = width;
			rect.height = height;
			_collider.rect = rect;
			addComponent(_collider);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			addEventListener("collideFlag", onCollidePlayer);
			
		}
		
		private function initRandomColor(bitmap:Bitmap):Bitmap
		{
			var randomNum:Number = Math.random();
			var color:int;
			if(randomNum < 0.25)
				color = 0;
			else if(randomNum < 0.5)
				color = 1;
			else if(randomNum < 0.75)
				color = 2;
			else
				color = 3;	
			
			switch(color)
			{
				case 0:
					bitmap = new blueFlag() as Bitmap;
					break;
				case 1:
					bitmap = new greenFlag() as Bitmap;
					break;
				case 3:
					bitmap = new redFlag() as Bitmap;
					break;
				case 4:
					bitmap = new yellowFlag() as Bitmap;
					break;
				default:
					break;
				
			}
			
			return bitmap;
		}
		
		private function onEnterFrame(event:Event):void
		{			
			if(y > _stageHeight)
			{
				//initSize();
				//x = _stageWidth / 2;
				//y = _stageHeight /2;
				//_position = initRandomPosition();
			

				dispose();
				removeFromParent();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				removeEventListener("collideFlag", onCollidePlayer);
			}
			
			width = y / 2;
			height = width;
			
			y += MainStage.speed;
			
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