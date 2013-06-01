package com.mollyjameson.gameobjs
{
	// Powerups of different types
	public class PowerUp extends BaseWorldObj 
	{
		public static const MONEY:int = 0;
		public static const EMOTIONAL_SUPPORT:int = 1;
		
		private var m_PowerUpType:int;
		public function PowerUp(powerup_type:int):void
		{
			m_PowerUpType = powerup_type;
			
			this.gotoAndStop( m_PowerUpType + 1 );
		}
		
		public function GetPowerUpType():int
		{
			return m_PowerUpType;
		}
	}
}