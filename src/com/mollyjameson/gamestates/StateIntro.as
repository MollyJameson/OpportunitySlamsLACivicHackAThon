package com.mollyjameson.gamestates 
{
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import flash.events.Event;
	
	import flash.text.TextFormat;
	import flash.media.Sound;

	/**
	 * ...
	 * @author Molly Jameson
	 */
	public class StateIntro extends BaseGameState 
	{
		private var m_PlayBtn:Button;
		private var m_PlayBtn2:Button;
		private var m_OptionsBtn:Button;

		// http://www.adobe.com/devnet/flash/quickstart/button_component_as3.html
		public function StateIntro() 
		{
			
		}
		
		override public function Init():void
		{
			m_PlayBtn = addBtn( 113, 385, "title_btn_play", onMouseClicked );
			m_PlayBtn2 = addBtn( 333, 385, "title_btn_play", OnRealisticVersionClicked );
			m_OptionsBtn = addBtn( 568, 385, "title_btn_options", onOptionsClicked );
			
			m_OptionsBtn.enabled = false;
		}
		
		override public function Enter():void 
		{
			super.Enter();
			
			// reset labels in case we've changed languages
			m_PlayBtn.label = "Play Game";
			m_PlayBtn2.label = "Play Real Version";
			m_OptionsBtn.label = "More Info";

		}
		
		private function requestState(requested:String):void
		{
			if ( Main.gameReady )
			{
				NextState = requested;
				var clickSound:Sound = new SoundBtnClick();
				clickSound.play();
			}
		}
		
		// TODO: add more logging here if possible
		public function onMouseClicked(ev:MouseEvent):void
		{
			Main.Inst.is_fun_version = true;
			requestState("game");
		}
		
		public function onOptionsClicked(ev:MouseEvent):void
		{
			//Main.Inst.showIntermediateAd();
			requestState("options");
		}
		public function OnRealisticVersionClicked(ev:MouseEvent):void
		{
			Main.Inst.is_fun_version = false;
			requestState("game");
		}
	}

}