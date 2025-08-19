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
	level.scr_enable_dynamic_attachments = getdvarx( "scr_enable_dynamic_attachments", "int", 0, 0, 3 );

	// If dynamic attachments is disabled there's nothing else to do here
	if ( level.scr_enable_dynamic_attachments == 0 )
		return;

	if( level.scr_enable_dynamic_attachments == 0 || !level.rankedMatch || level.oldschool )
        return;

    if( !isDefined( level.dynAttach ) )
    {
        level.dynAttach = spawnStruct();
    }

	if( !isDefined( level.dynAttach.initialized ) )
    {
		level.dynAttach.attachments = [];
		level.dynAttach.attachments[0]["tag"] = "";
		level.dynAttach.attachments[0]["weapons"] = "";
		level.dynAttach.attachments[0]["name"] = "";

		level.dynAttach.attachments[1]["tag"] = "_silencer_";
		level.dynAttach.attachments[1]["weapons"] = "ak47_mp;ak74u_mp;beretta_mp;colt45_mp;g36c_mp;g3_mp;m14_mp;m16_mp;m4_mp;mp5_mp;p90_mp;skorpion_mp;usp_mp;uzi_mp";
		level.dynAttach.attachments[1]["name"] = &"MPUI_SILENCER";

		level.dynAttach.attachments[2]["tag"] = "_reflex_";
		level.dynAttach.attachments[2]["weapons"] = "ak47_mp;ak74u_mp;g36c_mp;g3_mp;m1014_mp;m14_mp;m16_mp;m4_mp;m60e4_mp;mp5_mp;p90_mp;rpd_mp;saw_mp;skorpion_mp;uzi_mp;winchester1200_mp";
		level.dynAttach.attachments[2]["name"] = &"MPUI_RED_DOT_SIGHT";

		level.dynAttach.attachments[3]["tag"] = "_acog_";
		level.dynAttach.attachments[3]["weapons"] = "ak47_mp;ak74u_mp;g36c_mp;g3_mp;m1014_mp;m14_mp;m16_mp;m4_mp;m60e4_mp;mp5_mp;p90_mp;rpd_mp;saw_mp;skorpion_mp;uzi_mp;winchester1200_mp";
		level.dynAttach.attachments[3]["name"] = &"MPUI_ACOG_SCOPE";

		precacheString( &"OW_DYNATTACH_INSTALLING" );
		precacheString( &"OW_DYNATTACH_INSTALLED" );
		precacheString( &"OW_DYNATTACH_INSTALL_ERROR" );
		precacheString( &"OW_DYNATTACH_REMOVED_ALL" );

		precacheString( &"OW_DYNATTACH_MENU_INSTALL" );
		precacheString( &"OW_DYNATTACH_MENU_1_SILENCER" );
		precacheString( &"OW_DYNATTACH_MENU_2_REFLEX" );
		precacheString( &"OW_DYNATTACH_MENU_3_ACOG" );
		precacheString( &"OW_DYNATTACH_MENU_4_REMOVE" );
		precacheString( &"OW_DYNATTACH_MENU_BACK" );

		precacheString( &"MPUI_SILENCER" );
		precacheString( &"MPUI_RED_DOT_SIGHT" );
		precacheString( &"MPUI_ACOG_SCOPE" );

		forceClientDvar( "cl_ow_das_enabled", level.scr_enable_dynamic_attachments );

		level.dynAttach.menu = "dynamic_attachments";
		
		precacheMenu( level.dynAttach.menu );

		level.dynAttach.initialized = true;
	}

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );

	level thread waitPrematchOverThread();	
}

onPlayerConnected()
{
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
	self thread addNewEvent( "onPlayerKilled", ::onPlayerKilled );
}	

onPlayerSpawned()
{
	self.dynAttachInProgress = false;
}

onPlayerKilled()
{
	if ( isDefined( self.dynAttachInProgress ) && self.dynAttachInProgress ) 
	{
		self.dynAttachInProgress = false;
		self updateSecondaryProgressBar( undefined, undefined, true, undefined );
	}
}


waitPrematchOverThread()
{
	level.dynAttach.prematchOver = false;

	level waittill( "prematch_over" );

	level.dynAttach.prematchOver = true;
}


openDynamicAttachmentsMenu()
{
	if ( !isChangeAttacmentsAllowed() ) return;

	self setupMenuDvars();

	self openMenuNoMouse( level.dynAttach.menu );
}

