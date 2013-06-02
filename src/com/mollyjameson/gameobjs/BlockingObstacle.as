package com.mollyjameson.gameobjs
{
	// Powerups of different types
	public class BlockingObstacle extends BaseWorldObj 
	{
		public function BlockingObstacle(set_w:Number,set_h:Number):void
		{
			// draw a box with a label
			this.graphics.clear();
			this.graphics.beginFill(0);
			this.graphics.drawRect(0,0,set_w,set_h);
			this.graphics.endFill();
		}
	}
}