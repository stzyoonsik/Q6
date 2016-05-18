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
			texture = Texture.fromEmbeddedAsset(Assets.NormalCurve);
			var image:Image = new Image(texture);	
			image.width = 64;
			image.height = 64;
			_curveVector.push(image);
			_stageSprite.addChild(image);
			
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
			
			_colorImage.x = 420;
			_colorImage.width = 64;
			_colorImage.height = 64;	
			_colorImage.texture = Texture.fromEmbeddedAsset(Assets.CyanBG);
			
			_stageTextField.format.size = 30;
			_stageTextField.text = "STAGE : " + _stageNum.toString();
			addChild(_stageTextField);
			
			_stageSprite.addChild(_colorImage);
		}
		
		/**
		 * 
		 * 
		 */
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
			addEventListener("load", onClickLoad);
		}
		
		/**
		 * 
		 * @param event 터치이벤트
		 * 스테이지 업 버튼을 클릭했을때, 현재 스테이지 번호를 올려주는 콜백 메소드
		 */
		private function onClickStageUp(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_stageUpButton, TouchPhase.ENDED);
			if(touch)
			{
				_stageNum++;
				_stageTextField.text = "STAGE : " + _stageNum.toString();
			}			
		}
		
		/**
		 *  
		 * @param event 터치이벤트
		 * 스테이지 다운 버튼을 클릭했을때, 현재 스테이지 번호를 내려주는 콜백 메소드
		 */
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
		
		/**
		 * 
		 * @param event 
		 * 오브젝트를 클릭했을때, Objects 클래스로부터 디스패치 받는 콟백 메소드.
		 * 선택된 오브젝트를 맵에 뿌려준다.
		 */
		private function onClickObject(event:Event):void
		{
			switch(event.data)
			{
				case -1:
					var texture:Texture = Texture.fromEmbeddedAsset(Assets.Home);			
					changeObject(texture, 228, 64, 64, 1, true);
					break;
				case 0:
					changeObject(null, 228, 64, 64, 1, false);
					break;
				case 1:
					texture = Texture.fromEmbeddedAsset(Assets.CraterEllipse);	
					changeObject(texture, 228, 64, 64, 1, true);
					break;
				case 2:
					texture = Texture.fromEmbeddedAsset(Assets.CraterEllipse);	
					changeObject(texture, 146, 64, 64, 1, true);
					break;
				case 3:
					texture = Texture.fromEmbeddedAsset(Assets.CraterEllipse);	
					changeObject(texture, 310, 64, 64, 1, true);
					break;
				case 4:
					texture = Texture.fromEmbeddedAsset(Assets.DoubleCraterEllipse);	
					changeObject(texture, 228, 256, 64, 1, true);
					break;
				case 5:
					texture = Texture.fromEmbeddedAsset(Assets.CraterRect);	
					changeObject(texture, 180, 64, 64, 1, true);
					break;
				case 6:
					texture = Texture.fromEmbeddedAsset(Assets.CraterRect);	
					changeObject(texture, 276, 64, 64, 1, true);
					break;
				case 7:
					texture = Texture.fromEmbeddedAsset(Assets.Flag);	
					changeObject(texture, 180, 64, 64, 1, true);
					break;
				case 8:
					texture = Texture.fromEmbeddedAsset(Assets.Flag);	
					changeObject(texture, 276, 64, 64, 1, true);
					break;	
				case 9:
					texture = Texture.fromEmbeddedAsset(Assets.Coke);	
					changeObject(texture, 228, 32, 32, 1, true);
					break;	
				case 10:
					texture = Texture.fromEmbeddedAsset(Assets.Coke);	
					changeObject(texture, 146, 32, 32, 1, true);
					break;	
				case 11:
					texture = Texture.fromEmbeddedAsset(Assets.Coke);	
					changeObject(texture, 310, 32, 32, 1, true);
					break;					
				
			}	
			_objectDataVector[_currentObject] = event.data;
			printData();
		}
		
		/**
		 *  
		 * @param event 터치이벤트
		 * 커브를 클릭했을때, 선택된 값으로 데이터를 바꿔주는 메소드
		 */
		private function onClickCurve(event:Event):void
		{
			_curveDataVector[_currentPage] = event.data;
			changeCurve(int(event.data));
		}
		
		/**
		 * 
		 * @param event 터치이벤트
		 * 배경색을 클릭했을때, 내부에 값을 저장하고 화면에 선택된 배경색을 보여주는 콜백 메소드 
		 */
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
		
		/**
		 * 
		 * @param texture 텍스쳐
		 * @param x 좌표
		 * @param width 가로 길이
		 * @param height 세로 길이
		 * @param alpha 투명도
		 * @param visible 활성화
		 * 현재의 오브젝트를 선택된 오브젝트로 바꿔주는 메소드
		 */
		private function changeObject(texture:Texture, x:int, width:int, height:int, alpha:Number, visible:Boolean):void
		{
			_objectVector[_currentObject].texture = texture;
			_objectVector[_currentObject].x = x;
			_objectVector[_currentObject].width = width;
			_objectVector[_currentObject].height = height;
			_objectVector[_currentObject].alpha = alpha;
			_objectVector[_currentObject].visible = visible;			
		}
		
		/**
		 * 
		 * @param event 터치이벤트
		 * 맵을 클릭했을때, 현재 선택된 영역의 투명도를 1로 하고 나머지를 0.5로 해주는 메소드
		 */
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
		
		/**
		 * 
		 * @param event 터치이벤트
		 * 애드 버튼을 눌렀을때, 새로운 맵을 추가해주는 메소드
		 */
		private function onClickAdd(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_addButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("addButton");
				addMap();
				_currentPage = _mapVector.length - 1;
				_page.text = _currentPage.toString();
				
				viewCurrentMap();	
			}
		}
		
		/**
		 * 
		 * @param event 터치이벤트
		 * 딜리트 버튼을 눌렀을때, 현재 보여지는 맵과 그 안의 데이터들을 삭제하는 콜백 메소드
		 */
		private function onClickDelete(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_deleteButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("deleteButton");
				//trace("currentPage = " + _currentPage);
			
				if(_mapVector.length <= 1)
					return;
				
								
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
		
		/**
		 * 
		 * @param event 터치이벤트
		 * 이전 버튼을 눌렀을때, 이전 페이지를 보여주도록 하는 콜백 메소드
		 */
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
		
		/**
		 * 
		 * @param event 터치이벤트
		 * 넥스트 버튼을 눌렀을때, 다음 페이지를 보여주도록 하는 콜백 메소드
		 */
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
		
		/**
		 * 현재 페이지의 맵만 보여주고 나머지 맵들의 활성화를 끄는 메소드 
		 * 
		 */
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
		
		/**
		 * 오브젝트를 클릭할때마다 호출되는 메소드. 
		 * objectDataVector 의 내용을 trace함.
		 */
		private function printData():void
		{
			for(var i:int = 0; i < _objectDataVector.length; ++i)
			{
				trace(i + " " + _objectDataVector[i]);
			}
		}
		
		/**
		 * 
		 * @param direction 방향 (-1 = 직선, 0 = 왼쪽, 1 = 오른쪽)
		 * 현재 보여지는 맵의 커브 이미지를 바꿔주는 메소드 
		 */
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
		}
		
		/**
		 *  
		 * @param event event.data 안에 JSON 파일의 내용이 Object 형태로 담겨있음
		 * 로드 버튼을 클릭했을때 Load 클래스로부터 디스패치 받는 메소드
		 */
		private function onClickLoad(event:Event):void
		{
			release();
			
			_stageNum = event.data.stage;
			_stageTextField.text = "STAGE : " + _stageNum.toString();
			buildColor(event.data.backgroundColor);
			
			buildMap(event.data);
			
			viewCurrentMap();
			
//			for(var i:int = 0; i < _curveDataVector.length; ++i)
//			{
//				trace(_curveDataVector[i]);
//			}
			
		}
		
		/**
		 * 
		 * @param object 이미지
		 * @param texture 텍스쳐
		 * @param x 좌표
		 * @param width 가로 길이
		 * @param height 세로 길이
		 * @param alpha 투명도
		 * @param visible 활성화
		 * 
		 */
		private function initObject(object:Image, texture:Texture, x:int, width:int, height:int, alpha:Number, visible:Boolean):void
		{
			object.texture = texture;
			object.x = x;
			object.width = width;
			object.height = height;
			object.alpha = alpha;
			object.visible = visible;
		}
		
		/**
		 * 
		 * @param object 이미지
		 * @param value 오브젝트
		 * 오브젝트 번호에 해당되는 오브젝트들을 시각화하여 맵에 보여주는 메소드
		 */
		private function buildObject(object:Image, value:int):void
		{
			var texture:Texture;
			
			switch(value)
			{
				case -1:
					texture = Texture.fromEmbeddedAsset(Assets.Home);			
					initObject(object, texture, 228, 64, 64, 0.5, true);
					break;
				case 0:
					initObject(object, null, 228, 64, 64, 0.5, false);
					break;
				case 1:
					texture = Texture.fromEmbeddedAsset(Assets.CraterEllipse);	
					initObject(object, texture, 228, 64, 64, 0.5, true);
					break;
				case 2:
					texture = Texture.fromEmbeddedAsset(Assets.CraterEllipse);	
					initObject(object, texture, 146, 64, 64, 0.5, true);
					break;
				case 3:
					texture = Texture.fromEmbeddedAsset(Assets.CraterEllipse);	
					initObject(object, texture, 310, 64, 64, 0.5, true);
					break;
				case 4:
					texture = Texture.fromEmbeddedAsset(Assets.DoubleCraterEllipse);	
					initObject(object, texture, 228, 256, 64, 0.5, true);
					break;
				case 5:
					texture = Texture.fromEmbeddedAsset(Assets.CraterRect);	
					initObject(object, texture, 180, 64, 64, 0.5, true);
					break;
				case 6:
					texture = Texture.fromEmbeddedAsset(Assets.CraterRect);	
					initObject(object, texture, 276, 64, 64, 0.5, true);
					break;
				case 7:
					texture = Texture.fromEmbeddedAsset(Assets.Flag);	
					initObject(object, texture, 180, 64, 64, 0.5, true);
					break;
				case 8:
					texture = Texture.fromEmbeddedAsset(Assets.Flag);	
					initObject(object, texture, 276, 64, 64, 0.5, true);
					break;	
				case 9:
					texture = Texture.fromEmbeddedAsset(Assets.Coke);	
					initObject(object, texture, 228, 32, 32, 0.5, true);
					break;	
				case 10:
					texture = Texture.fromEmbeddedAsset(Assets.Coke);	
					initObject(object, texture, 146, 32, 32, 0.5, true);
					break;	
				case 11:
					texture = Texture.fromEmbeddedAsset(Assets.Coke);	
					initObject(object, texture, 310, 32, 32, 0.5, true);
					break;			
			}
			
			object.texture = texture;
		}
		
		/**
		 * 새로운 스테이지(JSON)을 로딩할 시 기존의 데이터들을 모두 지워주는 메소드  
		 * 
		 */
		private function release():void
		{
			
			for(var i:int = 0; i < _objectBGVector.length; ++i)
			{
				_objectBGVector[i].dispose();
				_objectBGVector[i] = null;
				_objectVector[i].dispose();
				_objectVector[i] = null;
			}
			
			for(i = 0; i < _mapVector.length; ++i)
			{
				_mapVector[i].removeEventListener(TouchEvent.TOUCH, onClickMap);
				_mapVector[i].dispose();				
				_mapVector[i].removeChildren();		
				_mapVector[i] = null;
				
				_curveVector[i].removeFromParent();
				_curveVector[i].dispose();
				_curveVector[i] = null;
			}
			
			_curveVector.splice(0, _curveVector.length);			
			_curveDataVector.splice(0, _curveDataVector.length);
			
			_mapVector.splice(0, _mapVector.length);
			
			_objectDataVector.splice(0, _objectDataVector.length);
			
			_objectBGVector.splice(0, _objectBGVector.length);
			_objectVector.splice(0, _objectVector.length);
		}
		
		/**
		 *  
		 * @param data JSON파일의 데이터
		 * JSON 로딩이 완료된 후, 데이터들을 시각화하여 맵에 뿌려주는 메소드
		 */
		private function buildMap(data:Object):void
		{
			var texture:Texture = Texture.fromEmbeddedAsset(Assets.ObjectBG);
			
			for(var i:int = 0; i < data.curve.length; ++i)
			{
				_curveDataVector.push(data.curve[i]);
				buildCurveVector(data.curve[i]);
			}
			
			for(i = 0; i < data.object.length; ++i)
			{
				_objectDataVector.push(data.object[i]);
				
				if(i % 10 == 0)
				{
					trace("맵벡터 푸쉬");
					_map = new Sprite();
					_stageSprite.addChild(_map);
					_mapVector.push(_map);
					_map.addEventListener(TouchEvent.TOUCH, onClickMap);
				}
				
				var objectBG:Image = new Image(texture);
				objectBG.alignPivot("center", "center");
				objectBG.x = 228;
				objectBG.y = (-i % 10) * 50 + 532; 
				objectBG.alpha = 0.5;
				_objectBGVector.push(objectBG);
				
				var object:Image = new Image(null);
				buildObject(object, data.object[i]);
				object.alignPivot("center", "center");
				object.touchable = false;
				object.y = (-i % 10) * 50 + 532; 
				
				_objectVector.push(object);
				
				_mapVector[int(i / 10)].addChild(objectBG);
				_mapVector[int(i / 10)].addChild(object);
				
				_currentPage = int(i / 10);
				_page.text = _currentPage.toString();
			}
		}
		
		/**
		 * 
		 * @param direction 방향 (-1 = 직선, 0 = 왼쪽, 1 = 오른쪽)
		 * JSON 로딩이 완료된 후, 내부에 값을 저장하고 화면에 커브 이미지를 보여주는 메소드
		 */
		private function buildCurveVector(direction:int):void
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
			var image:Image = new Image(texture);	
			image.width = 64;
			image.height = 64;
			_curveVector.push(image);	
			_stageSprite.addChild(image);			
		}
		
		/**
		 * 
		 * @param value 로딩된 데이터의 배경색 값
		 * JSON 로딩이 완료된 후, 내부에 값을 저장하고 화면에 나타나는 현재 배경색 이미지를 바꿔주는 메소드 
		 */
		private function buildColor(value:int):void
		{
			_color = value;
			
			var texture:Texture;
			
			if(value == 0)
			{
				texture = Texture.fromEmbeddedAsset(Assets.CyanBG);				
			}
			else
			{
				texture = Texture.fromEmbeddedAsset(Assets.OrangeBG);	
			}
			_colorImage.texture = texture;
		}
	}
}