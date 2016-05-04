package gameScene.util
{
	public final class PlayerState
	{
		
		/** 달리기 */
		public static const RUN:String = "run"; 
		
		/** 점프 */
		public static const JUMP:String = "jump";
		
		/** 점프 중*/
		public static const JUMPING:String = "jumping";
		
		/** 왼쪽 부딪힘 */
		public static const CRASHED_LEFT:String = "crashed_left"; 
		
		/** 왼쪽 튕김 */
		public static const CRASHING_LEFT:String = "crashing_left"; 
		
		/** 오른쪽 부딪힘 */
		public static const CRASHED_RIGHT:String = "crashed_right"; 
		
		/** 오른쪽 튕김 */
		public static const CRASHING_RIGHT:String = "crashing_right"; 
		
		/** 빠짐 */
		public static const FALL:String = "fall"; 
		
		/** 허우적 */
		public static const STRUGGLE:String = "struggle";
		
		/** 도착 */
		public static const ARRIVED:String = "arrived";
		
		/** 프로펠러 달리기 */
		public static const RUN_PROPELLER:String = "run_propeller"; 
		
		/** 프로펠러 점프 */
		public static const JUMP_PROPELLER:String = "jump_propeller"; 
	}
}