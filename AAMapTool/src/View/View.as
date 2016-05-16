package View
{
	import Asset.Assets;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class View extends Sprite
	{		
		private var _stageNum:int;
		private var _color:int;
		private var _objectBGVector:Vector.<Image> = new Vector.<Image>();
		private var _objectVector:Vector.<Image> = new Vector.<Image>();
		private var _objectDataVector:Vector.<int> = new Vector.<int>();
		private var _mapVector:Vector.<Sprite> = new Vector.<Sprite>()
		private var _curveDataVector:Vector.<int> = new Vector.<int>();
		
		private var _map:Sprite;
		
		private var _addButton:Button;
		private var _deleteButton:Button;
		
		private var _nextButton:Button;
		private var _prevButton:Button;
		
		private var _page:TextField = new TextField(100, 50, "0");	
		private var _currentPage:int;
		private var _currentObject:int;
		
		private var _stageSprite:Sprite = new Sprite();
		
		private var _stageUpButton:Button;
		private var _stageDownButton:Button;
		private var _stageTextField:TextField = new TextField(200, 50, "");
		
		private var _curveVector:Vector.<Image> = new Vector.<Image>();
		
		private var _colorImage:Image = new Image(null);
		
		
		public function get color():int { return _color; }
		public function get stageNum():int { return _stageNum; }
		public function get curveDataVector():Vector.<int> { return _curveDataVector; }
		public function get objectDataVector():Vector.<int> {	return _objectDataVector; }
		
		public function View()
		{
			addMap();
			initButton();
			initETC();
			addEvent();
			
			_objectBGVector[0].alpha = 1;			
			
			_stageSprite.y = 100;
			addChild(_stageSprite);
		}		

		private function addMap():void
		{
			_map = new Sprite();
			var texture:Texture = Texture.fromEmbeddedAsset(Assets.ObjectBG);
			for(var i:int = 0; i < 10; ++i)
			{
				var objectBG:Image = new Image(texture);
				objectBG.alignPivot("center", "center");
				objectBG.x = 228;
				objectBG.y = -i * 50 + 532; 
				objectBG.alpha = 0.5;
				_objectBGVector.push(objectBG);
				
				var object:Image = new Image(null);
				object.alignPivot("center", "center");
				object.touchable = false;
				object.width = 64;
				object.height = 64;
				object.x = 228;
				object.y = -i * 50 + 532; 
				object.alpha = 0.5;
				object.visible = false;
				_objectVector.push(object);
				
				_objectDataVector.push(0);
								
				_map.addChild(objectBG);
				_map.addChild(object);
			}					
			_mapVector.push(_map);
			
			_curveDataVector.push(-1);
			var image:Image = new Image(null);			
			_curveVector.push(image);
			_stageSprite.addChild(image);
			changeCurve(-1);
			
			_stageSprite.addChild(_map);	
			_map.addEventListener(TouchEvent.TOUCH, onClickMap);
		}
		
		private function initButton():void
		{
			var texture:Texture = Texture.fromEmbeddedAsset(Assets.Add);			
			_addButton = new Button(texture);
			_addButton.x = 300;
			_addButton.y = 600;
			_stageSprite.addChild(_addButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.Del);			
			_deleteButton = new Button(texture);
			_deleteButton.x = 50;
			_deleteButton.y = 600;
			_stageSprite.addChild(_deleteButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.Prev);			
			_prevButton = new Button(texture);
			_prevButton.width = 64;
			_prevButton.height = 64;
			_prevButton.x = 0;
			_prevButton.y = 300;
			_stageSprite.addChild(_prevButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.Next);
			_nextButton = new Button(texture);
			_nextButton.width = 64;
			_nextButton.height = 64;
			_nextButton.x = 390;
			_nextButton.y = 300;
			_stageSprite.addChild(_nextButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.StageUp);			
			_stageUpButton = new Button(texture);
			_stageUpButton.width = 32;
			_stageUpButton.height = 32;
			_stageUpButton.x = 200;
			addChild(_stageUpButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.StageDown);			
			_stageDownButton = new Button(texture);
			_stageDownButton.width = 32;
			_stageDownButton.height = 32;
			_stageDownButton.x = 200;
			_stageDownButton.y = 32;
			addChild(_stageDownButton);
		}
		
		private function initETC():void
		{
			_page.format.size = 30;
			_page.x = 180;
			_stageSprite.addChild(_page);
			
			_stageNum = 1;
			_color = 0;
			
			_colorImage.x = 356;
			_colorImage.width = 128;
			_colorImage.height = 128;	
			_colorImage.texture = Texture.fromEmbeddedAsset(Assets.CyanBG);
			
			_stageTextField.format.size = 30;
			_stageTextField.text = "STAGE : " + _stageNum.toString();
			addChild(_stageTextField);
			
			_stageSprite.addChild(_colorImage);
		}
		
		private function addEvent():void
		{			
			_addButton.addEventListener(TouchEvent.TOUCH, onClickAdd);
			_deleteButton.addEventListener(TouchEvent.TOUCH, onClickDelete);
			_prevButton.addEventListener(TouchEvent.TOUCH, onClickPrev);
			_nextButton.addEventListener(TouchEvent.TOUCH, onClickNext);
			_stageUpButton.addEventListener(TouchEvent.TOUCH, onClickStageUp);
			_stageDownButton.addEventListener(TouchEvent.TOUCH, onClickStageDown);
			
			addEventListener("object", onClickObject);
			addEventListener("curve", onClickCurve);
			addEventListener("color", onClickColor);
		}
		
		private function onClickStageUp(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_stageUpButton, TouchPhase.ENDED);
			if(touch)
			{
				_stageNum++;
				_stageTextField.text = "STAGE : " + _stageNum.toString();
			}
			
		}
		
		private function onClickStageDown(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_stageDownButton, TouchPhase.ENDED);
			if(touch)
			{
				if(_stageNum > 1)
					_stageNum--;
				
				_stageTextField.text = "STAGE : " + _stageNum.toString();
			}
			
		}
		
		private function onClickObject(event:Event):void
		{
			//trace(event.data);
			
			switch(event.data)
			{
				case -1:
					var texture:Texture = Texture.fromEmbeddedAsset(Assets.Home);			
					changeObject(texture, 228, 64, 64, 1, true);
					_objectDataVector[_currentObject] = -1;
					break;
				case 0:
					changeObject(null, 228, 64, 64, 1, false);
					_objectDataVector[_currentObject] = 0;
					break;
				case 1:
					texture = Texture.fromEmbeddedAsset(Assets.CraterEllipse);	
					changeObject(texture, 228, 64, 64, 1, true);
					_objectDataVector[_currentObject] = 1;
					break;
				case 2:
					texture = Texture.fromEmbeddedAsset(Assets.CraterEllipse);	
					changeObject(texture, 146, 64, 64, 1, true);
					_objectDataVector[_currentObject] = 2;
					break;
				case 3:
					texture = Texture.fromEmbeddedAsset(Assets.CraterEllipse);	
					changeObject(texture, 310, 64, 64, 1, true);
					_objectDataVector[_currentObject] = 3;
					break;
				case 4:
					texture = Texture.fromEmbeddedAsset(Assets.DoubleCraterEllipse);	
					changeObject(texture, 228, 256, 64, 1, true);
					_objectDataVector[_currentObject] = 4;
					break;
				case 5:
					texture = Texture.fromEmbeddedAsset(Assets.CraterRect);	
					changeObject(texture, 180, 64, 64, 1, true);
					_objectDataVector[_currentObject] = 5;
					break;
				case 6:
					texture = Texture.fromEmbeddedAsset(Assets.CraterRect);	
					changeObject(texture, 276, 64, 64, 1, true);
					_objectDataVector[_currentObject] = 6;
					break;
				case 7:
					texture = Texture.fromEmbeddedAsset(Assets.Flag);	
					changeObject(texture, 180, 64, 64, 1, true);
					_objectDataVector[_currentObject] = 7;
					break;
				case 8:
					texture = Texture.fromEmbeddedAsset(Assets.Flag);	
					changeObject(texture, 276, 64, 64, 1, true);
					_objectDataVector[_currentObject] = 8;
					break;				
			}	
			
			printData();
		}
		
		private function onClickCurve(event:Event):void
		{
			_curveDataVector[_currentPage] = event.data;
			changeCurve(int(event.data));
		}
		
		private function onClickColor(event:Event):void
		{
			_color = int(event.data);
			var texture:Texture;
			if(event.data == 0)
			{
				texture = Texture.fromEmbeddedAsset(Assets.CyanBG);				
			}
			else
			{
				texture = Texture.fromEmbeddedAsset(Assets.OrangeBG);	
			}
			_colorImage.texture = texture;
		}
		
		private function changeObject(texture:Texture, x:int, width:int, height:int, alpha:Number, visible:Boolean):void
		{
			_objectVector[_currentObject].texture = texture;
			_objectVector[_currentObject].x = x;
			_objectVector[_currentObject].width = width;
			_objectVector[_currentObject].height = height;
			_objectVector[_currentObject].alpha = alpha;
			_objectVector[_currentObject].visible = visible;			
		}
		
		private function onClickMap(event:TouchEvent):void
		{
			
			for(var i:int = 0; i < _objectBGVector.length; ++i)
			{
				var touch:Touch = event.getTouch(_objectBGVector[i], TouchPhase.ENDED);
				if(touch)
				{					
					for(var j:int = 0; j < _objectBGVector.length; ++j)
					{
						_objectBGVector[j].alpha = 0.5;
						_objectVector[j].alpha = 0.5;
					}
					_currentObject = i;
					
					_objectBGVector[i].alpha = 1;
					_objectVector[i].alpha = 1;
				}
			}
		}
		
		private function onClickAdd(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_addButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("addButton");
				addMap();
				//trace(_mapVector.length);
				_currentPage = _mapVector.length - 1;
				_page.text = _currentPage.toString();				
				
				changeCurve(-1);
				
				viewCurrentMap();				
			}
		}
		
		private function onClickDelete(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_deleteButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("deleteButton");
				//trace("currentPage = " + _currentPage);
			
				if(_mapVector.length <= 1)
					return;
				
				//trace("_mapVector[_currentPage].numChildren = " + _mapVector[_currentPage].numChildren);
								
				for(var i:int = 0; i < 10; ++i)
				{
					_objectBGVector[_currentPage * 10 + i].dispose();
					_objectBGVector[_currentPage * 10 + i] = null;
					_objectVector[_currentPage * 10 + i].dispose();
					_objectVector[_currentPage * 10 + i] = null;
					_objectDataVector[_currentPage * 10 + i] = null;
				}
				_mapVector[_currentPage].removeChildren();
				_curveVector[_currentPage].dispose();
				_curveVector[_currentPage] = null;
				
				_mapVector.splice(_currentPage, 1);
				_curveVector.splice(_currentPage, 1);
				_objectBGVector.splice(_currentPage * 10, 10);
				_objectVector.splice(_currentPage * 10, 10);
				_objectDataVector.splice(_currentPage * 10, 10);
				_curveDataVector.splice(_currentPage, 1);
				 
				if(_currentPage > 0)
					_currentPage--;
				
				_page.text = _currentPage.toString();
				viewCurrentMap();
			}
		}
		
		private function onClickPrev(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_prevButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("prevButton");
				if(_currentPage > 0)
					_currentPage--;
				
				_page.text = _currentPage.toString();
				viewCurrentMap();
			}
		}
		
		private function onClickNext(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_nextButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("nextButton");
				if(_currentPage < _mapVector.length - 1)
					_currentPage++;
				
				_page.text = _currentPage.toString();
				viewCurrentMap();				
			}
		}
		
		private function viewCurrentMap():void
		{
			for(var i:int = 0; i < _mapVector.length; ++i)
			{
				if(i == _currentPage)
				{
					_mapVector[i].visible = true;
					_curveVector[i].visible = true;
				}
				else
				{
					_mapVector[i].visible = false;
					_curveVector[i].visible = false;
				}
			}
		}
		
		private function printData():void
		{
			for(var i:int = 0; i < _objectDataVector.length; ++i)
			{
				trace(i + " " + _objectDataVector[i]);
			}
		}
		
		private function changeCurve(direction:int):void
		{
			var texture:Texture;
			switch(direction)
			{
				case -1:
					texture = Texture.fromEmbeddedAsset(Assets.NormalCurve);					
					break;
				case 0:
					texture = Texture.fromEmbeddedAsset(Assets.LeftCurve);
					break;
				case 1:
					texture = Texture.fromEmbeddedAsset(Assets.RightCurve);
					break;
			}
			
			
			_curveVector[_currentPage].texture = texture;
			_curveVector[_currentPage].visible = true;
			//addChild(image);
		}
	}
}