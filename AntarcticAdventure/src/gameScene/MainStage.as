package gameScene
{
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
	import gameScene.util.ObjectName;
	import gameScene.util.PlayerState;
	
	import trolling.event.TrollingEvent;
	import trolling.media.Sound;
	import trolling.media.SoundManager;
	import trolling.object.GameObject;
	import trolling.object.Scene;
	import gameScene.ui.IngameUi;

	public class MainStage extends Scene
	{
		private var _isStop:Boolean;
		private var _currentStage:int;
		private var _player:Player;
		private var _enemy:Enemy;
		
		private var _background:Background;
		private var _ui:IngameUi;
		private var _coverFace:GameObject = new GameObject();
		private static var _stageWidth:int;
		private static var _stageHeight:int;
		
		private static const MAX_SPEED:Number = 5;
		private static var _speed:Number;						//세로 
		private var _playerSpeed:Number;						//가로
		
		private var _yForJump:Number;
		private var _xForStruggle:Number;
		private var _xForMoveAtLeast:Number;		
		
		//private var _distanceToFinish:Number;
		private var _intervalBetweenObject:Number = 0;
		
		private var _objectArray:Array;
		
		private var _curveDistanceVector:Vector.<int> = new Vector.<int>();
		private var _curveDirectionVector:Vector.<int> = new Vector.<int>();
		private var _maxCurveCount:int;
		private var _curveCount:int
		
		private static var _coverFaceForFall:GameObject = new GameObject();
		private var _fallFlag:Boolean;
		
		
		private var _soundDic:Dictionary = new Dictionary();
		private var _soundURL:Vector.<String> = new Vector.<String>();
		private var _soundLoadCount:uint = 0;
		private var _filePath:File = File.applicationDirectory;
		
		private var _playerArrive:Boolean;
		
		private var _playerMaxLife:int;
		private var _totalNumFlag:int;
		
		public static function get coverFaceForFall():GameObject { return _coverFaceForFall; }
		public static function set coverFaceForFall(value:GameObject):void { _coverFaceForFall = value; }

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
			_currentStage = this.data as int;
			
			
			
			_stageWidth = this.width;
			_stageHeight = this.height;
			
			_yForJump = _stageHeight * 0.05;
			_xForStruggle = _stageWidth * 5;
			_xForMoveAtLeast = _stageWidth / 50;
			
			_speed = 0; 
			_playerSpeed = _stageWidth / 100;
			
			_background = new Background();
			addChild(_background);
			
			_ui = new IngameUi();
			addChild(_ui);
			
			_player = new Player();			
			addChild(_player); 				
			
			readTXT("stage.txt");
			
			_coverFace.width = _stageWidth;
			_coverFace.height = _stageHeight;
			_coverFace.addEventListener(TrollingEvent.TOUCH_HOVER, onTouchHover);		
			_coverFace.addEventListener(TrollingEvent.TOUCH_ENDED, onTouchEnded);
			addChild(_coverFace);
			
			_coverFaceForFall.width = _stageWidth;
			_coverFaceForFall.height = _stageHeight;
			_coverFaceForFall.addEventListener(TrollingEvent.TOUCH_HOVER, onTouchCoverFaceForFall);	
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);	
			
			pushSoundFiles();
			loadSound();
			
			 
	
		}
		
		private function onCompleteReadTxt():void
		{
			// UI 테스트용 변수 임의 설정 !
			_playerMaxLife = 5;
			//
			
			_ui.initialize(_currentStage, _objectArray.length, _playerMaxLife, _totalNumFlag);
			
			
			_player.maxLife = _playerMaxLife;
			_player.setCurrentLifeAtUi = setCurrentLife;
			_player.setCurrentFlagAtUi = setCurrentFlag;
			_player.onFailed = onFaild;
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
			if(pointsTemp.length <= 1)
				return;
			var prevTouch:Point = pointsTemp[0];
			var currentTouch:Point = pointsTemp[pointsTemp.length-1];
			
			
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
						
			//플레이어 위치와 너무 가까운 곳을 터치하면 플레이어 이동 안함
			if(Math.abs(point.x - _player.x) > _xForMoveAtLeast)
			{
				//터치 지점이 현재 플레이어 위치보다 오른쪽
				if(point.x > _player.x)
				{
					_player.x += _playerSpeed;
				}
				else
				{
					_player.x -= _playerSpeed;
				}
			}
			
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
		
			//trace("메인클래스 state = " + _player.state); 
			
			if(_speed < MAX_SPEED && 
				_player.state != PlayerState.FALL &&
				_player.state != PlayerState.STRUGGLE
				&&!_playerArrive)
			{
				_speed += MAX_SPEED / 50;				
			}
			
			_intervalBetweenObject += _speed;
			
			if(_intervalBetweenObject > 100)
			{
				//구름 생성
				var cloud:Cloud = new Cloud();
				addChildAt(cloud, 1);
				
				if(_objectArray.length != 0)
				{
					//trace(_objectArray[0] + "오브젝트 생성");
					makeObject();
					_objectArray.shift();
					// UI 남은 거리 업데이트
					if(_ui)
					{
						_ui.setCurrentDistance(_objectArray.length);
					}
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
					if(_player.state == PlayerState.FALL ||
						_player.state == PlayerState.STRUGGLE)
					{
						break;
					}
					_player.x += _playerSpeed * 0.5;
					break;
				case 1:
					if(_player.state == PlayerState.FALL ||
						_player.state == PlayerState.STRUGGLE)
					{
						break;
					}
					_player.x -= _playerSpeed * 0.5;
					break;
				default:
					break;
			}		
			
			if(_playerArrive && _player.state == PlayerState.RUN)
			{
				_player.state = PlayerState.ARRIVE;
			}
			
			if(_player.state == PlayerState.FALL)
			{
				if(!_player.fallFlag)
				{
					trace("빠짐빠짐빠짐빠짐빠짐빠짐빠짐빠짐빠짐빠짐빠짐빠짐빠짐빠짐빠짐");			
					addChild(_coverFaceForFall);
					_player.fallFlag = true;
				}
				
			}
		}
		
		private function onTouchCoverFaceForFall(event:TrollingEvent):void
		{
			
			//trace("위에있는 커버페이스");
			
			var point:Point = Point(event.data[0]).clone();
			
			if(event.data.length >= 10)
			{
				var prevTouchX:int;
				var currentTouchX:int;
				for(var i:int = 0; i<event.data.length; ++i)
				{
					
					if(i < 5)
					{
						currentTouchX += int(event.data[i].x);
					}
					else
					{
						prevTouchX += int(event.data[i].x);
					}
					
				}
				//trace(currentTouchY - prevTouchY);
				if(Math.abs(prevTouchX - currentTouchX) > _xForStruggle)
				{
					//trace("STRUGGLE");
					_player.state = PlayerState.STRUGGLE;
				}
				else
				{
					//trace("FALL");
					_player.state = PlayerState.FALL;
				}
			}
			
			else
			{
				//trace("FALL");
				_player.state = PlayerState.FALL;
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
								break;
							
							case 2:
								_objectArray = new Array();
								_objectArray = line.split(',');
								
								// 깃발 개수 카운트
								_totalNumFlag = 0;
								if (_objectArray)
								{
									for (i = 0; i < _objectArray.length; i++)
									{
										if (int(_objectArray[i]) == ObjectName.FLAG_LEFT || int(_objectArray[i]) == ObjectName.FLAG_RIGHT)
										{
											_totalNumFlag++;
										}
									}
								}								
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
				
				onCompleteReadTxt();
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
				case ObjectName.HOME:
					var home:Home = new Home();
					addChildAt(home, 1);
					home.addEventListener(PlayerState.ARRIVE, onArrive);
					break;
				//아무것도 생성 안함
				case ObjectName.EMPTY:
					break;
				//타원 크레이터 가운데
				case ObjectName.ELLIPSE_NORMAL:
					var ellipseCrater:EllipseCrater = new EllipseCrater(-1);
					addChildAt(ellipseCrater, 1);
					break;
				//타원 크레이터 왼쪽
				case ObjectName.ELLIPSE_LEFT:
					ellipseCrater = new EllipseCrater(0);
					addChildAt(ellipseCrater, 1);
					break;
				//타원 크레이터 오른쪽
				case ObjectName.ELLIPSE_RIGHT:
					ellipseCrater = new EllipseCrater(1);
					addChildAt(ellipseCrater, 1);
					break;
				//타원 크레이터 왼쪽, 오른쪽
				case ObjectName.ELLIPSE_LEFT_RIGHT:
					ellipseCrater = new EllipseCrater(0);
					addChildAt(ellipseCrater, 1);
					ellipseCrater = new EllipseCrater(1);
					addChildAt(ellipseCrater, 1);
					break;
				//네모 크레이터 왼쪽
				case ObjectName.RECT_LEFT:
					var rectangleCrater:RectangleCrater = new RectangleCrater(0);
					addChildAt(rectangleCrater, 1);
					break;
				//네모 크레이터 오른쪽
				case ObjectName.RECT_RIGHT:
					rectangleCrater = new RectangleCrater(1);
					addChildAt(rectangleCrater, 1);
					break;
				//깃발 왼쪽
				case ObjectName.FLAG_LEFT:
					var flag:Flag = new Flag(0);
					addChildAt(flag, 1);
					break;
				//깃발 오른쪽
				case ObjectName.FLAG_RIGHT:
					flag = new Flag(1);
					addChildAt(flag, 1);
					break;
				default:
					break;
				
			}
		}
		
		private function setCurrentLife(numLife:int):void
		{
			if (_ui)
			{
				_ui.setCurrentLife(numLife);
			}
		}
		
		private function setCurrentFlag(numFlag:int):void
		{
			if (_ui)
			{
				_ui.setCurrentFlag(numFlag);
			}
		}
		
		private function onFaild():void
		{
			// to do
			
			
			
		}
		
		private function onCleared():void
		{
			// to do
			
			
			
		}
	
	}
}