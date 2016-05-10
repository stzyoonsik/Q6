package gameScene.object.item
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import gameScene.MainStage;
	import gameScene.object.Objects;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	public class Fish extends Objects
	{
		[Embed(source="leftFish0.png")]
		public static const leftFish0:Class; 
		[Embed(source="leftFish1.png")]
		public static const leftFish1:Class;  
		[Embed(source="leftFish2.png")]
		public static const leftFish2:Class; 
		
		[Embed(source="rightFish0.png")]
		public static const rightFish0:Class; 
		[Embed(source="rightFish1.png")]
		public static const rightFish1:Class;  
		[Embed(source="rightFish2.png")]
		public static const rightFish2:Class; 
		
		private var _imageIndex:int;
		
		private var _jumpSpeed:int;
		private var _jumpHeight:int;
		private var _jumpTheta:Number = 0;
		
		
		public function Fish(direction:int)
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
	
			_direction = direction;
			
			_jumpSpeed = 4;
			_jumpHeight = _stageHeight / 15;
			
			
			if(direction == 0)
				_bitmap = new leftFish0() as Bitmap;
			else
				_bitmap = new rightFish0() as Bitmap;
			
			initRandomColor();			
			
			_image = new Image(new Texture(_bitmap));
			addComponent(_image);
			
			this.pivot = PivotType.CENTER;
			
			
			this.x = 0;
			this.y = 0;
			
			this.width = _stageWidth / 50;
			this.height = this.width;
			
			_collider = new Collider();
			_collider.setRect(0.5, 0.5);
			//colliderRender = true;
			addComponent(_collider);			
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			addEventListener("collideFish", onCollidePlayer);
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{
			if(_jumpTheta < 60)
			{
				if(_imageIndex == 0)
				{
					_imageIndex++;
				}
			}
			else if(_jumpTheta < 120)
			{				
				if(_imageIndex == 1)
				{
					if(_direction == 0)
						_bitmap = new leftFish1() as Bitmap;
					else
						_bitmap = new rightFish1() as Bitmap;
					
					_image.texture = new Texture(_bitmap);
					_imageIndex++;
				}			
			}			
			else
			{
				if(_imageIndex == 2)
				{
					if(_direction == 0)
						_bitmap = new leftFish2() as Bitmap;
					else
						_bitmap = new rightFish2() as Bitmap;
					
					_image.texture = new Texture(_bitmap);
					_imageIndex++;
				}				
			}
			
			
			var degree:Number = _jumpTheta * Math.PI / 180;
			this.y = -(Math.sin(degree) * _jumpHeight);
			
			if(_direction == 0)
				this.x -= _stageWidth / 700;
			else
				this.x += _stageWidth / 700;
			
			_jumpTheta += _jumpSpeed;
			
			if(_jumpTheta > 180)
			{
				trace("생선 삭제");
				dispose();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				removeEventListener("collideFish", onCollidePlayer);
			}
		}
		
		/**
		 *  플레이어와 생선이 충돌했을때 생선을 지워줌
		 * 
		 */
		private function onCollidePlayer(event:Event):void
		{
			dispose();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener("collideFish", onCollidePlayer);
			
		}
	}
}

