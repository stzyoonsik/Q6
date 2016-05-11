package gameScene.ui
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import gameScene.MainStage;
	
	import trolling.component.graphic.Image;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	
	import ui.CursorGauge;
	import ui.Title;

	public class IngameUi extends GameObject
	{
		private const TAG:String = "[IngameUi]";
		private const FIELDS:int = 0;
		private const REST:int = 1;
		private const LIFE:int = 2;
		private const FLAG:int = 3;
		private const SETTING:int = 4;
		// + Setting Popup
		
		private var _resourceDirectory:File;
		private var _resourceList:Array;
		private var _bitmaps:Dictionary;
		private var _loadCount:int;
		
		private var _stageId:int;
		private var _totalDistance:Number;
		private var _totalLife:Number;
		private var _totalFlag:int;
		
		private var _currentLife:int;
		
		private var _numbers:Dictionary;
		
		public function IngameUi()
		{
			_resourceDirectory = File.applicationDirectory.resolvePath("resources").resolvePath("ui").resolvePath("ingameUi");
			_resourceList = _resourceDirectory.getDirectoryListing();
			
			_loadCount = 0;
			_stageId = 0;
			_totalDistance = 0;
			_totalLife = 0;
			_totalFlag = 0;
			_currentLife = 0;
			_numbers = null;
		}
		
		public function initialize(stageId:int, totalDistance:Number, totalLife:Number, totalFlag:int):void
		{
			_stageId = stageId;
			_totalDistance = totalDistance;
			_totalLife = totalLife;
			_totalFlag = totalFlag;
			
			_bitmaps = new Dictionary();
			for(var i:int = 0; i < _resourceList.length; i++)
			{
				var file:File = _resourceList[i] as File;
				var loader:Loader = new Loader();
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
			
			if (!life)
			{
				return;
			}
			
			if (numLife < _currentLife)
			{
				for (var i:int = _currentLife - 1; i >= numLife; i--)
				{
					var heart:GameObject = life.getChild(i);
					if (heart)
					{
						heart.visable = false;
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
						heart.visable = true;
					}
				}
			}
		}
		
		public function setCurrentFlag(numFlag:int):void
		{
			// to do
			
			
			
			
		}
		
		private function onCompleteLoadAll():void
		{
			var fieldsXY:Number = MainStage.stageWidth / 50;
			// FIELDS
			var ingameText:GameObject = new GameObject();
			ingameText.x = ingameText.y = fieldsXY;
			ingameText.scaleX = 0.8;
			ingameText.scaleY = 0.8;
			ingameText.addComponent(new Image(new Texture(_bitmaps["ingameText"])));
			addChild(ingameText);
			
			delete _bitmaps["ingameText"];
			/////
		
			var gaugeWidth:Number = ingameText.width * ingameText.scaleX * 1.5;
			var gaugeHeight:Number = gaugeWidth * 0.19;
			var horizontalMargin:Number = gaugeWidth / 8;
			var dataX:Number = fieldsXY + ingameText.width * ingameText.scaleX + horizontalMargin;
			// REST
			var restGauge:CursorGauge = new CursorGauge(gaugeWidth, gaugeHeight, 0.03);
			restGauge.x = dataX;
			restGauge.y = fieldsXY + 8;
			restGauge.total = _totalDistance;
			addChild(restGauge);
			/////
			
			var verticalMargin:Number = gaugeHeight / 2; 
			// LIFE
			var life:GameObject = new GameObject();
			life.x = dataX;
			life.y = restGauge.y + gaugeHeight + verticalMargin;
			
			for (var i:int = 0; i < _totalLife; i++)
			{
				var heart:GameObject = new GameObject();
				heart.addComponent(new Image(new Texture(_bitmaps["heart"])));
				
				var scale:Number = gaugeHeight / heart.height; 
				heart.width *= scale;
				heart.height *= scale;  
					
				if (i != 0)
				{
					heart.x = heart.width * i;
				}
				
				life.addChild(heart);
			}
			addChild(life);
			
			delete _bitmaps["heart"];
			/////
			
			// FLAG
			var flag:GameObject = new GameObject();
			flag.x = dataX;
			flag.y = life.y + gaugeHeight + verticalMargin + 5;
			
			var slash:GameObject = new GameObject();
			slash.addComponent(new Image(new Texture(_bitmaps["slash"])));		

			delete _bitmaps["slash"];
			/////
			
			// SETTING
			var setting:GameObject = new GameObject();
			setting.addComponent(new Image(new Texture(_bitmaps["setting"])));
			
			setting.x = MainStage.stageWidth - setting.width - fieldsXY;
			setting.y = fieldsXY;
				
			addChild(setting);
			delete _bitmaps["setting"];
			/////

			var titleRes:Vector.<Texture> = new Vector.<Texture>();
			titleRes.push(new Texture(_bitmaps["stage"]));
			// TITLE
			var title:Title = new Title(MainStage.stageWidth, MainStage.stageHeight, titleRes);
			
			titleRes.pop();
			delete _bitmaps["stage"];
			/////
			
			// Numbers
			_numbers = new Dictionary();
			for (var name:String in _bitmaps)
			{
				_numbers[name] = new Texture(_bitmaps[name]); 
			}
			_bitmaps = null;
			/////
			
			// FLAG
			var numFlag:String = _totalFlag.toString();
			var totalFlagIndex:int = numFlag.length - 1;
			var digitHeight:Number = 0;
			for (i = numFlag.length * 2; i >= 0; i--)
			{
				var digit:GameObject;
				
				if (i < numFlag.length)
				{
					digit = new GameObject();
					digit.addComponent(new Image());
					
					scale = gaugeHeight / digitHeight;
				}
				else if (i > numFlag.length)
				{
					digit = new GameObject();
					digit.addComponent(new Image(_numbers[numFlag.charAt(totalFlagIndex)]));
					
					scale = gaugeHeight / digit.height;
					
					digitHeight = digit.height;
					totalFlagIndex--;
				}
				else
				{
					digit = slash;
					scale = gaugeHeight / digit.height;
				}
				 
				digit.width *= scale;
				digit.height *= scale;  
				
				if (i != 0)
				{
					digit.x = slash.width * i;
				}
				
				flag.addChild(digit);
			}
			addChild(flag);			
			/////
			
			// TITLE
			var stageId:String = _stageId.toString();
			for (i = 0; i < stageId.length; i++)
			{
				titleRes.push(_numbers[stageId.charAt(i)]);
			}
			
			title.addSubTitle(MainStage.stageWidth, MainStage.stageHeight, titleRes);
			title.fadeInterval = 70;
			title.isFade = true;
			addChild(title);
			
			titleRes.splice(0, titleRes.length);
			titleRes = null;
			/////
		}
		
		private function onCompleteLoad(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			var fileName:String = loaderInfo.url.replace(_resourceDirectory.url + "/", "")
			fileName = fileName.substring(0, fileName.indexOf("_"));
			
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
	}
}