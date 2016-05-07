package gameScene.background
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	
	import gameScene.MainStage;
	
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	public class Cloud extends GameObject
	{
		[Embed(source="cloud0.png")]
		public static const cloud:Class;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _isLeft:Boolean;
		
		public function get isLeft():Boolean { return _isLeft; }
		
		public function Cloud(stageWidth:int, stageHeight:int)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			pivot = PivotType.CENTER;
			var bitmap:Bitmap = new cloud() as Bitmap;
			var image:Image = new Image(new Texture(bitmap));		
			
			
			addComponent(image);
			
			var point:Point = initRandomPosition();
			x = point.x;
			y = point.y;
			
			//this.width = _stageWidth / 200 + (y / 10) ;
			width = (_stageWidth / 10) - (y / 2);
			height = width;
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
		}
	

		private function onEnterFrame(event:TrollingEvent):void
		{		
			var speed:int = MainStage.speed;
			if(y < 0)
			{
				dispose();
				removeFromParent();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}			
			
			width = (_stageWidth / 10) - (y / 2)
			height = width;
			
			if(isLeft)
			{
				x -= speed / 5;
				y -= speed/ 5;
			}
			else
			{
				x += speed / 5;
				y -= speed / 5;
			}
		}
		
		private function initRandomPosition():Point
		{
			var randomNum:Number = Math.random();
						
			_isLeft = (randomNum < 0.5) ? true : false;
			
			
			var point:Point = new Point(0,0);
						
			switch(_isLeft)
			{
				case true:					
					point.x = (Math.random() * _stageWidth / 10 * 3) + (_stageWidth / 10);
					point.y = (Math.random() * _stageHeight / 10 * 3) + (_stageHeight / 10);					
					break;
				case false:
					point.x = (Math.random() * _stageWidth / 10 * 3) + (_stageWidth / 10 * 6);
					point.y = (Math.random() * _stageHeight / 10 * 3) + (_stageHeight / 10);					
					break;
				default:
					break;
			}
			return point;
		}
	}
}