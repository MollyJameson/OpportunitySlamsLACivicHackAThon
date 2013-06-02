package com.mollyjameson.gameobjs
{
	import flash.display.Sprite;
	
	// Our hero
	public class Player extends BaseWorldObj 
	{
		public static const RES_MONEY:String = "money";
		public static const RES_EMO:String = "emo";
		public static const RES_HEALTH:String = "health";
		// in a real game this would be read in from a data file
		private var m_Resources:Object;
		private var m_MaxResources:Object;
		
		public var m_MoneyCap:int;
		
		public function Player():void
		{
			Reset();
		}
		
		public function Reset():void
		{
			m_MaxResources = new Object();
			m_Resources = new Object();
			
			// R
			m_MaxResources[RES_HEALTH] = 100;
			m_Resources[RES_HEALTH] = m_MaxResources[RES_HEALTH];
			
			// G
			m_MaxResources[RES_MONEY] = 100;
			m_Resources[RES_MONEY] = m_MaxResources[RES_MONEY];
			
			// B
			m_MaxResources[RES_EMO] = 100;
			m_Resources[RES_EMO] = m_MaxResources[RES_EMO];
			
			x = 20;
			y = Main.H/2;
			
			m_MoneyCap = 100;
		}
		
		public function GetResource(res_name:String):Number
		{
			return m_Resources[res_name];
		}
		public function GetMaxResource(res_name:String):Number
		{
			return m_MaxResources[res_name];
		}
		
		public function ModifyResource(res_name:String, mod_amount:Number):Number
		{
			m_Resources[res_name] += mod_amount;
			
			// money has a cap that changes per level
			if( res_name == RES_MONEY )
			{
				m_Resources[res_name] = m_Resources[res_name] > m_MoneyCap ? m_MoneyCap : m_Resources[res_name];
			}
			
			return m_Resources[res_name];
		}
	}
}