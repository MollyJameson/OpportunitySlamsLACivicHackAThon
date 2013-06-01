package com.mollyjameson.utils 
{
	 import flash.display.Sprite;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import flash.text.TextFormat;
	import fl.controls.Button;
 
    public class MsgBox extends Sprite 
	{
    
        private var m_Callback:Function;
		
		// just using a callback to not have to clean up.
		public function init( box_parent:Sprite, tag:String, onClosedCallback:Function ):void
		{
		  var btn:Button = new Button();
		  if( onClosedCallback != null )
		  {
		  	this.addChild(btn);
		  }
		  this.inst_text.htmlText = tag;
		  this.inst_text.selectable = false;
		  this.inst_text.mouseEnabled = false;
		  
		  var tf_format:TextFormat = new TextFormat();
			tf_format.size = 16;
			btn.setStyle("textFormat",tf_format);
			btn.label = Loc.GetText("generic_okay");
			
			var btn_width:Number = 150;
			var btn_height:Number = 60;
			btn.setSize(150, btn_height);
			btn.move(-btn_width/2, this.height/2 - btn_height*1.25);
			
			m_Callback = onClosedCallback;
			if( m_Callback != null )
			{
				btn.addEventListener(MouseEvent.CLICK, onBtnClicked);
		}
			
			
		}
		
		public function onBtnClicked(ev:MouseEvent):void
		{
			this.parent.removeChild(this);
			if( m_Callback != null )
			{
				m_Callback();
			}
		}
		public function UpdateText(new_text:String):void
		{
			 this.inst_text.htmlText = new_text;
		}
		public function ForceClose():void
		{
			this.parent.removeChild(this);
		}
     }
}