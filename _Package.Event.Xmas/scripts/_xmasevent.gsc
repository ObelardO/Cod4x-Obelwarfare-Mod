#include openwarfare\_eventmanager;
#include openwarfare\_utils;

init()
{
	preCacheModel( "santa_hat" );

	if ( level.gametype == "sab" || level.gametype == "sd" )
	{
		game["bomb_prop_model"] = "giftbox_2";
		precacheModel( game["bomb_prop_model"] );

		if ( level.gametype == "sab" )  
		{
			thread bombs ( "sab_bomb_allies" );
			thread bombs ( "sab_bomb_axis" );
		}
		else
		{
			thread bombs ( "bombzone" );
		}
		
	} 

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}

onPlayerConnected()
{
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
}

onPlayerSpawned()
{
	self attach("santa_hat");
}

bombs( bombZoneEntityName )
{
	bombZones = getEntArray( bombZoneEntityName, "targetname" );

	for ( index = 0; index < bombZones.size; index++ )
	{
		trigger = bombZones[index];
		visuals = getEntArray( bombZones[index].target, "targetname" );

		for ( i = 0; i < visuals.size; i++ )
		{
			if ( isDefined( visuals[i].model ) )
			{
				visuals[i].modelscale = 0.5;
				visuals[i] setModel ("xmas_tree");

				break;
			}
		}
	}
}