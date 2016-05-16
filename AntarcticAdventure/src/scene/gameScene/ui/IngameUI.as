package scene.gameScene.ui
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import scene.gameScene.MainStage;
	
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
		
		private var _resourceDirectory:File;
		private var _resourceList:Array;
		private var _bitmaps:Dictionary;
		private var _loadCount:int;
		
		private var _stageId:int;
		private var _totalDistance:Number;
		private var _totalLife:Number;
		private var _totalFlag:int;
		private var _currentLife:int;
		private var _currentFlag:int;
		private var _textures:Dictionary;
		
		private var _runGame:Function;
		
		public function IngameUI()
		{
			_resourceDirectory = new File(UIResource.DIRECTORY);
			_resourceList = _resourceDirectory.getDirectoryListing();
			
			_loadCount = 0;
			_stageId = 0;
			_totalDistance = 0;
			_totalLife = 0;
			_totalFlag = 0;
			_currentLife = 0;
			_textures = null;
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
			
			_bitmaps = new Dictionary();
			var file:File;
			var loader:Loader;
			for(var i:int = 0; i < _resourceList.length; i++)
			{
				file = _resourceList[i] as File;
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onCatchError);
				loader.load(new URLRequest(file.url));
			}
		}
		
		public override function dispose():void
		{
			// to do
			
			
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
						clearedPopup.setResult(_totalFlag, _currentFlag, _textures);
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
						image.texture = _textures[currentFlag.charAt(currentFlagIndex)];
					}
				}
				currentFlagIndex--;
			}
			
			_currentFlag = numFlag;
		}
		
		private function onCompleteLoadAll():void
		{
			var fieldsXY:Number = MainStage.stageWidth / 70;
			// FIELDS
			var ingameText:GameObject = new GameObject();
			ingameText.x = ingameText.y = fieldsXY;
			ingameText.scaleX = 0.8;
			ingameText.scaleY = 0.8;
			ingameText.addComponent(new Image(new Texture(_bitmaps[UIResource.INGAME_TEXT])));
			
			delete _bitmaps[UIResource.INGAME_TEXT];
			/////
			
			var gaugeWidth:Number = ingameText.width * ingameText.scaleX * 1.5;
			var gaugeHeight:Number = gaugeWidth * 0.19;
			var horizontalMargin:Number = gaugeWidth / 8;
			var dataX:Number = fieldsXY + ingameText.width * ingameText.scaleX + horizontalMargin;
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
				heart.addComponent(new Image(new Texture(_bitmaps[UIResource.HEART])));
				
				scale = gaugeHeight / heart.height; 
				heart.width *= scale;
				heart.height *= scale;  
				
				if (i != 0)
				{
					heart.x = heart.width * i;
				}
				
				life.addChild(heart);
			}
			
			delete _bitmaps[UIResource.HEART];
			/////
			
			// FLAG
			var flag:GameObject = new GameObject();
			flag.x = dataX;
			flag.y = life.y + gaugeHeight + verticalMargin + 5;
			
			var slash:GameObject = new GameObject();
			slash.addComponent(new Image(new Texture(_bitmaps[UIResource.SLASH])));		
			/////
			
			// SETTING_BUTTON
			var settingButton:Button = new Button(new Texture(_bitmaps[UIResource.SETTING_ICON]));
			settingButton.x = MainStage.stageWidth - settingButton.width;
			settingButton.y = fieldsXY * 2.5;
			settingButton.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedSettingButton);
			
			delete _bitmaps[UIResource.SETTING_ICON];
			/////
			
			// BACKGROUND
			var background:GameObject = new GameObject();
			background.addComponent(new Image(new Texture(_bitmaps[UIResource.BACKGROUND])));
			background.width = MainStage.stageWidth;
			background.height = MainStage.stageHeight;
			background.visible = false;
			
			delete _bitmaps[UIResource.BACKGROUND];
			//
			
			// SETTING_POPUP
			var settingPopup:SettingPopup = new SettingPopup(new Texture(_bitmaps[UIResource.SETTING_POPUP]));
			settingPopup.x = MainStage.stageWidth / 2;
			settingPopup.y = MainStage.stageHeight / 2;
			settingPopup.width *= 1.2;
			settingPopup.height *= 1.2;
			settingPopup.initialize(_bitmaps);
			
			delete _bitmaps[UIResource.SETTING_POPUP];
			//
			
			// CLEARED_POPUP
			var clearedPopup:ClearedPopup = new ClearedPopup(new Texture(_bitmaps[UIResource.CLEARED_POPUP]));
			clearedPopup.x = MainStage.stageWidth / 2;
			clearedPopup.y = MainStage.stageHeight / 2;
			clearedPopup.width *= 1.2;
			clearedPopup.height *= 1.2;
			clearedPopup.initialize(_bitmaps);
			
			delete _bitmaps[UIResource.CLEARED_POPUP];
			//
			
			// FAILED_POPUP
			var failedPopup:FailedPopup = new FailedPopup(new Texture(_bitmaps[UIResource.FAILED_POPUP]));
			failedPopup.x = MainStage.stageWidth / 2;
			failedPopup.y = MainStage.stageHeight / 2;
			failedPopup.width *= 1.2;
			failedPopup.height *= 1.2;
			failedPopup.initialize(_bitmaps);
			
			delete _bitmaps[UIResource.FAILED_POPUP];
			//
			
			var titleRes:Vector.<Texture> = new Vector.<Texture>();
			titleRes.push(new Texture(_bitmaps[UIResource.STAGE]));
			// TITLE
			var title:Title = new Title(MainStage.stageWidth, MainStage.stageHeight, titleRes);
			
			titleRes.pop();
			delete _bitmaps[UIResource.STAGE];
			/////
			
			// Numbers & Stars
			_textures = new Dictionary();
			for (var name:String in _bitmaps)
			{
				_textures[name] = new Texture(_bitmaps[name]); 
			}
			_bitmaps = null;
			/////
			
			// FLAG
			var numFlag:String = _totalFlag.toString();
			var totalFlagIndex:int = 0;
			var textMargin:Number = 5;
			var digit:GameObject;
			for (i = 0; i < numFlag.length * 2 + 1; i++)
			{
				if (i < numFlag.length)
				{
					digit = new GameObject();
					digit.addComponent(new Image(_textures["0"]));
				}
				else if (i > numFlag.length)
				{
					digit = new GameObject();
					digit.addComponent(new Image(_textures[numFlag.charAt(totalFlagIndex)]));
					
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
			
			// TITLE
			var stageId:String = _stageId.toString();
			for (i = 0; i < stageId.length; i++)
			{
				titleRes.push(_textures[stageId.charAt(i) + "orange"]);
			}
			
			title.addSubTitle(MainStage.stageWidth, MainStage.stageHeight, titleRes);
			title.fadeInterval = 70;
			title.isFade = true;
			
			titleRes.splice(0, titleRes.length);
			titleRes = null;
			/////
			
			//			private const FIELDS:int = 0;
			//			private const REST:int = 1;
			//			private const LIFE:int = 2;
			//			private const FLAG:int = 3;
			//			private const SETTING_BUTTON:int = 4;
			//			private const BACKGROUND:int = 5;
			//			private const SETTING_POPUP:int = 6;
			//			private const CLEARED_POPUP:int = 7;
			//			private const FAILED_POPUP:int = 8;
			//			private const TITLE:int = 9;
			
			addChild(ingameText);
			addChild(restGauge);
			addChild(life);
			addChild(flag);	
			addChild(settingButton);
			addChild(background);
			addChild(settingPopup);
			addChild(clearedPopup);
			addChild(failedPopup);
			addChild(title);
		}
		
		private function onCompleteLoad(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			var fileName:String = loaderInfo.url.replace(_resourceDirectory.url + "/", "")
			var index:int = fileName.indexOf("_");
			if (index != -1)
			{
				fileName = fileName.substring(0, index);
			}
			else
			{
				fileName = fileName.substring(0, fileName.indexOf("."));
			}
			
			_bitmaps[fileName] = loaderInfo.loader.content as Bitmap;
			
			loaderInfo.removeEventListener(Event.COMPLETE, onCompleteLoad);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onCatchError);
			loaderInfo.loader.unload();
			loaderInfo = null;
			
			_loadCount++;
			
			if (_resourceList.length <= _loadCount)
			{
				for (var i:int = 0; i < _resourceList.length; i++)
				{
					_resourceList[i] = null;
				}
				_resourceList = null;
				
				_resourceDirectory = null;
				_loadCount = 0;
				
				onCompleteLoadAll();
			}
		}
		
		private function onCatchError(event:IOErrorEvent):void
		{
			trace(TAG + " onCatchError : Please Check " + LoaderInfo(event.currentTarget).url + ".");
			
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onCompleteLoad);
			LoaderInfo(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onCatchError);
			
			_loadCount++;
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
				background.visible = false;
				background.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedBackground);
				if (_runGame)
				{
					_runGame(true);
				}
			}
		}
	}
}