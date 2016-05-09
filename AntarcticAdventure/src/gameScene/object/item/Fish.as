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
	
	public class Fish extends GameObject
	{
		[Embed(source="fish_red_left_0.png")]
		public static const fishRedLeft0:Class; 
		[Embed(source="fish_red_left_1.png")]
		public static const fishRedLeft1:Class;  
		[Embed(source="fish_red_left_2.png")]
		public static const fishRedLeft2:Class; 
		
		[Embed(source="fish_red_right_0.png")]
		public static const fishRedRight0:Class; 
		[Embed(source="fish_red_right_1.png")]
		public static const fishRedRight1:Class;  
		[Embed(source="fish_red_right_2.png")]
		public static const fishRedRight2:Class; 
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _image:Image;
		private var _bitmap:Bitmap;
		
		private var _collider:Collider;
		
		private var _direction:int;
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
			_jumpHeight = _stageHeight / 13;
			
			this.pivot = PivotType.CENTER;
			
			
			this.x = 0;
			this.y = 0;
			
			this.width = _stageWidth / 50;
			this.height = this.width;
			
			if(direction == 0)
				_bitmap = new fishRedLeft0() as Bitmap;
			else
				_bitmap = new fishRedRight0() as Bitmap;
			
			_image = new Image(new Texture(_bitmap));
			addComponent(_image);
			
			
			_collider = new Collider();
			_collider.setRect(0.5, 0.5);
			//colliderRender = true;
			addComponent(_collider);
			
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			addEventListener("collideFish", onCollidePlayer);
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{
			if(this.parent.y < _stageHeight * 0.6)
			{
				if(_imageIndex == 0)
				{
					_imageIndex++;
				}
			}
			else if(this.parent.y < _stageHeight * 0.7)
			{				
				if(_imageIndex == 1)
				{
					if(_direction == 0)
						_bitmap = new fishRedLeft1() as Bitmap;
					else
						_bitmap = new fishRedRight1() as Bitmap;
					
					_image.texture = new Texture(_bitmap);
					_imageIndex++;
				}			
			}			
			else
			{
				if(_imageIndex == 2)
				{
					if(_direction == 0)
						_bitmap = new fishRedLeft2() as Bitmap;
					else
						_bitmap = new fishRedRight2() as Bitmap;
					
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

