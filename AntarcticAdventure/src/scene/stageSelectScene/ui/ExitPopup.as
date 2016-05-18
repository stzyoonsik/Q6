package scene.stageSelectScene.ui
{
	import flash.desktop.NativeApplication;
	
	import loading.Resources;
	
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.Color;
	import trolling.utils.PivotType;
	
	import ui.Popup;
	import ui.button.Button;

	public class ExitPopup extends GameObject
	{
		private var _yesButton:Button;
		private var _noButton:Button;
		private var _canvas:Texture;
		
		public function ExitPopup(canvas:Texture)
		{
			_canvas = canvas;
			this.pivot = PivotType.CENTER;
			this.visible = false;
		}
		
		public override function dispose():void
		{
//			var _child:GameObject = getChild
		}
		
		public function initialize(resources:Resources):void
		{
			var backGroundImage:Image = new Image(_canvas);
			var popupBackGround:GameObject = new GameObject();
			popupBackGround.addComponent(backGroundImage);
			popupBackGround.pivot = PivotType.CENTER;
			
			var exitImage:Image = new Image(resources.getSubTexture("ExitPopupSheet.png", "exit"));
			var exitText:GameObject = new GameObject();
			exitText.addComponent(exitImage);
			exitText.pivot = PivotType.CENTER;
			exitText.y = -75;
			exitText.blendColor(Color.getRed(Color.AQUA), Color.getGreen(Color.AQUA), Color.getBlue(Color.AQUA));
			exitText.visible = true;
			
			_yesButton = new Button(resources.getSubTexture("ExitPopupSheet.png", "yes"));
			_yesButton.x = -90;
			_yesButton.y = 70;
			_yesButton.addEventListener(TrollingEvent.TOUCH_BEGAN, onInButton);
			_yesButton.addEventListener(TrollingEvent.TOUCH_IN, onInButton);
			_yesButton.addEventListener(TrollingEvent.TOUCH_OUT, onOutButton);
			_yesButton.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedButton);
			
			_noButton = new Button(resources.getSubTexture("ExitPopupSheet.png", "no"));
			_noButton.x = 90;
			_noButton.y = 70;
			_noButton.addEventListener(TrollingEvent.TOUCH_BEGAN, onInButton);
			_noButton.addEventListener(TrollingEvent.TOUCH_IN, onInButton);
			_noButton.addEventListener(TrollingEvent.TOUCH_OUT, onOutButton);
			_noButton.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedButton);
			
			addChild(popupBackGround);
			popupBackGround.addChild(exitText);
			popupBackGround.addChild(_yesButton);
			popupBackGround.addChild(_noButton);
			
			this.addEventListener(TrollingEvent.TOUCH_ENDED, onTouchSide);
		}
		
		private function onInButton(event:TrollingEvent):void
		{
			event.currentTarget.blendColor(1, 0, 0);
		}
		
		private function onOutButton(event:TrollingEvent):void
		{
			event.currentTarget.blendColor(1, 1, 1);
		}
		
		private function onEndedButton(event:TrollingEvent):void
		{
			event.currentTarget.blendColor(1, 1, 1);
			if(event.currentTarget == _noButton)
				this.close();
			else
				NativeApplication.nativeApplication.exit();
		}
		
		private function onTouchSide(event:TrollingEvent):void
		{
			this.close();
		}
		
		public function show():void
		{
			this.visible = true;
		}
		
		public function close():void
		{
			this.visible = false;
		}
	}
}