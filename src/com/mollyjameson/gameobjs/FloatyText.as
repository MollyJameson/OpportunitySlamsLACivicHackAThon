package com.mollyjameson.gameobjs
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import caurina.transitions.Tweener;
	import flash.text.TextFieldAutoSize;
	
	// Good old floaty text
	public class FloatyText extends Sprite 
	{
		
		public function FloatyText():void
		{
		}
		
		public function Init(txt:String,color:uint,end_x:int, end_y:int,add_glow:Boolean = true):void
		{
			var tf:TextField = new TextField();
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 24;
			myFormat.color = color;
			tf.defaultTextFormat = myFormat;
			tf.text = txt;
			this.addChild(tf);
			tf.filters = [new GlowFilter(0xFFFFFF)];
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			// float up
			Tweener.addTween(this, { time:1.2,scaleX:1.2,scaleY:1.2,y:(y-20)} );
			// lerp to final goal and remove self
			Tweener.addTween(this, { delay:1.3,time:1,x:end_x,y:end_y,onComplete:onCakeAndFireworksEnd} );
		}
		
		public function onCakeAndFireworksEnd():void
		{
			// remove self
			if( this.parent)
			{
				this.parent.removeChild(this);
			}
		}

	}
}