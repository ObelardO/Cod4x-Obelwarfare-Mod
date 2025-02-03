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
	level._effect["nv_light"] = loadfx( "nv/light_white_big" );
	precacheShader("ac130_overlay_grain");
	PreCacheShellShock("nightvision");

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


onPlayerConnected()
{
	self makeNightVisionHud();
	self resetNightVision();

	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
	self thread addNewEvent( "joined_spectators", ::onJoinedSpectators );
	self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );
}


onPlayerSpawned()
{
	self resetNightVision();
	self spawnNightVisionEffects();
	self thread switchNightVisionThread();
}


onJoinedSpectators()
{
	forceDisableAll();
}


onPlayerDeath()
{
	forceDisableAll();
}


resetNightVision()
{
	self notify ("nv_stop_updating_shock");

	self.nvon = false;
	self.laseron = false;

	self setClientDvar("cg_laserforceon", 0);
	self setClientDvar("cg_fovscale", 1);

	if(isDefined(self.grainOverlay))
	{
		self.grainOverlay.alpha = 0.0;
	}

	self StopShellShock();

	if (isDefined(self.nightvisionLightEnt))
	{
		self.nightvisionLightEnt Unlink();
		self.nightvisionLightEnt.origin = (0, 0, -2000);
	}
}


makeNightVisionHud()
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


spawnNightVisionEffects()
{
	if (!isDefined(self.nightvisionLightEnt))
	{
		self.nightvisionLightEnt = spawn("script_model", (0, 0, -2000));
		self.nightvisionLightEnt setModel("tag_origin");
		self.nightvisionLightEnt Hide();
		self.nightvisionLightFXPlayed = false;
	}
}


deleteNightVisionEffects()
{
	if (isDefined(self.nightvisionLightEnt))
	{
		self.nightvisionLightEnt Delete();
		self.nightvisionLightFXPlayed = false;
	}
}


forceDisableAll()
{
	self notify ("nv_stop_updating_switch");
	self resetNightVision();
	self deleteNightVisionEffects();
}


switchNightVisionThread()
{
	self endon( "disconnect" );
	self endon( "nv_stop_updating_switch" );

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

			self thread UpdateShellshockThread();

			if (isDefined(self.nightvisionLightEnt))
			{
				self.nightvisionLightEnt.origin = self GetEye() + ( 0, 0, 50 );
				self.nightvisionLightEnt linkto(self);
				self.nightvisionLightEnt ShowToPlayer(self);

				if (!self.nightvisionLightFXPlayed)
				{
					wait 0.1;
					playFxOnTag(level._effect["nv_light"], self.nightvisionLightEnt, "tag_origin");
					self.nightvisionLightFXPlayed = true;
				}
			}
		}

		// TODO: battary logic here
		//wait (2);
		//self ExecClientCommand( "+actionslot 1");
		//wait (0.1);

		self waittill("night_vision_off");

		self resetNightVision();
	}
}


UpdateShellshockThread()
{
	self endon( "nv_stop_updating_shock" );

	for (;;)
	{
		duration = 10;
		self shellshock( "nightvision", duration );
		wait 0.1;
		self AllowSprint (true);
		wait duration;
	}
}
