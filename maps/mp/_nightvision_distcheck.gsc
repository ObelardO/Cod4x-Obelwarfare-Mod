#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include openwarfare\_utils;

init()
{
	level.lightFXAass25 = loadfx ("nv/light_white_big");
	//level.lightFXAass25 = loadfx ("explosions/clusterbomb");

	//level.newBomb = spawn( "script_model", (0, 0, 0));
 	//level.newBomb setModel( "tag_origin" );
 	//level.newBomb linkto( self );
}

getAllPlayers()
{
	return getEntArray( "player", "classname" );
}

check_nightvision()
{
	self endon( "killed_player" );
	self endon( "spawned" );
	self endon( "disconnect" );
	level endon( "intermission" );
	level endon( "game_ended" );

	self.nightvision_on = false;

	while( 1 )
	{
		self waittill( "night_vision_on" );
		self.nightvision_on = true;
		//self thread shownightvisioninfo();


		setExpFog( 0, 350, 10/255, 10/255, 10/255, 0.0);
		//SetSunLight( 0, 0, 0 );
		//players = getAllPlayers();
		//for( i = 0; i < players.size; i++ )
		//	players[i] playLocalSound( "player_connected" );
		wait 0.05;
		//earthquake( 0.7, 0.75, (0,0,0), 1000 );
		
		//level.newBomb.origin = self getTagOrigin( "j_neck" ) + ( 0, 0, 6 );
		//level.newBomb linkto("j_neck");
		//playfxontag( level.lightFXAass25, level.newBomb, "tag_origin" );

		

		self waittill( "night_vision_off" );

		setExpFog( 1000, 100000, 51/255, 51/255, 51/255, 0.0 );
		//ResetSunLight();
		
		self.nightvision_on = false;


	}
}
/*
light(id, size, diff)
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("spawn");
	self endon("freshmodel");

	if (isDefined(self.light))
		self.light delete();

	self.light = spawn("script_model", self.origin);
	self.light setModel("tag_origin");
	self.light.diff = diff;
	self.light.id = id;
	self.light.scale = size;
	diff = undefined;
	wait 0.05; // Mert még az én kurva anyámat, nem?
	playFxOnTag(level.lightFXA, self.light, "tag_origin");
	self.light linkTo(self);
}
*/

