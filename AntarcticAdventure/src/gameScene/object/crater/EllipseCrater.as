package gameScene.object.crater
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import gameScene.MainStage;
	import gameScene.object.enemy.Enemy;
	import gameScene.object.enemy.initRandom;
	import gameScene.object.item.Fish;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	public class EllipseCrater extends GameObject
	{
		[Embed(source="crater_ellipse_0.png")]
		public static const crater:Class;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _direction:int;
		private var _collider:Collider;
		
		private var _isObjectCreate:Boolean;
		
		/**
		 * 
		 * @param stageWidth
		 * @param stageHeight
		 * @param direction -1 = normal, 0 = left, 1 = right
		 * 
		 */
		public function EllipseCrater(stageWidth:int, stageHeight:int, direction:int)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			var bitmap:Bitmap = new crater() as Bitmap;
			var image:Image = new Image(new Texture(bitmap));		
			
			pivot = PivotType.CENTER;
			addComponent(image);
			
			_direction = direction;
			
			x = _stageWidth / 2;
			y = _stageHeight * 0.4;
			
			//this.width = _stageWidth / 200 + (y / 10) ;
			width = _stageWidth / 20;
			height = width;
			
			_collider = new Collider();
//			var rect:Rectangle = new Rectangle();
//			rect.width = width * 0.75;
//			rect.height = height / 8;
//			rect.x = (width / 2) - (rect.width / 2);
//			rect.y = (height / 2) - (rect.y / 2);
			
			_collider.setRect(0.75, 0.125);
			//colliderRender = true;
			addComponent(_collider);
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			
			scaleY = (y - (_stageHeight / 3)) / 100;
			scaleX = scaleY;
		}
		
		public function get position():int
		{
			return _direction;
		}

		public function set position(value:int):void
		{
			_direction = value;
		}

		private function onEnterFrame(event:TrollingEvent):void
		{			
			if(y > _stageHeight)
			{
				
				dispose();
				removeFromParent();
				removeEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
				
			}
			
			//width = (y) - (_stageWidth / 4);
			//height = width;
			scaleY = (y - (_stageHeight / 3)) / 100;
			scaleX = scaleY;
			y += MainStage.speed;
			
			switch(_direction)
			{
				//가운데
				case -1:
					
					break;
				//왼쪽
				case 0:
					x -= MainStage.speed;
					break;
				//오른쪽
				case 1:
					x += MainStage.speed;
					break;
				default:
					break;
			}
			
			if(y > _stageHeight / 2)
			{
				if(!_isObjectCreate)
				{
					switch(initRandom())
					{
						//타원 크레이터만 생성
						case 0:
//							trace("물개 생성");
//							var enemy:Enemy = new Enemy(_stageWidth, _stageHeight);
//							addChild(enemy);
							switch(_direction)
							{
								case -1:
									trace("생선 랜덤 생성");
									var fish:Fish = new Fish(_stageWidth, _stageHeight, makeRandomForFish());
									addChild(fish);
									break;
								case 0:
									trace("생선 오른쪽 생성");
									fish = new Fish(_stageWidth, _stageHeight, 1);		
									addChild(fish);
									break;
								case 1:
									trace("생선 왼쪽 생성");
									fish = new Fish(_stageWidth, _stageHeight, 0);
									addChild(fish);
									break;
								default:
									break;
							}
							
							break;
						//물개 생성
						case 1:
							switch(_direction)
							{
								case -1:
									trace("생선 랜덤 생성");
									var fish:Fish = new Fish(_stageWidth, _stageHeight, makeRandomForFish());
									addChild(fish);
									break;
								case 0:
									trace("생선 오른쪽 생성");
									fish = new Fish(_stageWidth, _stageHeight, 1);		
									addChild(fish);
									break;
								case 1:
									trace("생선 왼쪽 생성");
									fish = new Fish(_stageWidth, _stageHeight, 0);
									addChild(fish);
									break;
								default:
									break;
							}
							break;
						//생선 생성
						case 2:
							switch(_direction)
							{
								case -1:
									trace("생선 랜덤 생성");
									var fish:Fish = new Fish(_stageWidth, _stageHeight, makeRandomForFish());
									addChild(fish);
									break;
								case 0:
									trace("생선 오른쪽 생성");
									fish = new Fish(_stageWidth, _stageHeight, 1);		
									addChild(fish);
									break;
								case 1:
									trace("생선 왼쪽 생성");
									fish = new Fish(_stageWidth, _stageHeight, 0);
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