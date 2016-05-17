package scene.gameScene
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import scene.gameScene.background.Background;
	import scene.gameScene.background.Cloud;
	import scene.gameScene.object.crater.EllipseCrater;
	import scene.gameScene.object.crater.RectangleCrater;
	import scene.gameScene.object.enemy.Enemy;
	import scene.gameScene.object.home.Home;
	import scene.gameScene.object.item.Coke;
	import scene.gameScene.object.item.Flag;
	import scene.gameScene.object.player.Player;
	import scene.gameScene.ui.IngameUI;
	import scene.gameScene.util.ObjectName;
	import scene.gameScene.util.PlayerState;
	import scene.loading.Resources;
	
	import trolling.core.Trolling;
	import trolling.event.TrollingEvent;
	import trolling.media.Sound;
	import trolling.media.SoundManager;
	import trolling.object.GameObject;
	import trolling.object.Scene;
	import scene.loading.Resources;

	public class MainStage extends Scene
	{
		private static var _currentStage:int;
		
//		private var _resource:Resource;
		
		private var _player:Player;
		private var _enemy:Enemy;		
		private var _background:Background;
		private var _ui:IngameUI;
		private var _coverFace:GameObject = new GameObject();
		
		private static var _stageWidth:int;
		private static var _stageHeight:int;
		
		private static const MAX_SPEED:Number = 5;
		private static var _speed:Number;						//세로 
		private var _playerSpeed:Number;						//가로
		
		private var _yForJump:Number;
		private var _xForStruggle:Number;
		private var _xForMoveAtLeast:Number;		
		
		private var _intervalBetweenObject:Number = 0;
		
		private var _objectArray:Array = new Array();
		private var _backgroundColor:int;
		
		//private var _curveDistanceVector:Vector.<int> = new Vector.<int>();
		private var _curveDirectionVector:Vector.<int> = new Vector.<int>();
		//private var _maxCurveCount:int;
		//private var _curveCount:int
		
		//private static var _coverFaceForFall:GameObject = new GameObject();
		//private var _fallFlag:Boolean;
		
		private var _soundDic:Dictionary = new Dictionary();
		private var _soundURL:Vector.<String> = new Vector.<String>();
		private var _soundLoadCount:uint = 0;
		private var _filePath:File = File.applicationDirectory;
		
		private var _spriteDir:File = File.applicationDirectory.resolvePath("scene/gameScene/sprite");
		private var _soundDir:File = File.applicationDirectory.resolvePath("scene/gameScene/sound");
		
		private var _playerArrive:Boolean;
		private static var _stageEnded:Boolean = false;
		
		private var _playerMaxLife:int;
		private var _totalNumFlag:int;
		
		private var _resource:Resources;
		private var _control:int;
		/** 0 = Screen Mode , 1 = Button Mode */
		private var _controlMode:int;
		private var _controller:Controller;
		
		//public static function get coverFaceForFall():GameObject { return _coverFaceForFall; }
		//public static function set coverFaceForFall(value:GameObject):void { _coverFaceForFall = value; }
		
		public static function get currentStage():int { return _currentStage; }
		public static function set stageEnded(value:Boolean):void { _stageEnded = value; }
		
		public static function get stageHeight():int { return _stageHeight; }
		public static function get stageWidth():int { return _stageWidth; }
		
		public static function get maxSpeed():Number { return MAX_SPEED; }
		
		public static function set speed(value:Number):void	{ _speed = value; }		
		public static function get speed():Number {	return _speed; }
	
		public function MainStage()
		{
			addEventListener(TrollingEvent.START_SCENE, oninit);
		}
		
		public function pause(value:Boolean):void
		{
			this.active = value;
		}
		
		private function oninit(event:Event):void
		{
			_currentStage = this.data as int;
			_stageEnded = false;
			
//			_resource = new Resource();
//			_resource.addEventListener("loadedAllImages", onLoadedAllImages);
			
			_resource = new Resources(_spriteDir, _soundDir);
			_resource.addSpriteName("MainStageSprite0.png");
			
			_resource.addSoundName("crashed0.mp3");
			_resource.addSoundName("crashed1.mp3");
			_resource.addSoundName("fall.mp3");
			_resource.addSoundName("fish.mp3");
			_resource.addSoundName("flag.mp3");
			_resource.addSoundName("jump.mp3");
			_resource.addSoundName("MainBgm.mp3");
			_resource.addSoundName("stageCleared.mp3");
			_resource.addSoundName("stageFailed.mp3");
			
			_resource.loadResource(onLoadedAllImages, onFailImageLoad);
			
			_stageWidth = this.width;
			_stageHeight = this.height;
			
			_yForJump = _stageHeight * 0.05;
			_xForStruggle = _stageWidth * 0.3;
			_xForMoveAtLeast = _stageWidth / 50;
			
			_speed = 0; 
			_playerSpeed = _stageWidth / 100;			 
		}
		
		private function onFailImageLoad(message:String):void
		{
			trace(message);
		}
		
		private function onLoadedAllImages():void
		{
			_ui = new IngameUI();
			
			_player = new Player(_resource);			
			addChild(_player);
			
			//readTXT("stage.txt");
			loadJSON("stage"+_currentStage+".json");
			
			_resource.getSoundFile("MainBgm.mp3").volume = 0.5;
			_resource.getSoundFile("MainBgm.mp3").loops = Sound.INFINITE;
			SoundManager.play("MainBgm.mp3");
			
			_resource.getSoundFile("stageFailed.mp3").loops = Sound.INFINITE;
			
			_resource.getSoundFile("stageCleared.mp3").loops = Sound.INFINITE;
		}
		
//		private function onCompleteReadTxt():void
//		{
//			// UI 테스트용 변수 임의 설정 !
//			_playerMaxLife = 5;
//			//
//			_ui.initialize(_currentStage, _objectArray.length, _playerMaxLife, _totalNumFlag, pause);
//			
//			_player.maxLife = _playerMaxLife;
//			_player.setCurrentLifeAtUi = setCurrentLife;
//			_player.setCurrentFlagAtUi = setCurrentFlag;
//				
// 
//			_player.onCleared = onCleared;
//			_player.onFailed = onFailed;
//		}

		
		/**
		 * 터치 뗏을때 이벤트
		 * @param event
		 * 
		 */
		private function onTouchEnded(event:TrollingEvent):void
		{
			if(_controlMode == 1)
				return;
			
			if(_player.state == PlayerState.ARRIVE ||
				_player.state == PlayerState.CRASHED_LEFT ||
				_player.state == PlayerState.CRASHED_RIGHT ||
				_player.state == PlayerState.FALL ||
				_player.state == PlayerState.STRUGGLE ||
				_player.state == PlayerState.DASH)
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
			if(_controlMode == 1)
				return;
			
			if(_player.state == PlayerState.ARRIVE ||
				_player.state == PlayerState.CRASHED_LEFT ||
				_player.state == PlayerState.CRASHED_RIGHT)
			{
				return;
			}	
			
			if(_player.state == PlayerState.FALL ||
				_player.state == PlayerState.STRUGGLE)
			{
				var pointsTemp:Vector.<Point> = event.data as Vector.<Point>;
				if(pointsTemp.length <= 1)
					return;
				var prevTouch:Point = pointsTemp[0];
				var currentTouch:Point = pointsTemp[pointsTemp.length-1];
				
				//trace(currentTouch.x - prevTouch.x);
				if(currentTouch.x - prevTouch.x > _xForStruggle)
				{				
					_player.struggleLeftCount++;
					if(_player.state == PlayerState.FALL)
						_player.state = PlayerState.STRUGGLE;
					
					//trace(_player.struggleLeftCount);
				}
				
				if(currentTouch.x - prevTouch.x < -_xForStruggle)
				{
					_player.struggleRightCount++;
					if(_player.state == PlayerState.FALL)
						_player.state = PlayerState.STRUGGLE;
					
					//trace(_player.struggleRightCount);
				}
				
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
		
			if (!this.active || _stageEnded)
			{
				return;
			}
			
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
				var cloud:Cloud = new Cloud(_resource);
				addChildAt(cloud, 1);
				
				if(_objectArray && _objectArray.length != 0)
				{
					//var curveIndex:int = ;
					if(_objectArray.length % 10 == 0 && _curveDirectionVector.length != 0)
					{
						_background.changeCurve(_curveDirectionVector[0]);
						_curveDirectionVector.shift();
					}
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
			
			
			
			if(_background)
			{
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
					//_coverFace.addChildAt(_coverFaceForFall, 0);
					_player.fallFlag = true;
				}
				
			}
		}
		
//		/**
//		 * 
//		 * @param event
//		 * 빠짐 상태 전용 커버 페이스 터치 이벤트 리스너
//		 */
//		private function onTouchCoverFaceForFall(event:TrollingEvent):void
//		{
//			var pointsTemp:Vector.<Point> = event.data as Vector.<Point>;
//			if(pointsTemp.length <= 1)
//				return;
//			var prevTouch:Point = pointsTemp[0];
//			var currentTouch:Point = pointsTemp[pointsTemp.length-1];
//			
//			//trace(currentTouch.x - prevTouch.x);
//			if(currentTouch.x - prevTouch.x > _xForStruggle)
//			{				
//				_player.struggleLeftCount++;
//				if(_player.state == PlayerState.FALL)
//					_player.state = PlayerState.STRUGGLE;
//				
//				//trace(_player.struggleLeftCount);
//			}
//			
//			if(currentTouch.x - prevTouch.x < -_xForStruggle)
//			{
//				_player.struggleRightCount++;
//				if(_player.state == PlayerState.FALL)
//					_player.state = PlayerState.STRUGGLE;
//				
//				//trace(_player.struggleRightCount);
//			}
//		} 
		/**
		 * 도착 
		 * @param event
		 * 
		 */
		private function onArrive(event:TrollingEvent):void
		{
			trace("집 도착");
			_playerArrive = true;
			_coverFace.active = false;
			_controller.active = false;
			
			_speed = 0;
			_coverFace.removeEventListener(TrollingEvent.TOUCH_HOVER, onTouchHover);
			event.currentTarget.removeEventListener(PlayerState.ARRIVE, onArrive);
		}
		
		private function loadJSON(fileName:String):void
		{
			var urlRequest:URLRequest  = new URLRequest(fileName);
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onCompleteLoadJSON);
			
			try
			{
				urlLoader.load(urlRequest);
			} 
			catch (error:Error)
			{
				trace("Cannot load : " + error.message);
			}
		}
		
		private function onCompleteLoadJSON(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			trace("completeHandler: " + loader.data);
			
			var data:Object = JSON.parse(loader.data);
			//trace("The answer is " + data.id+" ; "+data.first_var+" ; "+data.second_var);
//			trace(data.stage);
//			trace(data.backgroundColor);
//			trace(data.curve);
//			trace(data.object);			
			
			_backgroundColor = data.backgroundColor;			
			
			for(var i:int = 0; i < data.curve.length; ++i)
			{
				_curveDirectionVector.push(data.curve[i]);
			}
			
			for(i = 0; i < data.object.length; ++i)
			{
				_objectArray.push(data.object[i]);
				if (data.object[i] == ObjectName.FLAG_LEFT || data.object[i] == ObjectName.FLAG_RIGHT)
				{
					_totalNumFlag++;
				}
			}
			
			//onCompleteReadTxt();
			// UI 테스트용 변수 임의 설정 !
			_playerMaxLife = 5;
			//
			_ui.initialize(_currentStage, _objectArray.length, _playerMaxLife, _totalNumFlag, pause);
			_ui.addEventListener("control", onEndedControl);
			_ui.addEventListener("settingPopup", onEndedSettingPopup);
			_ui.addEventListener("initControlMode", onInitControlMode);
			//_ui.
			
			_player.maxLife = _playerMaxLife;
			_player.setCurrentLifeAtUi = setCurrentLife;
			_player.setCurrentFlagAtUi = setCurrentFlag;
			
			
			_player.onCleared = onCleared;
			_player.onFailed = onFailed;
			
			_background = new Background(_resource, _backgroundColor);
			addChildAt(_background, 0);
			
			
			
			
			//			
			_coverFace.width = _stageWidth;
			_coverFace.height = _stageHeight;
			_coverFace.addEventListener(TrollingEvent.TOUCH_HOVER, onTouchHover);		
			_coverFace.addEventListener(TrollingEvent.TOUCH_ENDED, onTouchEnded);
			addChild(_coverFace);
			
			_coverFace.addChild(_ui);
			
			_controller = new Controller(_resource);
			_coverFace.addChild(_controller);
			_controller.addEventListener("move", onMove);
			_controller.addEventListener("jump", onJump);
			_controller.visible = false;
			
			
			//_coverFaceForFall.width = _stageWidth;
			//_coverFaceForFall.height = _stageHeight * 0.8;
			//_coverFaceForFall.y = _stageHeight * 0.2;
			//_coverFaceForFall.addEventListener(TrollingEvent.TOUCH_HOVER, onTouchCoverFaceForFall);	
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);				
		}
		
