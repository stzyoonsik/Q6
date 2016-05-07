package gameScene.object.player 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import gameScene.MainStage;
	import gameScene.object.crater.EllipseCrater;
	import gameScene.object.crater.RectangleCrater;
	import gameScene.object.enemy.Enemy;
	import gameScene.object.item.Fish;
	import gameScene.object.item.Flag;
	import gameScene.util.PlayerState;
	
	import trolling.component.animation.Animator;
	import trolling.component.animation.State;
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.media.SoundManager;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.EventWith;
	import trolling.utils.PivotType;

	public class Player extends GameObject
	{
		[Embed(source="penguinRun0.png")]
		public static const penguinRun0:Class;
		
		[Embed(source="penguinRun1.png")]
		public static const penguinRun1:Class;
		
		[Embed(source="penguinRun2.png")]
		public static const penguinRun2:Class;
		
		[Embed(source="penguinRun3.png")]
		public static const penguinRun3:Class;
		
		[Embed(source="penguinJump0.png")]
		public static const penguinJump0:Class;
		
		[Embed(source="penguinJump1.png")]
		public static const penguinJump1:Class;
		
		[Embed(source="penguinCrashedLeft.png")]
		public static const penguinCrashedLeft:Class;
		
		[Embed(source="penguinCrashedRight.png")]
		public static const penguinCrashedRight:Class;
		
		[Embed(source="shadow.png")]
		public static const shadow:Class;
		
		private var _penguin:GameObject = new GameObject();		
		private var _grimja:GameObject = new GameObject();
		
		private var _bitmap:Bitmap;
		private var _image:Image;
		private var _animator:Animator;
		private var _grimjaCollider:Collider;
		private var _penguinCollider:Collider;
		
		private var _playerState:String;
		//private const MAX_MUJUK_FRAME:int = 10;
		//private var _mujukFrame:int;
		
		private var _jumpSpeed:int;
		private var _jumpHeight:int;
		private var _jumpTheta:Number = 0;
		private var _jumpFlag:Boolean;
		
		private var _crashSpeed:int;
		private var _crashHeight:int;
		private var _crashTheta:Number = 0;
		private var _hoppingCount:int;
		private var _crashFlag:Boolean;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		public function get state():String{ return _playerState; }
		public function set state(value:String):void{ _playerState = value; }
		
		public function get grimja():GameObject{ return _grimja; }		
		public function set grimja(value:GameObject):void {	_grimja = value;}
		
		public function get penguin():GameObject{ return _penguin;}
		public function set penguin(value:GameObject):void{ _penguin = value;}
		
		public function Player(stageWidth:int, stageHeight:int)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			pivot = PivotType.CENTER;
			
			x = 0;
			y = 0;
			
			_playerState = PlayerState.RUN;
			
			_jumpSpeed = 7.5;
			_jumpHeight = _stageHeight / 10;
			
			_crashSpeed = 10;
			_crashHeight = _stageHeight / 20;
			
			
			_bitmap = new shadow() as Bitmap;
			_image = new Image(new Texture(_bitmap));				
			
			_grimja.width = _stageWidth / 5;
			_grimja.height = _grimja.width
			_grimja.x = _stageWidth / 2;		
			_grimja.y = _stageHeight / 10 * 8.75;
			_grimja.addComponent(_image);	
			_grimja.pivot = PivotType.CENTER;
			
			_grimjaCollider = new Collider();
			
			_grimjaCollider.setRect(0.33, 0.0625);
			_grimja.addComponent(_grimjaCollider);
			
			_grimja.addEventListener(TrollingEvent.COLLIDE, onCollideWithGrimja);
			
			
				
			
			_penguin.width = _stageWidth / 5;
			_penguin.height = _penguin.width;
			_penguin.x = _stageWidth / 2;		
			_penguin.y = _stageHeight / 10 * 8;
			
			_penguin.pivot = PivotType.CENTER;
			
			
			_animator = new Animator(); 
			
			var state:State = new State(PlayerState.RUN);
			_bitmap = new penguinRun0() as Bitmap;
			state.addFrame(_bitmap);
			_bitmap = new penguinRun1() as Bitmap;
			state.addFrame(_bitmap);
			_bitmap = new penguinRun2() as Bitmap;
			state.addFrame(_bitmap);
			_bitmap = new penguinRun3() as Bitmap;
			state.addFrame(_bitmap);
			_animator.addState(state);
			state.interval = 5;
			
			state = new State(PlayerState.JUMP);
			_bitmap = new penguinJump0() as Bitmap;
			state.addFrame(_bitmap);
			_bitmap = new penguinJump1() as Bitmap;
			state.addFrame(_bitmap);
			_animator.addState(state);			
			state.interval = 3;
			
			state = new State(PlayerState.CRASHED_LEFT);
			_bitmap = new penguinCrashedLeft() as Bitmap;
			state.addFrame(_bitmap);	
			state.interval = 60;
			_animator.addState(state);	
			
			state = new State(PlayerState.CRASHED_RIGHT);
			_bitmap = new penguinCrashedRight() as Bitmap;
			state.addFrame(_bitmap);	
			state.interval = 60;
			_animator.addState(state);	
			
			
			state.play();
			
			_penguin.addComponent(_animator);
			
			
			
			addChild(_grimja);
			addChild(_penguin);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);	
		} 
		
		

		/**
		 * 
		 * @param event
		 * 그림자의 콜라이더에 다른 콜라이더가 충돌했을때 그 콜라이더에 대한 정보를
		 */
		private function onCollideWithGrimja(event:TrollingEvent):void
		{
			 
			//몬스터와 충돌
			//플레이어를 충돌 무시 상태로 만들고 n초(프레임)동안 부딪힘 상태로 변경
			//MainStage.speed 를 변경
			
			if(event.data is EllipseCrater)
			{
				
				//왼쪽을 부딪힘
				if(_playerState == PlayerState.RUN)
				{
					MainStage.speed = 0;
					if(_penguin.x < event.data.x)
					{
						
						_playerState = PlayerState.CRASHED_LEFT;
					}
						
					else
					{
						_playerState = PlayerState.CRASHED_RIGHT;
					}
				}
				
			}
			
			if(event.data.parent is RectangleCrater)
			{
				if(_playerState == PlayerState.RUN)
				{
					//MainStage.speed = 0;
					if(event.data.name == "left")
					{
						
						_playerState = PlayerState.CRASHED_LEFT;
					}
						
					else if(event.data.name == "right")
					{
						_playerState = PlayerState.CRASHED_RIGHT;
					}
				}
			}
			
			if(event.data is Enemy)
			{
				trace("몬스터");
				dispatchEvent(new Event("checkDirection"));
			}
			
			if(event.data is Flag)
			{
				trace("깃발");				
				event.data.dispatchEvent(new Event("collideFlag"));
			}
			
		
		}
		
		
		private function onEnterFrame(event:Event):void
		{
			//trace(_playerState);
			_grimja.x = _penguin.x;
			
			collideWall();
			
			if(_playerState == PlayerState.JUMP)
			{				
				
				jump();
			}
			
//			if(_playerState == PlayerState.JUMPING)
//			{				
//				
//			}
//			
			if(_playerState == PlayerState.CRASHED_LEFT)
			{
				crashed(0);
			}
			
//			if(_playerState == PlayerState.CRASHING_LEFT)
//			{
//				
//			}
			
			if(_playerState == PlayerState.CRASHED_RIGHT)
			{
				crashed(1);
			}
			
//			if(_playerState == PlayerState.CRASHING_RIGHT)
//			{
//				
//			}
			
			if(_playerState == PlayerState.FALL)
			{
				_grimjaCollider.isActive = false;
				_penguin.transition(PlayerState.FALL);
			}
		}
		
		/**
		 * 화면의 좌,우를 벗어나지 않도록 함
		 * 
		 */
		private function collideWall():void
		{
			//왼쪽 벽에 부딪힘
			if(_penguin.x - _penguin.width / 2 < 0)
			{
				_penguin.x = _penguin.width / 2;
				
			}
			
			//오른쪽 벽에 부딪힘
			if(_penguin.x + _penguin.width / 2 > _stageWidth)
			{
				_penguin.x = _stageWidth - _penguin.width / 2;
			}
		}
		
		/**
		 * ---점프--- 
		 * 일정 시간(_jumpTheta) 동안 일정 높이(_jumpHeight)만큼 일정 속도(_jumpSpeed)로 sin 그래프 모양으로 y가 올라갔다가 내려옴		 * 
		 */
		private function jump():void
		{
			if(!_jumpFlag)
			{
				trace("점프 시작");
				//_playerState = PlayerState.JUMPING;
				//_grimjaCollider.isActive = false;
				_penguin.transition(PlayerState.JUMP);
				SoundManager.play("jump");
				_jumpFlag = true;
			}
			var degree:Number = _jumpTheta * Math.PI / 180;
			_penguin.y = (_stageHeight / 10 * 8) - (Math.sin(degree) * _jumpHeight);
			
			_jumpTheta += _jumpSpeed;
			
			//점프 시 그림자의 크기가 작아졌다가 커짐
			_grimja.width = _stageWidth / 5 - (_grimja.y - _penguin.y);
			_grimja.height = _grimja.width;
			
			if(_jumpTheta >= 180)
			{
				_jumpFlag = false;
				_penguin.y = _stageHeight / 10 * 8;
				_playerState = PlayerState.RUN;
				//_grimjaCollider.isActive = true;
				_jumpTheta = 0;
				_penguin.transition(PlayerState.RUN);
			}
		}
		
		
		/**
		 * 
		 * @param direction 방향
		 * ---부딪힘---
		 * 타원크레이터나 물개와 충돌 시 sin 그래프 모양으로 4번 튕기게 함
		 */
		private function crashed(direction:int):void
		{
			if(!_crashFlag)
			{
				//trace("왼쪽 부딪힘");
				_grimjaCollider.isActive = false;
				if(direction == 0)
					_penguin.transition(PlayerState.CRASHED_LEFT);
				else
					_penguin.transition(PlayerState.CRASHED_RIGHT);
				_crashFlag = true;
			}
			
			var degree:Number = _crashTheta * Math.PI / 180;
			
			if(direction == 0)
				_penguin.x -= _stageWidth / 500;
			else
				_penguin.x += _stageWidth / 500;
			
			_penguin.y = (_stageHeight / 10 * 8) - (Math.sin(degree) * _crashHeight);
			
			_crashTheta += _crashSpeed;
			
			
			_grimja.width = _stageWidth / 5 - (_grimja.y - _penguin.y);
			_grimja.height = _grimja.width;
			
			if(_crashTheta >= 180)
			{
				_crashTheta = 0;
				_crashHeight *= 0.75;			
				_crashSpeed *= 1.25;
				_hoppingCount++;
				
				if(_hoppingCount == 0)
					SoundManager.play("crashed0");
				else
					SoundManager.play("crashed1");
			}
			
			
			
			if(_hoppingCount >= 3)
			{
				_crashSpeed = 10;
				_crashHeight = _stageHeight / 20;
				
				_hoppingCount = 0;
				_penguin.y = _stageHeight / 10 * 8;
				_playerState = PlayerState.RUN;
				_grimjaCollider.isActive = true;
				_crashTheta = 0;				
				_penguin.transition(PlayerState.RUN);
				_crashFlag = false;
			}
		}
		
		
		private function fall():void
		{
			
		}
	

	}
}