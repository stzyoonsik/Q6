package scene.loading
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import trolling.rendering.Texture;
	
	public class SpriteSheet
	{
		private var _name:String;
		private var _spriteBitmap:Bitmap;
		private var _atlasTexture:Texture;
		
		private var _subTextures:Dictionary;
		private var _images:Vector.<ImageInfo>;
		
		/**
		 *SpriteSheet는 생성될 때 이름과 비트맵, xml파일을 받아옵니다. 
		 * @param name
		 * @param spriteBitmap
		 * @param xml
		 * 
		 */		
		public function SpriteSheet(name:String, spriteBitmap:Bitmap, xml:XML)
		{
			_name = name;
			_spriteBitmap = spriteBitmap;
			_atlasTexture = new Texture(spriteBitmap);
			readXML(xml);
			loadSubTexture();
		}
		
		public function get subTextures():Dictionary
		{
			return _subTextures;
		}
		
		public function get images():Vector.<ImageInfo>
		{
			return _images;
		}
		
		public function get spriteBitmap():Bitmap
		{
			return _spriteBitmap;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		/**
		 *SpriteSheet의 xml로 생성된 ImageInfo들로 SubTexture를 생성합니다. 
		 * 
		 */		
		private function loadSubTexture():void
		{
			_subTextures = new Dictionary();
			for(var i:int = 0; i < _images.length; i++)
			{
				var region:Rectangle = new Rectangle(_images[i].x, _images[i].y, _images[i].width, _images[i].height);
				var subTexture:Texture = new Texture()
				subTexture.setFromTexture(_atlasTexture, region);
				_subTextures[_images[i].name] = subTexture;
			}
		}
		
		/**
		 *xml파일을 한줄씩 읽어서 ImageInfo를 생성합니다
		 * @param xml
		 * 
		 */		
		private function readXML(xml:XML):void
		{
			_images = new Vector.<ImageInfo>();
			
			for(var i:int = 0; i < xml.child("SubTexture").length(); i++)
			{
				var imageInfo:ImageInfo = new ImageInfo();
				imageInfo.name = xml.child("SubTexture")[i].attribute("name");
				imageInfo.x = xml.child("SubTexture")[i].attribute("x");
				imageInfo.y = xml.child("SubTexture")[i].attribute("y");
				imageInfo.width = xml.child("SubTexture")[i].attribute("width");
				imageInfo.height = xml.child("SubTexture")[i].attribute("height");
				trace("imageInfo.name = " + imageInfo.name + " imageInfo.x = " + imageInfo.x + " imageInfo.y = " + imageInfo.y + " imageinfo.width = " + imageInfo.width + " imageinfo.height = " + imageInfo.height);
				_images.push(imageInfo);
			}
		}
	}
}