package Select.Background
{	
	import Asset.Assets;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class Background extends Sprite
	{
		
		
		private var _leftCurveButton:Button;
		private var _normalCurveButton:Button;
		private var _rightCurveButton:Button;
		
		private var _cyanBG:Button;
		private var _orangeBG:Button;
		
		public function Background()
		{	
			init();
			pushEvent();
		}
		
		private function init():void
		{
			var texture:Texture = Texture.fromEmbeddedAsset(Assets.LeftCurve);
			_leftCurveButton = new Button(texture);
			_leftCurveButton.width = 128;
			_leftCurveButton.height = 128;			
			addChild(_leftCurveButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.NormalCurve);
			_normalCurveButton = new Button(texture);
			_normalCurveButton.x = 128;
			_normalCurveButton.width = 128;
			_normalCurveButton.height = 128;			
			addChild(_normalCurveButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.RightCurve);
			_rightCurveButton = new Button(texture);
			_rightCurveButton.x = 256;
			_rightCurveButton.width = 128;
			_rightCurveButton.height = 128;			
			addChild(_rightCurveButton);
			
			texture = Texture.fromEmbeddedAsset(Assets.CyanBG);
			_cyanBG = new Button(texture);
			_cyanBG.x = 96;
			_cyanBG.y = 128;
			_cyanBG.width = 64;
			_cyanBG.height = 64;			
			addChild(_cyanBG);
			
			texture = Texture.fromEmbeddedAsset(Assets.OrangeBG);
			_orangeBG = new Button(texture);
			_orangeBG.x = 224;
			_orangeBG.y = 128;
			_orangeBG.width = 64;
			_orangeBG.height = 64;			
			addChild(_orangeBG);
			
			
			
		}
		
		private function pushEvent():void
		{
			_leftCurveButton.addEventListener(TouchEvent.TOUCH, onClickLeftCurve);
			_normalCurveButton.addEventListener(TouchEvent.TOUCH, onClickNormalCurve);
			_rightCurveButton.addEventListener(TouchEvent.TOUCH, onClickRightCurve);
			_cyanBG.addEventListener(TouchEvent.TOUCH, onClickCyanBG);
			_orangeBG.addEventListener(TouchEvent.TOUCH, onClickOrangeBG);
		}
		
		private function onClickLeftCurve(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_leftCurveButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("leftCurveButton");
			}	
		}
		
		private function onClickNormalCurve(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_normalCurveButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("normalCurveButton");
			}	
		}
		
		private function onClickRightCurve(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_rightCurveButton, TouchPhase.ENDED);
			if(touch)
			{
				trace("rightCurveButton");
			}	
		}
		
		private function onClickCyanBG(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_cyanBG, TouchPhase.ENDED);
			if(touch)
			{
				trace("cyanBG");
			}	
		}
		
		private function onClickOrangeBG(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_orangeBG, TouchPhase.ENDED);
			if(touch)
			{
				trace("orangeBG");
			}	
		}
	}
}