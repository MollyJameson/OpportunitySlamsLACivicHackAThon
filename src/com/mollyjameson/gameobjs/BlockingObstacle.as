package com.mollyjameson.gameobjs
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
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
		
		public function SetLabel(str:String):void
		{
			var tf:TextField = new TextField();
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 24;
			myFormat.color = 0xFFFFFF;
			tf.defaultTextFormat = myFormat;
			tf.text = str;
			
			//tf.filters = [new GlowFilter(0xFFFFFF)];
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.CENTER;
			this.addChild(tf);
			
			tf.x = this.width/2 - tf.width/2;
			tf.y = this.height/2;
		}
	}
}