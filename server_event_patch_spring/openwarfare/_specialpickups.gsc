#include codescripts\character_mp;
#include maps\mp\_utility;

#include openwarfare\_eventmanager;
#include openwarfare\_utils;

init()
{
	if ( !isDefined( game["sps"] ) )
	{
		game["sps"] = [];

		game["sps"]["drop_zone_fx"] = loadFX( "misc/ui_flagbase_pink" );

		game["sps"]["drop_zone_points"] = [];

		hqRadios = getentarray( "hq_hardpoint", "targetname" );
		for ( i=0; i < hqRadios.size; i++ ) {
			game["sps"]["drop_zone_points"][i] = hqRadios[i].origin;
		}	

		game["sps"]["player_models"] = [];
		game["sps"]["player_models"][0] = "Yuusha";
		game["sps"]["player_models"][1] = "Yuusha_2";
		game["sps"]["player_models"][2] = "Eo";
		//game["sps"]["player_models"][3] = "Elysium_SC5";

		//precacheModel( game["sps"]["player_model"] );
		precacheModelArray( game["sps"]["player_models"] );
	}

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );

	level waittill("prematch_over");

	spawnDropZone();
}

onPlayerConnected()
{
	self thread addNewEvent( "onPlayerKilled",  ::onPlayerKilled );
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
	self thread addNewEvent( "onPlayerDeath",   ::onPlayerDeath );
}




onPlayerKilled()
{
	// Hide the HUD elements
	if ( isDefined( self.isSpecialPickuped ) && self.isSpecialPickuped == true ) {
		playSoundOnPlayers ( "specpikcs_die" );
		self.isSpecialPickuped = false;

		spawnDropZone();
	}
}


onPlayerSpawned()
{
	self.isSpecialPickuped = false;
}


onPlayerDeath()
{
	self setClientDvar( 
		"cg_thirdPerson", "0"
	);
}


spawnDropZone()
{
	// Exit if there are no any point
	points =  game["sps"]["drop_zone_points"];
	if ( isDefined( level.specPicksDropZone ) || points.size == 0 )
	{
		return;
	}

	// Get random coord
	dropZoneCoord = points[randomInt( points.size )];

	// Create a new drop zone
	dropZone = spawnstruct();
	
	// Create the trigger
	dropZone.trigger = spawn( "trigger_radius", dropZoneCoord, 0, 40, 10 );
	dropZone.origin = dropZoneCoord;
	
	// Spawn an special effect at the base of the drop zone to indicate where it is located
	traceStart = dropZoneCoord + (0,0,32);
	traceEnd = dropZoneCoord + (0,0,-32);
	trace = bulletTrace( traceStart, traceEnd, false, undefined );
	upangles = vectorToAngles( trace["normal"] );
	dropZone.baseEffect = spawnFx( game["sps"]["drop_zone_fx"], trace["position"], anglesToForward( upangles ), anglesToRight( upangles ) );
	triggerFx( dropZone.baseEffect );
	
	// Start monitoring the trigger
	dropZone thread onDropZoneUse();	
	
	return dropZone;
}

onDropZoneUse()
{
	level endon("game_ended");
	self endon("death");
	
	player = undefined;

	for (;;) {
		self.trigger waittill( "trigger", otherPlayer );

		player = otherPlayer;

		break;
	}

	iprintln ( "^6&&1 turned into a sexy waifu!", player.name );

	player playLocalSound( "specpikcs_up" );

	player.isSpecialPickuped = true;

	self removeDropZone();

	level.specPicksDropZone = undefined;

	//Detach Head Model (Original snip of script by BionicNipple)
	count = player getattachsize();
	for ( index = 0; index < count; index++ )
	{
		head = player getattachmodelname( index );

		if ( startsWith( head, "head" ) )
		{
			player detach( head );
			break;
		}
	}



	//player setModel( game["sps"]["player_model"] );
	player setModelFromArray( game["sps"]["player_models"] );

	wait 0.5;

	// Set 3rd. person view
	player setClientDvars( 
		"cg_thirdPerson", "1",
		"cg_thirdPersonAngle", "360",
		"cg_thirdPersonRange", "72"
	);

	wait 4;

	player setClientDvar( 
		"cg_thirdPerson", "0"
	);
}

removeDropZone()
{	
	// Remove the base effect
	self.baseEffect delete();
	
	// Remove the trigger
	self.trigger delete();

	//self delete();
}


startsWith( string, pattern )
{
    if ( string == pattern ) 
		return true;
    if ( pattern.size > string.size ) 
		return false;

    for ( index = 0; index < pattern.size; index++ )
	{
        if ( string[index] != pattern[index] ) 
			return false;
	}		

    return true;
}