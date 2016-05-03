package object.crater
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.object.GameObject;
	import trolling.utils.PivotType;

	public class RectangleCrater extends GameObject
	{
		[Embed(source="crater_rect_0.png")]
		public static const rectangleCrater:Class;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _position:int;
		private var _collider:Collider;
		
		public function RectangleCrater(stageWidth:int, stageHeight:int)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			var bitmap:Bitmap = new rectangleCrater() as Bitmap;
			var image:Image = new Image(bitmap);
			
			pivot = PivotType.CENTER;
			addComponent(image);
			
			_position = initRandomPosition();
			
			x = _stageWidth / 2;
			y = _stageHeight * 0.4;
			
			width = _stageWidth / 10;
			height = width;
			
			_collider = new Collider();
			var rect:Rectangle = new Rectangle();
			rect.width = width * 0.75;
			rect.height = height / 16;
			rect.x = (width / 2) - (rect.width / 2);
			rect.y = (height / 2) - (rect.y / 2);
			trace(rect);
			_collider.rect = rect;
			addComponent(_collider);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		private function onEnterFrame(event:Event):void
		{			
			if(y > _stageHeight)
			{				
				dispose();
				removeFromParent();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			
			//width = (y) - (_stageWidth / 10);
			//height = width;
			
			scaleY = (y - (_stageHeight / 3)) / 100;
			scaleX = scaleY;
			
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
	}
}