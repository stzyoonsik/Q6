package gameScene
{
	import flash.display.Screen;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import gameScene.background.Background;
	import gameScene.background.Cloud;
	import gameScene.object.crater.EllipseCrater;
	import gameScene.object.crater.RectangleCrater;
	import gameScene.object.enemy.Enemy;
	import gameScene.object.item.Flag;
	import gameScene.object.player.Player;
	import gameScene.util.PlayerState;
	
	import trolling.event.TrollingEvent;
	import trolling.media.Sound;
	import trolling.object.GameObject;
	import trolling.object.Scene;

	public class MainStage extends Scene
	{
		private var _player:Player;
		private var _enemy:Enemy;
		
		private var _background:Background;
		private var _coverFace:GameObject = new GameObject();
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _maxSpeed:Number;
		private static var _speed:Number;						//세로 
		private var _playerSpeed:Number;				//가로
		
		private var _yForJump:Number;
		private var _xForMoveAtLeast:Number;
		
		private var _frame:int;
		private const MAX_FRAME:int = 240;
		
//		private var _cloudVector:Vector.<Cloud> = new Vector.<Cloud>();
//		private var _ellipseCraterVector:Vector.<EllipseCrater> = new Vector.<EllipseCrater>();
//		private var _rectangleCraterVector:Vector.<RectangleCrater> = new Vector.<RectangleCrater>();
//		private var _flagVector:Vector.<Flag> = new Vector.<Flag>();
		
		public function MainStage()
		{
			_stageWidth = Screen.mainScreen.bounds.width;
			_stageHeight = Screen.mainScreen.bounds.height;
			
			_yForJump = _stageHeight;
			_xForMoveAtLeast = _stageWidth / 50;
			
			_maxSpeed = _stageHeight / 100; 
			_speed = _stageHeight / 100; 
			_playerSpeed = _stageWidth / 100;
			
			_background = new Background(_stageWidth, _stageHeight);
			addChild(_background);
			
			
			_enemy = new Enemy(_stageWidth, _stageHeight);						
			
			
			_player = new Player(_stageWidth, _stageHeight);			
			addChild(_player); 			
			
			
			_coverFace.width = _stageWidth;
			_coverFace.height = _stageHeight;
			_coverFace.addEventListener(TrollingEvent.TOUCH_HOVER, onTouchCoverFace);			
			addChild(_coverFace);
	
			addEventListener(Event.ENTER_FRAME, onEnterFrame);	
			
			//var sound:Sound = new Sound(new URLRequest(
			//SoundManager
		}

		public static function set speed(value:Number):void
		{
			_speed = value;
		}

		public static function get speed():Number
		{
			return _speed;
		}

		/**
		 * 
		 * @param event 터치 hover 
		 * 사용자의 터치 좌표를 바탕으로 점프와 이동을 하는 콜백 메소드
		 */
		private function onTouchCoverFace(event:TrollingEvent):void
		{
			if(_player.state == PlayerState.ARRIVED ||
				_player.state == PlayerState.CRASHED_LEFT ||
				_player.state == PlayerState.CRASHING_LEFT ||
				_player.state == PlayerState.CRASHED_RIGHT ||
				_player.state == PlayerState.CRASHING_RIGHT)
			{
				return;
			}
				
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
				//trace(currentTouchY - prevTouchY);
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
		
		/**
		 * 
		 * @param event
		 * 매 프레임마다 검사하여 속도를 올려주고, 오브젝트를 생성하는 콜백 메소드
		 */
		private function onEnterFrame(event:Event):void
		{
			if(_speed < _maxSpeed)
			{
				_speed += _maxSpeed / 50;
			}
			
			if(_frame > MAX_FRAME)
				_frame = 0;
			
			_frame++;
		
			if(_player.state == PlayerState.RUN)
			{
				if(_frame % 20 == 0)
				{
					var cloud:Cloud = new Cloud(_stageWidth, _stageHeight);
					addChild(cloud);
					makeRandomObject();
				}
			}
			
			
		}
		
		/**
		 * 랜덤 오브젝트 생성 메소드 
		 * 
		 */
		private function makeRandomObject():void
		{
			var randomNum:Number = int(Math.random() * 5);
			
			switch(randomNum)
			{
				case 0:
					var ellipseCrater:EllipseCrater = new EllipseCrater(_stageWidth, _stageHeight);
					addChildAt(ellipseCrater, 1);
					break;
				case 1:
					var flag:Flag = new Flag(_stageWidth, _stageHeight);
					addChildAt(flag, 1);
					break;
				case 2:
					var rectangleCrater:RectangleCrater = new RectangleCrater(_stageWidth, _stageHeight);
					addChildAt(rectangleCrater, 1);
					break;
				case 3:
					break;
				case 4:
					break;
//				case 5:
//					break;
//				case 0:
//					break;
//				case 1:
//					break;
//				case 0:
//					break;
//				case 1:
//					break;
				default:
					break;
				
			}
		}
	
	}
}