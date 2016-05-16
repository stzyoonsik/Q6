package scene.stageSelectScene
{
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
	import trolling.core.SceneManager;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.object.Scene;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	import ui.button.Button;
	
	public class StageSelectScene extends Scene
	{	
		private var _imageDic:Dictionary = new Dictionary();
		private var _imageURLVector:Vector.<String> = new Vector.<String>();
		private var _imageLoadCount:uint = 0;
		private var _filePath:File = File.applicationDirectory.resolvePath("scene/stageSelectScene");
		
		private var _backGround:GameObject;
		private var _backGroundImage:Image;
		
		private var _nextButton:Button;
		private var _prevButton:Button;
		
		private var _numberVector:Vector.<GameObject> = new Vector.<GameObject>();
		
		private var _stageIndex:uint;
		
		public function StageSelectScene()
		{
			addEventListener(TrollingEvent.START_SCENE, onInit);
		}
		
		private function onInit(event:Event):void
		{
			_imageURLVector.push("sea1.png");
			_imageURLVector.push("buttonImage.png");
			_imageURLVector.push("nextButton.png");
			_imageURLVector.push("prevButton.png");
			_imageURLVector.push("0_number.png");
			_imageURLVector.push("1_number.png");
			_imageURLVector.push("2_number.png");
			_imageURLVector.push("3_number.png");
			_imageURLVector.push("4_number.png");
			_imageURLVector.push("5_number.png");
			_imageURLVector.push("6_number.png");
			_imageURLVector.push("7_number.png");
			_imageURLVector.push("8_number.png");
			_imageURLVector.push("9_number.png");
			
			var loader:Loader;
			var urlRequest:URLRequest;
			for(var i:int = 0; i < _imageURLVector.length; i++)
			{
				loader = new Loader();
				urlRequest = new URLRequest(_filePath.resolvePath(_imageURLVector[i]).url);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadFaild);
				loader.load(urlRequest);
			}
		}
		
		private function onImageLoaded(event:Event):void
		{
			trace("ddd = " + LoaderInfo(event.currentTarget).url);
			_imageDic[LoaderInfo(event.currentTarget).url.replace(_filePath.url.toString()+"/", "")] = LoaderInfo(event.currentTarget).loader.content;
			
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onImageLoaded);
			LoaderInfo(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadFaild);
			_imageLoadCount++;
			
			if(_imageURLVector.length <= _imageLoadCount)
			{
				_imageURLVector.splice(0, _imageURLVector.length);
				completeLoadImage();
			}
		}
		
		private function onImageLoadFaild(event:IOErrorEvent):void
		{
			trace("Please Check " + LoaderInfo(event.currentTarget).url);
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onImageLoaded);
			LoaderInfo(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadFaild);
			_imageLoadCount++;
		}
		
		private function completeLoadImage():void
		{
			//			this.width = 800;
			//			this.height = 600;
			
			
//			if(this.data == null)
//			{
				_stageIndex = 0;
				if(this.data != null)
					_stageIndex = this.data as uint;
				
				_backGround = new GameObject();
				_backGroundImage = new Image(new Texture(_imageDic["sea1.png"]));
				_backGround.addComponent(_backGroundImage);
				
				_backGround.width = this.width;
				_backGround.height = this.height;
				
				var buttonTexture:Texture = new Texture(_imageDic["buttonImage.png"]);
				var buttonX:Number = this.width / 6;
				var buttonY:Number = this.height / 6;
				
				for(var i:int = 1; i <= 5; i++)
				{
					var stageButton:Button = new Button(buttonTexture);
					stageButton.name = i.toString();
					stageButton.width = 100;
					stageButton.height = 100;
					stageButton.x = buttonX*i;
					stageButton.y = buttonY*i;
					stageButton.pivot = PivotType.CENTER;
					stageButton.addEventListener(TrollingEvent.TOUCH_ENDED, onButtonClick);
					_backGround.addChild(stageButton);
					
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
				
				_nextButton = new Button(new Texture(_imageDic["nextButton.png"]));
				_nextButton.width = 100;
				_nextButton.height = 100;
				_nextButton.x = 860;
				_nextButton.y = 100;
				_nextButton.pivot = PivotType.CENTER;
				_nextButton.addEventListener(TrollingEvent.TOUCH_ENDED, onNextClick);
				
				_prevButton = new Button(new Texture(_imageDic["prevButton.png"]));
				_prevButton.width = 100;
				_prevButton.height = 100;
				_prevButton.x = 100;
				_prevButton.y = 440;
				_prevButton.pivot = PivotType.CENTER;
				_prevButton.addEventListener(TrollingEvent.TOUCH_ENDED, onPrevClick);
//			}
//			else
			
			setStageNumber();
			
			addChild(_backGround);
			_backGround.addChild(_nextButton);
			_backGround.addChild(_prevButton);
			_backGround.addEventListener(TrollingEvent.TOUCH_ENDED, onTouch);
		}
		
		private function setStageNumber():void
		{
			for(var i:int = 1; i <= 5; i++)
			{
				var stageCount:uint = (_stageIndex*5)+i;
				var countString:String = stageCount.toString();
				
				_numberVector[(i-1)*2].components[ComponentType.IMAGE].texture = new Texture(_imageDic[int(countString.charAt(0))+"_number.png"]);
				if(countString.length >= 2)
				{
					_numberVector[(i-1)*2].x = -10;
					_numberVector[((i-1)*2)+1].components[ComponentType.IMAGE].texture = new Texture(_imageDic[int(countString.charAt(1))+"_number.png"]);
					_numberVector[((i-1)*2)+1].x = 10;
				}
				else
				{
					_numberVector[((i-1)*2)+1].components[ComponentType.IMAGE].texture = null;
					_numberVector[(i-1)*2].x = 0;
				}
			}
		}
		
		private function onPrevClick(event:TrollingEvent):void
		{
			if(_stageIndex <= 0)
			{
				//				SceneManager.outScene();
				//				SceneManager.deleteScene("stageSelect");
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
			GameObject(event.currentTarget).parent.dispatchEvent(new TrollingEvent(event.type, event.data));
		}
		
		private function onButtonClick(event:TrollingEvent):void
		{
			SceneManager.addScene(MainStage, "Game");
			SceneManager.goScene("Game", (_stageIndex*5)+int(event.currentTarget.name));
			//			SceneManager.goScene("Game", 1);
		}
		
		private function onTouch(event:TrollingEvent):void
		{
			trace(event.data[0]);
		}
	}
}