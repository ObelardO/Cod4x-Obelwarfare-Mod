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
	level.scr_sniperzoom_enable = getdvarx( "scr_sniperzoom_enable", "int", 0, 0, 1 );

	// We'll stay in this module no matter what to set back the default zoom level
	if ( level.scr_sniperzoom_enable == 1 ) {
		level.scr_sniperzoom_lower_levels = getdvarx( "scr_sniperzoom_lower_levels", "int", 8, 0, 8 );
		level.scr_sniperzoom_upper_levels = getdvarx( "scr_sniperzoom_upper_levels", "int", 9, 0, 9 );
		level.scr_sniperzoom_focus_enable = getdvarx( "scr_sniperzoom_focus_enable", "int", 1, 0, 1 );
		
	  // Initialize some variables we'll be using to handle the different zoom levels
	  level.sniperZooms = []; level.sniperZoomsText = [];
	  iZoom = 10 - level.scr_sniperzoom_upper_levels; 
	  iZoomText = 34 - ( 2 * ( 9 - level.scr_sniperzoom_upper_levels ) );
	  upperLevel = 11 + level.scr_sniperzoom_lower_levels;
	  
	  while( iZoom < upperLevel && iZoom < 18 ) {
	   	// Check if this level is the default zoom level
	   	if ( iZoom == 10 ) {
	   		level.sniperZoomDefault = level.sniperZooms.size;
	   	}
	   	
	   	// Add this zoom level to the allowed zoom levels
	   	level.sniperZooms[ level.sniperZooms.size ] = iZoom;
	   	level.sniperZoomsText[ level.sniperZoomsText.size ] = iZoomText;
	   	
	   	// Move to the next zoom level
	   	iZoom++; iZoomText -= 2;
		}
		
		// Add the last zoom level x1
		if ( level.scr_sniperzoom_lower_levels == 8 ) {
			level.sniperZooms[ level.sniperZooms.size ] = 18;
		  level.sniperZoomsText[ level.sniperZoomsText.size ] = 1;
		}
	}

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


onPlayerConnected()
{
	// Only  start the following threads if sniper zoom is enabled
	if ( level.scr_sniperzoom_enable == 1 ) {
		self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
		self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );
	} else {
		self setClientDvar( "cg_fovmin", 10 );
	}
}


onPlayerSpawned()
{
	// Create the HUD element that will show the zoom level
	self.zoomLevelText = newClientHudElem(self);
	self.zoomLevelText.alpha = 0;
	self.zoomLevelText.fontScale = 1.4;
	self.zoomLevelText.font = "objective";
	self.zoomLevelText.archived = true;
	self.zoomLevelText.hideWhenInMenu = false;
	self.zoomLevelText.alignX = "right";
	self.zoomLevelText.alignY = "top";
	self.zoomLevelText.horzAlign = "right";
	self.zoomLevelText.vertAlign = "top";
	self.zoomLevelText.sort = 1001;
	self.zoomLevelText.label = &"&&1x";
	self.zoomLevelText.x = -10;
	self.zoomLevelText.y = 10;	
	
	// Set the default zoom level and start monitoring the player
	self setZoomLevel( level.sniperZoomDefault );
	self.scopeBlur = 0;
	self.scopeBlurSent = 0;
	self.scopeBlurStable = true;
	self thread monitorCurrentWeapon();
	self thread monitorUseMeleeKeys();

	if ( level.scr_sniperzoom_focus_enable == 1 ) {
		self thread monitorScopeFocus();
		self thread clearScopeBlurOnGameEnd();
	}
}


onPlayerDeath()
{
	// Reset the zoom level
	self setClientDvar( "cg_fovmin", level.sniperZooms[ level.sniperZoomDefault ] );
	self clearScopeBlur();
	
	// Destroy the HUD element
	if ( isDefined( self.zoomLevelText ) )
		self.zoomLevelText destroy();		
}


setZoomLevel( sniperZoomLevel )
{
	// Change the zoom level
	self.sniperZoomLevel = sniperZoomLevel;
	self setClientDvar( "cg_fovmin", level.sniperZooms[ sniperZoomLevel ] );
	
	// Update the text element showing the zoom level
	self.zoomLevelText setValue( level.sniperZoomsText[ sniperZoomLevel ] );		
}


monitorCurrentWeapon()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	// Get the current weapon (at this point the player should have the default sniper zoom value
	oldWeapon = self getCurrentWeapon();
	oldAds = 0;
	zoomLevelSet = false;

	for (;;)
	{
		wait (0.05);
		
		// Check if the player has switched weapons
		if ( oldWeapon != self getCurrentWeapon() ) {
			oldWeapon = self getCurrentWeapon();
			if ( zoomLevelSet ) {
				self setClientDvar( "cg_fovmin", level.sniperZooms[ level.sniperZoomDefault ] );
				self clearScopeBlur();
				zoomLevelSet = false;
			}
		} else {
			// Check if the player enable/disable ADS.
			// playerADS() climbs from 0 to 1 during the raise, so wait until the scope is fully up.
			if ( self playerADS() > oldAds ) {
				oldAds = self playerADS();
				if ( !zoomLevelSet && oldAds >= 1 && isSniperRifle( oldWeapon ) ) {
					self setClientDvar( "cg_fovmin", level.sniperZooms[ self.sniperZoomLevel ] );
					self thread updateZoomLevel();	
					zoomLevelSet = true;				
				}
			} else if ( self playerADS() < oldAds ) {
				oldAds = self playerADS();
				// Player is disabling ADS
				if ( zoomLevelSet ) {
					self setClientDvar( "cg_fovmin", level.sniperZooms[ level.sniperZoomDefault ] );
					self clearScopeBlur();
					zoomLevelSet = false;
				}
			}
		}
	}	
}


