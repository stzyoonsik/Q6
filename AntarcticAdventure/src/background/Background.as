package background
{
	import flash.display.Bitmap;
	
	import trolling.component.animation.Animator;
	import trolling.component.animation.State;
	import trolling.component.graphic.Image;
	import trolling.object.GameObject;
	import trolling.utils.PivotType;

	public class Background extends GameObject
	{
		[Embed(source="topBackground0.png")]
		public static const topBackground0:Class;
		
		[Embed(source="bottomBackground0.png")]
		public static const bottomBackground0:Class;
		
		[Embed(source="bottomBackground1.png")]
		public static const bottomBackground1:Class;
		
		private var _topBackground:GameObject = new GameObject();
		private var _bottomBackground:GameObject = new GameObject();
		
		private var _bitmap:Bitmap;
		private var _image:Image;
		private var _animator:Animator;
		
		public function Background(stageWidth:int, stageHeight:int)
		{
			
			_bitmap = new topBackground0() as Bitmap;
			_image = new Image(_bitmap);			
			
			_topBackground.width = stageWidth;
			_topBackground.height = stageHeight / 10 * 3.33;
			_topBackground.addComponent(_image);	
			addChild(_topBackground);
			
			
			
//			_bitmap = new bottomBackground0() as Bitmap;
//			_image = new Image(_bitmap);			
//			
				
			
//			_bottomBackground.addComponent(_image);	
//			addChild(_bottomBackground);
			
			_animator = new Animator(); 
			var state:State = _animator.addState("background");
			
			_bitmap = new bottomBackground0() as Bitmap;
			state.addFrame(_bitmap);
			_bitmap = new bottomBackground1() as Bitmap;
			state.addFrame(_bitmap);
			
			state.playSpeed = 5;
			state.play();
			
			_bottomBackground.width = stageWidth;
			_bottomBackground.height = stageHeight / 10 * 6.66;	
			_bottomBackground.y = stageHeight / 10 * 3.33;
			_bottomBackground.addComponent(_animator);
			addChild(_bottomBackground);
			
		}
	}
}