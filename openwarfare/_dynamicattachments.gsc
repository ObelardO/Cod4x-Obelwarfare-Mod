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

	level.attachments = [];
	level.attachments[0] = "";
	level.attachments[1] = "_silencer_";
	level.attachments[2] = "_reflex_";
	level.attachments[3] = "_acog_";

	level.validWeapons = [];
	level.validWeapons["_silencer_"] = "ak47_mp;ak74u_mp;beretta_mp;colt45_mp;g36c_mp;g3_mp;m14_mp;m16_mp;m4_mp;mp5_mp;p90_mp;skorpion_mp;usp_mp;uzi_mp";
	level.validWeapons["_reflex_"] = "ak47_mp;ak74u_mp;g36c_mp;g3_mp;m1014_mp;m14_mp;m16_mp;m4_mp;m60e4_mp;mp5_mp;p90_mp;rpd_mp;saw_mp;skorpion_mp;uzi_mp;winchester1200_mp";
	level.validWeapons["_acog_"] =  "ak47_mp;ak74u_mp;barrett_mp;dragunov_mp;g36c_mp;g3_mp;m14_mp;m16_mp;m21_mp;m40a3_mp;m4_mp;m60e4_mp;mp5_mp;p90_mp;remington700_mp;rpd_mp;saw_mp;skorpion_mp;uzi_mp";

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
	attachment = validForDetachmentAction( currentWeapon );
	newAttachment = "";
	baseWeapon = currentWeapon;
	
	// Get base weapon without attacments
	if (attachment != "")
	{
		baseWeapon = getSubStr( currentWeapon, 0, currentWeapon.size - attachment.size - 2 ) + "_mp";
	}

	iprintln("Weapon: " + currentWeapon);
	iprintln("Base Weapon: " + baseWeapon);
	iprintln("Attachment: " + attachment);

	// Get next attachment 
	if (level.scr_dynamic_attachments_enable > 0)
	{
		attachmentDetected = false;

		for ( i = 0; i <= level.scr_dynamic_attachments_enable; i++ )
		{
			if (!attachmentDetected && level.attachments[i] == attachment)
				attachmentDetected = true;

			if (attachmentDetected && level.attachments[i] != attachment && validForAttachmentAction(baseWeapon, level.attachments[i]))
			{
				newAttachment = level.attachments[i];
				break;
			}
		}
	}

	iprintln("New attachment: " + newAttachment);
	
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

			iprintlnbold("All attachments removed.");
		}
		else
		{
			newWeapon = getSubStr( baseWeapon, 0, baseWeapon.size - 3 ) + newAttachment + "mp";

			iprintlnbold("Attachment installed: ^3" + newAttachment + " to " + baseWeapon);
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


validForDetachmentAction( currentWeapon )
{
	// Check if the weapon is a special firing mode weapon
	if ( isSubStr( currentWeapon, "_single_" ) || isSubStr( currentWeapon, "_burst_" ) || isSubStr( currentWeapon, "_full_" ) )
		return "";

	// Check if the current weapon is valid for detachment
	for ( i = 1; i <= level.scr_dynamic_attachments_enable; i++ )
	{
		if ( isSubStr( currentWeapon, level.attachments[i] ) )
		{
			baseWeapon = getSubStr( currentWeapon, 0, currentWeapon.size - level.attachments[i].size - 2 ) + "_mp";

			if ( isSubStr( level.validWeapons[level.attachments[i]], baseWeapon ) ) return level.attachments[i];
		}
	}

	return "";
}


validForAttachmentAction( currentWeapon, attachment	)
{
	// Check if the weapon is a special firing mode weapon
	if ( isSubStr( currentWeapon, "_single_" ) || isSubStr( currentWeapon, "_burst_" ) || isSubStr( currentWeapon, "_full_" ) )
		return false;

	// Check if the current weapon is valid for the attachment that the player has
	for ( i = 1; i <= level.scr_dynamic_attachments_enable; i++ )
	{
		if (level.attachments[i] == attachment && isSubStr( level.validWeapons[attachment], currentWeapon ) ) return true;
	}

	return false;	
}

playSoundinSpace( alias, origin )
{
	org = spawn( "script_origin", origin );
	org.origin = origin;
	org playSound( alias  );
	wait 10; // MP doesn't have "sounddone" notifies =(
	org delete();
}