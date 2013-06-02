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

		private var m_TimesInState:int = 0;
		
		public function StateOutro() 
		{
			
		}
		
		override public function Init():void
		{
			m_BtnTitle = addBtn( 200, 385, "outro_btn_to_title", onQuitClicked );

			m_TF = new TextField();
			m_TF.width = 300;
			m_TF.mouseEnabled = false;
			m_TF.y = 100;
			
			m_TF.multiline = m_TF.wordWrap = true;
			this.addChild(m_TF);
			m_TF.selectable = false;
			m_TF.autoSize = TextFieldAutoSize.RIGHT;
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 24;
			myFormat.color = 0xFFFFFF;
			m_TF.defaultTextFormat = myFormat;
			
			m_TF.x = 450;
		}
		override public function Enter():void 
		{
			super.Enter();
			
			m_BtnTitle.label = "Play Again";
			//this.inst_txt_title.text = "outro header";
			
			// AGGH!!! code faster.
			
			var str:String = "";
			
			if( Main.Inst.level_number == Main.WEHO)
			{
				// Not random at all
				var weho_facts:Array = 
				[
				 "The median income of a resident of West Hollywood is $74,262, 30% higher than that of all of LA County.",
				 "97% of West Hollywood residents are high school graduates; 60% hold a Bachelors degree or higher.",
				 "One in ten (12%) West Hollywood residents lives under the poverty line; of those, 46% are single mothers.",
				 ];
				 
				 str = weho_facts[m_TimesInState % weho_facts.length];
			}
			else
			{
				var other_facts:Array = 
				[
				 "The median income of a resident of Boyle Heights is $29,524, nearly half the median income for all of LA County.",
				 "Less than half of Boyle Heights residents are high school graduates (48%) and only 7% hold a Bachelors degree or higher.",
				 "A third of the people living in Boyle Heights are living under the poverty line (33%), and half of them are single mothers (49%).",
				 ];
				 
				 str = other_facts[m_TimesInState % other_facts.length];
			}
			str += "\n\n Figures taken from the 2011 ACS 5-Year Estimates";

			m_TF.text = str;

			m_TimesInState++;
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