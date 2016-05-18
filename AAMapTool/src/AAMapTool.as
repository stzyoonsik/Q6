package 
{
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	[SWF(width = "1024", height = "800", backgroundColor = "0xaaaaaa")]	
	public class AAMapTool extends Sprite
	{
		public function AAMapTool()
		{
			var starling:Starling = new Starling(Main, stage);
			starling.start();
		}
	}
} 