package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import trolling.core.SceneManager;
	import trolling.core.Trolling;
	
	public class AntarcticAdventure extends Sprite
	{
		public function AntarcticAdventure()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var trolling:Trolling = new Trolling(stage);
			SceneManager.addScene(MainStage, "Main");
			
			trolling.start();
		}
	}
}