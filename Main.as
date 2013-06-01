package  
{
	
	import flash.display.Sprite;
	import com.mollyjameson.utils.Random;
	import com.mollyjameson.gamestates.BaseGameState;
	import com.mollyjameson.gamestates.StateIntro;
	import com.mollyjameson.gamestates.StateGameplay;
	import com.mollyjameson.gamestates.StateOutro;
	
	import fl.controls.Button;
	import flash.media.SoundTransform;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.events.Event;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class Main extends Sprite 
	{
		public static const W:int = 800;
		public static const H:int = 480;
		public static const VERSION_NUM:String = "V 0.0.5";
		public static var Inst:Main;
		public static var rand:Random;
		
		private var m_CurrState:BaseGameState;
		public static var gameReady:Boolean = false;
		
		private var m_GameStates:Object =
		{
			"intro":new StateIntro(),
			"game":new StateGameplay(),
			"outro":new StateOutro()
		}
		private var m_GameStateLayer:Sprite;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			//SWFProfiler.init(this.stage,this ); SWFProfiler.start();
			trace("Yes we've hit the entry point");
			
			// entry point
			Inst = this;
			
			// create gamestates here.
			rand = new Random((new Date()).getTime());
			
			//rand = new Random(123);
			trace("Seed: " + rand.seed + " generates: " + rand.nextInt());
			
			
			for each (var game_state:BaseGameState in m_GameStates) 
			{ 
				game_state.Init(); 
			} 
			m_GameStateLayer = new Sprite();
			this.addChild(m_GameStateLayer);
			
			/*var mute_btn:Button = new Button();
			mute_btn.enabled = true;
			mute_btn.toggle = true;
			mute_btn.setStyle("icon",SpeakerOn);
			mute_btn.setSize(40, 40);
			mute_btn.move(W - 50, 10);
			mute_btn.label = "";
			this.addChild(mute_btn);
			mute_btn.addEventListener(Event.CHANGE, changeHandler);*/
			
			Main.gameReady = true;
			
			m_CurrState = m_GameStates["intro"];
			m_CurrState.Enter();
			
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(ev:Event):void
		{
			m_CurrState.Update();
			if ( m_CurrState.NextState != "none" )
			{
				m_CurrState.Exit();
				var next_state:BaseGameState = m_GameStates[m_CurrState.NextState];
				if( next_state != null )
				{
					m_CurrState = next_state;
				}
				else
				{
					throw new Error("attempted to switch to invalid state");
				}
				m_CurrState.Enter();
			}
		}
		// global mute button.
		private function changeHandler(event:Event):void 
		{
			var mute_btn:Button = event.currentTarget as Button;
			if( !mute_btn.selected )
			{
				mute_btn.setStyle("icon",SpeakerOn);
				
				var full_transform:SoundTransform = new SoundTransform();
				SoundMixer.soundTransform = full_transform;
				
			}
			else
			{
				SoundMixer.stopAll();
				var mute_transform:SoundTransform = new SoundTransform(0);
				SoundMixer.soundTransform = mute_transform;
				
				mute_btn.setStyle("icon",SpeakerOff);
			}
		}
		
		public function AttachGameState(gamestate:BaseGameState):void
		{
			m_GameStateLayer.addChild(gamestate);
		}
		public function RemoveGameState(gamestate:BaseGameState):void
		{
			m_GameStateLayer.removeChild(gamestate);
		}
		
	}
	
}
