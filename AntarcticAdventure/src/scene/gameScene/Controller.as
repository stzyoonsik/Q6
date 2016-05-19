package scene.gameScene
{
	import loading.Resources;
	
	import trolling.event.TrollingEvent;
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
		
		public function Controller(resource:Resources)
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			this.alpha = 0.5;
			
		
			_left = new Button(resource.getSubTexture("MainStageSprite0.png", "left"));
			_left.pivot = PivotType.CENTER;
			_left.x = _stageWidth * 0.1;
			_left.y = _stageHeight * 0.8;
			_left.width = _stageWidth * 0.1;
			_left.height = _left.width;			
			_left.addEventListener(TrollingEvent.TOUCH_HOVER, onTouchLeft);
			
			_right = new Button(resource.getSubTexture("MainStageSprite0.png", "right"));
			_right.pivot = PivotType.CENTER;
			_right.x = _stageWidth * 0.25;
			_right.y = _stageHeight * 0.8;
			_right.width = _stageWidth * 0.1;
			_right.height = _right.width;	
			_right.addEventListener(TrollingEvent.TOUCH_HOVER, onTouchRight);
			
			
				
			_jump = new Button(resource.getSubTexture("MainStageSprite0.png", "jump"));
			_jump.pivot = PivotType.CENTER;
			_jump.x = _stageWidth * 0.9;
			_jump.y = _stageHeight * 0.8;
			_jump.width = _stageWidth * 0.1;
			_jump.height = _jump.width;
			_jump.addEventListener(TrollingEvent.TOUCH_BEGAN, onTouchJump);
			
			addChild(_left);
			addChild(_right);
			addChild(_jump);
		}
		
		private function onTouchLeft(event:TrollingEvent):void
		{
			trace("왼쪽");
			dispatchEvent(new TrollingEvent("move", 0));
		}
		
		private function onTouchRight(event:TrollingEvent):void
		{
			trace("오른쪽");
			dispatchEvent(new TrollingEvent("move", 1));
		}
		
		private function onTouchJump(event:TrollingEvent):void
		{
			trace("점프");
			dispatchEvent(new TrollingEvent("jump"));
		}
		
		
	}
}