package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import gameScene.MainStage;
	
	import stageSelectScene.StageSelectScene;
	
	import titleScene.TitleScene;
	
	import trolling.core.SceneManager;
	import trolling.core.Trolling;
	
	[SWF(frameRate = "24", width="800", height="600")]
	public class AntarcticAdventure extends Sprite
	{
		public function AntarcticAdventure()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Trolling.multitouchEnabled = true;
			var trolling:Trolling = new Trolling(stage, new Rectangle(0, 0, 800, 600));
			SceneManager.addScene(TitleScene, "Title");
			SceneManager.addScene(MainStage, "Game");
			SceneManager.addScene(StageSelectScene, "stageSelect");
			
			trolling.start();
		}
	}
}