setupMenuDvars()
{
	currentWeapon = self getCurrentWeapon();
	currentAttachment = getWeaponAttachment( currentWeapon );
	currentBaseWeapon = getWeaponWithoutAttachments ( currentWeapon, currentAttachment );

	//for ( i = 1; i <= level.scr_enable_dynamic_attachments; i++ )
	for ( i = 1; i < level.dynAttach.attachments.size; i++ )
	{
		checkAttachment = level.dynAttach.attachments[i]["tag"];
		mdvarName = "cl_ow_das" +checkAttachment+ "allowed";

		if ( checkAttachment == currentAttachment || i > level.scr_enable_dynamic_attachments )
		{
			self setClientDvar( mdvarName, "0" );
			continue;
		}

		if ( isWeaponValidForAttachment(currentWeapon, currentBaseWeapon, checkAttachment ) )
		{
			self setClientDvar( mdvarName, "1" );
		}
		else
		{
			self setClientDvar( mdvarName, "0" );
		}
	}

	if ( currentWeapon == currentBaseWeapon )
	{
		self setClientDvar( "cl_ow_das_none_allowed", "0" );
	}
	else
	{
		self setClientDvar( "cl_ow_das_none_allowed", "1" );
	}
}


installAttachment( newAttachment )
{
	if ( !isChangeAttacmentsAllowed() ) return;

	self endon("disconnect");
	self endon("death");
	level endon("game_ended");

	// Get weapon and attachment
	currentWeapon = self getCurrentWeapon();
	attachment = getWeaponAttachment( currentWeapon );
	baseWeapon = getWeaponWithoutAttachments ( currentWeapon, attachment );
	newAttachmentName = "";
	
	// Alias for direct function call from menus
	if (newAttachment == "none") newAttachment = "";

	// Get next attachment 
	if (newAttachment == "next")
	{
		attachmentDetected = false;

		for ( i = 0; i <= level.scr_enable_dynamic_attachments; i++ )
		{
			if (!attachmentDetected && level.dynAttach.attachments[i]["tag"] == attachment)
				attachmentDetected = true;

			if (attachmentDetected && level.dynAttach.attachments[i]["tag"] != attachment && isWeaponValidForAttachment(currentWeapon, baseWeapon, level.dynAttach.attachments[i]["tag"]))
			{
				newAttachment = level.dynAttach.attachments[i]["tag"];
				newAttachmentName = level.dynAttach.attachments[i]["name"];
				break;
			}
		}
	}
	// Get specifited attachment
	else if (isWeaponValidForAttachment(currentWeapon, baseWeapon, newAttachment))
	{
		newAttachmentName = getWeaponAttachmentName( newAttachment );
	}
	// Specifited attachment is not supported on this weapon
	else if (newAttachment != "")
	{
		newAttachmentName = getWeaponAttachmentName( newAttachment );
		self iprintln( &"OW_DYNATTACH_INSTALL_ERROR", newAttachmentName );
		return;
	}

	/* Debug output
	iprintln("Weapon: " + currentWeapon);
	iprintln("Base Weapon: " + baseWeapon);
	iprintln("Attachment: " + attachment);
	iprintln("New attachment: " + newAttachment);
	*/

	// If new attacment can be installed
	if (newAttachment != attachment)
	{
		self.dynAttachInProgress = true;

		// Get the ammo info for the current weapon
		totalAmmo = self getAmmoCount( currentWeapon );
		clipAmmo = self getWeaponAmmoClip( currentWeapon );

		// Disable the player's weapons
		//self thread maps\mp\gametypes\_gameobjects::_disableWeapon();
		self stopPlayer( true );

		// Wait for certain time to complete the requested action
		self thread playSoundinSpace ( "dyn_attach_change", self.origin );

		changeTimer = 0;

		// If attachment installed, add 2 seconds for removing it
		if ( attachment != "" ) changeTimer += 2;

		// If new attachment will be installed, add 2 seconds
		if ( newAttachment != "" ) changeTimer += 2;

		// Wait and display progress
		self thread displayProgressBar ( changeTimer * 1000 );
		wait (changeTimer);

		// Take the current weapon from the player
		self takeWeapon( currentWeapon );

		if (newAttachment == "")
		{
			newWeapon = baseWeapon;

			self iprintln( &"OW_DYNATTACH_REMOVED_ALL" );
		}
		else
		{
			newWeapon = getSubStr( baseWeapon, 0, baseWeapon.size - 3 ) +newAttachment+ "mp";

			self iprintln( &"OW_DYNATTACH_INSTALLED", newAttachmentName );
		}

		if ( isDefined( self.camo_num ) ) {
			self giveWeapon( newWeapon, self.camo_num );
		} else {
			self giveWeapon( newWeapon );
		}

		// Assign the proper ammo again
		self setWeaponAmmoClip( newWeapon, clipAmmo );
		self setWeaponAmmoStock( newWeapon, totalAmmo - clipAmmo );
		
		self switchToWeapon( newWeapon );

		//self thread maps\mp\gametypes\_gameobjects::_enableWeapon();
		self stopPlayer( false );

		self.dynAttachInProgress = false;		
	}
}


