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
	
	

	/**
	 * ...
	 * @author Molly Jameson
	 */
	public class StateInfo extends BaseGameState 
	{
		private var m_BtnTitle:Button;

		
		public function StateOutro() 
		{
			
		}
		
		override public function Init():void
		{
			m_BtnTitle = addBtn( 400, 385, "outro_btn_to_title", onQuitClicked );

		}
		override public function Enter():void 
		{
			super.Enter();
			
			m_BtnTitle.label = "Back";
			
			var tf:TextField = this.inst_txt;
			
			tf.htmlText = "A very short project coded for LA Civic Hack-a-thon. "+ 
							"I'm maining sharing to see if there's any interest in us developing it further. " + 
							"Contact <font color = '#0000FF'><u><a href='http://www.linkedin.com/pub/d-coulombe/52/19b/89a'>D Coulombe</a></u></font> or <font color = '#0000FF'><u><a href='http://www.MollyJameson.com'>Molly Jameson</a></u></font> for more details. "+
							"<br><br><br>Using data from the US Census we have built a side-scrolling Flash game where the user controls an avatar that must pick-up random drops and avoid obstacles for as long as they can. " +
							"The goals of this project are to give users a way to interact with statistical data provided by the Census in a fun way, as well as illustrate the social and economic stratification of Los Angeles. "+
							"The frequency of drops and obstacles reflects economic conditions and trends in education and job attainment in LA neighborhoods. "+
							"At the end, the user is presented with some relevant statistics used to build the level for their neighborhood, and encouraged to play again or explore another neighborhood."
			
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