﻿package com.mollyjameson.gamestates 
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
	import com.mollyjameson.gameobjs.BlockingObstacle;
	import com.mollyjameson.gameobjs.LevelData;
	import com.mollyjameson.gameobjs.FloatyText;
	

	/**
	 * ...
	 * @author Molly Jameson
	 */
	public class StateGameplay extends BaseGameState 
	{
		
		private var m_World:ScrollingWorld;
		private var m_Player:Player;
		
		private var m_LastTime:int;
		private var m_MoneyDripTimer:Number;
		private var m_CurrLevelData:LevelData;
		
		// powerups you destroy on contact. Obstacles block movement on collision.
		private var m_ArrPowerUps:Vector.<PowerUp>;
		private var m_ArrObstacles:Vector.<BlockingObstacle>;
		
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
			m_HUD[Player.RES_EMO].y = Main.H - m_HUD[Player.RES_EMO].height; m_HUD[Player.RES_EMO].x = 10;
			m_HUD[Player.RES_MONEY].y = m_HUD[Player.RES_EMO].y - m_HUD[Player.RES_MONEY].height; m_HUD[Player.RES_MONEY].x = 10;
			m_HUD[Player.RES_HEALTH].y = m_HUD[Player.RES_MONEY].y - m_HUD[Player.RES_HEALTH].height; m_HUD[Player.RES_HEALTH].x = 10;
			this.addChild(m_HUD[Player.RES_HEALTH]);
			this.addChild(m_HUD[Player.RES_EMO]);
			this.addChild(m_HUD[Player.RES_MONEY]);
			
			this.addChild(m_World);
			
		}
		override public function Enter():void 
		{
			super.Enter();
			
			m_LastTime = getTimer();
			
			
			
			m_World.addChild( m_Player );
			m_World.Reset();
			m_Player.Reset();
			m_Player.x = 40;
			
			m_UpPressed = false;
			m_DownPressed = false;
			m_LeftPressed = false;
			m_RightPressed = false;
			
			m_ArrPowerUps = new Vector.<PowerUp>();
			m_ArrObstacles = new Vector.<BlockingObstacle>;
			
			if( Main.Inst.is_fun_version )
			{
				m_HUD[Player.RES_HEALTH].visible = true;
				m_HUD[Player.RES_EMO].visible = true;
			}
			else
			{
				m_HUD[Player.RES_HEALTH].visible = false;
				m_HUD[Player.RES_EMO].visible = false;
			}
			
			InitTestLevel();
		}
		
		
		override public function Exit():void
		{
			if( stage )
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDownEvent);
				stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUpEvent);
			}
			trace("Remove world");
			// clear the world
			var len:int = m_ArrPowerUps.length;
			for( var i:int = 0; i < len; ++i )
			{
				if( m_ArrPowerUps[i].parent )
				{
					m_World.removeChild(m_ArrPowerUps[i]);
				}
			}
			trace("remove obstacles");
			len = m_ArrObstacles.length;
			for( var j:int = 0; j < len; ++j )
			{
				if( m_ArrObstacles[j].parent )
				{
					m_World.removeChild(m_ArrObstacles[j]);
				}
			}
			
			m_ArrPowerUps  = new Vector.<PowerUp>();
			
			m_ArrObstacles = new Vector.<BlockingObstacle>;
			
			super.Exit();
			
		}

		override public function Update():void
		{
			super.Update();
			var now:int = getTimer();
			var delta:int = now - m_LastTime;
			m_LastTime = now;
			
			var dt:Number = delta/1000.0;
			
			m_World.Tick(dt);
			
			m_MoneyDripTimer -= dt;
			//trace("Money drip timer: " + m_MoneyDripTimer);
			if( m_MoneyDripTimer < 0 )
			{
				//trace("Modifying Money by: " + m_CurrLevelData.m_MoneyDrip);
				var new_money:Number = m_Player.ModifyResource(Player.RES_MONEY,-m_CurrLevelData.m_MoneyDrip);
				m_HUD[Player.RES_MONEY].SetCurrValue(new_money);
				m_MoneyDripTimer = 1;
			}
			
			this.inst_location.text = "world: " + int(m_World.x) + " , " +  int(m_World.y) + " avatar " + int(m_Player.x) + " , " + int(m_Player.y);
			
			var m_LastGoodPosX:Number = m_Player.x;
			var m_LastGoodPosY:Number = m_Player.y;
			
			const PLAYER_SPEED:Number = 5;
			if( m_UpPressed && m_Player.y > 0)
			{
				m_Player.y -= PLAYER_SPEED;
			}
			if( m_DownPressed && m_Player.y < Main.H - m_Player.height )
			{
				m_Player.y += PLAYER_SPEED;
			}
			/*if( m_LeftPressed )
			{
				m_Player.x -= PLAYER_SPEED;
			}*/
			if( m_RightPressed )
			{
				m_Player.x += (PLAYER_SPEED/2);
			}
			
			var end_collision:Boolean = false;
			// if player is colliding with the world end move them forward anyways.
			// TODO: move this in scrolling world func. but if we can't move forward ( due to an obstacle... we will die here )
			var global_pt:Point = m_Player.localToGlobal(new Point());
			if( global_pt.x < 0 )
			{
				m_Player.x -= global_pt.x;
				end_collision = true;
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
						var new_money_sub:Number = m_Player.ModifyResource(Player.RES_MONEY,20);
						m_HUD[Player.RES_MONEY].SetCurrValue(new_money_sub);
						
						var float_text:FloatyText = new FloatyText();
						float_text.x = global_pt.x; 
						float_text.y = global_pt.y;
						this.addChild(float_text);
						float_text.Init("+Money",0x00FF00,m_HUD[Player.RES_MONEY].x,m_HUD[Player.RES_MONEY].y);
						
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
			var obstacle_collision:Boolean = false;
			len = m_ArrObstacles.length;
			// warning we could remove in this loop.
			for( var j:int = len - 1; j >= 0; --j )
			{
				// trivial hit test.
				var test_obj:BlockingObstacle = m_ArrObstacles[j];
				
				if( test_obj.hitTestObject(m_Player) )
				{
					// ruh roh, we need to step back to our last good position.
					// idealy we'd just step back along our velocity.
					m_Player.x = m_LastGoodPosX;
					m_Player.y = m_LastGoodPosY;
					obstacle_collision = true;
				}
			}
			
			// set final allowed position.
			// if we are off the board and also are colliding with an object then we're dead ( go to gameover state. )
			// hm... this is weird in the event of side collision
			if( obstacle_collision && end_collision )
			{
				NextState = "outro";
				trace("You lost due to collision");
			}
			if( m_Player.GetResource(Player.RES_MONEY) < 0 )
			{
				NextState = "outro";
				trace("You lost due to being out of money");
			}
			
			if( m_Player.x > m_CurrLevelData.m_FurthestX )
			{
				NextState = "outro";
				trace("You win for making it until the end, horray");
			}
			
		}
		
		private function InitTestLevel():void
		{
			/*var money_test:PowerUp = new PowerUp(PowerUp.MONEY);
			m_ArrPowerUps.push(money_test);
			money_test.x = 200; money_test.y = 200;
			m_World.addChild(money_test);
			
			var emo_test:PowerUp = new PowerUp(PowerUp.EMOTIONAL_SUPPORT);
			m_ArrPowerUps.push(emo_test);
			emo_test.x = 500; emo_test.y = 300;
			m_World.addChild(emo_test);
			
			
			var college_test:BlockingObstacle = new BlockingObstacle( 200,100 );
			m_ArrObstacles.push( college_test );
			college_test.x = 600; college_test.y = 100;
			m_World.addChild(college_test);*/
			
			var level_data:LevelData = Main.Inst.GetLevelData("test");
			m_ArrPowerUps = level_data.m_ArrPowerUps;
			m_ArrObstacles = level_data.m_ArrObstacles;
			
			var len:int = level_data.m_ArrPowerUps.length;
			for( var i:int = 0; i < len; ++i )
			{
				m_ArrPowerUps.push(level_data.m_ArrPowerUps[i]);
				m_World.addChild(m_ArrPowerUps[i]);
			}
			trace("add obstacles");
			len = level_data.m_ArrObstacles.length;
			for( var j:int = 0; j < len; ++j )
			{
				m_ArrObstacles.push(level_data.m_ArrObstacles[j]);
				m_World.addChild(m_ArrObstacles[j]);
			}
			m_CurrLevelData = level_data;
			
			m_MoneyDripTimer = 1;
		}
		
		public override function onKeyDownEvent(ev:KeyboardEvent):void
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
		public override function onKeyUpEvent(ev:KeyboardEvent):void
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