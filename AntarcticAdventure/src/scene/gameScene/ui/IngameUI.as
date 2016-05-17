package scene.gameScene.ui
{
	import flash.filesystem.File;
	
	import scene.gameScene.MainStage;
	import scene.loading.Resources;
	import scene.loading.SpriteSheet;
	
	import trolling.component.ComponentType;
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	
	import ui.Title;
	import ui.button.Button;
	import ui.gauge.CursorGauge;
	
	public class IngameUI extends GameObject
	{
		public static const CLEARED:String = "cleared";
		public static const FAILED:String = "failed";
		
		private const TAG:String = "[IngameUi]";
		private const FIELDS:int = 0;
		private const REST:int = 1;
		private const LIFE:int = 2;
		private const FLAG:int = 3;
		private const SETTING_BUTTON:int = 4;
		private const BACKGROUND:int = 5;
		private const SETTING_POPUP:int = 6;
		private const CLEARED_POPUP:int = 7;
		private const FAILED_POPUP:int = 8;
		private const TITLE:int = 9;
		
		private var _resources:Resources;
		
		private var _stageId:int;
		private var _totalDistance:Number;
		private var _totalLife:Number;
		private var _totalFlag:int;
		private var _currentLife:int;
		private var _currentFlag:int;
		
		private var _runGame:Function;
		
		public function IngameUI()
		{
			_stageId = 0;
			_totalDistance = 0;
			_totalLife = 0;
			_totalFlag = 0;
			_currentLife = 0;
			_runGame = null;
		}
		
		public function initialize(stageId:int, totalDistance:Number, totalLife:Number, totalFlag:int, pauseGame:Function):void
		{
			_stageId = stageId;
			_totalDistance = totalDistance;
			_totalLife = totalLife;
			_currentLife = _totalLife;
			_totalFlag = totalFlag;
			_runGame = pauseGame;
			
			_resources = new Resources(new File(UIResource.DIRECTORY));
			_resources.addSpriteName(UIResource.SPRITE);
			_resources.loadResource(onCompleteLoad, onFailedLoad);
		}
		
		public override function dispose():void
		{
			_resources = null;
			_runGame = null;
			
			super.dispose();
		}
		
		public function showPopup(type:String):void
		{
			if (!type)
			{
				trace(TAG + " showPopup : The type of Popup must be set.");
				return;
			}
			
			switch (type)
			{
				case CLEARED:
				{
					if (_runGame)
					{
						_runGame(false);
					}
					
					var background:GameObject = getChild(BACKGROUND);
					if (background)
					{
						background.visible = true;
					}
					
					var clearedPopup:ClearedPopup = getChild(CLEARED_POPUP) as ClearedPopup;
					if (clearedPopup)
					{
						clearedPopup.setResult(_totalFlag, _currentFlag, _resources);
						clearedPopup.show();
					}
				}
					break;
				
				case FAILED:
				{	
					background = getChild(BACKGROUND);
					if (background)
					{
						background.alpha = 0;
						background.visible = true;
					}
					addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
				}
					break;
				
				default:
					break;
			}
		}
		
		public function setCurrentDistance(distance:Number):void
		{
			var restGauge:CursorGauge = getChild(REST) as CursorGauge;
			
			if (restGauge)
			{
				restGauge.update(distance);
			}
		}
		
		public function setCurrentLife(numLife:int):void
		{
			var life:GameObject = getChild(LIFE);
			
			if (!life || numLife < 0)
			{
				return; 
			}
			
			if (numLife < _currentLife)
			{
				var heart:GameObject;
				for (var i:int = _currentLife - 1; i >= numLife; i--)
				{
					heart = life.getChild(i);
					if (heart)
					{
						heart.visible = false;
					}
				}
			}
			else if (numLife > _currentLife)
			{
				if (numLife > _totalLife)
				{
					numLife = _totalLife;
				}
				
				for (i = _currentLife; i < numLife; i++)
				{
					heart = life.getChild(i);
					if (heart)
					{
						heart.visible = true;
					}
				}
			}
			
			_currentLife = numLife;
		}
		
		public function setCurrentFlag(numFlag:int):void
		{
			var flag:GameObject = getChild(FLAG);
			
			if (!flag || numFlag < 0)
			{
				return;
			}
			
			var totalFlag:String = _totalFlag.toString();
			var currentFlag:String = numFlag.toString();
			var currentFlagIndex:int = currentFlag.length - 1;
			
			var digit:GameObject;
			var image:Image;
			for (var i:int = totalFlag.length - 1; i >= 0; i--)
			{
				if (currentFlagIndex < 0)
				{
					break;
				}
				
				digit = flag.getChild(i);	
				
				if (digit)
				{
					image = digit.components[ComponentType.IMAGE];
					
					if (image)
					{
						image.texture = 
							_resources.getSubTexture(UIResource.SPRITE, currentFlag.charAt(currentFlagIndex) + "_white");
					}
				}
				currentFlagIndex--;
			}
			
			_currentFlag = numFlag;
		}
		
		private function onCompleteLoad():void
		{
			var fieldsXY:Number = MainStage.stageWidth / 70;
			// FIELDS
			var field:GameObject = new GameObject();
			field.x = field.y = fieldsXY;
			field.scaleX = 0.8;
			field.scaleY = 0.8;
			field.addComponent(new Image(
				_resources.getSubTexture(UIResource.SPRITE, UIResource.FIELD)));
			/////
			
			var gaugeWidth:Number = field.width * field.scaleX * 1.5;
			var gaugeHeight:Number = gaugeWidth * 0.19;
			var horizontalMargin:Number = gaugeWidth / 8;
			var dataX:Number = fieldsXY + field.width * field.scaleX + horizontalMargin;
			var lightNavy:uint = 0xd9e6f2;
			var darkNavy:uint = 0x1b344b;
			// REST
			var restGauge:CursorGauge = new CursorGauge(gaugeWidth, gaugeHeight, 0.04, lightNavy, darkNavy);
			restGauge.x = dataX;
			restGauge.y = fieldsXY + 8;
			restGauge.total = _totalDistance;
			/////
			
			var verticalMargin:Number = gaugeHeight / 2; 
			// LIFE
			var life:GameObject = new GameObject();
			life.x = dataX;
			life.y = restGauge.y + gaugeHeight + verticalMargin;
			
			var heart:GameObject;
			var scale:Number;
			for (var i:int = 0; i < _totalLife; i++)
			{
				heart = new GameObject();
				heart.addComponent(new Image(
					_resources.getSubTexture(UIResource.SPRITE, UIResource.HEART)));
				
				scale = gaugeHeight / heart.height; 
				heart.width *= scale;
				heart.height *= scale;  
				
				if (i != 0)
				{
					heart.x = heart.width * i;
				}
				
				life.addChild(heart);
			}
			/////
			
			// FLAG
			var flag:GameObject = new GameObject();
			flag.x = dataX;
			flag.y = life.y + gaugeHeight + verticalMargin + 5;
			
			var slash:GameObject = new GameObject();
			slash.addComponent(new Image(
				_resources.getSubTexture(UIResource.SPRITE, UIResource.SLASH)));

			var numFlag:String = _totalFlag.toString();
			var totalFlagIndex:int = 0;
			var textMargin:Number = 5;
			var digit:GameObject;
			for (i = 0; i < numFlag.length * 2 + 1; i++)
			{
				if (i < numFlag.length)
				{
					digit = new GameObject();
					digit.addComponent(new Image(_resources.getSubTexture(UIResource.SPRITE, "0_white")));
				}
				else if (i > numFlag.length)
				{
					digit = new GameObject();
					digit.addComponent(new Image(
						_resources.getSubTexture(UIResource.SPRITE, numFlag.charAt(totalFlagIndex) + "_white")));
					
					totalFlagIndex++;
				}
				else
				{
					digit = slash;
				}
				
				scale = gaugeHeight / digit.height;
				digit.width *= scale;
				digit.height *= scale;  
				
				if (i > 0)
				{
					digit.x = digit.width * i + textMargin * i;
				}
				
				digit.red = 0;
				digit.green = 0;
				digit.blue = 0;
				
				flag.addChild(digit);
			}
			/////
			
			// SETTING_BUTTON
			var settingButton:Button = new Button(
				_resources.getSubTexture(UIResource.SPRITE, UIResource.SETTING_ICON));
			settingButton.x = MainStage.stageWidth - settingButton.width;
			settingButton.y = fieldsXY * 2.5;
			settingButton.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedSettingButton);
			/////
			
			// BACKGROUND
			var background:GameObject = new GameObject();
			background.addComponent(new Image(
				_resources.getSubTexture(UIResource.SPRITE, UIResource.BACKGROUND)));
			background.width = MainStage.stageWidth;
			background.height = MainStage.stageHeight;
			background.visible = false;
			//
			
			// SETTING_POPUP
			var settingPopup:SettingPopup = new SettingPopup(
				_resources.getSubTexture(UIResource.SPRITE, UIResource.SETTING_POPUP));
			settingPopup.x = MainStage.stageWidth / 2;
			settingPopup.y = MainStage.stageHeight / 2;
			settingPopup.width *= 1.2;
			settingPopup.height *= 1.2;
			settingPopup.initialize(_resources);
			settingPopup.addEventListener("control", onEndedControl);
			settingPopup.addEventListener("initControlMode", onInitControlMode);
			//
			
			// CLEARED_POPUP
			var clearedPopup:ClearedPopup = new ClearedPopup(
				_resources.getSubTexture(UIResource.SPRITE, UIResource.CLEARED_POPUP));
			clearedPopup.x = MainStage.stageWidth / 2;
			clearedPopup.y = MainStage.stageHeight / 2;
			clearedPopup.width *= 1.2;
			clearedPopup.height *= 1.2;
			clearedPopup.initialize(_resources);
			//
			
			// FAILED_POPUP
			var failedPopup:FailedPopup = new FailedPopup(
				_resources.getSubTexture(UIResource.SPRITE, UIResource.FAILED_POPUP));
			failedPopup.x = MainStage.stageWidth / 2;
			failedPopup.y = MainStage.stageHeight / 2;
			failedPopup.width *= 1.2;
			failedPopup.height *= 1.2;
			failedPopup.initialize(_resources);
			//
			
			var titleRes:Vector.<Texture> = new Vector.<Texture>();
			titleRes.push(_resources.getSubTexture(UIResource.SPRITE, UIResource.STAGE));
			// TITLE
			var title:Title = new Title(MainStage.stageWidth, MainStage.stageHeight, titleRes);
			
			titleRes.pop();
			
			var stageId:String = _stageId.toString();
			for (i = 0; i < stageId.length; i++)
			{
				titleRes.push(
					_resources.getSubTexture(UIResource.SPRITE, stageId.charAt(i) + "_orange"));
			}
			
			title.addSubTitle(MainStage.stageWidth, MainStage.stageHeight, titleRes);
			title.fadeInterval = 70;
			title.isFade = true;
			
			titleRes.splice(0, titleRes.length);
			titleRes = null;
			/////

			addChild(field);
			addChild(restGauge);
			addChild(life);
			addChild(flag);	
			addChild(settingButton);
			addChild(background);
			addChild(settingPopup);
			addChild(clearedPopup);
			addChild(failedPopup);
			addChild(title);
			
			var spriteSheet:SpriteSheet = _resources.getSpriteSheet(UIResource.SPRITE);
			spriteSheet.removeSubTexture(UIResource.FIELD);
			spriteSheet.removeSubTexture(UIResource.HEART);
			spriteSheet.removeSubTexture(UIResource.SETTING_ICON);
			spriteSheet.removeSubTexture(UIResource.BACKGROUND);
			spriteSheet.removeSubTexture(UIResource.SETTING_POPUP);
			spriteSheet.removeSubTexture(UIResource.CLEARED_POPUP);
			spriteSheet.removeSubTexture(UIResource.FAILED_POPUP);
			spriteSheet.removeSubTexture(UIResource.STAGE);
		}
		
		private function onFailedLoad(message:String):void
		{
			trace(message);
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{
			var background:GameObject = getChild(BACKGROUND);
			if (background)
			{
				background.alpha += 0.015;
				
				if (background.alpha >= 1)
				{
					if (_runGame)
					{
						_runGame(false);
					}
					removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
					
					var failedPopup:FailedPopup = getChild(FAILED_POPUP) as FailedPopup;
					if (failedPopup)
					{
						failedPopup.show();
					}
				}
			}
		}
		
		private function onEndedSettingButton(event:TrollingEvent):void
		{
			var title:Title = getChild(TITLE) as Title;
			var background:GameObject = getChild(BACKGROUND);
			var settingPopup:SettingPopup = getChild(SETTING_POPUP) as SettingPopup;
			
			if (background && settingPopup)
			{
				if (title)
				{
					removeChild(title);
				}
				
				if (!settingPopup.visible)
				{
					if (_runGame)
					{
						_runGame(false);						
					}
					background.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedBackground);
					background.visible = true;
					settingPopup.show();	
					dispatchEvent(new TrollingEvent("settingPopup", settingPopup.visible));
				}
			}
		}
		
		private function onEndedBackground(event:TrollingEvent):void
		{
			var background:GameObject = getChild(BACKGROUND);
			var settingPopup:SettingPopup = getChild(SETTING_POPUP) as SettingPopup;
			
			if (background && settingPopup)
			{
				settingPopup.close();
				dispatchEvent(new TrollingEvent("settingPopup", settingPopup.visible));
				background.visible = false;
				background.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedBackground);
				if (_runGame)
				{
					_runGame(true);
				}
			}
		}
		
		private function onEndedControl(event:TrollingEvent):void
		{
			dispatchEvent(new TrollingEvent("control", event.data));
		}
		
		private function onInitControlMode(event:TrollingEvent):void
		{
			dispatchEvent(new TrollingEvent("initControlMode", event.data));
		}
	}
}