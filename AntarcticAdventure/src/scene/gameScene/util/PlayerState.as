package scene.gameScene.util
{
	public final class PlayerState	{
		
		/** 달리기 */
		public static const RUN:String = "run"; 
		
		/** 점프 */
		public static const JUMP:String = "jump";		
		
		/** 왼쪽 부딪힘 */
		public static const CRASHED_LEFT:String = "crashed_left"; 		
		
		/** 오른쪽 부딪힘 */
		public static const CRASHED_RIGHT:String = "crashed_right"; 		
		
		/** 빠짐 */
		public static const FALL:String = "fall"; 
		
		/** 허우적 */
		public static const STRUGGLE:String = "struggle";
		
		/** 대쉬*/		
		public static const DASH:String = "dash";	
		
		/** 죽음*/		
		public static const DEAD:String = "dead";	
		
		/** 도착 */
		public static const ARRIVE:String = "arrive";
		
		/** 도착 후*/		
		public static const ARRIVED:String = "arrived";
	}
}