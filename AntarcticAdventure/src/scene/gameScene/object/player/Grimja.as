package scene.gameScene.object.player
{
	import loading.Resources;
	
	import scene.gameScene.MainStage;
	import scene.gameScene.ObjectTag;
	import scene.gameScene.object.Objects;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.utils.PivotType;

	public class Grimja extends Objects
	{
		private var _resource:Resources;
		
		public function Grimja(resource:Resources)
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			_resource = resource;
			
			_image = new Image(_resource.getSubTexture("MainStageSprite0.png", "shadow0"));			
			addComponent(_image);
			
			pivot = PivotType.CENTER;
			
			width = _stageWidth / 5;
			height = width	
			y = _stageHeight * 0.08;
			
			_collider = new Collider();
			_collider.setRect(0.33, 0.0625);
			_collider.addIgnoreTag(ObjectTag.ITEM);
			
			addComponent(_collider);
			//colliderRender = true;
			addEventListener(TrollingEvent.COLLIDE, onCollide);
		}
		
		/**
		 * 
		 * @param event
		 * 그림자의 콜라이더에 다른 콜라이더가 충돌했을때 그 콜라이더에 대한 정보를 바탕으로 어느 오브젝트와 충돌했는지를 검사하는 메소드
		 */
		private function onCollide(event:TrollingEvent):void
		{
			dispatchEvent(new TrollingEvent("collideGrimja", event.data));			
		}
	}
}