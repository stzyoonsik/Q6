package gameScene.object.enemy  
{
	import flash.display.Bitmap;
	
	import gameScene.MainStage;
	import gameScene.ObjectTag;
	import gameScene.object.Objects;
	
	import trolling.component.graphic.Image;
	import trolling.component.physics.Collider;
	import trolling.event.TrollingEvent;
	import trolling.rendering.Texture;
	import trolling.utils.PivotType;

	public class Enemy extends Objects
	{
		[Embed(source="enemy0.png")]
		public static const enemy0:Class; 
		[Embed(source="enemy1.png")]
		public static const enemy1:Class; 
		[Embed(source="enemy2.png")]
		public static const enemy2:Class; 
		
		private var _imageIndex:int;		
		
		public function Enemy()
		{
			this.tag = ObjectTag.ENEMY;
			
			_stageWidth = MainStage.stageWidth; 
			_stageHeight = MainStage.stageHeight;
					
			_bitmap = new enemy0() as Bitmap;
			_image = new Image(new Texture(_bitmap));
			addComponent(_image);
			
			this.pivot = PivotType.CENTER;			
			
			this.x = 0;
			this.y = -this.height * 0.03;
			
			
			this.width = _stageWidth / 30;
			this.height = this.width;			
			
			
			_collider = new Collider();
			_collider.setRect(0.4, 0.4);
			//colliderRender = true;
			addComponent(_collider);
			
			
			addEventListener(TrollingEvent.ENTER_FRAME, onEnterFrame);
			
		}
		
		private function onEnterFrame(event:TrollingEvent):void
		{
			if(this.parent.y < _stageHeight * 0.6)
			{
				if(_imageIndex == 0)
				{
					_imageIndex++;
				}
			}
			else if(this.parent.y < _stageHeight * 0.7)
			{				
				if(_imageIndex == 1)
				{
					_bitmap = new enemy1() as Bitmap;
					_image.texture = new Texture(_bitmap);
					_imageIndex++;
				}			
			}			
			else
			{
				if(_imageIndex == 2)
				{
					_bitmap = new enemy2() as Bitmap;
					_image.texture = new Texture(_bitmap);
					_imageIndex++;
				}				
			}
			
		}
	}
}