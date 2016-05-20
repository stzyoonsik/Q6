package loading
{
	import trolling.component.graphic.Image;
	import trolling.object.GameObject;
	import trolling.object.Scene;
	import trolling.rendering.Texture;

	public class Loading extends GameObject
	{
		private static var sCurrent:Loading;
		
		private var _barGauge:LoadingBar;
		
		public function Loading(texture:Texture)
		{
			sCurrent = this;
			
			var image:Image = new Image(texture);
			addComponent(image);
		}
		
		public function setLoading(loadScene:Scene, total:Number):void
		{
			this.width = loadScene.width;
			this.height = loadScene.height;
			
			_barGauge = new LoadingBar(this.width / 2, 30);
			_barGauge.total = total;
			_barGauge.x = 250;
			_barGauge.y = this.height - 60;
			addChild(_barGauge);
			loadScene.addChild(this);
		}
		
		public function setCurrent(current:Number):void
		{
			if(_barGauge == null)
				return;
			_barGauge.update(current);
		}
		
		public function loadComplete():void
		{
			_barGauge.dispose();
			this.removeFromParent();
		}
		
		public static function createLoadImage(texture:Texture):void
		{
			var loadImage:Loading = new Loading(texture);
		}

		public static function get current():Loading
		{
			return sCurrent;
		}
	}
}