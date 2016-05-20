package scene.gameScene.background
{
	import flash.events.Event;
	
	import loading.Resources;
	
	import scene.gameScene.MainStage;
	
	import trolling.component.graphic.Image;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.utils.PivotType;

	public class Snow extends GameObject
	{
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _reachedGround:Boolean;
		
		private var _size:int;
		
		private var _firstX:Number;
		private var _limitX:int;
		
		/**	0 = 왼쪽, 1 = 오른쪽  */
		private var _direction:int;
		
		private var _curve:int = -1;
		
		public function Snow(resource:Resources)
		{
			_stageWidth = MainStage.stageWidth;
			_stageHeight = MainStage.stageHeight;
			
			pivot = PivotType.CENTER;
			
			var image:Image = new Image(resource.getSubTexture("MainStageSprite0.png", "snow0"));	
			addComponent(image);
			
			init();			
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			addEventListener("changeCurve", onChangeCurve);
		}
		
		
		private function onEnterFrame(event:TrollingEvent):void
		{				
			if(this.y < 0 || this.y > _stageHeight ||
				this.x < 0 || this.x > _stageWidth)
				this.visible = false;
			else
				this.visible = true;
			
			falling();
			checkGround();			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		private function onChangeCurve(event:TrollingEvent):void
		{
			("커브 디스패치");
			_curve = int(event.data);
		}
		
		/**
		 * 눈의 초기 좌표를 랜덤하게 생성해주는 메소드 
		 * 
		 * 
		 */
		private function init():void
		{
			initPos();
			initDirection();		
			setSize();
		}
		
		/**
		 * 눈의 처음 좌표값을 랜덤하게 정하는 메소드
		 * 
		 */
		private function initPos():void
		{
			var randomNum:Number = Math.random();
			if(randomNum < 0.33)
			{
				randomNum = Math.random();
				this.x = randomNum * -_stageWidth;
			}
			else if(randomNum < 0.66)
			{
				randomNum = Math.random();
				this.x = randomNum * _stageWidth;
			}
			else
			{
				randomNum = Math.random();
				this.x = (randomNum * _stageWidth) + _stageWidth;
			}
			
			_firstX = this.x;
			
			randomNum = Math.random();
			this.y = -randomNum * _stageHeight;
			
			randomNum = Math.random();
			_limitX = int(_stageWidth * 0.05 * randomNum);
		}
		
		/**
		 * 눈의 처음 좌우 방향을 랜덤하게 정하는 메소드 
		 * 
		 */
		private function initDirection():void
		{
			var randomNum:Number = Math.random();	
			if(randomNum < 0.5)
				_direction = 0;
			else
				_direction = 1;
		}
		
		/**
		 * 랜덤하게 정해진 사이즈값에 따라 이미지의 크기를 바꿔주는 메소드
		 * @param randomNum 0~1 사이의 랜덤값
		 * 
		 */
		private function setSize():void
		{
			var randomNum:Number = Math.random();
			
			if(randomNum < 0.2)
				_size = 1;
			else if(randomNum < 0.4)
				_size = 2;
			else if(randomNum < 0.6)
				_size = 3;
			else if(randomNum < 0.8)
				_size = 4;
			else
				_size = 5;					
			
			this.width = (_size + 5) * _stageWidth * 0.001;
			this.height = this.width;
		}
		
		/**
		 * 눈이 내리는 모습을 연출하는 메소드 
		 * 
		 */
		private function falling():void
		{
			switch(_size)
			{
				case 1:
					this.y += _stageHeight * 0.0025;
					break;
				case 2:
					this.y += _stageHeight * 0.005;
					break;
				case 3:
					this.y += _stageHeight * 0.0075;
					break;
				case 4:
					this.y += _stageHeight * 0.01;
					break;
				case 5:
					this.y += _stageHeight * 0.0125;
					break;
				default:
					this.y += _stageHeight * 0.015;
					break;
			}
			
			
			if(_direction == 0)
			{
				this.x -= _stageWidth * 0.001;
				if(Math.abs(this.x - _firstX) >  _limitX)
				{
					_direction = 1;
				}
			}
			else
			{
				this.x += _stageWidth * 0.001;
				if(Math.abs(this.x - _firstX) >  _limitX)
				{
					_direction = 0;
				}
			}
			
			if(_curve == 0)
			{
				this.x += MainStage.speed * 0.6;
				_firstX += MainStage.speed * 0.6;
				_limitX += MainStage.speed * 0.6;
			}
			else if(_curve == 1)
			{
				this.x -= MainStage.speed * 0.6;
				_firstX -= MainStage.speed * 0.6;
				_limitX -= MainStage.speed * 0.6;
			}
		}
		
		/**
		 * 눈의 사이즈별로 땅에 닿았는지를 검사하는 메소드 
		 * 
		 */
		private function checkGround():void
		{
			switch(_size)
			{
				case 1:
					if(this.y > _stageHeight * 0.6){ _reachedGround = true; }		break;
				case 2:
					if(this.y > _stageHeight * 0.7){ _reachedGround = true; }		break;
				case 3:
					if(this.y > _stageHeight * 0.8){ _reachedGround = true;	}		break;
				case 4:
					if(this.y > _stageHeight * 0.9){ _reachedGround = true;	}		break;
				case 5:
					if(this.y > _stageHeight){ _reachedGround = true; }				break;
				default:
					if(this.y > _stageHeight){ _reachedGround = true; }				break;
			}
			
			if(_reachedGround)
			{
				init();
				_reachedGround = false;
			}
		}
	}
}