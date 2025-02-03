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

	//level.nightVisionFX = loadfx ("nv/light_white_big");
	//level.nightVisionFX = loadfx ("explosions/clusterbomb");


	level._effect["test_nv_fx"] = loadfx( "nv/light_white_big" );


	//return;

	//precacheShader("ac130_overlay_25mm");
	precacheShader("ac130_overlay_grain");

	PreCacheShellShock("nightvision");

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );

	//level.lightFXAass25 = loadfx ("nv/light_white_big");
	//level.nightvision_entity = spawn("script_model", (0, 0, -2000));
	//level.nightvision_entity setModel("tag_origin");
	//wait 0.05;
	

}

onPlayerConnected()
{
	self makeNightVisionHud();
	self resetNightVision();

	self thread switchNightVisionThread();
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
	self thread addNewEvent( "joined_spectators", ::onJoinedSpectators );
	self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );
}

resetNightVision()
{
	self.nvon = false;
	self.laseron = false;

	self setClientDvar("cg_laserforceon", 0);
	self setClientDvar("cg_fovscale", 1);

	if(isDefined(self.grainOverlay))
	{
		self.grainOverlay.alpha = 0.0;
	}

	self notify ("nightvision_shellshock_off");
	self StopShellShock();

	if (isDefined(self.nightvision_entity))
	{
		self.nightvision_entity Unlink();
		self.nightvision_entity.origin = (0, 0, -2000);
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

onPlayerSpawned()
{
	self.nightvision_entity = spawn("script_model", (0, 0, -2000));
	self.nightvision_entity setModel("tag_origin");
	wait 0.05;
	//playFxOnTag(level._effect["test_nv_fx"], self.nightvision_entity, "tag_origin");
	self.nightvision_entity Hide();
	self.nightvision_effect_played = false;

	self resetNightVision();
}

onJoinedSpectators()
{
	self resetNightVision();

	if (isDefined(self.nightvision_entity))
	{
		self.nightvision_entity Delete();
		self.nightvision_effect_played = false;
	}
}

onPlayerDeath()
{
	self resetNightVision();

	if (isDefined(self.nightvision_entity))
	{
		self.nightvision_entity Delete();
		self.nightvision_effect_played = false;
	}
}

switchNightVisionThread()
{
	self endon("disconnect");

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

			self thread doShellshock();

			if (isDefined(self.nightvision_entity))
			{
				self.nightvision_entity.origin = self getTagOrigin( "j_neck" ) + ( 0, 0, 6 );
				self.nightvision_entity linkto(self);
				self.nightvision_entity ShowToPlayer(self);

				if (!self.nightvision_effect_played)
				{
					wait 0.2;
					playFxOnTag(level._effect["test_nv_fx"], self.nightvision_entity, "tag_origin");
					self.nightvision_effect_played = true;
				}
				
			}

			//playFxOnTag(level._effect["test_nv_fx"], level.nightvision_entity, "tag_origin");

			/*
			playfx( level._effect["test_nv_fx"], self.origin );

			if(!isDefined(self.nightVisionModel))
			{
				self.nightVisionModel = spawn( "script_model", self getTagOrigin( "j_neck" ) + ( 0, 0, 6 ));
		 		self.nightVisionModel setModel( "tag_origin" );
		 		self.nightVisionModel linkto( self );

				//self.nightVisionModel.origin = self getTagOrigin( "j_neck" ) + ( 0, 0, 6 );
				//self.nightVisionModel linkto("j_neck");
				playfxontag( level.nightVisionFX, self.nightVisionModel, "tag_origin" );
			}
			*/
		}

		//wait (2);
		//self ExecClientCommand( "+actionslot 1");
		//wait (0.1);

		self waittill("night_vision_off");

		self resetNightVision();
	}
}

doShellshock()
{
	self endon( "nightvision_shellshock_off" );

	for (;;)
	{
		duration = 10;
		self shellshock( "nightvision", duration );
		wait 0.1;
		self AllowSprint (true);
		wait duration;
	}
}
