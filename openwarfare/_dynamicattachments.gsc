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
	level.scr_dynamic_attachments_enable = getdvarx( "scr_dynamic_attachments_enable", "int", 0, 0, 3 );

	// If dynamic attachments is disabled there's nothing else to do here
	if ( level.scr_dynamic_attachments_enable == 0 )
		return;

	precacheString( &"OW_DYNATTACH_INSTALLING" );
	precacheString( &"OW_DYNATTACH_INSTALLED" );
	precacheString( &"OW_DYNATTACH_REMOVED_ALL" );
	precacheString( &"MPUI_SILENCER" );
	precacheString( &"MPUI_RED_DOT_SIGHT" );
	precacheString( &"MPUI_ACOG_SCOPE" );

	level.attachments = [];
	level.attachments[0]["tag"] = "";
	level.attachments[0]["weapons"] = "";
	level.attachments[0]["name"] = "";

	level.attachments[1]["tag"] = "_silencer_";
	level.attachments[1]["weapons"] = "ak47_mp;ak74u_mp;beretta_mp;colt45_mp;g36c_mp;g3_mp;m14_mp;m16_mp;m4_mp;mp5_mp;p90_mp;skorpion_mp;usp_mp;uzi_mp";
	level.attachments[1]["name"] = &"MPUI_SILENCER";

	level.attachments[2]["tag"] = "_reflex_";
	level.attachments[2]["weapons"] = "ak47_mp;ak74u_mp;g36c_mp;g3_mp;m1014_mp;m14_mp;m16_mp;m4_mp;m60e4_mp;mp5_mp;p90_mp;rpd_mp;saw_mp;skorpion_mp;uzi_mp;winchester1200_mp";
	level.attachments[2]["name"] = &"MPUI_RED_DOT_SIGHT";

	level.attachments[3]["tag"] = "_acog_";
	level.attachments[3]["weapons"] = "ak47_mp;ak74u_mp;g36c_mp;g3_mp;m1014_mp;m14_mp;m16_mp;m4_mp;m60e4_mp;mp5_mp;p90_mp;rpd_mp;saw_mp;skorpion_mp;uzi_mp;winchester1200_mp";
	level.attachments[3]["name"] = &"MPUI_ACOG_SCOPE";

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


onPlayerConnected()
{
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
}	


onPlayerSpawned()
{
	self.attachmentAction = false;
}


attachDetachAttachment()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	// Make sure this module is active
	if ( level.scr_dynamic_attachments_enable == 0 || !isAlive(self) )
		return;
	
	// Initiate attaching/detaching action. If there's already another action running we'll cancel the request
	if ( self.attachmentAction ) return;

	// Get weapon and attachment
	currentWeapon = self getCurrentWeapon();
	attachment = getWeaponAttachment( currentWeapon );
	baseWeapon = getWeaponWithoutAttachments ( currentWeapon, attachment );
	newAttachment = "";
	newAttachmentName = "";
	
	// Get next attachment 
	if (level.scr_dynamic_attachments_enable > 0)
	{
		attachmentDetected = false;

		for ( i = 0; i <= level.scr_dynamic_attachments_enable; i++ )
		{
			if (!attachmentDetected && level.attachments[i]["tag"] == attachment)
				attachmentDetected = true;

			if (attachmentDetected && level.attachments[i]["tag"] != attachment && isWeaponValidForAttachment(currentWeapon, baseWeapon, level.attachments[i]["tag"]))
			{
				newAttachment = level.attachments[i]["tag"];
				newAttachmentName = level.attachments[i]["name"];
				break;
			}
		}
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
		self.attachmentAction = true;

		// Get the ammo info for the current weapon
		totalAmmo = self getAmmoCount( currentWeapon );
		clipAmmo = self getWeaponAmmoClip( currentWeapon );

		// Disable the player's weapons
		self thread maps\mp\gametypes\_gameobjects::_disableWeapon();

		// Wait for certain time to complete the requested action
		self playSound( "US_1mc_rsp_comeon" );
		xWait (2);

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
		self thread maps\mp\gametypes\_gameobjects::_enableWeapon();
		self.attachmentAction = false;		
	}
	
}


getWeaponAttachment( currentWeapon )
{
	// Check if the weapon is a special firing mode weapon
	if ( isSubStr( currentWeapon, "_single_" ) || isSubStr( currentWeapon, "_burst_" ) || isSubStr( currentWeapon, "_full_" ) )
		return "";

	// Check if the current weapon is valid for detachment
	for ( i = 1; i <= level.scr_dynamic_attachments_enable; i++ )
	{
		if ( isSubStr( currentWeapon, level.attachments[i]["tag"] ) )
		{
			baseWeapon = getWeaponWithoutAttachments( currentWeapon, level.attachments[i]["tag"] );

			if ( isSubStr( level.attachments[i]["weapons"], baseWeapon ) ) return level.attachments[i]["tag"];
		}
	}

	return "";
}


isWeaponValidForAttachment( currentWeapon, baseWeapon, attachment	)
{
	// Check if the weapon is a special firing mode weapon
	if ( isSubStr( currentWeapon, "_single_" ) || isSubStr( currentWeapon, "_burst_" ) || isSubStr( currentWeapon, "_full_" ) )
		return false;

	// Check if the current weapon is valid for the attachment that the player has
	for ( i = 1; i <= level.scr_dynamic_attachments_enable; i++ )
	{
		if (level.attachments[i]["tag"] == attachment && isSubStr( level.attachments[i]["weapons"], baseWeapon ) ) return true;
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

playSoundinSpace( alias, origin )
{
	org = spawn( "script_origin", origin );
	org.origin = origin;
	org playSound( alias  );
	wait 10; // MP doesn't have "sounddone" notifies =(
	org delete();
}