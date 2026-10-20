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
	// Get the main module's dvar
	level.scr_rangefinder_enable = getdvarx( "scr_rangefinder_enable", "int", 0, 0, 2 );

	// If range finder is disabled there's nothing else to do here
	if ( level.scr_rangefinder_enable == 0 )
		return;
		
	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


onPlayerConnected()
{
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
	self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );
}


onPlayerSpawned()
{
	// Create the HUD element that will show the zoom level
	self.rangeFinder = newClientHudElem(self);
	self.rangeFinder.alpha = 0;
	self.rangeFinder.fontScale = 1.4;
	self.rangeFinder.color = (0.8,0.8,0.8);
	self.rangeFinder.font = "objective";
	self.rangeFinder.archived = true;
	self.rangeFinder.hideWhenInMenu = false;
	self.rangeFinder.alignX = "center";
	self.rangeFinder.alignY = "bottom";
	self.rangeFinder.horzAlign = "center";
	self.rangeFinder.vertAlign = "bottom";
	self.rangeFinder.sort = 1001;
	self.rangeFinder.x = 0;
	self.rangeFinder.y = -20;
	
	// Check which unit we should show
	if ( level.scr_rangefinder_enable == 1 ) {
		self.rangeFinder.label = &"OW_RANGEFINDER_YARDS";
	} else {
		self.rangeFinder.label = &"OW_RANGEFINDER_METERS";
	}
	
	// Start monitoring the player
	self thread monitorCurrentWeapon();
}


onPlayerDeath()
{
	// Destroy the HUD element
	if ( isDefined( self.rangeFinder ) )
		self.rangeFinder destroy();		
}


monitorCurrentWeapon()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	// Get the current weapon (at this point the player should have the default sniper zoom value
	oldWeapon = self getCurrentWeapon();
	oldAds = 0;
	updateRangeFinder = false;
	
	// Define which multiplier to use
	if ( level.scr_rangefinder_enable == 1 ) {
		distMultiplier = 0.0278;
	} else {
		distMultiplier = 0.0254;
	}

	for (;;)
	{
		wait (0.05);
		
		// Check if the player has switched weapons
		if ( oldWeapon != self getCurrentWeapon() ) {
			oldWeapon = self getCurrentWeapon();
			self.rangeFinder.alpha = 0;
			updateRangeFinder = false;
		} else {
			// Wait until the scope animation has finished before showing the range
			if ( self playerADS() > oldAds ) {
				oldAds = self playerADS();
				if ( oldAds >= 1 && ( openwarfare\_sniperzoom::isSniperRifle( oldWeapon ) || oldWeapon == "binoculars_mp" ) ) {
					self.rangeFinder.alpha = 1;
					updateRangeFinder = true;
				}
			} else if ( self playerADS() < oldAds ) {
				oldAds = self playerADS();
				// Player is disabling ADS
				self.rangeFinder.alpha = 0;
				updateRangeFinder = false;
			}
		}
		
		// Check if we need to update the value for range finder
		if ( updateRangeFinder) {
			// Get a vector forward based on the player's angles
			vForward = maps\mp\_utility::vector_scale( anglesToForward( self getPlayerAngles() ), 50000 );
			
			// Run the trace
			playerEyes = self getPlayerEyes();
			trace = bulletTrace( playerEyes, playerEyes + vForward, true, self );
			distance = int( distance( playerEyes, trace["position"] ) * distMultiplier * 10 ) / 10;

			// Update the HUD element
			self.rangeFinder setValue( distance );			
		}
	}	
}