//		/**
//		 * 데이터를 읽어서 array에 푸쉬하는 메소드 
//		 * @param stageName
//		 * 
//		 */
//		private function readTXT(fileName:String):void
//		{
//			var file:File = new File();
//			var stream:FileStreamWithLineReader = new FileStreamWithLineReader();
//			file = File.applicationDirectory.resolvePath(fileName);
//			var lineCount:int;
//			var findStage:Boolean;
//			
//			if(file.exists)
//			{
//				stream.open(file, FileMode.READ);
//				while(stream.bytesAvailable)
//				{
//					var line:String = stream.readUTFLine();
//					
//					if(line != "#"+_currentStage.toString() && !findStage)
//					{
//						continue;
//					}
//					else
//					{
//						//trace(line);
//						findStage = true;
//						switch(lineCount)
//						{
//							case 0:
//								break;	
//							
//							case 1:
//								var tempArray:Array = line.split('/');
//								
//								for(var i:int = 0; i < tempArray.length; ++i)
//								{
//									_curveDistanceVector.push(int(tempArray[i].split(',')[0]));
//									_curveDirectionVector.push(int(tempArray[i].split(',')[1]));
//									_maxCurveCount++;
//								}
//								break;
//							
//							case 2:
//								_objectArray = new Array();
//								_objectArray = line.split(',');
//								
//								// 깃발 개수 카운트
//								_totalNumFlag = 0;
//								if (_objectArray)
//								{
//									for (i = 0; i < _objectArray.length; i++)
//									{
//										if (int(_objectArray[i]) == ObjectName.FLAG_LEFT || int(_objectArray[i]) == ObjectName.FLAG_RIGHT)
//										{
//											_totalNumFlag++;
//										}
//									}
//								}								
//								break;
//							
//							default:
//								break;
//						}
//						lineCount++;
//						if(lineCount >= 3)
//						{
//							break;
//						}
//					}				
//				}
//				stream.close();
//				
//				onCompleteReadTxt();
//			}
//			else
//			{
//				trace(fileName + " open error");
//			}
//		}
		
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
					var home:Home = new Home(_resource);
					addChildAt(home, 1);
					home.addEventListener(PlayerState.ARRIVE, onArrive);
					break;
				//아무것도 생성 안함
				case ObjectName.EMPTY:
					break;
				//타원 크레이터 가운데
				case ObjectName.ELLIPSE_NORMAL:
					var ellipseCrater:EllipseCrater = new EllipseCrater(_resource, -1);
					addChildAt(ellipseCrater, 1);
					break;
				//타원 크레이터 왼쪽
				case ObjectName.ELLIPSE_LEFT:
					ellipseCrater = new EllipseCrater(_resource, 0);
					addChildAt(ellipseCrater, 1);
					break;
				//타원 크레이터 오른쪽
				case ObjectName.ELLIPSE_RIGHT:
					ellipseCrater = new EllipseCrater(_resource, 1);
					addChildAt(ellipseCrater, 1);
					break;
				//타원 크레이터 왼쪽, 오른쪽
				case ObjectName.ELLIPSE_LEFT_RIGHT:
					ellipseCrater = new EllipseCrater(_resource, 0);
					addChildAt(ellipseCrater, 1);
					ellipseCrater = new EllipseCrater(_resource, 1);
					addChildAt(ellipseCrater, 1);
					break;
				//네모 크레이터 왼쪽
				case ObjectName.RECT_LEFT:
					var rectangleCrater:RectangleCrater = new RectangleCrater(_resource, 0);
					addChildAt(rectangleCrater, 1);
					break;
				//네모 크레이터 오른쪽
				case ObjectName.RECT_RIGHT:
					rectangleCrater = new RectangleCrater(_resource, 1);
					addChildAt(rectangleCrater, 1);
					break;
				//깃발 왼쪽
				case ObjectName.FLAG_LEFT:
					var flag:Flag = new Flag(_resource, 0);
					addChildAt(flag, 1);
					break;
				//깃발 오른쪽
				case ObjectName.FLAG_RIGHT:
					flag = new Flag(_resource, 1);
					addChildAt(flag, 1);
					break;
				//콜라 가운데
				case ObjectName.COKE_NORMAL:
					var coke:Coke = new Coke(_resource, -1);
					addChildAt(coke, 1);
					break;
				//콜라 왼쪽
				case ObjectName.COKE_LEFT:
					coke = new Coke(_resource, 0);
					addChildAt(coke, 1);
					break;
				//콜라 오른쪽
				case ObjectName.COKE_RIGHT:
					coke = new Coke(_resource, 1);
					addChildAt(coke, 1);
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
		
		private function onFailed():void
		{
			if (_ui)
			{
				if(_controlMode == 1)
				{
					_controller.visible = false;					
				}
				_ui.showPopup(IngameUI.FAILED);
			}
		}
		
		private function onCleared():void
		{
			if (_ui)
			{
				if(_controlMode == 1)
				{
					_controller.visible = false;					
				}
				_coverFace.active = true;
				_ui.showPopup(IngameUI.CLEARED);
			}
		}
		
		private function onEndedControl(event:TrollingEvent):void
		{
			_controlMode = int(event.data);
		}
		
		private function onEndedSettingPopup(event:TrollingEvent):void
		{
			trace("셋팅팝업 : " + event.data);
			if(event.data == true)
			{
				_controller.visible = false;				
			}
			
			else
			{
				if(_controlMode == 0)
				{
					_controller.visible = false;					
				}
				else
				{
					_controller.visible = true;					
				}
				
			}
		}
		
		private function onInitControlMode(event:TrollingEvent):void
		{
			trace("_controlMode = " + _controlMode);
			_controlMode = int(event.data);
			if(_controlMode == 1)
			{
				_controller.visible = true;	
			}
		}
		
		private function onMove(event:TrollingEvent):void
		{
			if(_controlMode == 0)
				return;
			
			trace("movemovemove");
			if(_player.state == PlayerState.RUN || _player.state == PlayerState.JUMP || _player.state == PlayerState.DASH)
			{
				if(event.data == 0)
				{
					_player.x -= _playerSpeed;
				}
				else
				{
					_player.x += _playerSpeed;
				}
			}
			
			else if(_player.state == PlayerState.FALL || _player.state == PlayerState.STRUGGLE)
			{
				if(event.data == 0)
				{
					_player.struggleLeftCount++;
					if(_player.state == PlayerState.FALL)
						_player.state = PlayerState.STRUGGLE;
				}
				else
				{
					_player.struggleRightCount++;
					if(_player.state == PlayerState.FALL)
						_player.state = PlayerState.STRUGGLE;
				}
			}
			
			
		}
		
		private function onJump(event:TrollingEvent):void			
		{
			if(_controlMode == 0)
				return;
			
			if(_player.state == PlayerState.RUN)
			{
				_player.state = PlayerState.JUMP;
			}
		}
	}
}