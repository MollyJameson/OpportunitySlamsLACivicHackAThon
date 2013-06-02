package com.mollyjameson.gameobjs
{
	// just holds data per level
	public class LevelData
	{
		public var m_ArrPowerUps:Vector.<PowerUp>;
		public var m_ArrObstacles:Vector.<BlockingObstacle>;
		
		public var m_MoneyDrip:Number;
		
		public var m_FurthestX:int;
		
		public function LevelData():void
		{
			m_ArrPowerUps = new Vector.<PowerUp>();
			m_ArrObstacles = new Vector.<BlockingObstacle>();
			m_MoneyDrip = 0;
			m_FurthestX = 0;
		}
		
		private function UpdateLevelInfo(xpos:int):void
		{
			if( xpos > m_FurthestX )
			{
				m_FurthestX = xpos;
			}
		}
		
		public function AddPickUp(pickup:XML):void
		{
			trace("Pickup type: " +pickup.PickUpType );
			if(pickup.PickUpType == "money")
			{
				var money_test:PowerUp = new PowerUp(PowerUp.MONEY);
				m_ArrPowerUps.push(money_test);
				money_test.x = pickup.x; money_test.y = pickup.y;
				UpdateLevelInfo(money_test.x);
			}
		}
		
		public function AddObstacle(obstacle:XML):void
		{
			trace("Pickup type: " +obstacle.ObstacleType );
			if(obstacle.ObstacleType == "College")
			{
				var college_test:BlockingObstacle = new BlockingObstacle( obstacle.w,obstacle.h );
				m_ArrObstacles.push( college_test );
				college_test.x = obstacle.x; college_test.y = obstacle.y;
				UpdateLevelInfo(college_test.x + obstacle.w);
			}
			else if(obstacle.ObstacleType == "Impossible")
			{
				var impossible_test:BlockingObstacle = new BlockingObstacle( obstacle.w,obstacle.h );
				m_ArrObstacles.push( impossible_test );
				impossible_test.x = obstacle.x; impossible_test.y = obstacle.y;
				UpdateLevelInfo(impossible_test.x + obstacle.w)
			}
		}
		
		public function AddMoneyDripRate(moneydrip:Number):void
		{
			trace("moneydrip: " + moneydrip);
			if( moneydrip )
			{
				m_MoneyDrip = moneydrip;
			}
		}
	}
}