updateZoomLevel()
{
	// Adjust the location based on the level
	self.zoomLevelText.x = -10 + ( -15 * self.sniperZoomLevel );
	self.zoomLevelText.alpha = 1; 
	self.zoomLevelText fadeOverTime( 1.5 );
	self.zoomLevelText.alpha = 0;	
}


zoomIn()
{
	// Check if sniper zoom is enabled
	if ( level.scr_sniperzoom_enable == 0 )
		return;
	
	// Make sure the player is using a sniper rifle and ADS are active
	if ( self isFullyScoped() && isSniperRifle( self getCurrentWeapon() ) ) {
		if ( self.sniperZoomLevel > 0 ) {
			self.sniperZoomLevel--;
			self thread setZoomLevel( self.sniperZoomLevel );
			self thread updateZoomLevel();
			self kickScopeFocus();
			self playZoomStepSound();
		}
	}	
}


zoomOut()
{
	// Check if sniper zoom is enabled
	if ( level.scr_sniperzoom_enable == 0 )
		return;
	
	// Make sure the player is using a sniper rifle and ADS are active
	if ( self isFullyScoped() && isSniperRifle( self getCurrentWeapon() ) ) {
		if ( self.sniperZoomLevel < level.sniperZooms.size - 1 ) {
			self.sniperZoomLevel++;
			self thread setZoomLevel( self.sniperZoomLevel );
			self thread updateZoomLevel();
			self kickScopeFocus();
			self playZoomStepSound();
		}
	}	
}


isFullyScoped()
{
	return self playerADS() >= 1;
}


isSniperRifle( weapon )
{
	if ( weapon == "m21_mp" )
		return true;
	if ( weapon == "barrett_mp" )
		return true;
	if ( weapon == "dragunov_mp" )
		return true;
	if ( weapon == "m40a3_mp" )
		return true;
	if ( weapon == "remington700_mp" )
		return true;
	return false;
}


monitorUseMeleeKeys()
{
	self endon("disconnect");
	self endon("death");
	
	for (;;)
	{
		wait (0.05);
		
		// Check if one of the keys we are monitoring has been pressed (Use = Zooms In, Melee = Zooms Out)
		if ( self useButtonPressed() ) {
			self thread zoomIn();
		} else if ( self meleeButtonPressed() ) {
			self thread zoomOut();
		}	
	}
}


// Scope goes soft on a zoom step, then sharpens once the zoom stops.
// Same curve as the Zakhaev Barrett in sniperescape_exchange::exchange_scale_dof_while_on_turret:
// one stable frame, then blur *= 0.9 every 0.05s. setblur() is singleplayer-only, so this
// drives the same renderer control per player through r_blur.
playZoomStepSound()
{
	self playLocalSound( "sniper_zoom_step" );
}


kickScopeFocus()
{
	if ( !isDefined( level.scr_sniperzoom_focus_enable ) || level.scr_sniperzoom_focus_enable == 0 )
		return;

	if ( !isDefined( self.scopeBlur ) || self.scopeBlur < 5 )
		self.scopeBlur = 5;
	else
		self.scopeBlur += 0.5;

	if ( self.scopeBlur > 8 )
		self.scopeBlur = 8;

	self.scopeBlurStable = false;
	self applyScopeBlur();
}


monitorScopeFocus()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	for (;;)
	{
		wait (0.05);

		if ( !isDefined( self.scopeBlur ) || self.scopeBlur <= 0 )
			continue;

		if ( !self playerAds() || !isSniperRifle( self getCurrentWeapon() ) ) {
			self clearScopeBlur();
			continue;
		}

		// First frame after the zoom stops does not decay
		if ( !isDefined( self.scopeBlurStable ) || !self.scopeBlurStable ) {
			self.scopeBlurStable = true;
			continue;
		}

		self.scopeBlur = self.scopeBlur * 0.9;
		if ( self.scopeBlur < 0.15 )
			self.scopeBlur = 0;

		self applyScopeBlur();
	}
}


applyScopeBlur()
{
	tenths = int( self.scopeBlur * 10 );
	if ( isDefined( self.scopeBlurSent ) && self.scopeBlurSent == tenths )
		return;

	self.scopeBlurSent = tenths;
	self setClientDvar( "r_blur", tenths * 0.1 );
}


clearScopeBlur()
{
	self.scopeBlur = 0;
	self.scopeBlurStable = true;

	if ( !isDefined( self.scopeBlurSent ) || self.scopeBlurSent == 0 )
		return;

	self.scopeBlurSent = 0;
	self setClientDvar( "r_blur", 0 );
}


clearScopeBlurOnGameEnd()
{
	self endon("disconnect");
	self endon("death");

	level waittill( "game_ended" );
	self clearScopeBlur();
}