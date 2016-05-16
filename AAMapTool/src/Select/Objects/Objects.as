package Select.Objects
{	
	import Asset.Assets;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.events.Event;

	public class Objects extends Sprite
	{
		
		
		private var _homeButton:Button;
		private var _emptyButton:Button;
		private var _ellipseImage:Image;
		private var _rectImage:Image;
		private var _flagImage:Image;
		
		private var _leftEllipseButton:Button;
		private var _centerEllipseButton:Button;
		private var _rightEllipseButton:Button;
		private var _leftRightEllipseButton:Button;
		
		private var _leftRectButton:Button;
		private var _rightRectButton:Button;
		
		private var _leftFlagButton:Button;
		private var _rightFlagButton:Button;
		
		
		public function Objects()
		{			
			init();
			pushEvent();
		}
		
		private function init():void
		{		
			var texture:Texture = Texture.fromEmbeddedAsset(Assets.Home);
			_homeButton = new Button(texture);
			_homeButton.x = 133;
			_homeButton.width = 64;
			_homeButton.height = 64;			
			addChild(_homeButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.Empty);
			_emptyButton = new Button(texture);
			_emptyButton.width = 64;
			_emptyButton.height = 64;
			_emptyButton.x = 133;
			_emptyButton.y = 64;
			addChild(_emptyButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.CraterEllipse);
			_ellipseImage = new Image(texture);	
			_ellipseImage.width = 64;
			_ellipseImage.height = 64;
			_ellipseImage.y = 128;
			addChild(_ellipseImage);
			
			
			texture = Texture.fromEmbeddedAsset(Assets.Left);
			_leftEllipseButton = new Button(texture);
			_leftEllipseButton.width = 32;
			_leftEllipseButton.height = 32;
			_leftEllipseButton.x = 100;
			_leftEllipseButton.y = 144;
			addChild(_leftEllipseButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.Center);
			_centerEllipseButton = new Button(texture);
			_centerEllipseButton.width = 32;
			_centerEllipseButton.height = 32;
			_centerEllipseButton.x = 150;
			_centerEllipseButton.y = 144;
			addChild(_centerEllipseButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.Right);
			_rightEllipseButton = new Button(texture);
			_rightEllipseButton.width = 32;
			_rightEllipseButton.height = 32;
			_rightEllipseButton.x = 200;
			_rightEllipseButton.y = 144;
			addChild(_rightEllipseButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.LeftRight);
			_leftRightEllipseButton = new Button(texture);
			_leftRightEllipseButton.width = 32;
			_leftRightEllipseButton.height = 32;
			_leftRightEllipseButton.x = 250;
			_leftRightEllipseButton.y = 144;
			addChild(_leftRightEllipseButton);
			
			
			texture = Texture.fromEmbeddedAsset(Assets.CraterRect);
			_rectImage = new Image(texture);	
			_rectImage.width = 64;
			_rectImage.height = 64;
			_rectImage.y = 208;
			addChild(_rectImage);
			
			texture = Texture.fromEmbeddedAsset(Assets.Left);
			_leftRectButton = new Button(texture);
			_leftRectButton.width = 32;
			_leftRectButton.height = 32;
			_leftRectButton.x = 100;
			_leftRectButton.y = 224;
			addChild(_leftRectButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.Right);
			_rightRectButton = new Button(texture);
			_rightRectButton.width = 32;
			_rightRectButton.height = 32;
			_rightRectButton.x = 200;
			_rightRectButton.y = 224;
			addChild(_rightRectButton)
			
			
			texture = Texture.fromEmbeddedAsset(Assets.Flag);
			_flagImage = new Image(texture);	
			_flagImage.width = 64;
			_flagImage.height = 64;
			_flagImage.y = 272;
			addChild(_flagImage);
			
			texture = Texture.fromEmbeddedAsset(Assets.Left);
			_leftFlagButton = new Button(texture);
			_leftFlagButton.width = 32;
			_leftFlagButton.height = 32;
			_leftFlagButton.x = 100;
			_leftFlagButton.y = 288;
			addChild(_leftFlagButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.Right);
			_rightFlagButton = new Button(texture);
			_rightFlagButton.width = 32;
			_rightFlagButton.height = 32;
			_rightFlagButton.x = 200;
			_rightFlagButton.y = 288;
			addChild(_rightFlagButton)
			
		}
		
		private function pushEvent():void
		{
			_homeButton.addEventListener(TouchEvent.TOUCH, onClickHome);
			_emptyButton.addEventListener(TouchEvent.TOUCH, onClickEmpty);
			_leftEllipseButton.addEventListener(TouchEvent.TOUCH, onClickLeftEllipse);
			_centerEllipseButton.addEventListener(TouchEvent.TOUCH, onClickCenterEllipse);
			_rightEllipseButton.addEventListener(TouchEvent.TOUCH, onClickRightEllipse);
			_leftRightEllipseButton.addEventListener(TouchEvent.TOUCH, onClickLeftRightEllipse);
			_leftRectButton.addEventListener(TouchEvent.TOUCH, onClickLeftRect);
			_rightRectButton.addEventListener(TouchEvent.TOUCH, onClickRightRect);
			_leftFlagButton.addEventListener(TouchEvent.TOUCH, onClickLeftFlag);
			_rightFlagButton.addEventListener(TouchEvent.TOUCH, onClickRightFlag);
		}
		
		private function onClickHome(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_homeButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("home");
				dispatchEvent(new Event("object", false, -1));
			}			
		}
		
		private function onClickEmpty(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_emptyButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("empty");
				dispatchEvent(new Event("object", false, 0));
			}			
		}
		
		private function onClickLeftEllipse(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_leftEllipseButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("leftEllipse");
				dispatchEvent(new Event("object", false, 2));
			}			
		}
		
		private function onClickCenterEllipse(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_centerEllipseButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("centerEllipse");
				dispatchEvent(new Event("object", false, 1));
			}			
		}
		
		private function onClickRightEllipse(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_rightEllipseButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("rightEllipse");
				dispatchEvent(new Event("object", false, 3));
			}			
		}
		
		private function onClickLeftRightEllipse(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_leftRightEllipseButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("leftRightEllipse");
				dispatchEvent(new Event("object", false, 4));
			}			
		}
		
		private function onClickLeftRect(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_leftRectButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("leftRectButton");
				dispatchEvent(new Event("object", false, 5));
			}	
		}
		
		private function onClickRightRect(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_rightRectButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("rightRectButton");
				dispatchEvent(new Event("object", false, 6));
			}	
		}
		
		private function onClickLeftFlag(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_leftFlagButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("leftFlagButton");
				dispatchEvent(new Event("object", false, 7));
			}	
		}
		
		private function onClickRightFlag(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_rightFlagButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("rightFlagButton");
				dispatchEvent(new Event("object", false, 8));
			}	
		}
	}
}