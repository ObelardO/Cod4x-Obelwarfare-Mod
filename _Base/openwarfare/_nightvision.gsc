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

#include openwarfare\_utils;
#include openwarfare\_eventmanager;

init()
{
	level.scr_nvs_enabled = getDvarx( "scr_nvs_enabled", "int", 1, 0, 1 ) && getDvarx( "scr_enable_nightvision", "int", 1, 0, 1 );

	// If night vision system is disabled then there's nothing else to do here
	if ( level.scr_nvs_enabled == 0 )
		return;

	level.scr_nvs_grain_enabled = getDvarx( "scr_nvs_grain_enabled", "int", 1, 0, 1 );
	level.scr_nvs_grain_power = getDvarx( "scr_nvs_grain_power", "float", 0.2, 0, 1 );

	level.scr_nvs_shock_enabled = getDvarx( "scr_nvs_shock_enabled", "int", 1, 0, 1 );
	level.scr_nvs_laser_enabled = getDvarx( "scr_nvs_laser_enabled", "int", 1, 0, 1 );
	level.scr_nvs_light_enabled = getDvarx( "scr_nvs_light_enabled", "int", 1, 0, 1 );

	level.scr_nvs_thick_enabled = getDvarx( "scr_nvs_thick_enabled", "int", 1, 0, 1 );
	level.scr_nvs_thick_power = getDvarx( "scr_nvs_thick_power", "float", 0.2, 0, 1 );

	level.scr_nvs_fovscale_enabled = getDvarx( "scr_nvs_fovscale_enabled", "int", 1, 0, 1 );
	level.scr_nvs_fovscale_power = getDvarx( "scr_nvs_fovscale_power", "float", 0.9, 0.5, 1 );

	if ( !isDefined( game["nvs"] ) )
	{
		game["nvs"] = [];
		game["nvs"]["light_fx"] = loadFx( "nv/light_white_big" );

		//if ( level.scr_nvs_grain_enabled )
		game["nvs"]["grain_shader"] = preCacheShader( "ac130_overlay_grain" );

		//if ( level.scr_nvs_shock_enabled )
		game["nvs"]["night_shock"] = PreCacheShellShock( "nightvision" );
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
	if ( !level.scr_nvs_grain_enabled ) return;

	// Laser visual improvements
	// TODO: Move it to config or csv
	self setClientDvar( "cg_laserEndOffset",        "0.5" );
	self setClientDvar( "cg_laserFlarePct",         "0.2" );
	self setClientDvar( "cg_laserLight",            "1"   );
	self setClientDvar( "cg_laserLightBeginOffset", "13"  );
	self setClientDvar( "cg_laserLightBodyTweak",   "15"  );
	self setClientDvar( "cg_laserLightEndOffset",   "-3"  );
	self setClientDvar( "cg_laserLightRadius",      "1.7" );
	self setClientDvar( "cg_laserRadius",           "0.5" );
	self setClientDvar( "cg_laserRange",            "500" );
	self setClientDvar( "cg_laserRangePlayer",      "500" );
}

setupGrainEffect()
{
	self.nvsGrainEffectHud = newClientHudElem( self );
	self.nvsGrainEffectHud.x = 0;
	self.nvsGrainEffectHud.y = 0;
	self.nvsGrainEffectHud.alignX = "left";
	self.nvsGrainEffectHud.alignY = "top";
	self.nvsGrainEffectHud.horzAlign = "fullscreen";
	self.nvsGrainEffectHud.vertAlign = "fullscreen";
	self.nvsGrainEffectHud setshader( "ac130_overlay_grain", 640, 480 );
	self.nvsGrainEffectHud.alpha = 0.0;
	self.nvsGrainEffectHud.sort = -1000;
}

setupLightEffect()
{
	if( !isDefined( self.nvsLightEffectEntity ) )
	{
		self.nvsLightEffectEntity = spawn( "script_model" , ( 0, 0, -2000 ) );
		self.nvsLightEffectEntity setModel( "tag_origin" );
		self.nvsLightEffectEntity Hide();
		self.nvsLightEffectFxPlayed = false;
	}
}

removeLightEffect()
{
	if( isDefined( self.nvsLightEffectEntity ) )
	{
		self.nvsLightEffectEntity Delete();
		self.nvsLightEffectFxPlayed = false;
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
	if( level.scr_nvs_shock_enabled )
	{
		self notify( "nvs_stop_shock_thread" );
		self stopShellShock();
	}

	// Reset laser effect
	if( level.scr_nvs_laser_enabled )
	{
		self.laseron = false;
		self setClientDvar( "cg_laserforceon", 0 );
	}

	// Reset FOV effect
	if ( level.scr_nvs_fovscale_enabled )
	{
		self setClientDvar( "cg_fovscale", 1 );
	}

	// Reset grain effect
	if( isDefined( self.nvsGrainEffectHud ) )
	{
		self.nvsGrainEffectHud.alpha = 0.0;
	}

	// Reset light effect
	if( isDefined( self.nvsLightEffectEntity ) )
	{
		self.nvsLightEffectEntity Unlink();
		self.nvsLightEffectEntity.origin = (0, 0, -2000);
	}

	// Reset thick effect
	if( level.scr_nvs_thick_enabled )
	{
		self thread openwarfare\_speedcontrol::setModifierSpeed( "_night_vision", 0 );
	}
}


switchVisionThread()
{
	self endon( "nvs_stop_switch_thread" );
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "night_vision_on" );

		if( !self.nvon )
		{
			self.nvon = true;

			if( level.scr_nvs_laser_enabled )
			{
				self.laseron = true;
				self setClientDvar( "cg_laserforceon", 1 );
			}

			if( level.scr_nvs_fovscale_enabled )
			{
				self setClientDvar( "cg_fovscale", level.scr_nvs_fovscale_power );
			}
			
			if( level.scr_nvs_grain_enabled && isDefined( self.nvsGrainEffectHud ) )
			{
				self.nvsGrainEffectHud.alpha = level.scr_nvs_grain_power;
			}

			if( level.scr_nvs_shock_enabled )
			{
				self thread updateShockThread();
			}

			if( level.scr_nvs_light_enabled && isDefined( self.nvsLightEffectEntity ) )
			{
				self.nvsLightEffectEntity.origin = self getEye() + ( 0, 0, 50 );
				self.nvsLightEffectEntity linkto( self );
				self.nvsLightEffectEntity showToPlayer( self );

				if ( !self.nvsLightEffectFxPlayed )
				{
					wait 0.1;
					playFxOnTag( game["nvs"]["light_fx"], self.nvsLightEffectEntity, "tag_origin" );
					self.nvsLightEffectFxPlayed = true;
				}
			}

			if( level.scr_nvs_thick_enabled )
			{
				self thread openwarfare\_speedcontrol::setModifierSpeed( "_night_vision", level.scr_nvs_thick_power * 100 );
			}
		}

		// TODO: battary logic here
		//wait (2);
		//self ExecClientCommand( "+actionslot 1");
		//wait (0.1);

		self waittill( "night_vision_off" );

		self resetAllEffects();
	}
}


updateShockThread()
{
	self endon( "nvs_stop_shock_thread" );
	self endon( "disconnect" );

	for (;;)
	{
		duration = 10;
		self shellshock( "nightvision", duration );
		wait 0.1;
		self allowSprint( true );
		wait duration;
	}
}


resetAll()
{
	self notify( "nvs_stop_switch_thread" );
	self resetAllEffects();
	self removeLightEffect();
}