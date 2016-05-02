package object.enemy  
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import trolling.component.graphic.Image;
	import trolling.object.GameObject;
	import trolling.utils.PivotType;

	public class Enemy extends GameObject
	{
		[Embed(source="enemy2.png")]
		public static const enemy2:Class;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		
		
		public function Enemy(stageWidth:int, stageHeight:int)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			var bitmap:Bitmap = new enemy2() as Bitmap;
			var image:Image = new Image(bitmap);			
			
			
			this.pivot = PivotType.CENTER;
			addComponent(image);
			
			this.x = _stageWidth / 2;
			this.y = _stageHeight / 2;
			
			this.width = _stageWidth / 10;
			this.height = this.width;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			width = (_stageWidth / 10) + (y / 2);
			height = width;
			
			
			if(y > _stageHeight)
			{
				//initSize();
				y = _stageHeight / 2;
			}
		}
		
//		private function initSize():void
//		{
//			width = _stageWidth / 10;
//			height = width;
//		}
		
	}
}