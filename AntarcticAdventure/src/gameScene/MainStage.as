package gameScene
{
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
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
	import trolling.media.SoundManager;
	import trolling.object.GameObject;
	import trolling.object.Scene;

	public class MainStage extends Scene
	{
		private var _currentStage:String;
		private var _player:Player;
		private var _enemy:Enemy;
		
		private var _background:Background;
		private var _coverFace:GameObject = new GameObject();
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private static var _maxSpeed:Number;
		private static var _speed:Number;						//세로 
		private var _playerSpeed:Number;				//가로
		
		private var _yForJump:Number;
		private var _xForMoveAtLeast:Number;
		
		private var _currentFrame:int;
		private const MAX_FRAME:int = 240;
		
		private var _distanceToFinish:int = 2000;
		
		//private var _objectVector:Vector.<int> = new Vector.<int>();
		private var _objectArray:Array;
		
		
		private var _soundDic:Dictionary = new Dictionary();
		private var _soundURL:Vector.<String> = new Vector.<String>();
		private var _soundLoadCount:uint = 0;
		private var _filePath:File = File.applicationDirectory;
		
//		private var _cloudVector:Vector.<Cloud> = new Vector.<Cloud>();
//		private var _ellipseCraterVector:Vector.<EllipseCrater> = new Vector.<EllipseCrater>();
//		private var _rectangleCraterVector:Vector.<RectangleCrater> = new Vector.<RectangleCrater>();
//		private var _flagVector:Vector.<Flag> = new Vector.<Flag>();
		
		public function MainStage()
		{
			addEventListener(TrollingEvent.START, oninit);
		}
		
		public static function get maxSpeed():Number
		{
			return _maxSpeed;
		}

		private function oninit(event:Event):void
		{
			_currentStage = "stage1";
			this.width = 800;
			this.height = 600;
//			_stageWidth = Screen.mainScreen.bounds.width;
//			_stageHeight = Screen.mainScreen.bounds.height;
			_stageWidth = this.width;
			_stageHeight = this.height;
			
			_yForJump = _stageHeight;
			_xForMoveAtLeast = _stageWidth / 50;
			
			_maxSpeed = 5; 
			_speed = 0; 
			_playerSpeed = _stageWidth / 100;
			
			_background = new Background(_stageWidth, _stageHeight);
			addChild(_background);
			
			
			//_enemy = new Enemy(_stageWidth, _stageHeight);						
			
			
			_player = new Player(_stageWidth, _stageHeight);			
			addChild(_player); 			
			
			
			_coverFace.width = _stageWidth;
			_coverFace.height = _stageHeight;
			_coverFace.addEventListener(TrollingEvent.TOUCH_HOVER, onTouchCoverFace);			
			addChild(_coverFace);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);	
			
			
			
			_soundURL.push("MainBgm.mp3");
			_soundURL.push("jump.mp3");
			_soundURL.push("crashed0.mp3");
			_soundURL.push("crashed1.mp3");
			
			
			
			
			for(var i:int = 0; i<_soundURL.length; ++i)
			{
				//var loader: = new Loader();
				var url:URLRequest = new URLRequest(_filePath.resolvePath(_soundURL[i]).url);
				trace(url.url);
				var sound:Sound = new Sound();
				sound.load(url);
				sound.addEventListener(Event.COMPLETE, onSoundLoaded);
				sound.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadFaild);			
				
			}
			
			readTXT(_currentStage); 
			
			this.scaleX = Screen.mainScreen.bounds.width / _stageWidth;
			this.scaleY = Screen.mainScreen.bounds.height / _stageHeight;
			
//			for(var i:int = 0; i<_objectArray.length; ++i)
//			{
//				trace(_objectArray[i]);
//			}
			//SoundManager.addSound();
		}

		public static function set speed(value:Number):void
		{
			_speed = value;
		}

		public static function get speed():Number
		{
			return _speed;
		}
		
		private function onSoundLoaded(event:Event):void
		{
			
			//_soundDic
			_soundLoadCount++;
			trace("*******************************");
			trace(event.currentTarget.url);
			_soundDic[event.currentTarget.url.replace(_filePath.url.toString(), "")] = event.currentTarget as Sound;
			
			if(_soundLoadCount >= _soundURL.length)
			{
				_soundURL.splice(0, _soundURL.length);
				loadComplete();
			}
		}
		
		private function loadComplete():void
		{
			trace("로딩끝");
			SoundManager.addSound("MainBgm", _soundDic["MainBgm.mp3"]);
			SoundManager.addSound("jump", _soundDic["jump.mp3"]);
			SoundManager.addSound("crashed0", _soundDic["crashed0.mp3"]);
			SoundManager.addSound("crashed1", _soundDic["crashed1.mp3"]);
			//SoundManager.setVolume(SoundManager.SELECT, 0.5, "MainBgm");
			var sound:Sound = _soundDic["MainBgm.mp3"]; 
			sound.volume = 0.5;
			sound.loops = Sound.INFINITE;
			SoundManager.play("MainBgm");
		}
		
		private function onSoundLoadFaild(event:IOErrorEvent):void
		{
			trace(event.text);
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
				
			//var point:Point = event.data[0];
			
			var point:Point = Point(event.data[0]).clone();
			point.x *= (_stageWidth / Screen.mainScreen.bounds.width);
			point.y *= (_stageHeight / Screen.mainScreen.bounds.height);
			
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
			if(Math.abs(point.x - _player.x) < _xForMoveAtLeast)
				return;
			
			//터치 지점이 현재 플레이어 위치보다 오른쪽
			if(point.x > _player.x)
			{
				_player.x += _playerSpeed;
			}
			else
			{
				_player.x -= _playerSpeed;
			}
			
			trace("point.x = " + point.x);
			trace("player.x = " + _player.x);
			trace("player.penguin.x = " + _player.penguin.x);
		}
		
		/**
		 * 
		 * @param event
		 * 매 프레임마다 검사하여 속도를 올려주고, 오브젝트를 생성하는 콜백 메소드
		 */
		private function onEnterFrame(event:Event):void
		{
			//trace("현재 속도 = " + _speed);
			//trace("남은 거리 = " + _distanceToFinish);
			if(_distanceToFinish <= 0)
			{
				//도착함
				trace("도착");
			}
			else
			{
				_distanceToFinish--;
			}
			
			if(_distanceToFinish < 1800)
			{				
				//왼쪽커브길
				//_background.changeCurve(1);
			}
			
			if(_distanceToFinish % 50 == 0)
			{
				
				if(_objectArray.length != 0)
				{
					trace("오브젝트 생성");
					makeObject();
					_objectArray.shift();
				}
			}
			
			
			
			
			if(_speed < _maxSpeed)
			{
				_speed += _maxSpeed / 50;
			}
			
			if(_currentFrame > MAX_FRAME)
			{
				_currentFrame = 0;
			}
			
			switch(_background.curve)
			{
				case 0:
					break;
				case 1:
					_player.x += _playerSpeed * 0.5;
					break;
				case 2:
					_player.x -= _playerSpeed * 0.5;
					break;
				default:
					break;
			}
			
			
			
			
//			_currentFrame++;
//			if(_currentFrame % 20 == 0)			
//			{
//				if(_player.state == PlayerState.RUN || 
//					_player.state == PlayerState.JUMPING ||
//					_player.state == PlayerState.JUMP)
//				{
//					var cloud:Cloud = new Cloud(_stageWidth, _stageHeight);
//					addChild(cloud);
//					if(_objectArray.length != 0)
//					{
//						makeObject();
//						_objectArray.shift();
//					}
//				}
//			}
			
			
		}
		
		private function readTXT(stageName:String):void
		{
			var file:File = new File();
			var stream:FileStream = new FileStream();
			file = File.applicationDirectory.resolvePath(stageName+".txt");
			
			if(file.exists)
			{
				stream.open(file, FileMode.READ);
				var str:String = stream.readMultiByte(stream.bytesAvailable, "utf-8");
				_objectArray = str.split(',');
				//setObjectVector(str);
				stream.close();
			}
			else
			{
				trace(stageName + " open error");
			}
		}
		
