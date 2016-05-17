package scene.stageSelectScene
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import scene.gameScene.MainStage;
	import scene.loading.ResourceLoad;
	import scene.loading.SpriteSheet;
	
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
		
		private var _spriteDir:File = File.applicationDirectory.resolvePath("scene/stageSelectScene");
		private var _soundDir:File = File.applicationDirectory.resolvePath("scene/stageSelectScene");
		
		private var _backGround:GameObject;
		private var _backGroundImage:Image;
		
		private var _nextButton:Button;
		private var _prevButton:Button;
		
		private var _numberVector:Vector.<GameObject> = new Vector.<GameObject>();
		
		private var _stageIndex:uint;
		
		private var _resource:ResourceLoad;
		private var _spriteSheet:SpriteSheet;
		
		public function StageSelectScene()
		{
			addEventListener(TrollingEvent.START_SCENE, onInit);
		}
		
		private function onInit(event:Event):void
		{
			if(this.data == null)
			{
				_resource = new ResourceLoad(onCompleteLoad, onFaildLoad);
				
				_resource.spriteName.push("selectSceneSprite0.png");
				
				_resource.loadResource(_spriteDir, _soundDir);
			}
			else
			{
				_stageIndex = ((this.data as uint)-1)/5;
				setStageNumber();
			}
		}
		
		private function onFaildLoad(message:String):void
		{
			trace(message);
		}
		
		private function onCompleteLoad():void
		{
			//			this.width = 800;
			//			this.height = 600;
			
			
//			if(this.data == null)
//			{
				_stageIndex = 0;
				if(this.data != null)
					_stageIndex = this.data as uint;
				
				_backGround = new GameObject();
				_backGroundImage = new Image(SpriteSheet(_resource.spriteSheetDic["selectSceneSprite0.png"]).subTextures["sea1"]);
				_backGround.addComponent(_backGroundImage);
				
				_backGround.width = this.width;
				_backGround.height = this.height;
				
				var buttonTexture:Texture = SpriteSheet(_resource.spriteSheetDic["selectSceneSprite0.png"]).subTextures["buttonImage"];
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
				
				_nextButton = new Button(SpriteSheet(_resource.spriteSheetDic["selectSceneSprite0.png"]).subTextures["nextButton"]);
				_nextButton.width = 100;
				_nextButton.height = 100;
				_nextButton.x = 860;
				_nextButton.y = 100;
				_nextButton.pivot = PivotType.CENTER;
				_nextButton.addEventListener(TrollingEvent.TOUCH_ENDED, onNextClick);
				
				_prevButton = new Button(SpriteSheet(_resource.spriteSheetDic["selectSceneSprite0.png"]).subTextures["prevButton"]);
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
		}
		
		private function setStageNumber():void
		{
			for(var i:int = 1; i <= 5; i++)
			{
				var stageCount:uint = (_stageIndex*5)+i;
				var countString:String = stageCount.toString();
				
				_numberVector[(i-1)*2].components[ComponentType.IMAGE].texture = SpriteSheet(_resource.spriteSheetDic["selectSceneSprite0.png"]).subTextures[int(countString.charAt(0))+"_number"];
				if(countString.length >= 2)
				{
					_numberVector[(i-1)*2].x = -10;
					_numberVector[((i-1)*2)+1].components[ComponentType.IMAGE].texture = SpriteSheet(_resource.spriteSheetDic["selectSceneSprite0.png"]).subTextures[int(countString.charAt(1))+"_number"];
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
		}
	}
}