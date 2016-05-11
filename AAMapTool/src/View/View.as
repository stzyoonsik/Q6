package View
{
	import Asset.Assets;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class View extends Sprite
	{		
		private var _objectVector:Vector.<Button> = new Vector.<Button>();
		private var _dataVector:Vector.<int> = new Vector.<int>();
		private var _mapVector:Vector.<Sprite> = new Vector.<Sprite>();
		
		private var _map:Sprite;
		
		private var _addButton:Button;
		private var _deleteButton:Button;
		
		private var _nextButton:Button;
		private var _prevButton:Button;
		
		private var _page:TextField = new TextField(100, 50, "0");	
		private var _currentPage:int;
		private var _currentObject:int;
		
		public function View()
		{
			addMap();
			initButton();
			initTextField();
			addEvent();
		}
		
		private function addMap():void
		{
			_map = new Sprite();
			var texture:Texture = Texture.fromEmbeddedAsset(Assets.ObjectBG);
			for(var i:int = 0; i < 10; ++i)
			{
				var objectBG:Button = new Button(texture);
				objectBG.x = 100;
				objectBG.y = -i * 50 + 500; 
				objectBG.alpha = 0.5;
				//objectBG.name = i.toString();
				_objectVector.push(objectBG);
				
				_map.addChild(objectBG);				
			}					
			_mapVector.push(_map);
			addChild(_map);	
			_map.addEventListener(TouchEvent.TOUCH, onClickMap);
		}
		
		private function initButton():void
		{
			var texture:Texture = Texture.fromEmbeddedAsset(Assets.Add);			
			_addButton = new Button(texture);
			_addButton.x = 300;
			_addButton.y = 600;
			addChild(_addButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.Del);			
			_deleteButton = new Button(texture);
			_deleteButton.x = 50;
			_deleteButton.y = 600;
			addChild(_deleteButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.Prev);			
			_prevButton = new Button(texture);
			_prevButton.width = 64;
			_prevButton.height = 64;
			_prevButton.x = 0;
			_prevButton.y = 300;
			addChild(_prevButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.Next);			
			_nextButton = new Button(texture);
			_nextButton.width = 64;
			_nextButton.height = 64;
			_nextButton.x = 390;
			_nextButton.y = 300;
			addChild(_nextButton);
		}
		
		private function initTextField():void
		{
			_page.format.size = 30;
			_page.x = 180;
			addChild(_page);
		}
		
		private function addEvent():void
		{
			
			_addButton.addEventListener(TouchEvent.TOUCH, onClickAdd);
			_deleteButton.addEventListener(TouchEvent.TOUCH, onClickDelete);
			_prevButton.addEventListener(TouchEvent.TOUCH, onClickPrev);
			_nextButton.addEventListener(TouchEvent.TOUCH, onClickNext);
		}
		
		private function onClickMap(event:TouchEvent):void
		{
			
			for(var i:int = 0; i < _objectVector.length; ++i)
			{
				var touch:Touch = event.getTouch(_objectVector[i], TouchPhase.ENDED);
				if(touch)
				{					
					for(var j:int = 0; j < _objectVector.length; ++j)
					{
						_objectVector[j].alpha = 0.5;
					}
					_currentObject = i;
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
				trace(_mapVector.length);
				_currentPage = _mapVector.length - 1;
				_page.text = _currentPage.toString();
				viewCurrentMap();
			}
		}
		
		private function onClickDelete(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_deleteButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("deleteButton");
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
				}
				else
				{
					_mapVector[i].visible = false;
				}
			}
		}
	}
}