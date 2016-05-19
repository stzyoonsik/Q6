package scene.gameScene.object.player
{	
	import loading.Resources;
	
	import scene.gameScene.MainStage;
	import scene.gameScene.ObjectTag;
	import scene.gameScene.object.Objects;
	import scene.gameScene.util.PlayerState;
	
	import trolling.component.animation.Animator;
	import trolling.component.animation.State;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.utils.PivotType;

	public class Penguin extends Objects
	{
		private var _resource:Resources;
		
		
		public function Penguin(resource:Resources)
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			_resource = resource;
			
			
			pivot = PivotType.CENTER;
			
			width = _stageWidth / 5;
			height = width;
			
			_collider = new Collider();
			_collider.setRect(0.3, 0.3);
			_collider.addIgnoreTag(ObjectTag.ENEMY);
			
			//_penguin.colliderRender = true;
			addComponent(_collider);
			addEventListener(TrollingEvent.COLLIDE, onCollide);			
			
			
			initAnimator();
			addComponent(_animator);
		}
		
		/**
		 * 애니메이터를 초기 세팅하는 메소드 
		 * 
		 */
		private function initAnimator():void
		{
			_animator = new Animator(); 
			
			var state:State = new State(PlayerState.RUN);
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinRun0"));
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinRun1"));
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinRun2"));
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinRun3"));
			_animator.addState(state);
			state.interval = 3;
			
			state = new State(PlayerState.JUMP);
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinJump0"));
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinJump1"));
			_animator.addState(state);			
			state.interval = 2;
			
			state = new State(PlayerState.CRASHED_LEFT);
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinCrashedLeft0"));	
			state.interval = 60;
			_animator.addState(state);	
			
			state = new State(PlayerState.CRASHED_RIGHT);
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinCrashedRight0"));	
			state.interval = 60;
			_animator.addState(state);		
			
			state = new State(PlayerState.FALL);
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinFall0"));	
			state.interval = 60;
			_animator.addState(state);
			
			state = new State(PlayerState.STRUGGLE);
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinStruggle0"));
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinStruggle1"));
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinStruggle2"));
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinStruggle3"));
			state.interval = 4;
			_animator.addState(state);
			
			state = new State(PlayerState.ARRIVED);
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinArrived0"));
			state.addFrame(_resource.getSubTexture("MainStageSprite0.png", "penguinArrived1"));
			state.interval = 5;
			_animator.addState(state);
			
			state.play();
		}
		
		/**
		 * 
		 * @param event
		 * 펭귄의 콜라이더에 다른 콜라이더가 충돌했을때 그 콜라이더에 대한 정보를 바탕으로 어느 오브젝트와 충돌했는지를 검사하는 메소드
		 */
		private function onCollide(event:TrollingEvent):void
		{
			dispatchEvent(new TrollingEvent("collidePenguin", event.data));			
		}
	}
}