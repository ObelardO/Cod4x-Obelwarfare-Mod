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

	self setClientDvars("cg_laserforceon", 0);
}

onPlayerSpawned()
{
	self.nvon = false;
	self.laseron = false;

	self setClientDvars("cg_laserforceon", 0);
}

onJoinedSpectators()
{
	self.nvon = false;
	self.laseron = false;

	self setClientDvars("cg_laserforceon", 0);

	//self iPrintlnBold("^2NABLUDENIE");
}

onPlayerDeath()
{
	self.nvon = false;
	self.laseron = false;

	self setClientDvars("cg_laserforceon", 0);

	//self iPrintlnBold("^2DEATH");
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
			self.laseron = true;
		}

		//wait (2);
		//self ExecClientCommand( "+actionslot 1");
		//wait (0.1);

		self waittill("night_vision_off");
		self.nvon = false;

		if(self.laseron)
		{
			self setClientDvar("cg_laserforceon", 0);
			self.laseron = false;
		}
	}
}