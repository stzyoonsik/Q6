package
{
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import background.Background;
	import background.Cloud;
	
	import object.crater.EllipseCrater;
	import object.crater.RectangleCrater;
	import object.enemy.Enemy;
	import object.item.Flag;
	import object.player.Player;
	
	import trolling.Scene;
	import trolling.core.Trolling;
	import trolling.event.TouchPhase;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.object.Scene;
	import trolling.utils.EventWith;
	import trolling.utils.TouchPhase;
	
	import util.PlayerState;

	public class MainStage extends Scene
	{
		private var _player:Player;
		private var _enemy:Enemy;
		//private var _ellipseCrater:EllipseCrater;
		//private var _flag:Flag;
		
		private var _background:Background;
		//private var _cloud:Cloud;
		
		//private var _leftFace:GameObject = new GameObject();
		//private var _rightFace:GameObject = new GameObject();
		private var _coverFace:GameObject = new GameObject();
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private static var _speed:Number;						//세로 
		private var _playerSpeed:Number;				//가로
		
		private var _yForJump:Number;
		private var _xForMoveAtLeast:Number;
		
		private var _frame:int;
		private const MAX_FRAME:int = 240;
		
		private var _cloudVector:Vector.<Cloud> = new Vector.<Cloud>();
		private var _ellipseCraterVector:Vector.<EllipseCrater> = new Vector.<EllipseCrater>();
		private var _rectangleCraterVector:Vector.<RectangleCrater> = new Vector.<RectangleCrater>();
		private var _flagVector:Vector.<Flag> = new Vector.<Flag>();
		
		public function MainStage()
		{
			_stageWidth = Screen.mainScreen.bounds.width;
			_stageHeight = Screen.mainScreen.bounds.height;
			
			_yForJump = _stageHeight;
			_xForMoveAtLeast = _stageWidth / 50;
			
			_speed = _stageHeight / 100; 
			_playerSpeed = _stageWidth / 100;
			
			_background = new Background(_stageWidth, _stageHeight);
			addChild(_background);
			
			//_cloud = new Cloud(_stageWidth, _stageHeight);
			//addChild(_cloud);
			
			_enemy = new Enemy(_stageWidth, _stageHeight);			
			//addChild(_enemy);
			
			
			
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
		private function initTouch():void
		{
			
		}
		
		private function onEnterFrame(event:Event):void
		{
			if(_frame > MAX_FRAME)
				_frame = 0;
			
			_frame++;
			
			if(_frame % 20 == 0)
			{
				var cloud:Cloud = new Cloud(_stageWidth, _stageHeight);
				addChild(cloud);
			}
			
			if(_frame % 20 == 0)
			{
				makeRandomObject();
			}
			
		}
		
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