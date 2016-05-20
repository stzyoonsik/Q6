package scene.gameScene.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	import gameData.SettingData;
	
	import loading.Resources;
	import loading.SpriteSheet;
	
	import scene.gameScene.MainStage;
	
	import trolling.core.SceneManager;
	import trolling.event.TrollingEvent;
	import trolling.media.SoundManager;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	
	import ui.Popup;
	import ui.button.Button;
	import ui.button.RadioButton;
	import ui.button.RadioButtonManager;
	import ui.button.SelectButton;

	/**
	 * 설정 팝업입니다. 
	 * @author user
	 * 
	 */
	public class SettingPopup extends Popup
	{
		public static const INIT_VIBRATION_MODE:String = "initVibrationMode";
		public static const INIT_CONTROL_MODE:String = "initControlMode";
		public static const VIBRATION_MODE:String = "vibrationMode";
		public static const CONTROL_MODE:String = "controlMode";
		
		private const BGM:int = 0;
		private const SOUND:int = 1;
		private const VIBRATION:int = 2;
		private const SCREEN:int = 3;
		private const BUTTON:int = 4;
		private const REPLAY:int = 5;
		private const MENU:int = 6;
		
		private var _settingData:SettingData;
		private var _controlButtonManager:RadioButtonManager;
				
		public function SettingPopup(canvas:Texture)
		{
			super(canvas);
			
			_controlButtonManager = null;
			_settingData = null;
		}
		
		public override function dispose():void
		{
			// output user setting
			if (_settingData)
			{
				_settingData.write();
				_settingData.dispose();
			}
			_settingData = null;
			
			var child:GameObject = getChild(BGM);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedBgm);
			
			child = getChild(SOUND);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedSound);
			
			child = getChild(VIBRATION);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedVibration);
			
			child = getChild(SCREEN);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedScreen);
			
			child = getChild(BUTTON);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedButton);
			
			child = getChild(REPLAY);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedReplay);
			
			child = getChild(MENU);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedMenu);
			
			_controlButtonManager = null;
			
			super.dispose();
		}
		
		public function initialize(resources:Resources):void
		{
			var checkButtonScale:Number = 0.8;
			var check:Texture = resources.getSubTexture(UIResource.SPRITE, UIResource.CHECK);
			var bitmapData:BitmapData = new BitmapData(check.width, check.height);
			var ct:ColorTransform = new ColorTransform();
			ct.alphaMultiplier = 0; 
			bitmapData.colorTransform(new Rectangle(0, 0, bitmapData.width, bitmapData.height), ct);
			// BGM
			var bgm:SelectButton = new SelectButton(new Texture(new Bitmap(bitmapData)), check);
			bgm.width *= checkButtonScale;
			bgm.height *= checkButtonScale;
			bgm.x = -(this.width / 10.5);
			bgm.y = -(this.height / 6.9);
			bgm.isSelected = true;
			bgm.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedBgm);
			//
			
			var margin:Number = this.height / 7.3;
			// SOUND
			var sound:SelectButton = new SelectButton(new Texture(new Bitmap(bitmapData)), check);
			sound.width *= checkButtonScale;
			sound.height *= checkButtonScale;
			sound.x = bgm.x;
			sound.y = bgm.y + margin;
			sound.isSelected = true;
			sound.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedSound);
			//
			
			// VIBRATION
			var vibration:SelectButton = new SelectButton(new Texture(new Bitmap(bitmapData)), check);
			vibration.width *= checkButtonScale;
			vibration.height *= checkButtonScale;
			vibration.x = bgm.x;checkButtonScale
			vibration.y = sound.y + margin;
			vibration.isSelected = true;
			vibration.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedVibration);
			//
			
			_controlButtonManager = new RadioButtonManager();
			var controlButtonScale:Number = 0.5;
			// SCREEN
			var screen:RadioButton = new RadioButton(
				resources.getSubTexture(UIResource.SPRITE, UIResource.SCREEN_WHITE),
				resources.getSubTexture(UIResource.SPRITE, UIResource.SCREEN_ORANGE));
			screen.width *= controlButtonScale;
			screen.height *= controlButtonScale;
			screen.x = this.width / 5.8;
			screen.y = sound.y - 2;
			screen.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedScreen);
			
			_controlButtonManager.addButton(screen);
			//
			
			// BUTTON
			var button:RadioButton = new RadioButton(
				resources.getSubTexture(UIResource.SPRITE, UIResource.BUTTON_WHITE),
				resources.getSubTexture(UIResource.SPRITE, UIResource.BUTTON_ORANGE));
			button.x = screen.x;
			button.y = screen.y + this.height / 9.8;
			button.width *= controlButtonScale;
			button.height *= controlButtonScale;
			button.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedButton);
						
			_controlButtonManager.addButton(button);
			//
			
			var stageButtonX:Number = this.width / 10;
			// REPLAY
			var replay:Button = new Button(
				resources.getSubTexture(UIResource.SPRITE, UIResource.REPLAY));
			replay.x = -stageButtonX;
			replay.y = this.height / 3.2;
			replay.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedReplay);
			//
			
			// MENU
			var menu:Button = new Button(
				resources.getSubTexture(UIResource.SPRITE, UIResource.MENU));
			menu.x = stageButtonX;
			menu.y = replay.y + 3;
			menu.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedMenu);
			//

			addChild(bgm);
			addChild(sound);
			addChild(vibration);
			addChild(screen);
			addChild(button);
			addChild(replay);
			addChild(menu);
			
			// load setting data
			_settingData = new SettingData("settingData", File.applicationStorageDirectory.resolvePath("data"));
			preset();
			_settingData.onReadyToPreset = preset;
			_settingData.read();
			
			var spriteSheet:SpriteSheet = resources.getSpriteSheet(UIResource.SPRITE);
			spriteSheet.removeSubTexture(UIResource.CHECK);
			spriteSheet.removeSubTexture(UIResource.SCREEN_WHITE);
			spriteSheet.removeSubTexture(UIResource.SCREEN_ORANGE);
			spriteSheet.removeSubTexture(UIResource.BUTTON_WHITE);
			spriteSheet.removeSubTexture(UIResource.BUTTON_ORANGE);
		}
		
		/**
		 * 저장된 SettingData가 있을 경우 해당 설정값으로 preset합니다. 
		 * 
		 */
		private function preset():void
		{
			if (!_settingData.bgm)
			{
				SoundManager.isBgmActive = false;
				SoundManager.stopBgm();
			}
			
			if (!_settingData.sound)
			{
				SoundManager.isSoundEffectActive = false;	
				SoundManager.stopSoundEffect();
			}
			
			dispatchEvent(new TrollingEvent(INIT_VIBRATION_MODE, _settingData.vibration));
			dispatchEvent(new TrollingEvent(INIT_CONTROL_MODE, _settingData.control));
			
			// in popup
			var button:SelectButton = getChild(BGM) as SelectButton;
			if (button) button.isSelected = _settingData.bgm;
			
			button = getChild(SOUND) as SelectButton;
			if (button) button.isSelected = _settingData.sound;
			
			button = getChild(VIBRATION) as SelectButton;
			if (button) button.isSelected = _settingData.vibration;
			
			if (_controlButtonManager)
			{
				_controlButtonManager.selectButton(_settingData.control);
			}
		}
		
		/**
		 * 체크박스 선택 여부에 따라 BGM을 제어합니다. 
		 * @param event TrollingEvent.TOUCH_ENDED
		 * 
		 */
		private function onEndedBgm(event:TrollingEvent):void
		{
			// BGM on/off
			var bgm:SelectButton = getChild(BGM) as SelectButton;
			
			if (bgm)
			{
				if (bgm.isSelected)
				{
					SoundManager.isBgmActive = true;
					SoundManager.wakeBgm();
					
				}
				else
				{
					SoundManager.isBgmActive = false;
					SoundManager.stopBgm();
				}
				_settingData.bgm = bgm.isSelected;
			}
		}
		
		/**
		 * 체크박스 선택 여부에 따라 효과음을 제어합니다. 
		 * @param event TrollingEvent.TOUCH_ENDED
		 * 
		 */
		private function onEndedSound(event:TrollingEvent):void
		{
			// Sound on/off
			var sound:SelectButton = getChild(SOUND) as SelectButton;
			
			if (sound)
			{
				if (sound.isSelected)
				{
					SoundManager.isSoundEffectActive = true;
				}
				else
				{ 
					SoundManager.isSoundEffectActive = false;
					SoundManager.stopSoundEffect();
				}
				_settingData.sound = sound.isSelected;
			}
		}
		
		/**
		 * 체크박스 선택 여부에 따라 진동을 제어합니다. 
		 * @param event TrollingEvent.TOUCH_ENDED
		 * SettingPopup.VIBRATION_MODE 이벤트를 dispatch합니다.
		 */
		private function onEndedVibration(event:TrollingEvent):void
		{
			// Vibration on/off
			_settingData.vibration = !_settingData.vibration;
			dispatchEvent(new TrollingEvent(VIBRATION_MODE, _settingData.vibration));
		}
		
		/**
		 * 컨트롤 모드를 Screen으로 변경합니다. 
		 * @param event TrollingEvent.TOUCH_ENDED
		 * SettingPopup.CONTROL_MODE 이벤트를 dispatch합니다. 
		 */
		private function onEndedScreen(event:TrollingEvent):void
		{
			// switch control mode	
			_settingData.control = SettingData.CONTROL_SCREEN;
			dispatchEvent(new TrollingEvent(CONTROL_MODE, _settingData.control));
		}
		
		/**
		 * 컨트롤 모드를 Button으로 변경합니다. 
		 * @param event TrollingEvent.TOUCH_ENDED
		 * SettingPopup.CONTROL_MODE 이벤트를 dispatch합니다. 
		 */
		private function onEndedButton(event:TrollingEvent):void
		{
			// switch control mode
			_settingData.control = SettingData.CONTROL_BUTTON;
			dispatchEvent(new TrollingEvent(CONTROL_MODE, _settingData.control));
		}
		
		/**
		 * 해당 스테이지를 다시 시작합니다. 
		 * @param event TrollingEvent.TOUCH_ENDED
		 * 
		 */
		private function onEndedReplay(event:TrollingEvent):void
		{
			SceneManager.restartScene(MainStage, "Game", MainStage.currentStage);
		}
		
		/**
		 * 스테이지 선택 씬으로 돌아갑니다. 
		 * @param event TrollingEvent.TOUCH_ENDED
		 * 
		 */
		private function onEndedMenu(event:TrollingEvent):void
		{
			SceneManager.outScene(MainStage.currentStage);
		}
	}
}