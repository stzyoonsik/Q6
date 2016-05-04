package gameScene.object.enemy  
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import gameScene.util.PlayerState;
	
	import trolling.component.animation.Animator;
	import trolling.component.animation.State;
	import trolling.component.graphic.Image;
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
		
		//private var _animator:Animator;
		private var _image:Image;
		private var _bitmap:Bitmap;
		private var _bitmapVector:Vector.<Bitmap> = new Vector.<Bitmap>();
		private var _textureVector:Vector.<Texture> = new Vector.<Texture>();
		
		private var _texture:Texture;
		
		public function Enemy(stageWidth:int, stageHeight:int)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
//			_animator = new Animator(); 
//			
//			var state:State = new State("enemy_appear");
//			_bitmap = new enemy0() as Bitmap;
//			state.addFrame(_bitmap);
//			_bitmap = new enemy1() as Bitmap;
//			state.addFrame(_bitmap);
//			_bitmap = new enemy2() as Bitmap;
//			state.addFrame(_bitmap);
//			_animator.addState(state);
//			state.interval = 15;
//			
//			state = new State("enemy");
//			_bitmap = new enemy2() as Bitmap;
//			state.addFrame(_bitmap);
//			state.interval = 60;
//			
//			
//			state.play();
//						
//			
//			addComponent(_animator);			
			_bitmap = new enemy0() as Bitmap;
			_bitmapVector.push(_bitmap);
			_bitmap = new enemy1() as Bitmap;
			_bitmapVector.push(_bitmap);
			_bitmap = new enemy2() as Bitmap;
			_bitmapVector.push(_bitmap);
			
			_image = new Image(_bitmapVector[0]);		
			
			pivot = PivotType.CENTER;
			addComponent(_image);
			
			
			this.x = _stageWidth / 2;
			this.y = _stageHeight / 2;
			
			this.width = _stageWidth / 10;
			this.height = this.width;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_texture = new Texture(_bitmapVector[0]);
		}
		
		private function onEnterFrame(event:Event):void
		{
			if(this.parent.y < _stageHeight * 0.5)
			{
				
			}
				 //_image.texture = _bitmapVector[0];
		}
		
		
	}
}