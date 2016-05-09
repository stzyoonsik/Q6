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
		
		private var _speed:int;
		
		public function get isLeft():Boolean { return _isLeft; }
		
		public function Cloud()
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			pivot = PivotType.CENTER;
			var bitmap:Bitmap = new cloud() as Bitmap;
			var image:Image = new Image(new Texture(bitmap));				
			
			addComponent(image);
			
			var point:Point = initRandomPosition();
			this.x = point.x;
			this.y = point.y;
			
			this.width = (_stageWidth / 10) - (this.y / 2);
			this.height = this.width;
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
		}
	

		private function onEnterFrame(event:TrollingEvent):void
		{		
			_speed = MainStage.speed;
			if(this.y < 0)
			{
				dispose();
				removeFromParent();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}			
			
			this.width = (_stageWidth / 10) - (this.y / 2)
			this.height = this.width;
			
			if(isLeft)
			{
				this.x -= _speed / 5;
				this.y -= _speed/ 5;
			}
			else
			{
				this.x += _speed / 5;
				this.y -= _speed / 5;
			}
		}
		
		/**
		 * 구름의 초기 좌표를 랜덤하게 생성해주는 메소드 
		 * @return 
		 * 
		 */
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