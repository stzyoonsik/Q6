package scene.gameScene.background
{
	import flash.display.Bitmap;
	
	import scene.gameScene.MainStage;
	import scene.gameScene.loading.Resource;
	
	import trolling.component.animation.Animator;
	import trolling.component.animation.State;
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	public class Background extends GameObject
	{		
		/** -1 = normal, 0 = left, 1 = right*/
		private var _curve:int = -1;
		
		private var _topBackground:GameObject = new GameObject();
		private var _bottomBackground:GameObject = new GameObject();
		private var _topBackgroundMountain:GameObject = new GameObject();
		
		private var _bitmap:Bitmap;
		private var _image:Image;
		private var _animator:Animator;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		public function get curve():int	{ return _curve; }		
		
		public function Background(color:int)
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			//_image = new Image(new Texture(Resource.imageDic["topBackground0"]));	
			_image = new Image(Resource.spriteSheet.subTextures["topBackground0"]);	
			
			_topBackground.addComponent(_image); 
			
			_topBackground.width = _stageWidth;
			_topBackground.height = _stageHeight / 10 * 3.33;
			
			initColor(color);
			
			addChild(_topBackground);	
			
			_topBackgroundMountain.pivot = PivotType.CENTER;
			//_image = new Image(new Texture(Resource.imageDic["topBackgroundMountain0"]));	
			_image = new Image(Resource.spriteSheet.subTextures["topBackgroundMountain0"]);	
			_topBackgroundMountain.addComponent(_image);
			
			_topBackgroundMountain.width = _stageWidth * 2;
			_topBackgroundMountain.height = _stageHeight * 0.05;
			_topBackgroundMountain.y = _stageHeight / 10 * 3.33 - (_topBackgroundMountain.height / 2);
			addChild(_topBackgroundMountain);
			
			initAnimator();
			
			_bottomBackground.width = _stageWidth;
			_bottomBackground.height = _stageHeight / 10 * 6.66;	
			_bottomBackground.y = _stageHeight / 10 * 3.33;			
			
			_bottomBackground.addComponent(_animator);
			addChild(_bottomBackground);			
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);			
		}
		
		private function initColor(color:int):void
		{
			if(color == 0)
				_topBackground.blendColor(0, 1, 1);
			else
				_topBackground.blendColor(1, 0.5, 0.25);
		}
		
		private function initAnimator():void
		{
			_animator = new Animator();
			
			var state:State = new State("curve_none"); 			
			state.addFrame(Resource.spriteSheet.subTextures["bottomBackground0"]);
			state.addFrame(Resource.spriteSheet.subTextures["bottomBackground1"]);
			_animator.addState(state);
			state.interval= ((MainStage.maxSpeed - MainStage.speed) + 1) * 5;			
			
			state = new State("curve_left"); 						
			state.addFrame(Resource.spriteSheet.subTextures["bottomBackgroundLeft0"]);
			state.addFrame(Resource.spriteSheet.subTextures["bottomBackgroundLeft1"]);
			state.addFrame(Resource.spriteSheet.subTextures["bottomBackgroundLeft2"]);	
			_animator.addState(state);
			state.interval= ((MainStage.maxSpeed - MainStage.speed) + 1) * 5;			
			
			state = new State("curve_right"); 						
			state.addFrame(Resource.spriteSheet.subTextures["bottomBackgroundRight0"]);
			state.addFrame(Resource.spriteSheet.subTextures["bottomBackgroundRight1"]);
			state.addFrame(Resource.spriteSheet.subTextures["bottomBackgroundRight2"]);	
			_animator.addState(state);
			state.interval= ((MainStage.maxSpeed - MainStage.speed) + 1) * 5;
			
			state.play();
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{
			if(MainStage.speed == 0)
			{
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
						if(_topBackgroundMountain.x > _stageWidth)
						{
							_topBackgroundMountain.x = 0;
						}
						_topBackgroundMountain.x += MainStage.speed;
						break;
					case 1:
						if(_topBackgroundMountain.x < 0)
						{
							_topBackgroundMountain.x = _stageWidth;
						}
						_animator.getState("curve_right").interval = ((MainStage.maxSpeed - MainStage.speed) + 1) * 5;
						_topBackgroundMountain.x -= MainStage.speed;
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