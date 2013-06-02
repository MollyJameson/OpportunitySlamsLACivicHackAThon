package com.mollyjameson.gamestates 
{
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import flash.events.Event;
	
	import flash.text.TextFormat;
	import flash.media.Sound;
	import flash.display.MovieClip;

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
			
			for(var i:int = 0; i < 4; ++i )
			{
				var mc_btn:MovieClip = this["btn_" + i];
				if( mc_btn )
				{
					mc_btn.addEventListener(MouseEvent.CLICK,onMouseClickBtn);
					mc_btn.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverBtn);
					mc_btn.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutBtn);
					mc_btn.gotoAndStop(1);
				}
			}
		}
		
		override public function Enter():void 
		{
			super.Enter();
			
			// reset labels in case we've changed languages
			m_PlayBtn.label = "Play Game";
			m_PlayBtn2.label = "Play Real Version";
			m_OptionsBtn.label = "More Info";

		}
		
		private function onMouseOverBtn(ev:MouseEvent):void
		{
			var mc:MovieClip = ev.currentTarget as MovieClip;
			if( mc )
			{
				mc.gotoAndStop(2);
			}
		}
		private function onMouseOutBtn(ev:MouseEvent):void
		{
			var mc:MovieClip = ev.currentTarget as MovieClip;
			if( mc )
			{
				mc.gotoAndStop(1);
			}
		}
		private function onMouseClickBtn(ev:MouseEvent):void
		{
			// whatever hack.
			var mc:MovieClip = ev.currentTarget as MovieClip;
			if( mc )
			{
				if( mc.name == "btn_0")
				{
					Main.Inst.level_number = Main.WEHO;
					Main.Inst.is_fun_version = false;
				}
				else if( mc.name == "btn_1")
				{
					Main.Inst.level_number = Main.BOYLE_HEIGHT;
					Main.Inst.is_fun_version = false;
				}
				else if( mc.name == "btn_2")
				{
					Main.Inst.level_number = Main.LEIMERT_PARK;
					Main.Inst.is_fun_version = true;
				}
				else if( mc.name == "btn_3")
				{
					Main.Inst.level_number = Main.TORRANCE;
					Main.Inst.is_fun_version = true;
				}
			}
			requestState("game");
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