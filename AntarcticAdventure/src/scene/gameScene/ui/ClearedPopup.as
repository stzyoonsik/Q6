package scene.gameScene.ui
{
	import flash.utils.Dictionary;
	
	import scene.gameScene.MainStage;
	
	import trolling.component.graphic.Image;
	import trolling.core.SceneManager;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	
	import ui.Popup;
	import ui.button.Button;

	public class ClearedPopup extends Popup
	{
		private const REPLAY:int = 0;
		private const MENU:int = 1;
		private const NEXT:int = 2;
		
		public function ClearedPopup(canvas:Texture)
		{
			super(canvas);
		}
		
		public override function dispose():void
		{
			var child:GameObject = getChild(REPLAY);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedReplay);
			
			child = getChild(MENU);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedMenu);
			
			child = getChild(NEXT);
			if (child) child.removeEventListener(TrollingEvent.TOUCH_ENDED, onEndedNext);
			
			super.dispose();
		}
		
		public function initialize(bitmaps:Dictionary):void
		{
			var stageButtonX:Number = this.width / 8;
			// REPLAY
			var replay:Button = new Button(new Texture(bitmaps[UIResource.REPLAY]));
			replay.x = -stageButtonX;
			replay.y = this.height / 3.5;
			replay.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedReplay);
			//
			
			var margin:Number = 3;
			// MENU
			var menu:Button = new Button(new Texture(bitmaps[UIResource.MENU]));
			menu.y = replay.y + margin;
			menu.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedMenu);
			//
			
			// NEXT
			var next:Button = new Button(new Texture(bitmaps[UIResource.NEXT]));
			next.x = stageButtonX;
			next.y = replay.y + margin;
			next.addEventListener(TrollingEvent.TOUCH_ENDED, onEndedNext);
			
			delete bitmaps[UIResource.NEXT];
			//
			
			addChild(replay);
			addChild(menu);
			addChild(next);
		}
		
		public function setResult(totalFlag:int, obtainedFlag:int, textures:Dictionary):void
		{
			var ratio:Number = obtainedFlag / totalFlag * 100; 
			var numStar:int = 1;
			if (ratio <= 50)		numStar = 1;
			else if (ratio <= 80)	numStar = 2;
			else					numStar = 3;
			
			var child:GameObject;
			var childX:Number = -(this.width / 4.19);
			var scale:Number = 0.8;
			var margin:Number = 30;
			
			// star
			for (var i:int = 0; i < 3; i++)
			{
				child = new GameObject;
				if (i < numStar)
				{
					child.addComponent(new Image(textures[UIResource.FILLED_STAR]));
				}
				else
				{
					child.addComponent(new Image(textures[UIResource.STAR]));
				}
				child.x = childX + child.width * i - margin * i;
				child.y = -(this.height / 6.4);
				child.width *= scale;
				child.height *= scale;
				addChild(child);
			}
			
			// flag
			var strTotalFlag:String = totalFlag.toString();
			var strObtainedFlag:String = obtainedFlag.toString();
			var totalFlagIndex:int = strTotalFlag.length - 1;
			var obtainedFlagIndex:int = strObtainedFlag.length - 1;
			childX = -8;
			scale = 0.5;
			margin = 5;
			
			for (i = strTotalFlag.length * 2; i >= 0; i--)
			{
				child = new GameObject();
				if (i < strTotalFlag.length)
				{
					if (obtainedFlagIndex >= 0)
					{
						child.addComponent(new Image(textures[strObtainedFlag.charAt(obtainedFlagIndex)]));
						obtainedFlagIndex--;	
					}
					else
					{
						child.addComponent(new Image(textures["0"]));
					}
				}
				else if (i > strTotalFlag.length)
				{
					child.addComponent(new Image(textures[strTotalFlag.charAt(totalFlagIndex)]));
					totalFlagIndex--;
				}
				else
				{
					child.addComponent(new Image(textures[UIResource.SLASH]));
				}
				child.width *= scale;
				child.height *= scale;  
				child.x = childX + child.width * i + margin * i;
				child.y = this.height / 10.5;
				addChild(child);
			}
		}
		
		private function onEndedReplay(event:TrollingEvent):void
		{
			SceneManager.restartScene(MainStage, "Game", MainStage.currentStage);
		}
		
		private function onEndedMenu(event:TrollingEvent):void
		{
			SceneManager.outScene(MainStage.currentStage);
		}
		
		private function onEndedNext(event:TrollingEvent):void
		{
			SceneManager.restartScene(MainStage, "Game", MainStage.currentStage + 1); // need to check if this stage is the last stage
		}
	}
}