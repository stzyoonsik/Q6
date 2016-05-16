package scene.gameScene.background
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import scene.gameScene.MainStage;
	import scene.loading.Resource;
	
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	public class Cloud extends GameObject
	{		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _isLeft:Boolean;		
		
		public function Cloud()
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			pivot = PivotType.CENTER;
			
			var image:Image = new Image(Resource.spriteSheet.subTextures["cloud0"]);	
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
			if(this.y < 0)
			{
				dispose();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}			
			
			this.width = (_stageWidth / 10) - (this.y / 2)
			this.height = this.width;
			
			if(_isLeft)
			{
				this.x -= MainStage.speed / 5;
				this.y -= MainStage.speed/ 5;
			}
			else
			{
				this.x += MainStage.speed / 5;
				this.y -= MainStage.speed / 5;
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
					point.x = (Math.random() * _stageWidth * 0.3) + (_stageWidth * 0.1);
					point.y = (Math.random() * _stageHeight * 0.2) + (_stageHeight * 0.1);					
					break;
				case false:
					point.x = (Math.random() * _stageWidth * 0.3) + (_stageWidth * 0.6);
					point.y = (Math.random() * _stageHeight * 0.2) + (_stageHeight * 0.1);				
					break;
				default:
					break;
			}
			return point;
		}
	}
}