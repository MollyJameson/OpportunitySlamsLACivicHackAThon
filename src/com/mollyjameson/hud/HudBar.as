package com.mollyjameson.hud
{
	import flash.display.Sprite;
	
	// Our hero
	public class HudBar extends Sprite 
	{
		private const W:Number = 100;
		private const H:Number = 20;
		private var m_Color:uint;
		private var m_CurrValue:Number;
		private var m_CapValue:Number;
		private var m_MaxValue:Number;
		public function HudBar(color:uint,max_val:Number,cap_val:Number):void
		{
			m_Color = color;
			m_MaxValue = max_val;
			m_CapValue = cap_val;
			SetCurrValue(m_MaxValue);
		}
		
		public function SetCurrValue(curr_val:Number):void
		{
			m_CurrValue = curr_val;
			this.graphics.clear();
			this.graphics.beginFill(0);
			this.graphics.drawRect(0,0,W+3,H+3);
			this.graphics.endFill();
			
			var cap_width:Number = (W-3) * (m_CapValue/m_MaxValue);
			this.graphics.beginFill(0);
			this.graphics.drawRect(cap_width+3,0,W+3,H+3);
			this.graphics.endFill();
			
			this.graphics.beginFill(m_Color);
			var fill_width:Number = (W-3) * (m_CurrValue/m_MaxValue);
			
			this.graphics.drawRect(3,3,fill_width,H-3);
			this.graphics.endFill();
		}
		
		public function Reset():void
		{
			SetCurrValue(m_MaxValue);
		}
	}
}