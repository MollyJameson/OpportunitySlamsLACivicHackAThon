package com.mollyjameson.gameobjs
{
	// just holds data per level
	public class LevelData
	{
		public var m_ArrPowerUps:Vector.<PowerUp>;
		public var m_ArrObstacles:Vector.<BlockingObstacle>;
		
		public function LevelData():void
		{
			m_ArrPowerUps = new Vector.<PowerUp>();
			m_ArrObstacles = new Vector.<BlockingObstacle>();
		}
		
		public function AddPickUp(pickup:XML):void
		{
			trace("Pickup type: " +pickup.PickUpType );
			if(pickup.PickUpType == "money")
			{
				var money_test:PowerUp = new PowerUp(PowerUp.MONEY);
				m_ArrPowerUps.push(money_test);
				money_test.x = pickup.x; money_test.y = pickup.y;
			}
			
		}
	}
}