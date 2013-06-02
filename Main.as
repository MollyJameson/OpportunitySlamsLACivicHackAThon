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
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import com.mollyjameson.gameobjs.LevelData;
	import flash.events.KeyboardEvent;
	
	public class Main extends Sprite 
	{
		public static const W:int = 800;
		public static const H:int = 480;
		public static const VERSION_NUM:String = "V 0.0.5";
		public static var Inst:Main;
		public static var rand:Random;
		
		private var m_CurrState:BaseGameState;
		public static var gameReady:Boolean = false;
		public var is_fun_version:Boolean = false;
		
		private var m_GameStates:Object =
		{
			"intro":new StateIntro(),
			"game":new StateGameplay(),
			"outro":new StateOutro()
		}
		private var m_GameStateLayer:Sprite;
		
		private var m_Levels:Object = {}
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownEvent,false,0,true);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUpEvent,false,0,true);

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
			
			loadXMLFile();
			
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
			m_GameStateLayer.stage.focus = this;
		}
		public function RemoveGameState(gamestate:BaseGameState):void
		{
			m_GameStateLayer.removeChild(gamestate);
		}
		public function onKeyDownEvent(ev:KeyboardEvent):void
		{
			//trace("key event " + ev);
			
			if( m_CurrState )
			{
				m_CurrState.onKeyDownEvent(ev);
			}
		}
		public function onKeyUpEvent(ev:KeyboardEvent):void
		{
			if( m_CurrState )
			{
				m_CurrState.onKeyUpEvent(ev);
			}
		}
		
		public function GetLevelData(str:String):LevelData
		{
			return m_Levels[str];
		}
		
		private function loadXMLFile():void
		{
			var loader= new URLLoader(new URLRequest("data/TestLevel.xml"));
			loader.addEventListener(Event.COMPLETE, loadedCompleteHandler);
		}
		private function loadedCompleteHandler(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, loadedCompleteHandler);
			var xmldata:XML = XML(e.target.data);
			
			var test_level:LevelData = new LevelData();
			var pickups:XMLList = xmldata.pickups;
			
			if( pickups )
			{
				var item_list:XMLList = pickups.item;
				if( item_list )
				{
					for each (var pickup_items:XML in item_list) 
					{
						//trace("pickup_items: " + pickup_items);
						test_level.AddPickUp(pickup_items);
					}
				}
			}
			// Get pickup data
			// Get Obstacle data
			// Get goal data ( very specificly named )
			// Get drips
			var drips:XMLList = xmldata.drips;
			trace("drips: " + drips);
			if( drips.money )
			{
				test_level.AddMoneyDripRate(drips.money);
			}
			
			m_Levels["test"] = test_level;
		}
		
	}
	
}
