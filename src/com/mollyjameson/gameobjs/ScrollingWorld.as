package com.mollyjameson.gameobjs
{
	import flash.display.Sprite;
	
	// In a real game this would be a tilemap... but i"m in a a hurry now
	// So it's a placeholder for a huge sprite
	public class ScrollingWorld extends Sprite 
	{
		private var m_WorldSpeed:Number = 2;
		public function Reset():void
		{
			x = 0; y = 0;
		}
		
		public function Tick(dt:Number = 1):void
		{
			// TODO: time base
			x -= m_WorldSpeed;
		}
	}
}