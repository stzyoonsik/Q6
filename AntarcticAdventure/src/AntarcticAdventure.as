package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import scene.stageSelectScene.StageSelectScene;
	import scene.titleScene.TitleScene;
	
	import trolling.core.SceneManager;
	import trolling.core.Trolling;
	
	[SWF(frameRate = "24", width="960", height="540")]
	public class AntarcticAdventure extends Sprite
	{
		public function AntarcticAdventure()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Trolling.multitouchEnabled = true;
			var trolling:Trolling = new Trolling(stage, new Rectangle(0, 0, 960, 540));
			trolling.statsVisible = true;
			SceneManager.addScene(TitleScene, "Title");
			SceneManager.addScene(StageSelectScene, "stageSelect");
			
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
			
			trolling.start();
		}
		
		private function onExit(event:Event):void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, onExit);
			
			SceneManager.dispose();
		}
	}
}