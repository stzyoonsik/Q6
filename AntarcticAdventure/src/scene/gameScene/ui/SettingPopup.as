package scene.gameScene.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import scene.gameScene.MainStage;
	import scene.stageSelectScene.StageSelectScene;
	
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
	import flash.events.Event;

	public class SettingPopup extends Popup
	{
		private const BGM:int = 0;
		private const SOUND:int = 1;
		private const SCREEN:int = 2;
		private const BUTTON:int = 3;
		private const REPLAY:int = 4;
		private const MENU:int = 5;
		
		private const CONTROL_SCREEN:int = 0;
		private const CONTROL_BUTTON:int = 1;

		private var _controlButtonManager:RadioButtonManager;
		
		private var _bgm:Boolean;
		private var _sound:Boolean;
		private var _control:int;
		
		public function SettingPopup(canvas:Texture)
		{
			super(canvas);
			
			_controlButtonManager = null;
			
			_bgm = true;
			_sound = true;
			_control = CONTROL_SCREEN;
		}
		
		public override function dispose():void
		{
			// output user setting
			saveSetting();
			
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
		
		public function initialize(bitmaps:Dictionary):void
		{
			// preset load
			loadSetting();
			
			// preset
			preset(_bgm, _sound, _control);
			
			var check:Bitmap = bitmaps[UIResource.CHECK] as Bitmap;
			var bitmapData:BitmapData = new BitmapData(check.width, check.height);
			var ct:ColorTransform = new ColorTransform();
			ct.alphaMultiplier = 0; 
			bitmapData.colorTransform(new Rectangle(0, 0, bitmapData.width, bitmapData.height), ct);
			// BGM
			var bgm:SelectButton = new SelectButton(new Texture(new Bitmap(bitmapData)), new Texture(check));
			bgm.x = -(this.width / 10.7);
			bgm.y = -(this.height / 9.5);
			bgm.isSelected = _bgm;
			bgm.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedBgm);
			//
			
			// SOUND
			var sound:SelectButton = new SelectButton(new Texture(new Bitmap(bitmapData)), new Texture(check));
			sound.x = bgm.x + this.width / 2.96;
			sound.y = bgm.y;
			sound.width = check.width;
			sound.height = check.height;
			sound.isSelected = _sound;
			sound.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedSound);
						
			delete bitmaps[UIResource.CHECK];
			//
			
			_controlButtonManager = new RadioButtonManager();
			var controlButtonScale:Number = 0.5;
			// SCREEN
			var screen:RadioButton = new RadioButton(
				new Texture(bitmaps[UIResource.SCREEN_WHITE]), new Texture(bitmaps[UIResource.SCREEN_ORANGE]));
			screen.width *= controlButtonScale;
			screen.height *= controlButtonScale;
			screen.x = bgm.x + screen.width / 3.8;
			screen.y = this.height / 14;
			screen.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedScreen);
			
			_controlButtonManager.addButton(screen);
			
			delete bitmaps[UIResource.SCREEN_WHITE];
			delete bitmaps[UIResource.SCREEN_ORANGE];
			//
			
			// BUTTON
			var button:RadioButton = new RadioButton(
				new Texture(bitmaps[UIResource.BUTTON_WHITE]), new Texture(bitmaps[UIResource.BUTTON_ORANGE]));
			button.x = screen.x + screen.width + 10;
			button.y = screen.y;
			button.width *= controlButtonScale;
			button.height *= controlButtonScale;
			button.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedButton);
						
			_controlButtonManager.addButton(button);
			_controlButtonManager.selectButton(_control);
			
			delete bitmaps[UIResource.BUTTON_WHITE];
			delete bitmaps[UIResource.BUTTON_ORANGE];
			//
			
			var stageButtonX:Number = this.width / 10;
			// REPLAY
			var replay:Button = new Button(new Texture(bitmaps[UIResource.REPLAY]));
			replay.x = -stageButtonX;
			replay.y = this.height / 3.5;
			replay.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedReplay);
			//
			
			// MENU
			var menu:Button = new Button(new Texture(bitmaps[UIResource.MENU]));
			menu.x = stageButtonX;
			menu.y = replay.y + 3;
			menu.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedMenu);
			//
		
//			private const BGM:int = 0;
//			private const SOUND:int = 1;
//			private const SCREEN:int = 2;
//			private const BUTTON:int = 3;
//			private const REPLAY:int = 4;
//			private const MENU:int = 5;
			
			addChild(bgm);
			addChild(sound);
			addChild(screen);
			addChild(button);
			addChild(replay);
			addChild(menu);
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
			
			if (control == CONTROL_BUTTON)
			{
				// to do
												
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
			}
		}
		
		private function onEndedScreen(event:TrollingEvent):void
		{
			// switch control type	
			dispatchEvent(new TrollingEvent("control", CONTROL_SCREEN));
		}
		
		private function onEndedButton(event:TrollingEvent):void
		{
			// switch control type
			dispatchEvent(new TrollingEvent("control", CONTROL_BUTTON));
		}
		
		private function onEndedReplay(event:TrollingEvent):void
		{
			SceneManager.restartScene(MainStage, "Game", MainStage.currentStage);
		}
		
		private function onEndedMenu(event:TrollingEvent):void
		{
			SceneManager.outScene(MainStage.currentStage);
//			SceneManager.deleteScene("Game");
		}
	}
}