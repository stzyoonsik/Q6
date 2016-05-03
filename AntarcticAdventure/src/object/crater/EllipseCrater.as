package object.crater
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.object.GameObject;
	import trolling.utils.PivotType;
	import flash.geom.Rectangle;

	public class EllipseCrater extends GameObject
	{
		[Embed(source="crater_ellipse_0.png")]
		public static const crater:Class;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _position:int;
		private var _collider:Collider;
		
		public function EllipseCrater(stageWidth:int, stageHeight:int)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			var bitmap:Bitmap = new crater() as Bitmap;
			var image:Image = new Image(bitmap);		
			
			pivot = PivotType.CENTER;
			addComponent(image);
			
			_position = initRandomPosition();
			
			x = _stageWidth / 2;
			y = _stageHeight * 0.4;
			
			//this.width = _stageWidth / 200 + (y / 10) ;
			width = _stageWidth / 20;
			height = width;
			
			_collider = new Collider();
			var rect:Rectangle = new Rectangle();
			rect.width = width * 0.75;
			rect.height = height / 8;
			rect.x = (width / 2) - (rect.width / 2);
			rect.y = (height / 2) - (rect.y / 2);
			
			_collider.rect = rect;
			addComponent(_collider);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function get position():int
		{
			return _position;
		}

		public function set position(value:int):void
		{
			_position = value;
		}

		private function onEnterFrame(event:Event):void
		{			
			if(y > _stageHeight)
			{
				
				dispose();
				removeFromParent();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
			}
			
			//width = (y) - (_stageWidth / 4);
			//height = width;
			scaleY = (y - (_stageHeight / 3)) / 100;
			scaleX = scaleY;
			y += MainStage.speed;
			
			switch(_position)
			{
				//왼쪽
				case 0:
					x -= MainStage.speed;
					break;
				//가운데
				case 1:
					break;
				//오른쪽
				case 2:
					x += MainStage.speed;
					break;
				default:
					break;
			}
		}
		
		/**
		 * 
		 * @return 0~2 사이의 랜덤 값
		 * 
		 */
		public function initRandomPosition():int
		{			
			var randomNum:Number = Math.random();
			
			if(randomNum < 0.33)
				return 0;
			else if(randomNum < 0.66)
				return 1;
			else
				return 2;			
		}
		
		
		
//		private function initSize():void
//		{
//			width = _stageWidth / 20 + (y / 2);
//			height = width;
//		}
	}
}