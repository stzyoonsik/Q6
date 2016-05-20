package scene.gameScene
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import gameData.AesCrypto;
	import gameData.SettingData;
	
	import loading.Loading;
	import loading.LoadingEvent;
	import loading.Resources;
	
	import scene.gameScene.background.Background;
	import scene.gameScene.background.Cloud;
	import scene.gameScene.background.Snow;
	import scene.gameScene.object.crater.EllipseCrater;
	import scene.gameScene.object.crater.RectangleCrater;
	import scene.gameScene.object.enemy.Enemy;
	import scene.gameScene.object.home.Home;
	import scene.gameScene.object.item.Coke;
	import scene.gameScene.object.item.Flag;
	import scene.gameScene.object.player.Player;
	import scene.gameScene.ui.Controller;
	import scene.gameScene.ui.IngameUI;
	import scene.gameScene.ui.SettingPopup;
	import scene.gameScene.util.ObjectName;
	import scene.gameScene.util.PlayerState;
	
	import trolling.event.TrollingEvent;
	import trolling.media.Sound;
	import trolling.media.SoundManager;
	import trolling.object.GameObject;
	import trolling.object.Scene;

	public class MainStage extends Scene
	{
		private static var _currentStage:int;

		private const PLAYER_MAX_LIFE:int = 5;
		
		private var _player:Player;
		private var _enemy:Enemy;		
		private var _background:Background;
		private var _snow:Snow;
		private var _snowVector:Vector.<GameObject>;
		private const MAX_SNOW_COUNT:int = 200;
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
		
		private var _curveDirectionVector:Vector.<int> = new Vector.<int>();
		
		private var _spriteDir:File = File.applicationDirectory.resolvePath("scene/gameScene/sprite");
		private var _soundDir:File = File.applicationDirectory.resolvePath("scene/gameScene/sound");
		private var _dataDir:File = File.applicationDirectory.resolvePath("scene/gameScene/data");
		
		private var _playerArrive:Boolean;
		private static var _stageEnded:Boolean = false;
		
		private var _totalNumFlag:int;
		
		private var _resource:Resources;
		private var _control:int;
		/** 0 = Screen Mode , 1 = Button Mode */
		private var _controlMode:int;
		private var _controller:Controller;
		
		private static var _vibration:Boolean;
		
		public static function get currentStage():int { return _currentStage; }
		public static function set stageEnded(value:Boolean):void { _stageEnded = value; }
		
		public static function get stageHeight():int { return _stageHeight; }
		public static function get stageWidth():int { return _stageWidth; }
		
		public static function get maxSpeed():Number { return MAX_SPEED; }
		
		public static function set speed(value:Number):void	{ _speed = value; }		
		public static function get speed():Number {	return _speed; }
		
		public static function get vibration():Boolean { return _vibration; }
	
		public function MainStage()
		{
			addEventListener(TrollingEvent.START_SCENE, oninit);
		}
		
		public override function dispose():void
		{
			// to do
			_ui.removeEventListener(IngameUI.ENDED_SETTING_BUTTON, onEndedSettingButton);
			_ui.removeEventListener(SettingPopup.VIBRATION_MODE, onEndedControl);
			_ui.removeEventListener(SettingPopup.INIT_VIBRATION_MODE, onInitControlMode);
			_ui.removeEventListener(SettingPopup.CONTROL_MODE, onEndedControl);
			_ui.removeEventListener(SettingPopup.INIT_CONTROL_MODE, onInitControlMode);
			
			
			
			super.dispose();
		}
		
		public function pause(value:Boolean):void
		{
			this.active = value;
		}
		
		private function oninit(event:Event):void
		{
			this.name = "MainStage";
			
			_currentStage = this.data as int;
			_stageEnded = false;
			
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
			
			Loading.current.setLoading(this, _resource.getTotalLoadCount());
			
			_resource.addEventListener(LoadingEvent.COMPLETE, onCompleteLoad);
			_resource.addEventListener(LoadingEvent.FAILED, onFailedLoad);
			_resource.addEventListener(LoadingEvent.PROGRESS, onProgressLoad);
			_resource.loadResource();
			
			_stageWidth = this.width;
			_stageHeight = this.height;
			
			_yForJump = _stageHeight * 0.05;
			_xForStruggle = _stageWidth * 0.3;
			_xForMoveAtLeast = _stageWidth / 50;
			
			_speed = 0;
			_playerSpeed = _stageWidth / 85;			 
		}
		
		private function onProgressLoad(event:LoadingEvent):void
		{
			Loading.current.setCurrent(event.data as Number);
		}
		
		private function onFailedLoad(event:LoadingEvent):void
		{
			trace(event.data as String);
			Resources(event.currentTarget).removeEventListener(LoadingEvent.COMPLETE, onCompleteLoad);
			Resources(event.currentTarget).removeEventListener(LoadingEvent.FAILED, onFailedLoad);
			Resources(event.currentTarget).removeEventListener(LoadingEvent.PROGRESS, onProgressLoad);
		}
		
		private function onCompleteLoad(event:LoadingEvent):void
		{
			Loading.current.loadComplete();
			Resources(event.currentTarget).removeEventListener(LoadingEvent.COMPLETE, onCompleteLoad);
			Resources(event.currentTarget).removeEventListener(LoadingEvent.FAILED, onFailedLoad);
			Resources(event.currentTarget).removeEventListener(LoadingEvent.PROGRESS, onProgressLoad);
			
			_ui = new IngameUI();
			
			_player = new Player(_resource);			
			addChild(_player);
			
			//readTXT("stage.txt");
			loadJSON("stage"+_currentStage+".json");
			
			var sound:Sound = _resource.getSoundFile("crashed0.mp3");
			if (sound)
			{
				sound.volume = 0.6;
				SoundManager.addSound("crashed0.mp3", sound);
			}
			
			sound = _resource.getSoundFile("crashed1.mp3");
			if (sound)
			{
				sound.volume = 0.6;
				SoundManager.addSound("crashed1.mp3", sound);
			}
			
			sound = _resource.getSoundFile("fall.mp3");
			if (sound)
			{
				sound.volume = 0.6;
				SoundManager.addSound("fall.mp3", sound);
			}
			
			sound = _resource.getSoundFile("fish.mp3");
			if (sound)
			{
				sound.volume = 0.6;
				SoundManager.addSound("fish.mp3", sound);
			}
			
			sound = _resource.getSoundFile("flag.mp3");
			if (sound)
			{
				sound.volume = 0.6;
				SoundManager.addSound("flag.mp3", sound);
			}
			
			sound = _resource.getSoundFile("jump.mp3");
			if (sound)
			{
				sound.volume = 0.6;
				SoundManager.addSound("jump.mp3", sound);
			}
			
			sound = _resource.getSoundFile("MainBgm.mp3");
			if (sound)
			{
				sound.volume = 0.3;
				sound.loops = Sound.INFINITE;
				SoundManager.addSound("MainBgm.mp3", sound);
				SoundManager.play("MainBgm.mp3");
			}
			
			sound = _resource.getSoundFile("stageCleared.mp3");
			if (sound)
			{
				sound.volume = 0.5;
				sound.loops = Sound.INFINITE;
				SoundManager.addSound("stageCleared.mp3", sound);
			}
			
			sound = _resource.getSoundFile("stageFailed.mp3");
			if (sound)
			{
				sound.volume = 0.6;
				sound.loops = Sound.INFINITE;
				SoundManager.addSound("stageFailed.mp3", sound);
			}			
		}
		
		/**
		 * 터치 뗏을때 이벤트
		 * @param event
		 * 
		 */
		private function onTouchEnded(event:TrollingEvent):void
		{
			if(_controlMode == SettingData.CONTROL_BUTTON)
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
			if(_controlMode == SettingData.CONTROL_BUTTON)
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
					if(_player.struggleLeftCount - _player.struggleRightCount <= 1)   
						_player.struggleLeftCount++;
					
					if(_player.state == PlayerState.FALL)
						_player.state = PlayerState.STRUGGLE;
					
					//trace(_player.struggleLeftCount);
				}
				
				if(currentTouch.x - prevTouch.x < -_xForStruggle)
				{
					if(_player.struggleRightCount - _player.struggleLeftCount <= 1)   
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
				if(_backgroundColor == -1){ var cloud:Cloud = new Cloud(_resource, -1); }
				else{ cloud = new Cloud(_resource, 0); }				
				addChildAt(cloud, 1);
				
				if(_objectArray && _objectArray.length != 0)
				{
					if(_objectArray.length % 10 == 0 && _curveDirectionVector.length != 0)
					{
						_background.changeCurve(_curveDirectionVector[0]);
						if(_snowVector)
						{
							for(var i:int = 0; i < _snowVector.length; ++i)
							{
								_snowVector[i].dispatchEvent(new TrollingEvent("changeCurve", _curveDirectionVector[0]));
							}
						}
						
						
						_curveDirectionVector.shift();
					}
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
					_player.fallFlag = true;
				}
				
			}
		}
		
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
			var urlRequest:URLRequest  = new URLRequest(_dataDir.resolvePath(fileName).url);
			
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
			var decryptData:String = AesCrypto.decrypt(loader.data, "jiminhyeyunyoonsik");
			var data:Object = JSON.parse(decryptData);
			
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
			
			_ui.initialize(_currentStage, _objectArray.length, PLAYER_MAX_LIFE, _totalNumFlag, pause);
			_ui.addEventListener(IngameUI.ENDED_SETTING_BUTTON, onEndedSettingButton);
			_ui.addEventListener(SettingPopup.INIT_VIBRATION_MODE, onInitVibrationMode);
			_ui.addEventListener(SettingPopup.INIT_CONTROL_MODE, onInitControlMode);
			_ui.addEventListener(SettingPopup.VIBRATION_MODE, onEndedVibration);
			_ui.addEventListener(SettingPopup.CONTROL_MODE, onEndedControl);
			
			_player.maxLife = PLAYER_MAX_LIFE;
			_player.setCurrentLifeAtUi = setCurrentLife;
			_player.setCurrentFlagAtUi = setCurrentFlag;
			_player.onCleared = onCleared;
			_player.onFailed = onFailed;
			
			
			//30%의 확률로 눈 내림
			if(Math.random() > 0.7)
			{
				_snowVector = new Vector.<GameObject>();
				_backgroundColor = -1;
				_background = new Background(_resource, _backgroundColor);
				addChildAt(_background, 0);
				
				for(i = 0; i < MAX_SNOW_COUNT; ++i)
				{
					_snow = new Snow(_resource);
					_snowVector.push(_snow);
					addChild(_snow);
				}				
			}
			else
			{
				_background = new Background(_resource, _backgroundColor);
				addChildAt(_background, 0);
			}
			
			
				
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
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			loader.removeEventListener(Event.COMPLETE, onCompleteLoadJSON);
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
					var home:Home = new Home(_resource, Number(_player.currentFlag/_totalNumFlag));
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
		
		/**
		 * ui의 현재 체력을 바꿔주는 메소드 
		 * @param numLife 체력
		 * 
		 */
		private function setCurrentLife(numLife:int):void
		{
			if (_ui)
			{
				_ui.setCurrentLife(numLife);
			}
		}
		
		/**
		 * ui의 현재 깃발 개수를 바꿔주는 메소드
		 * @param numFlag 현재 획득한 깃발
		 * 
		 */
		private function setCurrentFlag(numFlag:int):void
		{
			if (_ui)
			{
				_ui.setCurrentFlag(numFlag);
			}
		}
		
		/**
		 * 플레이어의 체력이 0이하가 되었을때 디스패치 받는 메소드 
		 * 
		 */
		private function onFailed():void
		{
			if (_ui)
			{
				if(_controlMode == SettingData.CONTROL_BUTTON)
				{
					_controller.visible = false;					
				}
				_ui.showPopup(IngameUI.FAILED);
			}
		}
		
		/**
		 * 성공적으로 완주했을때 디스패치 받는 메소드 
		 * 
		 */
		private function onCleared():void
		{
			if (_ui)
			{
				if(_controlMode == SettingData.CONTROL_BUTTON)
				{
					_controller.visible = false;					
				}
				_coverFace.active = true;
				_ui.showPopup(IngameUI.CLEARED);
			}
		}
		
		/**
		 * 세팅에서 조작 방식을 선택했을때 디스패치 받는 메소드 
		 * @param event
		 * 
		 */
		private function onEndedControl(event:TrollingEvent):void
		{
			_controlMode = int(event.data);
		}
		
		/**
		 * 세팅 팝업창이 켜져있을때 조작버튼을 감춰주는 메소드  
		 * @param event
		 * 
		 */
		private function onEndedSettingPopup(event:TrollingEvent):void
		private function onEndedSettingButton(event:TrollingEvent):void
		{
			trace("셋팅팝업 : " + event.data);
			if(event.data == true)
			{
				_controller.visible = false;				
			}
			else
			{
				if(_controlMode == SettingData.CONTROL_SCREEN)
				{
					_controller.visible = false;					
				}
				else
				{
					_controller.visible = true;					
				}
			}
		}
		
		/**
		 * 세팅된 값에 따라 컨트롤 모드를 바꿔주는 디스패치 메소드 
		 * @param event
		 * 
		 */
		private function onInitVibrationMode(event:TrollingEvent):void
		{
			_vibration = event.data;
		}
		
		
		private function onEndedVibration(event:TrollingEvent):void
		{
			_vibration = event.data;
		}
		
		private function onInitControlMode(event:TrollingEvent):void
		{
			trace("_controlMode = " + _controlMode);
			_controlMode = int(event.data);
			if(_controlMode == SettingData.CONTROL_BUTTON)
			{
				_controller.visible = true;	
			}
		}
		
		/**
		 * 버튼 조작 모드에서 좌,우를 터치할때 발생하는 콜백 메소드 
		 * @param event
		 * 
		 */
		private function onEndedControl(event:TrollingEvent):void
		{
			_controlMode = int(event.data);
		}
		
		private function onMove(event:TrollingEvent):void
		{
			if(_controlMode == SettingData.CONTROL_SCREEN)
				return;
			
			//trace("movemovemove");
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
					if(_player.struggleLeftCount - _player.struggleRightCount <= 1)   
						_player.struggleLeftCount++;
					
					if(_player.state == PlayerState.FALL)
						_player.state = PlayerState.STRUGGLE;
				}
				else
				{
					if(_player.struggleRightCount - _player.struggleLeftCount <= 1)   
						_player.struggleRightCount++;
					
					if(_player.state == PlayerState.FALL)
						_player.state = PlayerState.STRUGGLE;
				}
			}
			
			
		}
		
		/**
		 * 버튼 조작 모드에서 점프를 터치할때 발생하는 콜백 메소드 
		 * @param event
		 * 
		 */
		private function onJump(event:TrollingEvent):void			
		{
			if(_controlMode == SettingData.CONTROL_SCREEN)
				return;
			
			if(_player.state == PlayerState.RUN)
			{
				_player.state = PlayerState.JUMP;
			}
		}
	}
}