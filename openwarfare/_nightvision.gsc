//******************************************************************************
//  _____                  _    _             __
// |  _  |                | |  | |           / _|
// | | | |_ __   ___ _ __ | |  | | __ _ _ __| |_ __ _ _ __ ___
// | | | | '_ \ / _ \ '_ \| |/\| |/ _` | '__|  _/ _` | '__/ _ \
// \ \_/ / |_) |  __/ | | \  /\  / (_| | |  | || (_| | | |  __/
//  \___/| .__/ \___|_| |_|\/  \/ \__,_|_|  |_| \__,_|_|  \___|
//       | |               We don't make the game you play.
//       |_|                 We make the game you play BETTER.
//
//            Website: http://openwarfaremod.com/
//******************************************************************************

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

#include openwarfare\_eventmanager;
#include openwarfare\_utils;

init()
{
	level.scr_nvs_enabled = getDvarx( "scr_nvs_enabled", "int", 1, 0, 1 ) && getDvarx( "scr_enable_nightvision", "int", 1, 0, 1 );

	// If night vision system is disabled then there's nothing else to do here
	if ( level.scr_nvs_enabled == 0 )
		return;

	level.scr_nvs_grain_enabled = getDvarx( "scr_nvs_grain_enabled", "int", 0, 0, 1 );
	level.scr_nvs_shock_enabled = getDvarx( "scr_nvs_shock_enabled", "int", 0, 0, 1 );

	if ( !isDefined( game["nvs"] ) )
	{
		game["nvs"] = [];
		game["nvs"]["light_fx"] = loadFx( "nv/light_white_big" );

		//if ( level.scr_nvs_grain_enabled )
		game["nvs"]["grain_shader"] = preCacheShader("ac130_overlay_grain");

		//if ( level.scr_nvs_shock_enabled )
		game["nvs"]["night_shock"] = PreCacheShellShock("nightvision");
	}

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


onPlayerConnected()
{
	self setupLaserEffect();
	self setupGrainEffect();
	self resetAllEffects();

	self thread addNewEvent( "onPlayerSpawned",    ::onPlayerSpawned );

	self thread addNewEvent( "onJoinedSpectators", ::resetAll );
	self thread addNewEvent( "onPlayerDeath",      ::resetAll );
	self thread addNewEvent( "onJoinedTeam",       ::resetAll );
}

setupLaserEffect()
{
	// Laser visual improvements
	// TODO: Move it to config or csv
	self setClientDvar("cg_laserEndOffset",        "0.5" );
	self setClientDvar("cg_laserFlarePct",         "0.2" );
	self setClientDvar("cg_laserLight",            "1"   );
	self setClientDvar("cg_laserLightBeginOffset", "13"  );
	self setClientDvar("cg_laserLightBodyTweak",   "15"  );
	self setClientDvar("cg_laserLightEndOffset",   "-3"  );
	self setClientDvar("cg_laserLightRadius",      "1.7" );
	self setClientDvar("cg_laserRadius",           "0.5" );
	self setClientDvar("cg_laserRange",            "500" );
	self setClientDvar("cg_laserRangePlayer",      "500" );
}

setupGrainEffect()
{
	self.grainOverlay = newClientHudElem( self );
	self.grainOverlay.x = 0;
	self.grainOverlay.y = 0;
	self.grainOverlay.alignX = "left";
	self.grainOverlay.alignY = "top";
	self.grainOverlay.horzAlign = "fullscreen";
	self.grainOverlay.vertAlign = "fullscreen";
	self.grainOverlay setshader ("ac130_overlay_grain", 640, 480);
	self.grainOverlay.alpha = 0.0;
	self.grainOverlay.sort = -1000;
}

setupLightEffect()
{
	if ( !isDefined(self.nightvisionLightEnt) )
	{
		self.nightvisionLightEnt = spawn("script_model", (0, 0, -2000));
		self.nightvisionLightEnt setModel("tag_origin");
		self.nightvisionLightEnt Hide();
		self.nightvisionLightFXPlayed = false;
	}
}

removeLightEffect()
{
	if ( isDefined(self.nightvisionLightEnt) )
	{
		self.nightvisionLightEnt Delete();
		self.nightvisionLightFXPlayed = false;
	}
}


onPlayerSpawned()
{
	self resetAllEffects();
	self setupLightEffect();
	self thread switchVisionThread();
}


resetAllEffects()
{
	self.nvon = false;

	// Reset shellshock effect
	self notify ("nvs_stop_shock_thread");
	self StopShellShock();

	// Reset laser effect
	self.laseron = false;
	self setClientDvar("cg_laserforceon", 0);
	self setClientDvar("cg_fovscale", 1);

	// Reset grain effect
	if(isDefined(self.grainOverlay))
	{
		self.grainOverlay.alpha = 0.0;
	}

	// Reset light effect
	if (isDefined(self.nightvisionLightEnt))
	{
		self.nightvisionLightEnt Unlink();
		self.nightvisionLightEnt.origin = (0, 0, -2000);
	}
}


switchVisionThread()
{
	self endon( "nvs_stop_switch_thread" );
	self endon( "disconnect" );

	for(;;)
	{
		self waittill("night_vision_on");

		if(!self.nvon)
		{
			self.nvon = true;

			self.laseron = true;
			
			self setClientDvar("cg_laserforceon", 1);
			self setClientDvar("cg_fovscale", 0.9);

			if(isDefined(self.grainOverlay))
			{
				self.grainOverlay.alpha = 0.2;
			}

			self thread UpdateShockThread();

			if ( isDefined(self.nightvisionLightEnt) )
			{
				self.nightvisionLightEnt.origin = self GetEye() + ( 0, 0, 50 );
				self.nightvisionLightEnt linkto(self);
				self.nightvisionLightEnt ShowToPlayer(self);

				if (!self.nightvisionLightFXPlayed)
				{
					wait 0.1;
					playFxOnTag(game["nvs"]["light_fx"], self.nightvisionLightEnt, "tag_origin");
					self.nightvisionLightFXPlayed = true;
				}
			}
		}

		// TODO: battary logic here
		//wait (2);
		//self ExecClientCommand( "+actionslot 1");
		//wait (0.1);

		self waittill("night_vision_off");

		self resetAllEffects();
	}
}


UpdateShockThread()
{
	self endon( "nvs_stop_shock_thread" );
	self endon( "disconnect" );

	for (;;)
	{
		duration = 10;
		self shellshock( "nightvision", duration );
		wait 0.1;
		self AllowSprint (true);
		wait duration;
	}
}


resetAll()
{
	self notify ("nvs_stop_switch_thread");
	self resetAllEffects();
	self removeLightEffect();
}