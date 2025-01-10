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

#include openwarfare\_eventmanager;
#include openwarfare\_utils;

init()
{
	//return;

	//precacheShader("ac130_overlay_25mm");
	precacheShader("ac130_overlay_grain");

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}

onPlayerConnected()
{
	self.nvon = false;
	self.laseron = false;

	self thread laser_nv();
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
	self thread addNewEvent( "joined_spectators", ::onJoinedSpectators );
	self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );

	self setClientDvar("cg_laserforceon", 0);
	self setClientDvar("cg_fovscale", 1);
}

onPlayerSpawned()
{
	self.nvon = false;
	self.laseron = false;

	self setClientDvar("cg_laserforceon", 0);
	self setClientDvar("cg_fovscale", 1);

	if(isDefined(self.grainOverlay))
	{
		self.grainOverlay.alpha = 0.0;
	}
}

onJoinedSpectators()
{
	self.nvon = false;
	self.laseron = false;

	self setClientDvar("cg_laserforceon", 0);
	self setClientDvar("cg_fovscale", 1);

	//self iPrintlnBold("^2NABLUDENIE");

	if(isDefined(self.grainOverlay))
	{
		self.grainOverlay.alpha = 0.0;
	}
}

onPlayerDeath()
{
	self.nvon = false;
	self.laseron = false;

	self setClientDvar("cg_laserforceon", 0);
	self setClientDvar("cg_fovscale", 1);

	//self iPrintlnBold("^2DEATH");

	if(isDefined(self.grainOverlay))
	{
		self.grainOverlay.alpha = 0.0;
	}
}


laser_nv()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("night_vision_on");
		self.nvon = true;

		if(!self.laseron)
		{
			self setClientDvar("cg_laserforceon", 1);
			self setClientDvar("cg_fovscale", 0.85);
			self.laseron = true;
		}

		if(!isDefined(self.grainOverlay))
		{
			self.grainOverlay = newClientHudElem( self );
			self.grainOverlay.x = 0;
			self.grainOverlay.y = 0;
			self.grainOverlay.alignX = "left";
			self.grainOverlay.alignY = "top";
			self.grainOverlay.horzAlign = "fullscreen";
			self.grainOverlay.vertAlign = "fullscreen";
			self.grainOverlay setshader ("ac130_overlay_grain", 640, 480);
			self.grainOverlay.alpha = 0.4;
			self.grainOverlay.sort = -100;
		}
		else
		{
			self.grainOverlay.alpha = 0.3;
		}

		//wait (2);
		//self ExecClientCommand( "+actionslot 1");
		//wait (0.1);

		self waittill("night_vision_off");
		self.nvon = false;

		if(self.laseron)
		{
			self setClientDvar("cg_laserforceon", 0);
			self setClientDvar("cg_fovscale", 1);
			self.laseron = false;
		}

		if(isDefined(self.grainOverlay))
		{
			self.grainOverlay.alpha = 0.0;
		}
	}
}