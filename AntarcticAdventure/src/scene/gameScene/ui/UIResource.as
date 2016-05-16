package scene.gameScene.ui
{
	import flash.filesystem.File;

	public final class UIResource
	{
		public static const DIRECTORY:String = File.applicationDirectory.resolvePath("resources/ui/ingameUi").url;
		
		public static const INGAME_TEXT:String = "ingameText";
		public static const HEART:String = "heart";
		public static const SLASH:String = "slash";
		public static const SETTING_ICON:String = "setting";
		public static const STAGE:String = "stage";
		public static const BACKGROUND:String = "background";
		public static const SETTING_POPUP:String = "popupSetting";
		public static const CHECK:String = "check";
		public static const SCREEN_WHITE:String = "screenWhite";
		public static const SCREEN_ORANGE:String = "screenOrange";
		public static const BUTTON_WHITE:String = "buttonWhite";
		public static const BUTTON_ORANGE:String = "buttonOrange";
		public static const CLEARED_POPUP:String = "popupCleared";
		public static const FAILED_POPUP:String = "popupFailed";
		public static const REPLAY:String = "replay";
		public static const MENU:String = "menu";
		public static const NEXT:String = "next";
		public static const STAR:String = "star";
		public static const FILLED_STAR:String = "starFilled";
	}
}