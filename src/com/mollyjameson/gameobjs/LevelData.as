package com.mollyjameson.gameobjs
{
	// just holds data per level
	public class LevelData
	{
		public var m_ArrPowerUps:Vector.<PowerUp>;
		public var m_ArrObstacles:Vector.<BlockingObstacle>;
		
		public var m_MoneyDrip:Number;
		public var m_HSGoalComplete:Number;
		public var m_CollegeGoalComplete:Number;
		
		public var m_FurthestX:int;
		
		public function LevelData():void
		{
			m_ArrPowerUps = new Vector.<PowerUp>();
			m_ArrObstacles = new Vector.<BlockingObstacle>();
			m_MoneyDrip = 0;
			m_FurthestX = 0;
			m_HSGoalComplete = 0;
			m_CollegeGoalComplete = 0;
		}
		
		private function UpdateLevelInfo(xpos:int):void
		{
			if( xpos > m_FurthestX )
			{
				m_FurthestX = xpos;
				trace("Furthest X is " + m_FurthestX);
			}
		}
		
		public function AddPickUp(pickup:XML):void
		{
			trace("what the hell: " + pickup);
			trace("Pickup type: " + pickup.PickUpType );
			var pickup_obj:PowerUp = null;
			
			// just being really explicit with this so I can control whats changing.
			// obviously there are less terrible ways of doing this
			var frame_mapping:Object = 
			{
				"money": PowerUp.MONEY,
				"HSDiploma": PowerUp.HSDIPLOMA,
				"CollegeDiploma": PowerUp.COLLEGE_DIPLOMA,
				"JobCashier": PowerUp.JOB_CASHIER,
				"JobComputer": PowerUp.JOB_COMPUTER,
				"JobDoctor": PowerUp.JOB_DOCTOR
			};
			
			trace(frame_mapping["money"] + " should exist");
			trace(frame_mapping[pickup.PickUpType] + " label of " + pickup.PickUpType);
			
			if( frame_mapping[pickup.PickUpType] != null )
			{
				var power_up_id:int = frame_mapping[pickup.PickUpType];
				pickup_obj = new PowerUp(power_up_id);
				
				if( pickup.amount )
				{
					trace("pickup amount" + pickup.amount);
					pickup_obj.SetMoneyAmount(pickup.amount);
				}
			}
			else
			{
				trace("no powerup of ID found " + pickup.PickUpType);
			}
			if( pickup_obj )
			{
				var requires_list:XMLList = pickup.requires;
				for each (var requirement:XML in requires_list) 
				{
					trace("requirement " + requirement);
					if( requirement.@stat == "money" )
					{
						trace("money stat" + requirement.requires);
						pickup_obj.SetMoneyRequirement(int(requirement));
					}
					if( requirement.@stat == "goal" )
					{
						if( requirement == "HSDiploma")
						{
							pickup_obj.SetHSDiplomaRequirement(true);
						}
						else if( requirement == "CollegeDiploma")
						{
							pickup_obj.SetCollegeDiplomaRequirement(true);
						}
					}
				}
				m_ArrPowerUps.push(pickup_obj);
				pickup_obj.x = pickup.x; pickup_obj.y = pickup.y;
				UpdateLevelInfo(pickup_obj.x);
			}
		}
		
		public function AddObstacle(obstacle:XML):void
		{
			trace("ObstacleType type: " +obstacle.ObstacleType );
			if(obstacle.ObstacleType == "Impossible")
			{
				var impossible_test:BlockingObstacle = new BlockingObstacle( obstacle.w,obstacle.h );
				m_ArrObstacles.push( impossible_test );
				impossible_test.x = obstacle.x; impossible_test.y = obstacle.y;
				// String num confusion in ECMA script :(
				UpdateLevelInfo(int(impossible_test.x) + int(obstacle.w));
				
				if(obstacle.label )
				{
					impossible_test.SetLabel(obstacle.label);
				}
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