//		private function setObjectVector(str:String):void
//		{			
//			_objectArray = str.split(',');
//		}
		
		private function makeObject():void
		{
			switch(int(_objectArray[0]))
			{
				//아무것도 생성 안함
				case 0:
					break;
				//타원 크레이터 가운데
				case 1:
					var ellipseCrater:EllipseCrater = new EllipseCrater(_stageWidth, _stageHeight, -1);
					addChildAt(ellipseCrater, 1);
					break;
				//타원 크레이터 왼쪽
				case 2:
					ellipseCrater = new EllipseCrater(_stageWidth, _stageHeight, 0);
					addChildAt(ellipseCrater, 1);
					break;
				//타원 크레이터 오른쪽
				case 3:
					ellipseCrater = new EllipseCrater(_stageWidth, _stageHeight, 1);
					addChildAt(ellipseCrater, 1);
					break;
				//타원 크레이터 왼쪽, 오른쪽
				case 4:
					ellipseCrater = new EllipseCrater(_stageWidth, _stageHeight, 0);
					addChildAt(ellipseCrater, 1);
					ellipseCrater = new EllipseCrater(_stageWidth, _stageHeight, 1);
					addChildAt(ellipseCrater, 1);
					break;
				//네모 크레이터 왼쪽
				case 5:
					var rectangleCrater:RectangleCrater = new RectangleCrater(_stageWidth, _stageHeight, 0);
					addChildAt(rectangleCrater, 1);
					break;
				//네모 크레이터 오른쪽
				case 6:
					rectangleCrater = new RectangleCrater(_stageWidth, _stageHeight, 1);
					addChildAt(rectangleCrater, 1);
					break;
				//깃발 왼쪽
				case 7:
					var flag:Flag = new Flag(_stageWidth, _stageHeight, 0);
					addChildAt(flag, 1);
					break;
				//깃발 오른쪽
				case 8:
					flag = new Flag(_stageWidth, _stageHeight, 1);
					addChildAt(flag, 1);
					break;
				default:
					break;
				
			}
		}
		
//		/**
//		 * 랜덤 오브젝트 생성 메소드 
//		 * 
//		 */
//		private function makeRandomObject():void
//		{
//			var randomNum:Number = int(Math.random() * 5);
//			
//			switch(randomNum)
//			{
//				case 0:
//					var ellipseCrater:EllipseCrater = new EllipseCrater(_stageWidth, _stageHeight);
//					addChildAt(ellipseCrater, 1);
//					break;
//				case 1:
//					var flag:Flag = new Flag(_stageWidth, _stageHeight);
//					addChildAt(flag, 1);
//					break;
//				case 2:
//					var rectangleCrater:RectangleCrater = new RectangleCrater(_stageWidth, _stageHeight);
//					addChildAt(rectangleCrater, 1);
//					break;
//				case 3:
//					break;
//				case 4:
//					break;
////				case 5:
////					break;
////				case 0:
////					break;
////				case 1:
////					break;
////				case 0:
////					break;
////				case 1:
////					break;
//				default:
//					break;
//				
//			}
//		}
	
	}
}