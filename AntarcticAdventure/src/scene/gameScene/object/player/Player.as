package scene.gameScene.object.player 
{
	import flash.events.Event;
	
	import scene.gameScene.MainStage;
	import scene.gameScene.ObjectTag;
	import scene.loading.Resource;
	import scene.gameScene.object.Objects;
	import scene.gameScene.object.crater.EllipseCrater;
	import scene.gameScene.object.crater.RectangleCrater;
	import scene.gameScene.object.enemy.Enemy;
	import scene.gameScene.object.item.Coke;
	import scene.gameScene.object.item.Fish;
	import scene.gameScene.object.item.Flag;
	import scene.gameScene.util.PlayerState;
	
	import trolling.component.animation.Animator;
	import trolling.component.animation.State;
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.media.Sound;
	import trolling.media.SoundManager;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	public class Player extends Objects
	{		
		private var _penguin:GameObject = new GameObject();		
		private var _grimja:GameObject = new GameObject();
		
		private var _grimjaCollider:Collider;
		private var _penguinCollider:Collider;
		
		private var _state:String;
		
		private var _maxLife:int;
		private var _currentLife:int;
		private var _currentFlag:int;
		
		private var _jumpSpeed:Number;
		private var _jumpHeight:Number;
		private var _jumpTheta:Number;
		private var _jumpFlag:Boolean;
		
		private var _crashSpeed:Number;
		private var _crashHeight:Number;
		private var _crashTheta:Number;
		private var _hoppingCount:int;
		private var _crashFlag:Boolean;
		
		private var _fallFlag:Boolean;
		private var _fallY:Number = 0;
		private var _fallScaleX:Number = 1;
		private var _fallScaleY:Number = 1;
		
		private var _struggleFlag:Boolean;
		private var _struggleLeftCount:int;
		private var _struggleRightCount:int;
		
		private var _dashFlag:Boolean;
		//private var _dashSpeed:Number = 0;
		private var _dashCount:int;
		
		
		private const END_DELAY:uint = 120;
		private var _endFrameCounter:uint;
		private var _arrived:Boolean;
		
		private var _setCurrentLifeAtUi:Function;
		private var _setCurrentFlagAtUi:Function;
		private var _onCleared:Function;
		private var _onFailed:Function;
		
		public function get fallFlag():Boolean { return _fallFlag; }
		public function set fallFlag(value:Boolean):void { _fallFlag = value; }
		
		public function get state():String{ return _state; }
		public function set state(value:String):void{ _state = value; }
		
		public function set maxLife(value:int):void{ _maxLife = value; _currentLife = _maxLife;}
		
		public function get currentLife():int{ return _currentLife; }
		public function get currentFlag():int{ return _currentFlag; }
		
		public function set setCurrentLifeAtUi(value:Function):void{ _setCurrentLifeAtUi = value;}
		public function set setCurrentFlagAtUi(value:Function):void{ _setCurrentFlagAtUi = value;}
		public function set onCleared(value:Function):void{ _onCleared = value;}
		public function set onFailed(value:Function):void{ _onFailed = value;}
		
		public function get struggleLeftCount():int	{ return _struggleLeftCount; }		
		public function set struggleLeftCount(value:int):void {	_struggleLeftCount = value; }
		
		public function get struggleRightCount():int { return _struggleRightCount; }		
		public function set struggleRightCount(value:int):void { _struggleRightCount = value; }
		
		public function Player()
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			this.pivot = PivotType.CENTER;
			this.x = _stageWidth / 2;
			this.y = _stageHeight / 10 * 8;
			
			_state = PlayerState.RUN;
			
			_maxLife = 0;
			_currentLife = 0;
			_currentFlag = 0;
			
			_endFrameCounter = 0;
			_arrived = false;
			
			_setCurrentLifeAtUi = null;
			_setCurrentFlagAtUi = null;
			_onCleared = null;
			_onFailed = null;
			
			_jumpSpeed = 8;
			_jumpHeight = _stageHeight / 12;
			_jumpTheta = 0;
			
			_crashSpeed = 10;
			_crashHeight = _stageHeight / 20;
			_crashTheta = 0;
			
			_penguin.pivot = PivotType.CENTER;
			
			_penguin.width = _stageWidth / 5;
			_penguin.height = _penguin.width;
			
			_penguinCollider = new Collider();
			_penguinCollider.setRect(0.3, 0.3);
			_penguinCollider.addIgnoreTag(ObjectTag.ENEMY);
			
			//_penguin.colliderRender = true;
			_penguin.addComponent(_penguinCollider);
			_penguin.addEventListener(TrollingEvent.COLLIDE, onCollideWithPenguin);
			
			
			
			initAnimator();
			_penguin.addComponent(_animator);
			
			
			_image = new Image(Resource.spriteSheet.subTextures["shadow0"]);				
			_grimja.addComponent(_image);
			
			_grimja.pivot = PivotType.CENTER;
			
			_grimja.width = _stageWidth / 5;
			_grimja.height = _grimja.width	
			_grimja.y = _stageHeight * 0.08;
			
			_grimjaCollider = new Collider();			
			_grimjaCollider.setRect(0.33, 0.0625);
			_grimjaCollider.addIgnoreTag(ObjectTag.ITEM);
			
			_grimja.addComponent(_grimjaCollider);
			//_grimja.colliderRender = true;
			_grimja.addEventListener(TrollingEvent.COLLIDE, onCollideWithGrimja);
			
			
			addChild(_grimja);
			addChild(_penguin);
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);	
		} 
		
		/**
		 * 애니메이터를 초기 세팅하는 메소드 
		 * 
		 */
		private function initAnimator():void
		{
			_animator = new Animator(); 
			
			var state:State = new State(PlayerState.RUN);
			state.addFrame(Resource.spriteSheet.subTextures["penguinRun0"]);
			state.addFrame(Resource.spriteSheet.subTextures["penguinRun1"]);
			state.addFrame(Resource.spriteSheet.subTextures["penguinRun2"]);
			state.addFrame(Resource.spriteSheet.subTextures["penguinRun3"]);
			_animator.addState(state);
			state.interval = 3;
			
			state = new State(PlayerState.JUMP);
			state.addFrame(Resource.spriteSheet.subTextures["penguinJump0"]);
			state.addFrame(Resource.spriteSheet.subTextures["penguinJump1"]);
			_animator.addState(state);			
			state.interval = 2;
			
			state = new State(PlayerState.CRASHED_LEFT);
			state.addFrame(Resource.spriteSheet.subTextures["penguinCrashedLeft0"]);	
			state.interval = 60;
			_animator.addState(state);	
			
			state = new State(PlayerState.CRASHED_RIGHT);
			state.addFrame(Resource.spriteSheet.subTextures["penguinCrashedRight0"]);	
			state.interval = 60;
			_animator.addState(state);		
			
			state = new State(PlayerState.FALL);
			state.addFrame(Resource.spriteSheet.subTextures["penguinFall0"]);	
			state.interval = 60;
			_animator.addState(state);
			
			state = new State(PlayerState.STRUGGLE);
			state.addFrame(Resource.spriteSheet.subTextures["penguinStruggle0"]);
			state.addFrame(Resource.spriteSheet.subTextures["penguinStruggle1"]);
			state.addFrame(Resource.spriteSheet.subTextures["penguinStruggle2"]);
			state.addFrame(Resource.spriteSheet.subTextures["penguinStruggle3"]);
			state.interval = 4;
			_animator.addState(state);
			
			state = new State(PlayerState.ARRIVED);
			state.addFrame(Resource.spriteSheet.subTextures["penguinArrived0"]);
			state.addFrame(Resource.spriteSheet.subTextures["penguinArrived1"]);
			state.interval = 5;
			_animator.addState(state);
			
			state.play();
		}
		
		/**
		 * 
		 * @param event
		 * 그림자의 콜라이더에 다른 콜라이더가 충돌했을때 그 콜라이더에 대한 정보를 바탕으로 어느 오브젝트와 충돌했는지를 검사하는 메소드
		 */
		private function onCollideWithPenguin(event:TrollingEvent):void
		{
			if(event.data is Fish)
			{
				SoundManager.play("fish");
				event.data.dispatchEvent(new Event("collideFish"));
				
				// Life 증가 처리
				_currentLife++;
				if (_currentLife > _maxLife)
				{
					_currentLife = _maxLife;
				}
				
				if (_setCurrentLifeAtUi)
				{
					_setCurrentLifeAtUi(_currentLife);
				}
			}
			
			else if(event.data is Flag)
			{
				trace("깃발 먹음");
				SoundManager.play("flag");			
				event.data.dispatchEvent(new Event("collideFlag"));
				
				// Flag 증가 처리
				_currentFlag++;
				if (_setCurrentFlagAtUi)
				{
					_setCurrentFlagAtUi(_currentFlag);
				}
			}	
			
			else if(event.data is Coke)
			{
				trace("콜라 먹음");
				SoundManager.play("flag");			
				event.data.dispatchEvent(new Event("collideCoke"));						
				
				_state = PlayerState.DASH;
			}	
			
		}
		
		
		/**
		 * 
		 * @param event
		 * 그림자의 콜라이더에 다른 콜라이더가 충돌했을때 그 콜라이더에 대한 정보를 바탕으로 어느 오브젝트와 충돌했는지를 검사하는 메소드
		 */
		private function onCollideWithGrimja(event:TrollingEvent):void
		{			
			if(event.data is EllipseCrater)
			{
				
				//왼쪽을 부딪힘
				if(_state == PlayerState.RUN)
				{
					MainStage.speed = 0;
					if(this.x < event.data.x)
					{						
						_state = PlayerState.CRASHED_LEFT;
					}
						
					else
					{
						_state = PlayerState.CRASHED_RIGHT;
					}
				}
				
			}
				
			else if(event.data.parent is RectangleCrater)
			{
				if(_state == PlayerState.RUN)
				{					
					if(event.data.name == "left")
					{			
						MainStage.speed = 0;
						_state = PlayerState.CRASHED_LEFT;
					}						
					else if(event.data.name == "right")
					{
						MainStage.speed = 0;
						_state = PlayerState.CRASHED_RIGHT;
					}
					else
					{
						MainStage.speed = 0;
						_state = PlayerState.FALL;
						_fallY = event.data.parent.y;
						_fallScaleY = event.data.parent.scaleY / 16.6;
						_fallScaleX = _fallScaleY;
						
						event.data.parent.dispatchEvent(new Event("fall"));
					}
				}
			} 
				
			else if(event.data is Enemy)
			{
				trace("물개와 충돌");
				MainStage.speed = 0;
				if(this.x < event.data.parent.x)
				{						
					_state = PlayerState.CRASHED_LEFT;
				}
					
				else
				{
					_state = PlayerState.CRASHED_RIGHT;
				}
			}			
			
			
		}
		
		
		private function onEnterFrame(event:TrollingEvent):void
		{			
			collideWall();
			
			switch(_state)
			{
				case PlayerState.JUMP: 
					jump();
					break;
				case PlayerState.CRASHED_LEFT:
					crashed(0);
					break;
				case PlayerState.CRASHED_RIGHT:
					crashed(1);
					break;
				case PlayerState.FALL:
					fall();
					break;
				case PlayerState.STRUGGLE:
					struggle();
					break;
				case PlayerState.DASH:
					dash();
					break;
				case PlayerState.DEAD:
					break;
				case PlayerState.ARRIVE:
					arrived();
					break;
				case PlayerState.ARRIVED:
					cleared();
					break;
				case PlayerState.DEAD:
					break;
				default:
					break;
			}
		}
		
		
		/**
		 * 남은거리가 0이 되었을때의 이벤트
		 * 
		 */
		private function arrived():void
		{
			if (!_arrived)
			{
				SoundManager.play("stageCleared");
				_arrived = true;
			}
			
			if(this.y <= (_stageHeight * 0.8) - 20)
			{
				_penguin.transition(PlayerState.ARRIVED);
				_state = PlayerState.ARRIVED;
			}
			else
			{				
				if(!(this.y <= (_stageHeight / 10 * 8)-20))
				{
					this.y -= 1;
					this.scaleY -= 0.01;
					this.scaleX = this.scaleY;
				}
				if(!(this.x > ((_stageWidth/2)-30)))
				{
					this.x += 3;
				}
				if(!(this.x < ((_stageWidth/2)+30)))
				{
					this.x -= 3;
				}
			}
		}
		
		private function cleared():void
		{
			_endFrameCounter++;

			// 일정 시간 후 스테이지 클리어 팝업 호출
			if (_endFrameCounter >= END_DELAY)
			{
				if (_onCleared)
				{
					_onCleared();
				}
				_endFrameCounter = 0;
			}
		}
		
		/**
		 * 화면의 좌,우를 벗어나지 않도록 함
		 * 
		 */
		private function collideWall():void
		{
			//왼쪽 벽에 부딪힘
			if(this.x - _penguin.width / 2 < 0)
			{
				this.x = _penguin.width / 2;
				
			}
			
			//오른쪽 벽에 부딪힘
			if(this.x + _penguin.width / 2 > _stageWidth)
			{
				this.x = _stageWidth - _penguin.width / 2;
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
				_penguin.transition(PlayerState.JUMP);
				SoundManager.play("jump");
				_jumpFlag = true;
			}
			var degree:Number = _jumpTheta * Math.PI / 180;
			trace(degree);
			_penguin.y = -(Math.sin(degree) * _jumpHeight);
			
			_jumpTheta += _jumpSpeed;
			
			//점프 시 그림자의 크기가 작아졌다가 커짐
			_grimja.width = _stageWidth / 5 + _penguin.y;
			_grimja.height = _grimja.width;
			
			if(_jumpTheta >= 180)
			{
				_jumpFlag = false;
				_penguin.y = 0;
				_state = PlayerState.RUN;				
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
				
				SoundManager.play("crashed0");
				// Life 감소 처리
				_currentLife--;
				if (_currentLife <= 0)
				{
					_currentLife = 0;
					
				}
				
				if (_setCurrentLifeAtUi)
				{
					_setCurrentLifeAtUi(_currentLife);
				}
				
				if (_currentLife <= 0) // 죽음
				{
					die();
				}
			}
			
			var degree:Number = _crashTheta * Math.PI / 180;
			
			if(direction == 0)
				this.x -= _stageWidth / 500;
			else
				this.x += _stageWidth / 500;
			
			_penguin.y = -(Math.sin(degree) * _crashHeight);
			
			_crashTheta += _crashSpeed;
			
			
			_grimja.width = _stageWidth / 5 + _penguin.y;
			_grimja.height = _grimja.width;
			
			if(_crashTheta >= 180)
			{
				_crashTheta = 0;
				_crashHeight *= 0.75;			
				_crashSpeed *= 1.25;				
				
				SoundManager.play("crashed1");
				
				_hoppingCount++;
			}
			
			
			
			if(_hoppingCount >= 3)
			{
				_crashSpeed = 10;
				_crashHeight = _stageHeight / 20;
				
				_hoppingCount = 0;
				_penguin.y = 0;
				_state = PlayerState.RUN;
				_grimjaCollider.isActive = true;
				_crashTheta = 0;				
				_penguin.transition(PlayerState.RUN);
				_crashFlag = false;
				
				_jumpFlag = false;
				_jumpTheta = 0;
			}
		}
		
		
		private function fall():void
		{
			if(!_fallFlag)
			{
				_penguin.transition(PlayerState.FALL);
				SoundManager.play("fall");	
				
				this.y = _fallY;
				_penguin.scaleY = _fallScaleY;
				_penguin.scaleX = _fallScaleX;
				
				_grimjaCollider.isActive = false;
				_grimja.visible = false;
				
				// Life 감소 처리
				_currentLife--;
				if (_currentLife <= 0)
				{
					_currentLife = 0;
					
				}
				
				if (_setCurrentLifeAtUi)
				{
					_setCurrentLifeAtUi(_currentLife);
				}
				
				if (_currentLife <= 0) // 죽음
				{
					die();
				}
			}
		}
		
		private function struggle():void
		{
			if(!_struggleFlag)
			{
				_penguin.transition(PlayerState.STRUGGLE);
				_struggleFlag = true;
			}			
			
			if(_struggleLeftCount > 5 && _struggleRightCount > 5)
			{
				trace("탈출");
				_struggleLeftCount = 0;
				_struggleRightCount = 0;
				_fallFlag = false;
				_struggleFlag = false;
				
				_penguin.scaleY = 1;
				_penguin.scaleX = 1;
				
				_grimja.visible = true;
				_grimjaCollider.isActive = true;
				
				this.y = _stageHeight / 10 * 8;
				
				_state = PlayerState.RUN;
				_penguin.transition(PlayerState.RUN);
				
				//MainStage.coverFaceForFall.removeFromParent();
			}
			
		}
		
		private function dash():void
		{
			if(!_dashFlag)
			{
				_grimjaCollider.isActive = false;
				_animator.getState(PlayerState.RUN).interval = 1;
				_dashFlag = true;
				MainStage.speed = MainStage.maxSpeed * 3;
			}
			
			_dashCount++;
			
			if(0 <= _dashCount && _dashCount < 12)
			{
				this.scaleX += 0.05;
				this.scaleY += 0.05;
			}
			else if(36 <= _dashCount && _dashCount < 48)
			{
				this.scaleX -= 0.05;
				this.scaleY -= 0.05;
			}			
			
			else if(48 <= _dashCount && _dashCount < 60)
			{				
				MainStage.speed = MainStage.maxSpeed;
				this.scaleX = 1;
				this.scaleY = 1;
				_grimjaCollider.isActive = true;
				_animator.getState(PlayerState.RUN).interval = 3;				
			}
			
			else if(60 <= _dashCount)
			{
				_dashCount = 0;
				_dashFlag = false;				
				_state = PlayerState.RUN;
			}
		}
		private function die():void
		{
			_state = PlayerState.DEAD;
			this.active = false;
			MainStage.stageEnded = true;
			SoundManager.play("stageFailed");
			
			if (_onFailed)
			{
				_onFailed();
			}
		}		
	}
}