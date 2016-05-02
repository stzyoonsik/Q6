package object.player 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import object.crater.EllipseCrater;
	import object.crater.RectangleCrater;
	import object.enemy.Enemy;
	import object.item.Fish;
	import object.item.Flag;
	
	import trolling.component.animation.Animator;
	import trolling.component.animation.State;
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.object.GameObject;
	import trolling.utils.EventWith;
	import trolling.utils.PivotType;
	
	import util.PlayerState;

	public class Player extends GameObject
	{
		[Embed(source="penguinRun0.png")]
		public static const penguinRun0:Class;
		
		[Embed(source="penguinRun1.png")]
		public static const penguinRun1:Class;
		
		[Embed(source="penguinRun2.png")]
		public static const penguinRun2:Class;
		
		[Embed(source="penguinRun3.png")]
		public static const penguinRun3:Class;
		
		[Embed(source="penguinJump0.png")]
		public static const penguinJump0:Class;
		
		[Embed(source="penguinJump1.png")]
		public static const penguinJump1:Class;
		
		[Embed(source="shadow.png")]
		public static const shadow:Class;
		
		private var _penguin:GameObject = new GameObject();		
		private var _grimja:GameObject = new GameObject();
		
		private var _bitmap:Bitmap;
		private var _image:Image;
		private var _animator:Animator;
		private var _grimjaCollider:Collider;
		
		private var _state:String; 
		
		private var _jumpSpeed:int;
		private var _jumpHeight:int;
		private var _theta:Number = 0;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		public function get state():String{ return _state; }
		public function set state(value:String):void{ _state = value; }
		
		public function get grimja():GameObject{ return _grimja; }		
		public function set grimja(value:GameObject):void {	_grimja = value;}
		
		public function get penguin():GameObject{ return _penguin;}
		public function set penguin(value:GameObject):void{ _penguin = value;}
		
		public function Player(stageWidth:int, stageHeight:int)
		{
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			pivot = PivotType.CENTER;
			
			//x = stageWidth / 2;
			//y = stageHeight / 10 * 8;
			x = 0;
			y = 0;
			//this.width = stageWidth / 5;
			//this.height = this.width;
			
			_state = PlayerState.RUN;
			_jumpSpeed = 5;
			_jumpHeight = _stageHeight / 10;
			
			_bitmap = new shadow() as Bitmap;
			_image = new Image(_bitmap);			
			
			_grimja.width = _stageWidth / 5;
			_grimja.height = _grimja.width
			_grimja.x = _stageWidth / 2;		
			_grimja.y = _stageHeight / 10 * 9;
			//_grimja.y = y + stageHeight / 15;
			_grimja.addComponent(_image);	
			_grimja.pivot = PivotType.CENTER;
			
			_grimjaCollider = new Collider();
			var rect:Rectangle = new Rectangle();
			rect.width = _grimja.width / 3;
			rect.height = rect.width;
			
			_grimjaCollider.rect = rect;
			_grimja.addComponent(_grimjaCollider);
			
			_grimja.addEventListener(TrollingEvent.COLLIDE, onCollideWithGrimja);
			
			
			
			
			
			//_image = new Image(_bitmap);			
			
			_penguin.width = _stageWidth / 5;
			_penguin.height = _penguin.width;
			_penguin.x = _stageWidth / 2;		
			_penguin.y = _stageHeight / 10 * 8;
			//_penguin.x = (stageWidth / 2) - (_penguin.width / 2); 
			//_penguin.y = stageHeight / 10 * 8; 			
			//_penguin.addComponent(_image);
			
			_penguin.pivot = PivotType.CENTER;
			
			
			_animator = new Animator(); 
			var state:State = _animator.addState(PlayerState.RUN);
			//_bitmap.width = stageWidth / 5;
			//_bitmap.height = _bitmap.width;
			_bitmap = new penguinRun0() as Bitmap;
			state.addFrame(_bitmap);
			_bitmap = new penguinRun1() as Bitmap;
			state.addFrame(_bitmap);
			_bitmap = new penguinRun2() as Bitmap;
			state.addFrame(_bitmap);
			_bitmap = new penguinRun3() as Bitmap;
			state.addFrame(_bitmap);
			
			state = _animator.addState(PlayerState.JUMP);
			_bitmap = new penguinJump0() as Bitmap;
			state.addFrame(_bitmap);
			_bitmap = new penguinJump1() as Bitmap;
			state.addFrame(_bitmap);
			
			
			state.playSpeed = 3;
			state.play();
			
			
			
			
			_penguin.addComponent(_animator);
			_penguin.addEventListener(TrollingEvent.COLLIDE, onCollideWithPenguin);
			
			
			addChild(_grimja);
			addChild(_penguin);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);	
		} 
		
		

		private function onCollideWithGrimja(event:TrollingEvent):void
		{
			 
			//몬스터와 충돌
			//플레이어를 충돌 무시 상태로 만들고 n초(프레임)동안 부딪힘 상태로 변경
			//MainStage.speed 를 변경
			
			if(event.data is EllipseCrater)
			{
				trace("타원크레이터");
			}
			
			if(event.data is RectangleCrater)
			{
				trace("네모크레이터");
			}
			
			if(event.data is Enemy)
			{
				trace("몬스터");
			}
			
			
			
//			switch(event.data)
//			{
//				case EllipseCrater:
//					break;
//				case Enemy:
//					break;
//				default:
//					break;
//			}
		
		}
		
		private function onCollideWithPenguin(event:TrollingEvent):void
		{
			if(event.data is Fish)
			{
				trace("생선");
			}
			
			if(event.data is Flag)
			{
				trace("깃발");
			}
		}
		
		
		private function onEnterFrame(event:Event):void
		{
			_grimja.x = _penguin.x;
			
			collideWall();
			
			if(_state == PlayerState.JUMP)
			{				
				trace("점프 시작");
				_state = PlayerState.JUMPING;
				_grimjaCollider.isActive = false;
				transition(PlayerState.JUMP);
			}
			
			if(_state == PlayerState.JUMPING)
			{
				
				jump();
			}
		}
		
		private function collideWall():void
		{
			//왼쪽 벽에 부딪힘
			if(_penguin.x - _penguin.width / 2 < 0)
			{
				_penguin.x = _penguin.width / 2;
				
			}
			
			//오른쪽 벽에 부딪힘
			if(_penguin.x + _penguin.width / 2 > _stageWidth)
			{
				_penguin.x = _stageWidth - _penguin.width / 2;
			}
		}
		
		private function jump():void
		{
			
			//trace("점프중");	
			//_jumpFrame++;
			var degree:Number = _theta * Math.PI / 180;
			_penguin.y = (_stageHeight / 10 * 8) - (Math.sin(degree) * _jumpHeight);
			
			//trace(Math.sin(_theta * Math.PI / 180));
			_theta += _jumpSpeed;
			//trace("theta = " + _theta);
			//if(_penguin.y > _stageHeight / 10 * 8)
			if(_theta >= 180)
			{
				_penguin.y = _stageHeight / 10 * 8;
				_state = PlayerState.RUN;
				_grimjaCollider.isActive = true;
				_theta = 0;
				transition(PlayerState.RUN);
			}
		}

		

	}
}