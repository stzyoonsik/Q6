package scene.gameScene.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	import scene.data.SettingData;
	import scene.gameScene.MainStage;
	import scene.loading.Resources;
	import scene.loading.SpriteSheet;
	
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

	public class SettingPopup extends Popup
	{
		private const BGM:int = 0;
		private const SOUND:int = 1;
		private const SCREEN:int = 2;
		private const BUTTON:int = 3;
		private const REPLAY:int = 4;
		private const MENU:int = 5;
		
		private var _settingData:SettingData;
		private var _controlButtonManager:RadioButtonManager;
		
		private var _temp:Vector.<GameObject>;
				
		public function SettingPopup(canvas:Texture)
		{
			super(canvas);
			
			_controlButtonManager = null;
			_settingData = null;
			_temp = null;
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
			// load setting data
			_settingData = new SettingData("settingData", File.applicationStorageDirectory.resolvePath("data"));
			_settingData.onReadyToPreset = onCompleteLoadData;
			_settingData.read();
			
			_temp = new Vector.<GameObject>();
			
			var check:Texture = resources.getSubTexture(UIResource.SPRITE, UIResource.CHECK);
			var bitmapData:BitmapData = new BitmapData(check.width, check.height);
			var ct:ColorTransform = new ColorTransform();
			ct.alphaMultiplier = 0; 
			bitmapData.colorTransform(new Rectangle(0, 0, bitmapData.width, bitmapData.height), ct);
			// BGM
			var bgm:SelectButton = new SelectButton(new Texture(new Bitmap(bitmapData)), check);
			bgm.x = -(this.width / 10.7);
			bgm.y = -(this.height / 9.5);
			bgm.isSelected = true;
			bgm.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedBgm);
			_temp.push(bgm);
			//
			
			// SOUND
			var sound:SelectButton = new SelectButton(new Texture(new Bitmap(bitmapData)), check);
			sound.x = bgm.x + this.width / 2.96;
			sound.y = bgm.y;
			sound.width = check.width;
			sound.height = check.height;
			sound.isSelected = true;
			sound.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedSound);
			_temp.push(sound);
			//
			
			_controlButtonManager = new RadioButtonManager();
			var controlButtonScale:Number = 0.5;
			// SCREEN
			var screen:RadioButton = new RadioButton(
				resources.getSubTexture(UIResource.SPRITE, UIResource.SCREEN_WHITE),
				resources.getSubTexture(UIResource.SPRITE, UIResource.SCREEN_ORANGE));
			screen.width *= controlButtonScale;
			screen.height *= controlButtonScale;
			screen.x = bgm.x + screen.width / 3.8;
			screen.y = this.height / 14;
			screen.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedScreen);
			
			_controlButtonManager.addButton(screen);
			//
			
			// BUTTON
			var button:RadioButton = new RadioButton(
				resources.getSubTexture(UIResource.SPRITE, UIResource.BUTTON_WHITE),
				resources.getSubTexture(UIResource.SPRITE, UIResource.BUTTON_ORANGE));
			button.x = screen.x + screen.width + 10;
			button.y = screen.y;
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
			replay.y = this.height / 3.5;
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
			addChild(screen);
			addChild(button);
			addChild(replay);
			addChild(menu);
			
			var spriteSheet:SpriteSheet = resources.getSpriteSheet(UIResource.SPRITE);
			spriteSheet.removeSubTexture(UIResource.CHECK);
			spriteSheet.removeSubTexture(UIResource.SCREEN_WHITE);
			spriteSheet.removeSubTexture(UIResource.SCREEN_ORANGE);
			spriteSheet.removeSubTexture(UIResource.BUTTON_WHITE);
			spriteSheet.removeSubTexture(UIResource.BUTTON_ORANGE);
		}
		
		private function saveSetting():void
		{
			// to do
			
		}
		
		private function loadSetting():void
		{
			// to do
			
		}
		
		private function preset(bgm:Boolean, sound:Boolean, control:int):void
		{
			if (!bgm)
			{
				SoundManager.isBgmActive = false;
				SoundManager.stopBgm();
			}
			
			if (!sound)
			{
				SoundManager.isSoundEffectActive = false;	
				SoundManager.stopSoundEffect();
			}
			
			dispatchEvent(new TrollingEvent("initControlMode", control));			
		}
		
		private function onCompleteLoadData():void
		{
			// preset
			preset(_settingData.bgm, _settingData.sound, _settingData.control);
			
			if (_controlButtonManager)
			{
				_controlButtonManager.selectButton(_settingData.control);
			}

			if (_temp)
			{
				var button:SelectButton;
				button = _temp[0] as SelectButton;
				button.isSelected = _settingData.bgm;
				
				button = _temp[1] as SelectButton;
				button.isSelected = _settingData.sound;
				
				_temp.splice(0, _temp.length);
				_temp = null;
			}
		}
		
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
		
		private function onEndedScreen(event:TrollingEvent):void
		{
			// switch control type	
			dispatchEvent(new TrollingEvent("control", SettingData.CONTROL_SCREEN));
			_settingData.control = SettingData.CONTROL_SCREEN;
		}
		
		private function onEndedButton(event:TrollingEvent):void
		{
			// switch control type
			dispatchEvent(new TrollingEvent("control", SettingData.CONTROL_BUTTON));
			_settingData.control = SettingData.CONTROL_BUTTON;
		}
		
		private function onEndedReplay(event:TrollingEvent):void
		{
			SceneManager.restartScene(MainStage, "Game", MainStage.currentStage);
		}
		
		private function onEndedMenu(event:TrollingEvent):void
		{
			SceneManager.outScene(MainStage.currentStage);
			SceneManager.deleteScene("Game");
		}
	}
}