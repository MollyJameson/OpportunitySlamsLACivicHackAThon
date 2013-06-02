package com.mollyjameson.gameobjs
{
	// Powerups of different types
	public class PowerUp extends BaseWorldObj 
	{
		public static const MONEY:int = 0;
		public static const EMOTIONAL_SUPPORT:int = 1;
		public static const HSDIPLOMA:int = 2;
		public static const COLLEGE_DIPLOMA:int = 3;
		
		public static const JOB_CASHIER:int = 4;
		public static const JOB_COMPUTER:int = 5;
		public static const JOB_DOCTOR:int = 6;
		
		private var m_PowerUpType:int;
		
		private var m_MoneyReq:int;
		private var m_HSReq:Boolean;
		private var m_CollegeReq:Boolean;
		private var m_MoneyReward:int;
		
		public function PowerUp(powerup_type:int):void
		{
			m_PowerUpType = powerup_type;
			
			this.gotoAndStop( m_PowerUpType + 1 );
			
			m_HSReq = false;
			m_CollegeReq = false;
			m_MoneyReq = 0;
			m_MoneyReward = 0;
		}
		
		public function GetPowerUpType():int
		{
			return m_PowerUpType;
		}
		
		public function SetMoneyAmount(val:int):void
		{
			m_MoneyReward = val;
		}
		public function GetMoneyAmount():int
		{
			return m_MoneyReward;
		}
		
		// screw it, just switching to hardcoding for time reasons.
		
		public function GetMoneyRequirement():int
		{
			return m_MoneyReq;
		}
		public function SetMoneyRequirement(val:int):void
		{
			m_MoneyReq = val;
		}
		public function SetHSDiplomaRequirement(val:Boolean):void
		{
			m_HSReq = val;
		}
		public function GetHSDiplomaRequirement():Boolean
		{
			return m_HSReq;
		}
		public function SetCollegeDiplomaRequirement(val:Boolean):void
		{
			m_CollegeReq = val;
		}
		public function GetCollegeDiplomaRequirement():Boolean
		{
			return m_CollegeReq;
		}
	}
}