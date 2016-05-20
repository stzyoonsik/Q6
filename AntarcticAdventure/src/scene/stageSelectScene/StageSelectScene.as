package scene.stageSelectScene
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import gameData.PlayData;
	
	import loading.Loading;
	import loading.LoadingEvent;
	import loading.Resources;
	import loading.SpriteSheet;
	
	import scene.gameScene.MainStage;
	import scene.stageSelectScene.ui.ExitPopup;
	
	import trolling.component.ComponentType;
	import trolling.component.graphic.Image;
	import trolling.core.SceneManager;
	import trolling.event.TrollingEvent;
	import trolling.media.Sound;
	import trolling.media.SoundManager;
	import trolling.object.GameObject;
	import trolling.object.Scene;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	import ui.button.Button;
	
	public class StageSelectScene extends Scene
	{	
		public static const LAST_STAGE_ID:int = 10;
		private static var _playData:PlayData;
		
		private var _imageDic:Dictionary = new Dictionary();
		private var _imageURLVector:Vector.<String> = new Vector.<String>();
		private var _imageLoadCount:uint = 0;
		
		private var _spriteDir:File = File.applicationDirectory.resolvePath("scene/stageSelectScene");
		private var _soundDir:File = File.applicationDirectory.resolvePath("scene/stageSelectScene");
		
		private var _backGround:GameObject;
		private var _backGroundImage:Image;
		
		private var _nextButton:Button;
		private var _prevButton:Button;
		
		private var _exitPopup:ExitPopup;
		
		private var _numberVector:Vector.<GameObject> = new Vector.<GameObject>();
		private var _buttonVector:Vector.<Button> = new Vector.<Button>();
		private var _starVector:Vector.<GameObject> = new Vector.<GameObject>();
		
		private var _stageIndex:uint;
		
		private var _resource:Resources;
		private var _spriteSheet:SpriteSheet;
		
		public function StageSelectScene()
		{
			addEventListener(TrollingEvent.START_SCENE, onInit);
			addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		
		public override function dispose():void
		{
			removeEventListener(Event.DEACTIVATE, onDeactivate);
			
			// output play data
			if (_playData)
			{
				_playData.write();
				_playData.dispose();
			}
			_playData = null;
			
			super.dispose();
		}
		
		private function onInit(event:Event):void
		{
			if(this.data == null)
			{
				// read PlayData
				_playData = new PlayData("playData", File.applicationStorageDirectory.resolvePath("data"));
				_playData.read();
				
				_resource = new Resources(_spriteDir, _soundDir);
				_resource.addSpriteName("selectSceneSprite0.png");
				_resource.addSpriteName("ExitPopupSheet.png");
				_resource.addSoundName("stageSelect.mp3");
				
				Loading.current.setLoading(this, _resource.getTotalLoadCount());
				
				_resource.addEventListener(LoadingEvent.COMPLETE, onCompleteLoad);
				_resource.addEventListener(LoadingEvent.FAILED, onFailedLoad);
				_resource.addEventListener(LoadingEvent.PROGRESS, onProgressLoad);
				_resource.loadResource();
			}
			else
			{
				_stageIndex = ((this.data as uint)-1)/5;
				setStageNumber();
				
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
				
				var sound:Sound = _resource.getSoundFile("stageSelect.mp3");
				if (sound)
				{
					sound.loops = Sound.INFINITE;
					SoundManager.addSound("stageSelect.mp3", sound);
					SoundManager.play("stageSelect.mp3");
				}
			}
		}
		
		private function onProgressLoad(event:LoadingEvent):void
		{
			Loading.current.setCurrent(event.data as Number);
		}
		
		private function onTouchKeyBoard(event:KeyboardEvent):void
		{
//			trace(event.keyCode);
//			if(event.keyCode == 8)
			if(event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				if(_exitPopup != null)
				{
					if(!_exitPopup.visible)
						_exitPopup.show();
					else
						_exitPopup.close();
				}
			}
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
			Resources(event.currentTarget).removeEventListener(LoadingEvent.COMPLETE, onCompleteLoad);
			Resources(event.currentTarget).removeEventListener(LoadingEvent.FAILED, onFailedLoad);
			Resources(event.currentTarget).removeEventListener(LoadingEvent.PROGRESS, onProgressLoad);
			
			_stageIndex = 0;
			
			_backGround = new GameObject();
			_backGroundImage = new Image(_resource.getSubTexture("selectSceneSprite0.png", "sea1"));
			_backGround.addComponent(_backGroundImage);
			
			_backGround.width = this.width;
			_backGround.height = this.height;
			
			var buttonTexture:Texture = _resource.getSubTexture("selectSceneSprite0.png", "buttonImage");
			var buttonX:Number = this.width / 6;
			var buttonY:Number = this.height / 6;
			
			for(var i:int = 1; i <= 5; i++)
			{
				var stageButton:Button = new Button(buttonTexture);
				stageButton.width = 100;
				stageButton.height = 100;
				stageButton.x = buttonX*i;
				stageButton.y = buttonY*i;
				stageButton.pivot = PivotType.CENTER;
				stageButton.addEventListener(TrollingEvent.TOUCH_ENDED, onButtonClick);
				_backGround.addChild(stageButton);
				_buttonVector.push(stageButton);
				
				var stageNumber:GameObject = new GameObject();
				var numberImage:Image = new Image();
				stageNumber.y = -5;
				stageNumber.width = 20;
				stageNumber.height = 30;
				stageNumber.addComponent(numberImage);
				stageNumber.pivot = PivotType.CENTER;
				stageButton.addChild(stageNumber);
				stageNumber.addEventListener(TrollingEvent.TOUCH_BEGAN, onBubble);
				stageNumber.addEventListener(TrollingEvent.TOUCH_ENDED, onBubble);
				_numberVector.push(stageNumber);
				
				var stageNumber2:GameObject = new GameObject();
				var numberImage2:Image = new Image();
				stageNumber2.y = -5;
				stageNumber2.width = 20;
				stageNumber2.height = 30;
				stageNumber2.addComponent(numberImage2);
				stageNumber2.pivot = PivotType.CENTER;
				stageNumber2.addEventListener(TrollingEvent.TOUCH_BEGAN, onBubble);
				stageNumber2.addEventListener(TrollingEvent.TOUCH_ENDED, onBubble);
				stageButton.addChild(stageNumber2);
				_numberVector.push(stageNumber2);
			}
			
			_nextButton = new Button(_resource.getSubTexture("selectSceneSprite0.png", "nextButton"));
			_nextButton.width = 100;
			_nextButton.height = 100;
			_nextButton.x = 860;
			_nextButton.y = 100;
			_nextButton.pivot = PivotType.CENTER;
			_nextButton.addEventListener(TrollingEvent.TOUCH_ENDED, onNextClick);
			
			_prevButton = new Button(_resource.getSubTexture("selectSceneSprite0.png", "prevButton"));
			_prevButton.width = 100;
			_prevButton.height = 100;
			_prevButton.x = 100;
			_prevButton.y = 440;
			_prevButton.pivot = PivotType.CENTER;
			_prevButton.addEventListener(TrollingEvent.TOUCH_ENDED, onPrevClick);
			
			// stars
			var root:GameObject;
			var star:GameObject;
			var scale:Number = 0.5;
			for (i = 0; i < 5; i++)
			{
				root = new GameObject();
				root.pivot = PivotType.CENTER;
				root.x = _buttonVector[i].width * 0.75;
				root.y = -(_buttonVector[i].height * 0.05);
				
				for (var j:int = 0; j < 3; j++)
				{
					star = new GameObject();
					star.pivot = PivotType.CENTER;
					star.addComponent(new Image(_resource.getSubTexture("selectSceneSprite0.png", "star")));
					star.width *= scale;
					star.height *= scale;
					
					var starX:Number = star.width * 0.25;
					var starY:Number = star.height * 0.7;
					if (j == 0)
					{
						star.x = -starX;
						star.y = -starY;
					}
					else if (j == 2)
					{
						star.x = -starX;
						star.y = starY;
					}
					
					root.addChild(star);
				}
				
				_buttonVector[i].addChild(root);
				_starVector.push(root);
			}
			
			_exitPopup = new ExitPopup(_resource.getSubTexture("ExitPopupSheet.png", "popup"));
			_exitPopup.x = this.width / 2;
			_exitPopup.y = this.height / 2;
			_exitPopup.width = this.width;
			_exitPopup.height = this.height;
			_exitPopup.initialize(_resource);
			
			addChild(_backGround);
			addChild(_exitPopup);
			_backGround.addChild(_nextButton);
			_backGround.addChild(_prevButton);

			_resource.getSoundFile("stageSelect.mp3").loops = Sound.INFINITE;
			
			setStageNumber();

			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
				
			var sound:Sound = _resource.getSoundFile("stageSelect.mp3");
			if (sound)
			{
				sound.loops = Sound.INFINITE;
				SoundManager.addSound("stageSelect.mp3", sound);
				SoundManager.play("stageSelect.mp3");
			}

			Loading.current.loadComplete();
		}
		
		private function setStageNumber():void
		{
			for(var i:int = 0; i < 5; i++)
			{
				var stageCount:uint = (_stageIndex*5)+i+1;
				var countString:String = stageCount.toString();
			
				_buttonVector[i].name = countString;
				
				_numberVector[i*2].components[ComponentType.IMAGE].texture = _resource.getSubTexture("selectSceneSprite0.png", countString.charAt(0)+"_number");
				if(countString.length >= 2)
				{
					_numberVector[i*2].x = -10;
					_numberVector[(i*2)+1].components[ComponentType.IMAGE].texture = _resource.getSubTexture("selectSceneSprite0.png", countString.charAt(1)+"_number");
					_numberVector[(i*2)+1].x = 10;
				}
				else
				{
					_numberVector[(i*2)+1].components[ComponentType.IMAGE].texture = null;
					_numberVector[i*2].x = 0;
				}
				
				setStageColor(_buttonVector[i]);
			}
			
			// _stageIndex에 따라 _prevButton, _nextButton visible 여부 제어
			if (_stageIndex == 0)
			{
				_prevButton.visible = false;
				_nextButton.visible = true;
			}
			else if ((_stageIndex + 1) * 5 == LAST_STAGE_ID)
			{
				_prevButton.visible = true;
				_nextButton.visible = false;
			}
			else
			{
				_prevButton.visible = true;
				_nextButton.visible = true;
			}
			
			setStar();
		}
		
		/**
		 * PlayData에 기준하여 접근 제한할 stageButton의 색상을 조정합니다.
		 * @param stageButton 색상을 조정할 stageButton입니다.
		 * 
		 */
		private function setStageColor(stageButton:Button):void
		{
			var stageId:int = int(stageButton.name);
			if (stageId == 1)
			{
				stageButton.blendColor(1, 1, 1);
				return;
			}
			
			if (!_playData)
			{
				stageButton.blendColor(0.5, 0.5, 0.5);
			}
			else
			{
				if (_playData.getData(stageId - 1) == -1) // 이전 스테이지 클리어 기록이 없음
				{
					stageButton.blendColor(0.5, 0.5, 0.5);
				}
				else
				{
					stageButton.blendColor(1, 1, 1);
				}
			}
		}
		
		/**
		 * PlayData에 기준하여 각 stageButton에 별점을 표시합니다. 
		 * 
		 */
		private function setStar():void
		{
			if (!_playData)
			{
				return;
			}
			
			var numStar:int;
			var star:GameObject;
			var image:Image;
			for (var i:int = 0; i < _starVector.length; i++)
			{
				numStar = _playData.getData(int(_buttonVector[i].name));
				
				for (var j:int = 0; j < 3; j++)
				{
					star = _starVector[i].getChild(j);
					if (!star)
					{
						break;
					}
					
					image = star.components[ComponentType.IMAGE];
					if (image)
					{
						if (j + 1 <= numStar)
						{
							image.texture = _resource.getSubTexture("selectSceneSprite0.png", "star_filled");
						}
						else
						{
							image.texture = _resource.getSubTexture("selectSceneSprite0.png", "star");
						}
					}
				}
			}
		}
		
		private function onPrevClick(event:TrollingEvent):void
		{
			if(_stageIndex <= 0)
			{
				return;
			}
			_stageIndex--;
			setStageNumber();
		}
		
		private function onNextClick(event:TrollingEvent):void
		{
			if(_stageIndex >= 1)
				return;
			_stageIndex++;
			setStageNumber();
		}
		
		private function onBubble(event:TrollingEvent):void
		{
			if(GameObject(event.currentTarget).parent != null)
				GameObject(event.currentTarget).parent.dispatchEvent(new TrollingEvent(event.type, event.data));
		}
		
		private function onButtonClick(event:TrollingEvent):void
		{
			var stageButton:Button = event.currentTarget as Button;
			if (!stageButton)
			{
				return;
			}
			
			// 첫 번째 스테이지이거나 이전 스테이지의 클리어 기록이 있는 스테이지일 경우에만 진입 가능
			var stageId:int = int(stageButton.name);
			var isAccessible:Boolean = true;
			if (stageId > 1)
			{
				if (!_playData)
				{
					isAccessible = false;
				}
				else
				{
					if (_playData.getData(stageId - 1) == -1)
					{
						isAccessible = false;
					}
				}
			}
				
			if (isAccessible)
			{
				NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
				SceneManager.addScene(MainStage, "Game");
				SceneManager.goScene("Game", stageId);
			}
		}
		
		private function onDeactivate(event:Event):void
		{
			if (_playData)
			{
				_playData.write();
			}
		}
				
		public static function get playData():PlayData
		{
			return _playData;
		}
	}
}