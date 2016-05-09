package gameScene.object.item
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import gameScene.MainStage;
	
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
		
		public function Flag(direction)
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			var bitmap:Bitmap;
			bitmap = initRandomColor(bitmap);			
			var image:Image = new Image(new Texture(bitmap));	
			
			this.pivot = PivotType.CENTER;
			addComponent(image);
			
			_direction = direction;
			
			this.x = _stageWidth / 2;
			this.y = _stageHeight * 0.4;
			
			this.width = _stageWidth / 20;
			this.height = width;
			
			_collider = new Collider();
			_collider.setRect(0.25, 0.33);
			colliderRender = true;
			addComponent(_collider);
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			
			addEventListener("collideFlag", onCollidePlayer);
			
		}
		
		/**
		 * 
		 * @param bitmap
		 * @return 
		 * 
		 */
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
			if(this.y > _stageHeight)
			{
				dispose();
				removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
				removeEventListener("collideFlag", onCollidePlayer);
			}
					
			
			this.scaleY = (this.y - (_stageHeight / 3)) / 100;
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
		
		
		/**
		 *  플레이어와 깃발이 충돌했을때 깃발을 지워줌
		 * 
		 */
		private function onCollidePlayer(event:Event):void
		{
			dispose();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener("collideFlag", onCollidePlayer);
			
		}
	}
}