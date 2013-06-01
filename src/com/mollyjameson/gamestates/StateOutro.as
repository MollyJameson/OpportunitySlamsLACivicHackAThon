package com.mollyjameson.gamestates 
{
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import flash.events.Event;
	
	import com.mollyjameson.utils.Misc;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.media.Sound;
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;

	/**
	 * ...
	 * @author Molly Jameson
	 */
	public class StateOutro extends BaseGameState 
	{
		private var m_TF:TextField;
		private var m_BtnTitle:Button;

		
		public function StateOutro() 
		{
			
		}
		
		override public function Init():void
		{
			m_BtnTitle = addBtn( 200, 385, "outro_btn_to_title", onQuitClicked );

			m_TF = new TextField();
			m_TF.width = Main.W / 2;
			m_TF.mouseEnabled = false;
			m_TF.autoSize = TextFieldAutoSize.CENTER;
			m_TF.y = 150;
			m_TF.x = Main.W / 2;
			m_TF.multiline = true;
			this.addChild(m_TF);
		}
		override public function Enter():void 
		{
			super.Enter();
			
			m_BtnTitle.label = "outro_btn_to_title";
			//this.inst_txt_title.text = "outro header";
			
			
			
			var myHTML:String = "Some HTML";
			trace("html: " + myHTML);
			m_TF.htmlText = myHTML;
			
			
		}
		
		
		public function onMouseClicked(ev:MouseEvent):void
		{
			if ( Main.gameReady )
			{
				NextState = "game";
				var clickSound:Sound = new SoundBtnClick();
				clickSound.play();
			}
		}
		
		private function onQuitClicked(ev:MouseEvent):void
		{
			if ( Main.gameReady )
			{
				NextState = "intro";
				var clickSound:Sound = new SoundBtnClick();
				clickSound.play();
			}
		}
		
	}

}