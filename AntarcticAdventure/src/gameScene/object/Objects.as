package gameScene.object
{
	import flash.display.Bitmap;
	
	import trolling.component.animation.Animator;
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.object.GameObject;

	public class Objects extends GameObject
	{
		/**	게임 화면의 너비 */
		protected var _stageWidth:int;
		/**	게임 화면의 높이 */
		protected var _stageHeight:int;
		
		protected var _image:Image;
		protected var _bitmap:Bitmap;
		
		protected var _animator:Animator;
		
		protected var _collider:Collider;
		
		/**	방향 -1 = 정면, 0 = 왼쪽, 1 = 오른쪽 */
		protected var _direction:int;
		
		public function Objects()
		{
		}
		
		/**
		 * 
		 * 랜덤하게 색상을 초기화하는 메소드 
		 */
		protected function initRandomColor():void
		{
			var randomNum:int = int(Math.random() * 5);
			
			switch(randomNum)
			{
				//빨간색
				case 0:
					this.red = 1;
					this.blue = 0;
					this.green = 0;
					break;
				//파란색
				case 1:
					this.red = 0;
					this.blue = 1;
					this.green = 0;
					break;
				//초록색
				case 2:
					this.red = 0;
					this.blue = 0;
					this.green = 1;
					break;
				//분홍색
				case 3:
					this.red = 1;
					this.blue = 1;
					this.green = 0;
					break;
				//노란색
				case 4:
					this.red = 1;
					this.blue = 0;
					this.green = 1;
					break;
				//하늘색 (거의 안나옴)
				case 5:
					this.red = 0;
					this.blue = 1;
					this.green = 1;
					break;
				default:
					break;
			}
		}
	}
}