getWeaponAttachment( currentWeapon )
{
	// Check if the weapon is a special firing mode weapon
	if ( isSubStr( currentWeapon, "_single_" ) || isSubStr( currentWeapon, "_burst_" ) || isSubStr( currentWeapon, "_full_" ) )
		return "";

	// Check if the current weapon is valid for detachment
	for ( i = 1; i <= level.scr_enable_dynamic_attachments; i++ )
	{
		if ( isSubStr( currentWeapon, level.dynAttach.attachments[i]["tag"] ) )
		{
			baseWeapon = getWeaponWithoutAttachments( currentWeapon, level.dynAttach.attachments[i]["tag"] );

			if ( isSubStr( level.dynAttach.attachments[i]["weapons"], baseWeapon ) ) return level.dynAttach.attachments[i]["tag"];
		}
	}

	return "";
}


getWeaponAttachmentName( attachment )
{	
	for ( i = 1; i <= level.scr_enable_dynamic_attachments; i++ )
	{
		if ( level.dynAttach.attachments[i]["tag"] == attachment )
		{
			return level.dynAttach.attachments[i]["name"];
		}
	}

	return "";
}


isWeaponValidForAttachment( currentWeapon, baseWeapon, attachment )
{
	// Check if the weapon is a special firing mode weapon
	if ( isSubStr( currentWeapon, "_single_" ) || isSubStr( currentWeapon, "_burst_" ) || isSubStr( currentWeapon, "_full_" ) )
		return false;

	// Check if the current weapon is valid for the attachment that the player has
	for ( i = 1; i <= level.scr_enable_dynamic_attachments; i++ )
	{
		if (level.dynAttach.attachments[i]["tag"] == attachment && isSubStr( level.dynAttach.attachments[i]["weapons"], baseWeapon ) ) return true;
	}

	return false;	
}


getWeaponWithoutAttachments( currentWeapon, attachment )
{
	if (attachment != "")
	{
		return getSubStr( currentWeapon, 0, currentWeapon.size - attachment.size - 2 ) + "_mp";
	}

	return currentWeapon;
}


stopPlayer( condition )
{
	if ( condition )
	{
		self thread openwarfare\_speedcontrol::setModifierSpeed( "_dynamic_attachments", 80 );
		self thread maps\mp\gametypes\_gameobjects::_disableWeapon();
		self thread maps\mp\gametypes\_gameobjects::_disableJump();
		self thread maps\mp\gametypes\_gameobjects::_disableSprint();
	}
	else
	{
		self thread openwarfare\_speedcontrol::setModifierSpeed( "_dynamic_attachments", 0 );
		self thread maps\mp\gametypes\_gameobjects::_enableWeapon();
		self thread maps\mp\gametypes\_gameobjects::_enableJump();
		self thread maps\mp\gametypes\_gameobjects::_enableSprint();
	}
}


displayProgressBar( totalTime )
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");

	time = 0;
	startTime = openwarfare\_timer::getTimePassed();

	while ( time < totalTime )
	{
		wait (0.01);

		self updateSecondaryProgressBar( time, totalTime, false, &"OW_DYNATTACH_INSTALLING" );

		time = openwarfare\_timer::getTimePassed() - startTime;
	}

	self updateSecondaryProgressBar( undefined, undefined, true, undefined );
}


playSoundinSpace( alias, origin )
{
	org = spawn( "script_origin", origin );
	org.origin = origin;
	org playSound( alias  );
	wait 5; // MP doesn't have "sounddone" notifies =(
	org delete();
}


isChangeAttacmentsAllowed()
{
	if ( level.scr_enable_dynamic_attachments == 0 || !isAlive( self ) ) return false;

	if ( self.dynAttachInProgress || self isSpectating() || isRoundPaused() ) return false;

	return true;
}


isRoundPaused()
{
	return /*level.inReadyUpPeriod || level.inStrategyPeriod ||*/ level.inPrematchPeriod || level.inTimeoutPeriod /*|| level.inGracePeriod*/ || game["state"] == "postgame";
}
