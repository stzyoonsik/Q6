package background
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
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
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		//private var _state:State;
		
		public function Background(stageWidth:int, stageHeight:int)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			_bitmap = new topBackground0() as Bitmap;
			_image = new Image(_bitmap);			
			
			_topBackground.width = _stageWidth;
			_topBackground.height = _stageHeight / 10 * 3.33;
			_topBackground.addComponent(_image);	
			addChild(_topBackground);
			
			
			
			_animator = new Animator(); 
			var state:State = new State("background"); 
			_animator.addState(state);
			
			_bitmap = new bottomBackground0() as Bitmap;
			state.addFrame(_bitmap);
			_bitmap = new bottomBackground1() as Bitmap;
			state.addFrame(_bitmap);
			
			state.animationSpeed = MainStage.speed / 3;
			state.play();
			
			_bottomBackground.width = _stageWidth;
			_bottomBackground.height = _stageHeight / 10 * 6.66;	
			_bottomBackground.y = _stageHeight / 10 * 3.33;
			_bottomBackground.addComponent(_animator);
			addChild(_bottomBackground);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			
		}
		
		private function onEnterFrame(event:Event):void
		{
			_animator.getState("background").animationSpeed = (_stageHeight / 100) - (MainStage.speed / 3 * 2);
			
			//trace(_animator.getState("background").animationSpeed);
			
			
		}
	}
}