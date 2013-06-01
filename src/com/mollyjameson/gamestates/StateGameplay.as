package com.mollyjameson.gamestates 
{
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import caurina.transitions.Tweener;
	import com.mollyjameson.gameobjs.ScrollingWorld;
	import com.mollyjameson.gameobjs.Player;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	import com.mollyjameson.gameobjs.PowerUp;
	import com.mollyjameson.hud.HudBar;
	

	/**
	 * ...
	 * @author Molly Jameson
	 */
	public class StateGameplay extends BaseGameState 
	{
		
		private var m_World:ScrollingWorld;
		private var m_Player:Player;
		private var m_ArrPowerUps:Vector.<PowerUp>;
		private var m_ArrObstacles:Array;
		
		private var m_HUD:Object;
		
		// Extremely basic keyboard controls
		private var m_UpPressed:Boolean;
		private var m_DownPressed:Boolean;
		private var m_LeftPressed:Boolean;
		private var m_RightPressed:Boolean;
		
		override public function Init():void
		{
			// In a real game this would be a tilemap... but i"m in a a hurry now
			m_World = new ScrollingWorld();
			m_Player = new Player();
			
			m_HUD = new Object();
			
			m_HUD[Player.RES_HEALTH] = new HudBar(0xFF0000,m_Player.GetMaxResource(Player.RES_HEALTH));
			m_HUD[Player.RES_MONEY] = new HudBar(0x00FF00,m_Player.GetMaxResource(Player.RES_MONEY));
			m_HUD[Player.RES_EMO] = new HudBar(0x0000FF,m_Player.GetMaxResource(Player.RES_EMO));
			m_HUD[Player.RES_EMO].y = Main.H - m_HUD[Player.RES_EMO].height;
			m_HUD[Player.RES_MONEY].y = m_HUD[Player.RES_EMO].y - m_HUD[Player.RES_MONEY].height;
			m_HUD[Player.RES_HEALTH].y = m_HUD[Player.RES_MONEY].y - m_HUD[Player.RES_HEALTH].height;
			this.addChild(m_HUD[Player.RES_HEALTH]);
			this.addChild(m_HUD[Player.RES_EMO]);
			this.addChild(m_HUD[Player.RES_MONEY]);
		}
		override public function Enter():void 
		{
			super.Enter();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownEvent,false,0,true);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUpEvent,false,0,true);
			
			
			this.addChild(m_World);
			
			m_World.addChild( m_Player );
			m_Player.x = 40;
			
			m_UpPressed = false;
			m_DownPressed = false;
			m_LeftPressed = false;
			m_RightPressed = false;
			
			m_ArrPowerUps = new Vector.<PowerUp>();
			
			InitTestLevel();
		}
		
		
		override public function Exit():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDownEvent);
			stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUpEvent);
			
			// clear the world
			var len:int = m_ArrPowerUps.length;
			for( var i:int = 0; i < len; ++i )
			{
				m_World.removeChild(m_ArrPowerUps[i]);
			}
			m_ArrPowerUps  = new Vector.<PowerUp>();
			
			super.Exit();
			
		}

		override public function Update():void
		{
			super.Update();
			
			m_World.Tick();
			
			const PLAYER_SPEED:Number = 5;
			if( m_UpPressed )
			{
				m_Player.y -= PLAYER_SPEED;
			}
			if( m_DownPressed )
			{
				m_Player.y += PLAYER_SPEED;
			}
			if( m_LeftPressed )
			{
				m_Player.x -= PLAYER_SPEED;
			}
			if( m_RightPressed )
			{
				m_Player.x += PLAYER_SPEED;
			}
			
			// if player is colliding with the world end move them forward anyways.
			// TODO: move this in scrolling world func. but if we can't move forward ( due to an obstacle... we will die here )
			var global_pt:Point = m_Player.localToGlobal(new Point());
			if( global_pt.x < 0 )
			{
				m_Player.x -= global_pt.x;
			}
			
			// collect powerups
			
			var len:int = m_ArrPowerUps.length;
			// warning we could remove in this loop.
			for( var i:int = len - 1; i >= 0; --i )
			{
				var power_up:PowerUp = m_ArrPowerUps[i];
				
				if( power_up.hitTestObject(m_Player) )
				{
					// remove and give player the resource.
					if( power_up.GetPowerUpType() == PowerUp.MONEY )
					{
						m_Player.ModifyResource(Player.RES_MONEY,5);
						m_HUD[Player.RES_MONEY].SetCurrValue(-5);
					}
					else if( power_up.GetPowerUpType() == PowerUp.EMOTIONAL_SUPPORT )
					{
						m_Player.ModifyResource(Player.RES_EMO,5);
						m_HUD[Player.RES_EMO].SetCurrValue(-5);
					}
					
					m_World.removeChild(power_up);
					m_ArrPowerUps.splice(i,1);
				}
			}
		}
		
		private function InitTestLevel():void
		{
			var money_test:PowerUp = new PowerUp(PowerUp.MONEY);
			m_ArrPowerUps.push(money_test);
			money_test.x = 200; money_test.y = 200;
			m_World.addChild(money_test);
			
			var emo_test:PowerUp = new PowerUp(PowerUp.EMOTIONAL_SUPPORT);
			m_ArrPowerUps.push(emo_test);
			emo_test.x = 500; emo_test.y = 300;
			m_World.addChild(emo_test);
		}
		
		private function onKeyDownEvent(ev:KeyboardEvent):void
		{
			//trace("on key down: " + ev);
			
			if( ev.keyCode == Keyboard.UP )
			{
				m_UpPressed = true;
			}
			if( ev.keyCode == Keyboard.DOWN )
			{
				m_DownPressed = true;
			}
			if( ev.keyCode == Keyboard.LEFT )
			{
				m_LeftPressed = true;
			}
			if( ev.keyCode == Keyboard.RIGHT )
			{
				m_RightPressed = true;
			}
		}
		private function onKeyUpEvent(ev:KeyboardEvent):void
		{
			//trace("on key up: " + ev);
			if( ev.keyCode == Keyboard.UP )
			{
				m_UpPressed = false;
			}
			if( ev.keyCode == Keyboard.DOWN )
			{
				m_DownPressed = false;
			}
			if( ev.keyCode == Keyboard.LEFT )
			{
				m_LeftPressed = false;
			}
			if( ev.keyCode == Keyboard.RIGHT )
			{
				m_RightPressed = false;
			}
		}
		
		
	}// class

}// namespace