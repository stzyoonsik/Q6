package gameScene
{
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import gameScene.background.Background;
	import gameScene.background.Cloud;
	import gameScene.object.crater.EllipseCrater;
	import gameScene.object.crater.RectangleCrater;
	import gameScene.object.enemy.Enemy;
	import gameScene.object.home.Home;
	import gameScene.object.item.Flag;
	import gameScene.object.player.Player;
	import gameScene.util.FileStreamWithLineReader;
	import gameScene.util.PlayerState;
	
	import trolling.event.TrollingEvent;
	import trolling.media.Sound;
	import trolling.media.SoundManager;
	import trolling.object.GameObject;
	import trolling.object.Scene;

	public class MainStage extends Scene
	{
		private var _isStop:Boolean;
		private var _currentStage:int;
		private var _player:Player;
		private var _enemy:Enemy;
		
		private var _background:Background;
		private var _coverFace:GameObject = new GameObject();
		private static var _stageWidth:int;
		private static var _stageHeight:int;
		
		private static const MAX_SPEED:Number = 5;
		private static var _speed:Number;						//세로 
		private var _playerSpeed:Number;						//가로
		
		private var _yForJump:Number;
		private var _xForMoveAtLeast:Number;		
		
		private var _distanceToFinish:Number;
		private var _intervalBetweenObject:Number = 0;
		
		private var _objectArray:Array;
		
		private var _curveDistanceVector:Vector.<int> = new Vector.<int>();
		private var _curveDirectionVector:Vector.<int> = new Vector.<int>();
		private var _maxCurveCount:int;
		private var _curveCount:int
		
		
		private var _soundDic:Dictionary = new Dictionary();
		private var _soundURL:Vector.<String> = new Vector.<String>();
		private var _soundLoadCount:uint = 0;
		private var _filePath:File = File.applicationDirectory;
		
		private var _playerArrive:Boolean;
		
		public static function get stageHeight():int { return _stageHeight; }
		
		public static function get stageWidth():int { return _stageWidth; }
		
		public static function get maxSpeed():Number { return MAX_SPEED; }
		
		public static function set speed(value:Number):void	{ _speed = value; }		
		public static function get speed():Number {	return _speed; }
		
		public function MainStage()
		{
			addEventListener(TrollingEvent.START_SCENE, oninit);
		}
		
		private function oninit(event:Event):void
		{
			_currentStage = 2;
			this.width = 800;
			this.height = 600;
			
			_stageWidth = this.width;
			_stageHeight = this.height;
			
			_yForJump = Screen.mainScreen.bounds.height * 0.05;
			_xForMoveAtLeast = _stageWidth / 50;
			
			_speed = 0; 
			_playerSpeed = _stageWidth / 100;
			
			_background = new Background();
			addChild(_background);
			
			_player = new Player();			
			addChild(_player); 				
			
			_coverFace.width = _stageWidth;
			_coverFace.height = _stageHeight;
			_coverFace.addEventListener(TrollingEvent.TOUCH_HOVER, onTouchHover);		
			_coverFace.addEventListener(TrollingEvent.TOUCH_ENDED, onTouchEnded);
			addChild(_coverFace);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);	
			
			pushSoundFiles();
			loadSound();
			
			readTXT("stage.txt"); 
			
			this.scaleX = Screen.mainScreen.bounds.width / _stageWidth;
			this.scaleY = Screen.mainScreen.bounds.height / _stageHeight;
	
		}
		
		/**
		 * 추가 할 사운드 파일들을 푸쉬하는 메소드 
		 * 
		 */
		private function pushSoundFiles():void
		{
			_soundURL.push("MainBgm.mp3");
			_soundURL.push("jump.mp3");
			_soundURL.push("crashed0.mp3");
			_soundURL.push("crashed1.mp3");
			_soundURL.push("fish.mp3");
			_soundURL.push("flag.mp3");
		}
		
		/**
		 * 푸쉬된 사운드 파일들을 로드하는 메소드 
		 * 
		 */
		private function loadSound():void
		{
			for(var i:int = 0; i<_soundURL.length; ++i)
			{
				var url:URLRequest = new URLRequest(_filePath.resolvePath(_soundURL[i]).url);
				trace(url.url);
				var sound:Sound = new Sound();
				sound.load(url);
				sound.addEventListener(Event.COMPLETE, onSoundLoaded);
				sound.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadFaild);			
				
			}
		}
		
		/**
		 * 로드에 성공한 사운드 파일을 딕셔너리에 추가하는 메소드 
		 * @param event
		 * 
		 */		
		private function onSoundLoaded(event:Event):void
		{
			_soundLoadCount++;
			_soundDic[event.currentTarget.url.replace(_filePath.url.toString(), "")] = event.currentTarget as Sound;
			
			if(_soundLoadCount >= _soundURL.length)
			{
				_soundURL.splice(0, _soundURL.length);
				loadComplete();
			}
		}
		
		/**
		 * 모든 사운드가 로드됬을때 매니저에 등록하는 메소드 
		 * 
		 */
		private function loadComplete():void
		{
			SoundManager.addSound("MainBgm", _soundDic["MainBgm.mp3"]);
			SoundManager.addSound("jump", _soundDic["jump.mp3"]);
			SoundManager.addSound("crashed0", _soundDic["crashed0.mp3"]);
			SoundManager.addSound("crashed1", _soundDic["crashed1.mp3"]);
			SoundManager.addSound("fish", _soundDic["fish.mp3"]);
			SoundManager.addSound("flag", _soundDic["flag.mp3"]);
			
			var sound:Sound = _soundDic["MainBgm.mp3"]; 
			sound.volume = 0.5;
			sound.loops = Sound.INFINITE;
			SoundManager.play("MainBgm");
		}
		
		/**
		 * 사운드 로드에 실패했을때 호출되는 콜백 메소드
		 * @param event
		 * 
		 */
		private function onSoundLoadFaild(event:IOErrorEvent):void
		{
			trace(event.text);
		}

		/**
		 * 터치 뗏을때 이벤트
		 * @param event
		 * 
		 */
		private function onTouchEnded(event:TrollingEvent):void
		{
			if(_player.state == PlayerState.ARRIVE ||
				_player.state == PlayerState.CRASHED_LEFT ||
				_player.state == PlayerState.CRASHED_RIGHT)
			{
				return;
			}
			
			var pointsTemp:Vector.<Point> = event.data as Vector.<Point>;
			trace(pointsTemp);
			if(pointsTemp.length <= 1)
				return;
			var prevTouch:Point = pointsTemp[0];
			var currentTouch:Point = pointsTemp[pointsTemp.length-1];
			
			trace(currentTouch.y - prevTouch.y);
			trace("_yForJump = " + _yForJump);
			
			if(currentTouch.y - prevTouch.y > _yForJump)
			{
				//trace("JUMPJUMPJUMP");
				_player.state = PlayerState.JUMP;
			}
		}
		
		/**
		 * 
		 * @param event 터치 hover 
		 * 사용자의 터치 좌표를 바탕으로 점프와 이동을 하는 콜백 메소드
		 */
		private function onTouchHover(event:TrollingEvent):void
		{
			if(_player.state == PlayerState.ARRIVE ||
				_player.state == PlayerState.CRASHED_LEFT ||
				_player.state == PlayerState.CRASHED_RIGHT)
			{
				return;
			}				
			
			var point:Point = Point(event.data[0]).clone();
			point.x *= (_stageWidth / Screen.mainScreen.bounds.width);
			point.y *= (_stageHeight / Screen.mainScreen.bounds.height);
			
						
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
			
//			trace("point.x = " + point.x);
//			trace("player.x = " + _player.x);
//			trace("player.penguin.x = " + _player.penguin.x);
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
		
			
			
			if(_speed < MAX_SPEED && _player.state != PlayerState.FALL && !_playerArrive)
			{
				_speed += MAX_SPEED / 50;
			}
			//trace("현재 속도 = " + _speed);
			_distanceToFinish -= _speed;
			_intervalBetweenObject += _speed;
			//trace(_intervalBetweenObject);
			if(_intervalBetweenObject > 100)
			{
				//구름 생성
				var cloud:Cloud = new Cloud();
				addChild(cloud);
				
				if(_objectArray.length != 0)
				{
					//trace(_objectArray[0] + "오브젝트 생성");
					makeObject();
					_objectArray.shift();
				}
				_intervalBetweenObject = 0;
			}
						
			
			if(_curveCount < _maxCurveCount)
			{
				if( _objectArray.length < _curveDistanceVector[_curveCount])
				{
					trace("****************커브 변경****************");
					_background.changeCurve(_curveDirectionVector[_curveCount]);	
					//_curveDistanceArray.shift();
					_curveCount++;
				}
			}
						
			
			switch(_background.curve)
			{
				case -1:
					break;
				case 0:
					_player.x += _playerSpeed * 0.5;
					break;
				case 1:
					_player.x -= _playerSpeed * 0.5;
					break;
				default:
					break;
			}		
			
			if(_playerArrive && _player.state == PlayerState.RUN)
			{
				_player.state = PlayerState.ARRIVE;
			}
		}
		
		/**
		 * 도착 
		 * @param event
		 * 
		 */
		private function onArrive(event:TrollingEvent):void
		{
			trace("원모어타임");
			_playerArrive = true;
			_speed = 0;
			_coverFace.removeEventListener(TrollingEvent.TOUCH_HOVER, onTouchHover);
			event.currentTarget.removeEventListener(PlayerState.ARRIVE, onArrive);
		}
		
		/**
		 * 데이터를 읽어서 array에 푸쉬하는 메소드 
		 * @param stageName
		 * 
		 */
		private function readTXT(fileName:String):void
		{
			var file:File = new File();
			var stream:FileStreamWithLineReader = new FileStreamWithLineReader();
			file = File.applicationDirectory.resolvePath(fileName);
			var lineCount:int;
			var findStage:Boolean;
			
			if(file.exists)
			{
				stream.open(file, FileMode.READ);
				while(stream.bytesAvailable)
				{
					var line:String = stream.readUTFLine();
					
					if(line != "#"+_currentStage.toString() && !findStage)
					{
						continue;
					}
					else
					{
						//trace(line);
						findStage = true;
						switch(lineCount)
						{
							case 0:
								break;							
							case 1:
								var tempArray:Array = line.split('/');
								
								for(var i:int = 0; i < tempArray.length; ++i)
								{
									_curveDistanceVector.push(int(tempArray[i].split(',')[0]));
									_curveDirectionVector.push(int(tempArray[i].split(',')[1]));
									_maxCurveCount++;
								}
								trace("--------------커브------------------");
//								for(i = 0; i < tempArray.length; ++i)
//								{
//									trace(_curveDistanceVector[i]);
//									trace(_curveDirectionVector[i]);
//								}
								break;
							case 2:
								_objectArray = new Array();
								_objectArray = line.split(',');
								break;
							default:
								break;
						}
						lineCount++;
						if(lineCount >= 3)
						{
							break;
						}
					}				
				}
				stream.close();
			}
			else
			{
				trace(fileName + " open error");
			}
		}
		
		/**
		 * 오브젝트를 생성하는 메소드 
		 * 
		 */
		private function makeObject():void
		{
			switch(int(_objectArray[0]))
			{
				//도착
				case -1:
					var home:Home = new Home();
					addChildAt(home, 1);
					home.addEventListener(PlayerState.ARRIVE, onArrive);
					break;
				//아무것도 생성 안함
				case 0:
					break;
				//타원 크레이터 가운데
				case 1:
					var ellipseCrater:EllipseCrater = new EllipseCrater(-1);
					addChildAt(ellipseCrater, 1);
					break;
				//타원 크레이터 왼쪽
				case 2:
					ellipseCrater = new EllipseCrater(0);
					addChildAt(ellipseCrater, 1);
					break;
				//타원 크레이터 오른쪽
				case 3:
					ellipseCrater = new EllipseCrater(1);
					addChildAt(ellipseCrater, 1);
					break;
				//타원 크레이터 왼쪽, 오른쪽
				case 4:
					ellipseCrater = new EllipseCrater(0);
					addChildAt(ellipseCrater, 1);
					ellipseCrater = new EllipseCrater(1);
					addChildAt(ellipseCrater, 1);
					break;
				//네모 크레이터 왼쪽
				case 5:
					var rectangleCrater:RectangleCrater = new RectangleCrater(0);
					addChildAt(rectangleCrater, 1);
					break;
				//네모 크레이터 오른쪽
				case 6:
					rectangleCrater = new RectangleCrater(1);
					addChildAt(rectangleCrater, 1);
					break;
				//깃발 왼쪽
				case 7:
					var flag:Flag = new Flag(0);
					addChildAt(flag, 1);
					break;
				//깃발 오른쪽
				case 8:
					flag = new Flag(1);
					addChildAt(flag, 1);
					break;
				default:
					break;
				
			}
		}
	
	}
}