package scene.gameScene.object.player
{
	import loading.Resources;
	
	import scene.gameScene.MainStage;
	import scene.gameScene.object.Objects;
	import scene.gameScene.util.PlayerState;
	
	import trolling.component.animation.Animator;
	import trolling.component.animation.State;
	import trolling.utils.PivotType;

	public class Struggle extends Objects
	{
		private var _resource:Resources;		
		
		public function Struggle(resource:Resources)
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			_resource = resource;
			
			
			pivot = PivotType.CENTER;
			
			width = _stageWidth / 20;
			height = width;
			
			initAnimator();
			addComponent(_animator);
		}
		
		private function initAnimator():void
		{
			_animator = new Animator(); 
			
			var state:State = new State("controllerStruggle");
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "controller0"));
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "controller1"));
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "controller2"));
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "controller3"));
			_animator.addState(state);
			state.interval = 2;			
			
			state.play();
		}
	}
}