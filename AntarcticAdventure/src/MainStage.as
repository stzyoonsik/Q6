package
{
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import background.Background;
	import background.Cloud;
	
	import object.crater.EllipseCrater;
	import object.enemy.Enemy;
	import object.player.Player;
	
	import trolling.core.Trolling;
	import trolling.event.TouchPhase;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.object.Scene;
	import trolling.utils.EventWith;
	
	import util.PlayerState;

	public class MainStage extends Scene
	{
		private var _player:Player;
		private var _enemy:Enemy;
		private var _ellipseCrater:EllipseCrater;
		
		private var _background:Background;
		private var _cloud:Cloud;
		
		//private var _leftFace:GameObject = new GameObject();
		//private var _rightFace:GameObject = new GameObject();
		private var _coverFace:GameObject = new GameObject();
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private static var _speed:Number;						//세로 
		private var _playerSpeed:Number;				//가로
		
		private var _yForJump:Number;
		private var _xForMoveAtLeast:Number;
		
		public function MainStage()
		{
			_stageWidth = Screen.mainScreen.bounds.width;
			_stageHeight = Screen.mainScreen.bounds.height;
			
			_yForJump = _stageHeight / 3;
			_xForMoveAtLeast = _stageWidth / 50;
			
			_speed = _stageHeight / 100; 
			_playerSpeed = _stageWidth / 100;
			
			_background = new Background(_stageWidth, _stageHeight);
			addChild(_background);
			
			_cloud = new Cloud(_stageWidth, _stageHeight);
			addChild(_cloud);
			
			_enemy = new Enemy(_stageWidth, _stageHeight);			
			//addChild(_enemy);
			
			_ellipseCrater = new EllipseCrater(_stageWidth, _stageHeight);
			addChild(_ellipseCrater);
			
			_player = new Player(_stageWidth, _stageHeight);			
			addChild(_player); 			
			
			
			_coverFace.width = _stageWidth;
			_coverFace.height = _stageHeight;
			_coverFace.addEventListener(TouchPhase.HOVER, onTouchCoverFace);
			//_coverFace.addEventListener(TouchPhase.
			addChild(_coverFace);
			//제일 밑에 있어야함
			//initTouchFace();
	
			addEventListener(Event.ENTER_FRAME, onEnterFrame);		
		}

		public static function get speed():Number
		{
			return _speed;
		}

		private function onTouchCoverFace(event:TrollingEvent):void
		{
			var point:Point = event.data[0];
			if(event.data.length >= 10)
			{
				var prevTouchY:int;
				var currentTouchY:int;
				for(var i:int = 0; i<event.data.length; ++i)
				{
					
					if(i < 5)
					{
						currentTouchY += int(event.data[i].y);
					}
					else
					{
						prevTouchY += int(event.data[i].y);
					}
					
				}
				trace(currentTouchY - prevTouchY);
				if(prevTouchY - currentTouchY > _yForJump)
				{
					trace("JUMPJUMPJUMP");
					_player.state = PlayerState.JUMP;
				}
			}
			
			
			//플레이어 위치와 너무 가까운 곳을 터치하면 플레이어 이동 안함
			if(Math.abs(point.x - _player.penguin.x) < _xForMoveAtLeast)
				return;
			
			//터치 지점이 현재 플레이어 위치보다 오른쪽
			if(point.x > _player.penguin.x)
			{
				_player.penguin.x += _playerSpeed;
			}
			else
			{
				_player.penguin.x -= _playerSpeed;
			}
		}
		private function initTouch():void
		{
			
		}
		
		private function onEnterFrame(event:Event):void
		{
			//checkCollision();
			
			
			//checkPlayerPosition();
			//move();
		}
		
		private function move():void
		{
			
			
			_enemy.y += _speed;
			
			
		}
		
		private function checkCollision():void
		{
			//trace("플레이어 좌표 = " + _player.getBound() + " 몬스터 좌표 = " + _enemy.getBound());
			//몬스터와 충돌
			if(isCollideEnemyOrCrater())
			{
				_enemy.y = _stageHeight / 2;
				_ellipseCrater.x = _stageWidth / 2;
				_ellipseCrater.y = _stageHeight /2;
				
				_ellipseCrater.position = _ellipseCrater.initRandomPosition();
			}
			
			//아이템과 충돌
			if(isCollideItem())
			{
				
			}
			
		}
		
		private function isCollideEnemyOrCrater():Boolean
		{
			if(_player.grimja.getBound().intersects(_enemy.getBound()) || _player.grimja.getBound().intersects(_ellipseCrater.getBound()))
			{
				trace("몬스터 또는 크레이터와 충돌");
				//플레이어 상태 -> 부딪힘
				return true;
			}
			
			return false;
		}
		
		private function isCollideItem():Boolean
		{
//			if(_player.getRectangle().intersects(_flag.getRectangle()))
//			{
//				return true;
//			}
			
			return false;
		}
		
//		private function checkPlayerPosition():void
//		{
//			_leftFace.width = _player.x;
//			
//			_rightFace.width = _stageWidth - _leftFace.width;
//			_rightFace.x = _player.x;
//		}
		
		private function onTouchLeftFace(event:Event):void
		{
			trace("왼쪽");
			
			//trace(event.
			_player.x -= _playerSpeed;
			
		}
		
		private function onTouchRightFace(event:Event):void
		{
			trace("오른쪽");
			_player.x += _playerSpeed;
		}
	}
}