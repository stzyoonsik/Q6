package gameScene.object.crater
{
	import flash.display.Bitmap;
	
	import gameScene.MainStage;
	import gameScene.ObjectTag;
	import gameScene.object.Objects;
	import gameScene.object.enemy.Enemy;
	import gameScene.object.item.Fish;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	public class EllipseCrater extends Objects
	{
		[Embed(source="ellipseCrater0.png")]
		public static const crater:Class;
		
		
		private var _isObjectCreate:Boolean;
		
		/**
		 * 
		 * @param stageWidth
		 * @param stageHeight
		 * @param direction -1 = normal, 0 = left, 1 = right
		 * 
		 */
		public function EllipseCrater(direction:int)
		{
			this.tag = ObjectTag.ENEMY;
			 
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			var bitmap:Bitmap = new crater() as Bitmap;
			var image:Image = new Image(new Texture(bitmap));		
			
			this.pivot = PivotType.CENTER;
			addComponent(image);
			
			_direction = direction;
			
			if(_direction == 0)
				this.x = _stageWidth * 0.475;
			else if(_direction == -1)
				this.x = _stageWidth * 0.5;
			else
				this.x = _stageWidth * 0.525
			this.y = _stageHeight * 0.4;
			
			this.width = _stageWidth * 0.05;
			this.height = this.width;
			
			_collider = new Collider();			
			_collider.setRect(0.75, 0.125);
			//colliderRender = true;
			addComponent(_collider);
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			
//			this.scaleY = 0.5
//			this.scaleX = scaleY;
		}		
	

		private function onEnterFrame(event:TrollingEvent):void
		{			
			if(this.y > _stageHeight)
			{				
				dispose();
				removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
				
			}
			
			this.scaleY += 0.02 * MainStage.speed;
			this.scaleX = this.scaleY;
			this.y += MainStage.speed;
			
			switch(_direction)
			{
				//가운데
				case -1:					
					break;
				//왼쪽
				case 0:
					this.x -= MainStage.speed;
					break;
				//오른쪽
				case 1:
					this.x += MainStage.speed;
					break;
				default:
					break;
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
							var enemy:Enemy = new Enemy();
							addChild(enemy);
							break;
						//생선 생성
						case 2:
							switch(_direction)
							{
								case -1:
									trace("생선 랜덤 생성");
									var fish:Fish = new Fish(makeRandomForFish());
									addChild(fish);
									break;
								case 0:
									trace("생선 오른쪽 생성");
									fish = new Fish(1);		
									addChild(fish);
									break;
								case 1:
									trace("생선 왼쪽 생성");
									fish = new Fish(0);
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