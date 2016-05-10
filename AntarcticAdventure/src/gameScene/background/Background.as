package gameScene.background
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import gameScene.MainStage;
	
	import trolling.component.animation.Animator;
	import trolling.component.animation.State;
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	public class Background extends GameObject
	{
		[Embed(source="topBackground0.png")]
		public static const topBackground0:Class;
		
		[Embed(source="bottomBackground0.png")]
		public static const bottomBackground0:Class;
		
		[Embed(source="bottomBackground1.png")]
		public static const bottomBackground1:Class;
		
		[Embed(source="bottomBackgroundLeft0.png")]
		public static const bottomBackgroundLeft0:Class;
		
		[Embed(source="bottomBackgroundLeft1.png")]
		public static const bottomBackgroundLeft1:Class;
		
		[Embed(source="bottomBackgroundLeft2.png")]
		public static const bottomBackgroundLeft2:Class;
		
		[Embed(source="bottomBackgroundRight0.png")]
		public static const bottomBackgroundRight0:Class;
		
		[Embed(source="bottomBackgroundRight1.png")]
		public static const bottomBackgroundRight1:Class;
		
		[Embed(source="bottomBackgroundRight2.png")]
		public static const bottomBackgroundRight2:Class;
		
		/** -1 = normal, 0 = left, 1 = right*/
		private var _curve:int = -1;
		
		private var _topBackground:GameObject = new GameObject();
		private var _bottomBackground:GameObject = new GameObject();
		
		private var _bitmap:Bitmap;
		private var _image:Image;
		private var _animator:Animator;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		public function get curve():int	{ return _curve; }		
		public function set curve(value:int):void { _curve = value; }
		
		public function Background()
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			_bitmap = new topBackground0() as Bitmap;
			_image = new Image(new Texture(_bitmap));			
			_topBackground.addComponent(_image);
			
			_topBackground.width = _stageWidth;
			_topBackground.height = _stageHeight / 10 * 3.33;
				
			addChild(_topBackground);	
			
			
			
			_bottomBackground.width = _stageWidth;
			_bottomBackground.height = _stageHeight / 10 * 6.66;	
			_bottomBackground.y = _stageHeight / 10 * 3.33;
			
			_animator = new Animator();
			
			var state:State = new State("curve_none"); 				
			_bitmap = new bottomBackground0() as Bitmap;
			state.addFrame(new Texture(_bitmap));
			_bitmap = new bottomBackground1() as Bitmap;
			state.addFrame(new Texture(_bitmap));
			_animator.addState(state);
			state.interval= ((MainStage.maxSpeed - MainStage.speed) + 1) * 5;
			
			
			state = new State("curve_left"); 						
			_bitmap = new bottomBackgroundLeft0() as Bitmap;
			state.addFrame(new Texture(_bitmap));
			_bitmap = new bottomBackgroundLeft1() as Bitmap;
			state.addFrame(new Texture(_bitmap));
			_bitmap = new bottomBackgroundLeft2() as Bitmap;
			state.addFrame(new Texture(_bitmap));	
			_animator.addState(state);
			state.interval= ((MainStage.maxSpeed - MainStage.speed) + 1) * 5;
			
			
			state = new State("curve_right"); 						
			_bitmap = new bottomBackgroundRight0() as Bitmap;
			state.addFrame(new Texture(_bitmap));
			_bitmap = new bottomBackgroundRight1() as Bitmap;
			state.addFrame(new Texture(_bitmap));
			_bitmap = new bottomBackgroundRight2() as Bitmap;
			state.addFrame(new Texture(_bitmap));	
			_animator.addState(state);
			state.interval= ((MainStage.maxSpeed - MainStage.speed) + 1) * 5;
			
			state.play();				
			_bottomBackground.addComponent(_animator);
			addChild(_bottomBackground);
			
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);			
		}
		
		

		private function onEnterFrame(event:TrollingEvent):void
		{
			if(MainStage.speed == 0)
			{
				//trace("배경 프리즈");
				_animator.freeze(true);
			}
			else
			{				
				_animator.freeze(false);
				switch(_curve)
				{
					case -1:						
						_animator.getState("curve_none").interval = ((MainStage.maxSpeed - MainStage.speed) + 1) * 5;
						break;
					case 0:
						_animator.getState("curve_left").interval = ((MainStage.maxSpeed - MainStage.speed) + 1) * 5;
						break;
					case 1:
						_animator.getState("curve_right").interval = ((MainStage.maxSpeed - MainStage.speed) + 1) * 5;
						break;
					default:
						break;
				}
			}
			
		}
		
		/**
		 * 
		 * @param curveNum 변경할 커브길 번호 (-1 = 일반, 0 = 왼쪽, 1 = 오른쪽)
		 * 해당 길로 애니메이션을 바꿔주는 메소드
		 */
		public function changeCurve(curveNum:int):void
		{
			_curve = curveNum;
			switch(curveNum)
			{
				case -1:
					_bottomBackground.transition("curve_none");
					break;
				case 0:
					_bottomBackground.transition("curve_left");
					break;
				case 1:
					_bottomBackground.transition("curve_right");
					break;
				default:
					break;				
			}
		}
	}
}