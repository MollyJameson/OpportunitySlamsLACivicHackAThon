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
		private var m_HSPowerUps:int;
		private var m_CollegePowerUps:int;
		
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
			
			m_HUD[Player.RES_HEALTH] = new HudBar(0xFF0000,m_Player.GetMaxResource(Player.RES_HEALTH),0.3);
			m_HUD[Player.RES_MONEY] = new HudBar(0x00FF00,m_Player.GetMaxResource(Player.RES_MONEY),0.3);
			m_HUD[Player.RES_EMO] = new HudBar(0x0000FF,m_Player.GetMaxResource(Player.RES_EMO),0.3);
			m_HUD[Player.RES_EMO].y = Main.H - m_HUD[Player.RES_EMO].height; m_HUD[Player.RES_EMO].x = 10;
			m_HUD[Player.RES_MONEY].y = m_HUD[Player.RES_EMO].y - m_HUD[Player.RES_MONEY].height; m_HUD[Player.RES_MONEY].x = 10;
			m_HUD[Player.RES_HEALTH].y = m_HUD[Player.RES_MONEY].y - m_HUD[Player.RES_HEALTH].height; m_HUD[Player.RES_HEALTH].x = 10;
			
			
			this.addChild(m_World);
			
			// on top of the world
			this.addChild(m_HUD[Player.RES_HEALTH]);
			this.addChild(m_HUD[Player.RES_EMO]);
			this.addChild(m_HUD[Player.RES_MONEY]);
			
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
			m_HSPowerUps = 0;
			
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
			
			this.UpdateRestrictions();
			
			m_Player.m_MoneyCap = this.m_CurrLevelData.m_MoneyCap;
			
			m_HUD[Player.RES_HEALTH].Reset(m_Player.m_MoneyCap);
			m_HUD[Player.RES_EMO].Reset(m_Player.m_MoneyCap);
			m_HUD[Player.RES_MONEY].Reset(m_Player.m_MoneyCap);
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
				UpdateRestrictions();
			}
			
			//this.inst_location.text = "world: " + int(m_World.x) + " , " +  int(m_World.y) + " avatar " + int(m_Player.x) + " , " + int(m_Player.y);
			this.inst_location.visible = false;
			
			var m_LastGoodPosX:Number = m_Player.x;
			var m_LastGoodPosY:Number = m_Player.y;
			
			const PLAYER_SPEED:Number = 5;
			//const PLAYER_SPEED:Number = 20;
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
				if( power_up.visible && power_up.parent )
				{
					if( power_up.hitTestObject(m_Player) )
					{
						
						if( power_up.GetMoneyAmount() > 0 )
						{
							var new_money_sub:Number = m_Player.ModifyResource(Player.RES_MONEY,power_up.GetMoneyAmount());
							m_HUD[Player.RES_MONEY].SetCurrValue(new_money_sub);
							
							var float_text:FloatyText = new FloatyText();
							float_text.x = global_pt.x; 
							float_text.y = global_pt.y;
							this.addChild(float_text);
							float_text.Init("+Money " + power_up.GetMoneyAmount(),0x00FF00,m_HUD[Player.RES_MONEY].x,m_HUD[Player.RES_MONEY].y);
							UpdateRestrictions();
						}
						// remove and give player the resource.
						if( power_up.GetPowerUpType() == PowerUp.EMOTIONAL_SUPPORT )
						{
							m_Player.ModifyResource(Player.RES_EMO,5);
							m_HUD[Player.RES_EMO].SetCurrValue(-5);
						}
						else if( power_up.GetPowerUpType() == PowerUp.HSDIPLOMA )
						{
							m_HSPowerUps++;
							if( m_HSPowerUps >= this.m_CurrLevelData.m_HSGoalComplete )
							{
								// Show or hide any obstacles that get in the way.
								UpdateRestrictions();
							}
						}
						else if( power_up.GetPowerUpType() == PowerUp.COLLEGE_DIPLOMA )
						{
							m_CollegePowerUps++;
							if( m_CollegePowerUps >= this.m_CurrLevelData.m_CollegeGoalComplete )
							{
								// Show or hide any obstacles that get in the way.
								UpdateRestrictions();
							}
						}
						
						m_World.removeChild(power_up);
						m_ArrPowerUps.splice(i,1);
						break;
					}
				}
			}
			var obstacle_collision:Boolean = false;
			len = m_ArrObstacles.length;
			// warning we could remove in this loop.
			for( var j:int = len - 1; j >= 0; --j )
			{
				// trivial hit test.
				var test_obj:BlockingObstacle = m_ArrObstacles[j];
				// HACK: kind of awkward because you can hit the side but no time to do real velocity check collision resolution
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
			
			var level_data:LevelData = Main.Inst.GetLevelData();
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
		
		public function UpdateRestrictions():void
		{
			var completed_hs_goal:Boolean = false;
			if( m_HSPowerUps >= this.m_CurrLevelData.m_HSGoalComplete )
			{
				completed_hs_goal = true;
			}
			var complete_college_goal:Boolean = false;
			if( m_CollegePowerUps >= this.m_CurrLevelData.m_CollegeGoalComplete )
			{
				complete_college_goal = true;
			}
			//trace("College goal levels " + m_CollegePowerUps + " of " + this.m_CurrLevelData.m_CollegeGoalComplete);
			
			var curr_money:int = m_Player.GetResource(Player.RES_MONEY);
			var len:int = m_ArrPowerUps.length;
			for( var i:int = 0; i < len; ++i )
			{
				// set as not visible if requirements aren't met
				var power_up:PowerUp = m_ArrPowerUps[i];
				var edu_allow:Boolean = true;
				if( power_up.GetHSDiplomaRequirement() )
				{
					if( !completed_hs_goal )
					{
						edu_allow = false;
					}
				}
				if( power_up.GetCollegeDiplomaRequirement() )
				{
					if( !complete_college_goal )
					{
						edu_allow = false;
					}
					//trace("college degree required and " + complete_college_goal);
				}
				// special case so can't keep going to college.
				if( power_up.GetPowerUpType() == PowerUp.COLLEGE_DIPLOMA && complete_college_goal )
				{
					power_up.visible = false;
				}
				else if( power_up.GetPowerUpType() == PowerUp.HSDIPLOMA && completed_hs_goal )
				{
					power_up.visible = false;
				}
				else if( curr_money >= power_up.GetMoneyRequirement() && edu_allow )
				{
					power_up.visible = true;
				}
				else
				{
					power_up.visible = false;
				}
			}
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