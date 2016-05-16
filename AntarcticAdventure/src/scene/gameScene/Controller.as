package scene.gameScene
{
	import scene.loading.Resource;
	
	import trolling.object.GameObject;
	import trolling.utils.PivotType;
	
	import ui.button.Button;

	public class Controller extends GameObject
	{
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _left:Button;
		private var _right:Button;
		private var _jump:Button;
		
		public function Controller()
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
		
			_left = new Button(Resource.spriteSheet.subTextures["left"]);
			_left.pivot = PivotType.CENTER;
			_left.x = _stageWidth * 0.1;
			_left.y = _stageHeight * 0.8;
			_left.width = _stageWidth * 0.1;
			_left.height = _left.width;
			
			
			
			_right = new Button(Resource.spriteSheet.subTextures["right"]);		
			_right.pivot = PivotType.CENTER;
			_right.x = _stageWidth * 0.3;
			_right.y = _stageHeight * 0.8;
			_right.width = _stageWidth * 0.1;
			_right.height = _right.width;			
			
			
				
			_jump = new Button(Resource.spriteSheet.subTextures["jump"]);
			_jump.pivot = PivotType.CENTER;
			_jump.x = _stageWidth * 0.85;
			_jump.y = _stageHeight * 0.8;
			_jump.width = _stageWidth * 0.1;
			_jump.height = _jump.width;
			
			
			
			addChild(_left);
			addChild(_right);
			addChild(_jump);
		}
	}
}