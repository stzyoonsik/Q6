package scene.gameScene.object.crater
{
	import scene.gameScene.MainStage;
	import scene.gameScene.ObjectTag;
	import scene.gameScene.object.Objects;
	import scene.gameScene.object.enemy.Enemy;
	import scene.gameScene.object.item.Fish;
	import loading.Resources;
	import loading.Resources;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;
	
	public class EllipseCrater extends Objects
	{		
		private var _isObjectCreate:Boolean;
		private var _resource:loading.Resources;
		
		public function EllipseCrater(resource:loading.Resources, direction:int)
		{
			this.tag = ObjectTag.ENEMY;
			
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			_resource = resource;
			
			var image:Image = new Image(_resource.getSubTexture("MainStageSprite0.png", "ellipseCrater0"));		
			
			this.pivot = PivotType.CENTER;
			addComponent(image);
			
			_direction = direction;
			initPosition();			
			
			this.width = _stageWidth * 0.025;
			this.height = this.width;
			
			_collider = new Collider();			
			_collider.setRect(0.75, 0.125);
			//colliderRender = true;
			addComponent(_collider);
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
		}		
		
		private function initPosition():void
		{
			if(_direction == 0)
				this.x = _stageWidth * 0.475;
				
			else if(_direction == -1)
				this.x = _stageWidth * 0.5;
				
			else
				this.x = _stageWidth * 0.525
			
			
			this.y = _stageHeight * 0.4;
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{			
			if(this.y > _stageHeight)
			{				
				dispose();
				removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
				
			}
			
			if(MainStage.speed != 0)
			{
				this.scaleY += setScale(0.03);
				this.scaleX = this.scaleY;
				
				this._addY += y / 2400;
				this.y += (MainStage.speed + this._addY);
				
				switch(_direction)
				{
					//가운데
					case -1:					
						break;
					//왼쪽
					case 0:
						this.x -= (MainStage.speed + this._addY);
						break;
					//오른쪽
					case 1:
						this.x += (MainStage.speed + this._addY);
						break;
					default:
						break;
				}
			}
			
			
			
			if(this.y > _stageHeight / 2)
			{
				if(!_isObjectCreate)
				{
					switch(initRandom())
					{
						//타원 크레이터만 생성
						case 0:
							break;
						//물개 생성
						case 1:
							trace("물개 생성");
							var enemy:Enemy = new Enemy(_resource);
							addChild(enemy);
							break;
						//생선 생성
						case 2:
							switch(_direction)
							{
								case -1:
									trace("생선 랜덤 생성");
									var fish:Fish = new Fish(_resource, makeRandomForFish());
									addChild(fish);
									break;
								case 0:
									trace("생선 오른쪽 생성");
									fish = new Fish(_resource, 1);		
									addChild(fish);
									break;
								case 1:
									trace("생선 왼쪽 생성");
									fish = new Fish(_resource, 0);
									addChild(fish);
									break;
								default:
									break;
							}
							break;
						
						default:
							break;
					}
					
					_isObjectCreate = true;
				}
			}
			
		}
		
		/**
		 * 0 또는 1 또는 2를 랜덤으로 리턴하는 메소드 
		 * @return 
		 * 
		 */
		private function initRandom():int
		{			
			var randomNum:Number = Math.random();
			
			if(randomNum < 0.33)
				return 0;
			else if(randomNum < 0.66)
				return 1;
			else
				return 2;			
		}
		
		/**
		 * 생선이 튀는 방향을 랜덤으로 하기위한 메소드 
		 * @return 
		 * 
		 */
		private function makeRandomForFish():int
		{
			var randomNum:Number = Math.random();
			
			if(randomNum < 0.5)
				return 0;
			else 
				return 1;
		}	
		
	}
}