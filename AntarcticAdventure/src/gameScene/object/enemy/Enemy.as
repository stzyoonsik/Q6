package gameScene.object.enemy  
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import gameScene.util.PlayerState;
	
	import trolling.component.animation.Animator;
	import trolling.component.animation.State;
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	public class Enemy extends GameObject
	{
		[Embed(source="enemy_0.png")]
		public static const enemy0:Class; 
		[Embed(source="enemy_1.png")]
		public static const enemy1:Class; 
		[Embed(source="enemy_2.png")]
		public static const enemy2:Class; 
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _animator:Animator;
		//private var _image:Image;
		private var _bitmap:Bitmap;
		
		private var _collider:Collider;
		
		
		//private var _bitmapVector:Vector.<Bitmap> = new Vector.<Bitmap>();
		//private var _textureVector:Vector.<Texture> = new Vector.<Texture>();
		
		//private var _texture:Texture;
		
		public function Enemy(stageWidth:int, stageHeight:int)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
					
			
			
			_animator = new Animator(); 
			var state:State = new State("enemy0");
			_bitmap = new enemy0() as Bitmap;
			state.addFrame(new Texture(_bitmap));
			_animator.addState(state);
			state.interval = 60;
			
			state = new State("enemy1");
			_bitmap = new enemy1() as Bitmap;
			state.addFrame(new Texture(_bitmap));
			_animator.addState(state);
			state.interval = 60;
			
			state = new State("enemy2");
			_bitmap = new enemy2() as Bitmap;
			state.addFrame(new Texture(_bitmap));
			_animator.addState(state);
			state.interval = 60;
			
//			state = new State("enemy");
//			//_bitmap = new enemy2() as Bitmap;
//			state.addFrame(new Texture(_bitmap));
//			state.interval = 60;
			
			
			state.play();
			
			
			addComponent(_animator);	
			
			//_image = new Image(_bitmapVector[0]);		
			
			pivot = PivotType.CENTER;
			//addComponent(_image);
			
			
			this.x = 0;
			this.y = -this.height / 10;
			
			this.width = _stageWidth / 30;
			this.height = this.width;
			
			_collider = new Collider();
			_collider.setRect(0.4, 0.4);
			colliderRender = true;
			addComponent(_collider);
			
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{
//			scaleY = (y - (_stageHeight / 3)) / 100;
//			scaleX = scaleY;
			
			if(this.parent.y < _stageHeight * 0.6)
			{
				trace(this.parent.y);
				_animator.transition("enemy0");				
			}
			else if(this.parent.y < _stageHeight * 0.7)
			{
				_animator.transition("enemy1");				
			}
			else
			{
				_animator.transition("enemy2");	
			}
				 //_image.texture = _bitmapVector[0];
		}
		
		
		
	}
}