shownightvisioninfo()
{
	//self endon("killed_player");
	//self endon( "spawned" );
	self endon( "disconnect" );
	level endon( "intermission" );
	level endon( "game_ended" );

	while( isAlive( self ) )
	{
		//PlayerHeadPos = self getEye();
		PlayerHeadPos = self getTagOrigin( "j_neck" ) + ( 0, 0, 6 );
		if( isDefined( PlayerHeadPos ) )
		{
			direction = vector_scale( anglesToForward( self getPlayerAngles() ), 999999 );
			posTarget = PlayerHeadPos + direction;

			/#
			if ( getdvar( "swm_nightvision_debug" ) == "" )
				setdvar( "swm_nightvision_debug", "0" );

			if ( getdvar( "swm_nightvision_debug" ) == "1" )
				line( PlayerHeadPos, posTarget, (0.5, 1, 0.6) );
			#/
		
			if( self.nightvision_on )
			{
				/#
				if( !isDefined( self.nightvision_lightFX ) )
				{
					self.nightvision_lightFX = PlayFX(level.lightFXAass25, PlayerHeadPos);
				}
				else
				{
					self.nightvision_lightFX.origin = PlayerHeadPos;
				}
				#/


				if( !isDefined( self.nightvision_dist ) )
				{
					self.nightvision_dist = [];
					posX = 38;
				
					self.nightvision_dist[0] = newClientHudElem( self );
					self.nightvision_dist[0].horzAlign = "center";
					self.nightvision_dist[0].vertAlign = "middle";
					self.nightvision_dist[0].alignx = "right";
					self.nightvision_dist[0].aligny = "middle";
					self.nightvision_dist[0].x = posX - 23;
					self.nightvision_dist[0].y = 152;
					self.nightvision_dist[0].font = "default";
					self.nightvision_dist[0].glowColor = ( 0, 0.4, 0.9 );
					self.nightvision_dist[0].glowAlpha = 0.4;
					self.nightvision_dist[0].fontscale = 1.4;
					self.nightvision_dist[0].color = ( 0 , 0, 0.1 );
					self.nightvision_dist[0].alpha = 0.9;
				
					self.nightvision_dist[1] = newClientHudElem( self );
					self.nightvision_dist[1].horzAlign = "center";
					self.nightvision_dist[1].vertAlign = "middle";
					self.nightvision_dist[1].alignx = "right";
					self.nightvision_dist[1].aligny = "middle";
					self.nightvision_dist[1].x = posX - 19;
					self.nightvision_dist[1].y = 147;
					self.nightvision_dist[1].font = "default";
					self.nightvision_dist[1].glowColor = ( 0, 0.4, 0.9 );
					self.nightvision_dist[1].glowAlpha = 0.8;
					self.nightvision_dist[1].fontscale = 2.2;
					self.nightvision_dist[1].color = ( 0 , 0, 0.1 );
					self.nightvision_dist[1].alpha = 0.9;
					self.nightvision_dist[1] setText( &"." );
				
					self.nightvision_dist[2] = newClientHudElem( self );
					self.nightvision_dist[2].horzAlign = "center";
					self.nightvision_dist[2].vertAlign = "middle";
					self.nightvision_dist[2].alignx = "right";
					self.nightvision_dist[2].aligny = "middle";
					self.nightvision_dist[2].x = posX - 11;
					self.nightvision_dist[2].y = 152;
					self.nightvision_dist[2].font = "default";
					self.nightvision_dist[2].glowColor = ( 0, 0.4, 0.9 );
					self.nightvision_dist[2].glowAlpha = 0.8;
					self.nightvision_dist[2].fontscale = 1.4;
					self.nightvision_dist[2].color = ( 0 , 0, 0.1 );
					self.nightvision_dist[2].alpha = 0.9;
				
					self.nightvision_dist[3] = newClientHudElem( self );
					self.nightvision_dist[3].horzAlign = "center";
					self.nightvision_dist[3].vertAlign = "middle";
					self.nightvision_dist[3].alignx = "right";
					self.nightvision_dist[3].aligny = "middle";
					self.nightvision_dist[3].x = posX;
					self.nightvision_dist[3].y = 152;
					self.nightvision_dist[3].font = "default";
					self.nightvision_dist[3].glowColor = ( 0, 0.4, 0.9 );
					self.nightvision_dist[3].glowAlpha = 0.8;
					self.nightvision_dist[3].fontscale = 1.4;
					self.nightvision_dist[3].color = ( 0 , 0, 0.1 );
					self.nightvision_dist[3].alpha = 0.9;
					self.nightvision_dist[3] setText( &"m" );
				}

				btrace = bulletTrace( PlayerHeadPos, posTarget, true, self );
				dist_raw = distance( PlayerHeadPos, btrace["position"] ) * 0.0254;
				dist_x10 = int( dist_raw * 10 );
				dist_txt = "" + dist_x10;
				dist_decimeter = getsubstr( dist_txt, dist_txt.size - 1 );
				dist_decimeter = int( dist_decimeter );
				dist_meter = int( ( dist_x10 - dist_decimeter ) / 10 );

				self.nightvision_dist[0] setvalue( dist_meter );
				self.nightvision_dist[2] setvalue( dist_decimeter );
				wait ( 0.05 );
			}
			else if( isDefined( self.nightvision_dist ) )
				self nightvision_dist_destroy();

		}
		wait ( 0.01 );
	}

	if( isDefined( self.nightvision_dist ) )
			self nightvision_dist_destroy();
}

nightvision_dist_destroy()
{
	for( nv = 0; nv < self.nightvision_dist.size; nv++ )
		self.nightvision_dist[nv] destroy();
	self.nightvision_dist = undefined;
}
