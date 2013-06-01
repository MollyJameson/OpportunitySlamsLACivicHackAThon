package com.mollyjameson.gamestates 
{
	import flash.display.Sprite;
	import fl.controls.Button;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Molly Jameson
	 */
	public class BaseGameState extends Sprite
	{
		public var NextState:String;
		// so http://allgamesallfree.com/games16521-ceo-for-a-bubble.html
		// has this crazy thing where it's turning the stage black?
		public function BaseGameState() 
		{
			/*this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, Main.W, Main.H);
			this.graphics.endFill();*/
		}
		// the stage is inited but this sprite won't be.
		public function Init():void
		{
		
		}
		public function Enter():void
		{
			NextState = "none";
			Main.Inst.AttachGameState(this);
			
		}
		public function Update():void
		{
		}
		public function Exit():void
		{
			Main.Inst.RemoveGameState(this);
		}
		
		public function addBtn( xPos:int, yPos:int, tag:String, fnc:Function = null ):Button
		{
			var btn:Button = new Button();
			
			var tf_format:TextFormat = new TextFormat();
			tf_format.size = 16;
			btn.setStyle("textFormat",tf_format);
			btn.label = tag;
			//buttonLeft.labelPlacement = ButtonLabelPlacement.LEFT;
			//buttonLeft.setStyle("icon", AdobeLogo);
			
			btn.setSize(150, 60);
			btn.move(xPos, yPos);
			this.addChild(btn);
			
			if( fnc != null )
			{
				btn.addEventListener(MouseEvent.CLICK, fnc,false,0,true);
			}
			return btn;
		}
		
	}

}