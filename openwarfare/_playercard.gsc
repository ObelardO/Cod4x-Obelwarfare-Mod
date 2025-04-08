//**********************************************************************************
//                                                                                  
//        _   _       _        ___  ___      _        ___  ___          _             
//       | | | |     | |       |  \/  |     | |       |  \/  |         | |            
//       | |_| | ___ | |_   _  | .  . | ___ | |_   _  | .  . | ___   __| |___       
//       |  _  |/ _ \| | | | | | |\/| |/ _ \| | | | | | |\/| |/ _ \ / _` / __|      
//       | | | | (_) | | |_| | | |  | | (_) | | |_| | | |  | | (_) | (_| \__ \      
//       \_| |_/\___/|_|\__, | \_|  |_/\___/|_|\__, | \_|  |_/\___/ \__,_|___/      
//                       __/ |                  __/ |                               
//                      |___/                  |___/                                
//                                                                                  
//                       Website: http://www.holymolymods.com                       
//*********************************************************************************
// Coded for Openwarfare Mod by [105]HolyMoly  Dec.15/2014
// V.1.1

#include openwarfare\_eventmanager;
#include openwarfare\_utils;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

init()
{

	// Get the main module's dvars
	level.scr_playercards = getdvarx( "scr_playercards", "int", 3, 0, 3 );  
	level.scr_playercards_hardpoints = getdvarx( "scr_playercards_hardpoints", "int", 1, 0, 1 );  

        // If not activated
	if ( level.scr_playercards == 0 && level.scr_playercards_hardpoints == 0 )
		return;

        // NO Center Obit
        setDvar( "ui_hud_show_center_obituary", "0" );

        // Dvars Playercards
        level.scr_playercards_amount = getdvarx( "scr_playercards_amount", "int", 20, 1, 20 );
        level.scr_playercards_time_visible = getdvarx( "scr_playercards_time_visible", "float", 1.5, 1.5, 5 );

        // Dvar Playercard Hardpoints
	level.scr_playercards_hardpoints_enemy_display = getdvarx( "scr_playercards_hardpoints_enemy_display", "int", 1, 0, 1 ); 
        level.scr_playercards_hardpoints_time_visible = getdvarx( "scr_playercards_hardpoints_time_visible", "float", 3.5, 1.5, 5 );   
        
        // Precache playercards
	for ( cards = 0; cards < level.scr_playercards_amount; cards++ ) {
		precacheShader( "playercard_emblem_" + cards );
	}

        if( level.scr_playercards == 2 ) {
                loadWeaponIcons();
        }

        if( level.scr_playercards == 3 ) {
                loadHudIcons();
        }

        loadHardpointShaders();

        precacheString( &"OW_KILLCARD_ATTACKER" );
	precacheString( &"OW_KILLCARD_VICTIM" );
	precacheString( &"OW_KILLCARD_UAV_INBOUND" );
	precacheString( &"OW_KILLCARD_AIRSTRIKE_INBOUN" );
	precacheString( &"OW_KILLCARD_HELICOPTER_INBOUN" );

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}

onPlayerConnected()
{

        if( !isDefined( self.playerCard ) ) {
                self.playerCard = randomIntRange( 0, level.scr_playercards_amount );
                self.showingPlayercard = false;
                self.showingPlayercardHp = false;
               
        }
	
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );

}

onPlayerSpawned()
{

        // Killed by / You Killed
        if( !isDefined( self.playercardText ) ){
	        self.playercardText = newClientHudElem( self );
	        self.playercardText.x = 0; 
                self.playercardText.y = -130;
	        self.playercardText.alignX = "center";
	        self.playercardText.alignY = "top";
	        self.playercardText.horzAlign = "center";
	        self.playercardText.vertAlign = "bottom";
	        self.playercardText.fontScale = 1.6;
	        self.playercardText.sort = -1;
	        self.playercardText.glowAlpha = 0;
                self.playercardText.alpha = 0;

        }

        // Player Name
        if( !isDefined( self.playercardName ) ){
	        self.playercardName = newClientHudElem( self );
	        self.playercardName.x = -20; 
                self.playercardName.y = -100;
	        self.playercardName.alignX = "center";
	        self.playercardName.alignY = "top";
	        self.playercardName.horzAlign = "center";
	        self.playercardName.vertAlign = "bottom";
	        self.playercardName.fontScale = 1.6;
	        self.playercardName.sort = -1;
	        self.playercardName.glowAlpha = 0;
                self.playercardName.alpha = 0;

        }

        // Player Rank Number
        if( !isDefined( self.playercardRankNumber ) ){
	        self.playercardRankNumber = newClientHudElem( self );
	        self.playercardRankNumber.x = -89; 
                self.playercardRankNumber.y = -100;
	        self.playercardRankNumber.alignX = "center";
	        self.playercardRankNumber.alignY = "top";
	        self.playercardRankNumber.horzAlign = "center";
	        self.playercardRankNumber.vertAlign = "bottom";
	        self.playercardRankNumber.fontScale = 1.6;
	        self.playercardRankNumber.sort = -1;
	        self.playercardRankNumber.glowAlpha = 0;
                self.playercardRankNumber.alpha = 0;

        }

        // Background Image
        if( !isDefined( self.playercardImage ) ) {
	        // Create the HUD element to display the playercard
	        self.playercardImage = newClientHudElem( self );
	        self.playercardImage.x = 0;
	        self.playercardImage.y = -110;	
	        self.playercardImage.sort = -2;
                self.playercardImage.alignX = "center";
	        self.playercardImage.alignY = "top";
	        self.playercardImage.horzAlign = "center";
	        self.playercardImage.vertAlign = "bottom";
                self.playercardImage.alpha = 0;
        }

        // Rank Icon
	if ( !isDefined( self.playercardRankIcon ) ) {
		self.playercardRankIcon = self createIcon( "white", 25, 25 );
		self.playercardRankIcon setPoint( "CENTER", "BOTTOM", -111, -90 );
		self.playercardRankIcon.sort = -1;
		self.playercardRankIcon.alpha = 0;
	}

        // Team Icon
        if( level.scr_playercards == 1 ) {
	        if ( !isDefined( self.playercardTeamIcon ) ) {
		        self.playercardTeamIcon = self createIcon( "white", 25, 25 );
		        self.playercardTeamIcon setPoint( "CENTER", "BOTTOM", 105, -90 );
		        self.playercardTeamIcon.sort = -1;
		        self.playercardTeamIcon.alpha = 0;
	        }
        }

        // Weapon Icon
        if( level.scr_playercards >= 2 ) {
	        if ( !isDefined( self.playercardKillWeapon ) ) {
		        self.playercardKillWeapon = self createIcon( "white", 25, 25 );
		        self.playercardKillWeapon setPoint( "CENTER", "BOTTOM", 80, -90 );
		        self.playercardKillWeapon.sort = -1;
		        self.playercardKillWeapon.alpha = 0;
	        }
        }

        if( level.scr_playercards_hardpoints == 1 ) {

                // Player Name
                if( !isDefined( self.playercardNameHardpoint ) ){
	                self.playercardNameHardpoint = newClientHudElem( self );
	                self.playercardNameHardpoint.x = -190; 
                        self.playercardNameHardpoint.y = -140;
	                self.playercardNameHardpoint.alignX = "left";
	                self.playercardNameHardpoint.alignY = "middle";
	                self.playercardNameHardpoint.horzAlign = "right";
	                self.playercardNameHardpoint.vertAlign = "middle";
	                self.playercardNameHardpoint.fontScale = 1.6;
	                self.playercardNameHardpoint.sort = -1;
	                self.playercardNameHardpoint.glowAlpha = 0;
                        self.playercardNameHardpoint.alpha = 0;

                }

                // Player Rank Number
                if( !isDefined( self.playercardRankNumberHardpoint ) ){
	                self.playercardRankNumberHardpoint = newClientHudElem( self );
	                self.playercardRankNumberHardpoint.x = -230; 
                        self.playercardRankNumberHardpoint.y = -140;
	                self.playercardRankNumberHardpoint.alignX = "left";
	                self.playercardRankNumberHardpoint.alignY = "middle";
	                self.playercardRankNumberHardpoint.horzAlign = "right";
	                self.playercardRankNumberHardpoint.vertAlign = "middle";
	                self.playercardRankNumberHardpoint.fontScale = 1.6;
	                self.playercardRankNumberHardpoint.sort = -1;
	                self.playercardRankNumberHardpoint.glowAlpha = 0;
                        self.playercardRankNumberHardpoint.alpha = 0;


                }

                // Background Image
                if( !isDefined( self.playercardImageHardpoint ) ) {
	                // Create the HUD element to display the playercard
	                self.playercardImageHardpoint = newClientHudElem( self );
	                self.playercardImageHardpoint.x = -260;
	                self.playercardImageHardpoint.y = -140;
	                self.playercardImageHardpoint.sort = -2;
                        self.playercardImageHardpoint.alignX = "left";
	                self.playercardImageHardpoint.alignY = "middle";
	                self.playercardImageHardpoint.horzAlign = "right";
	                self.playercardImageHardpoint.vertAlign = "middle";
                        self.playercardImageHardpoint.alpha = 0;


                 }

                // Rank Icon
	        if( !isDefined( self.playercardRankIconHardpoint ) ) {
		        self.playercardRankIconHardpoint = self createIcon( "white", 25, 25 );
		        self.playercardRankIconHardpoint setPoint( "MIDDLE", "RIGHT", -245, -140 );
		        self.playercardRankIconHardpoint.sort = -1;
		        self.playercardRankIconHardpoint.alpha = 0;


	         }

                // Hardpoint Text
                if( !isDefined( self.playercardHardpointText ) ) {
	                self.playercardHardpointText = newClientHudElem( self );
	                self.playercardHardpointText.x = -256; 
                        self.playercardHardpointText.y = -112;
	                self.playercardHardpointText.alignX = "left";
	                self.playercardHardpointText.alignY = "middle";
	                self.playercardHardpointText.horzAlign = "right";
	                self.playercardHardpointText.vertAlign = "middle";
	                self.playercardHardpointText.fontScale = 1.4;
	                self.playercardHardpointText.sort = -1;
	                self.playercardHardpointText.glowAlpha = 0;
		        self.playercardHardpointText.alpha = 0;


                }

                // Weapon Icon
                if( !isDefined( self.playercardKillWeaponHardpoint ) ) {
		        self.playercardKillWeaponHardpoint = self createIcon( "white", 25, 25 );
		        self.playercardKillWeaponHardpoint setPoint( "MIDDLE", "RIGHT", -40, -140 );
		        self.playercardKillWeaponHardpoint.sort = -1;
		        self.playercardKillWeaponHardpoint.alpha = 0;

	        }

                // Move for Fly By Messages
                if( isDefined( level.scr_hud_flyby_messages_enable ) && level.scr_hud_flyby_messages_enable == 1 ) {
                        self.playercardKillWeaponHardpoint setPoint( "MIDDLE", "RIGHT", -40, -40 );
                        self.playercardHardpointText.y = -12;
                        self.playercardRankIconHardpoint setPoint( "MIDDLE", "RIGHT", -245, -40 );
                        self.playercardImageHardpoint.y = -40;
                        self.playercardRankNumberHardpoint.y = -40;
                        self.playercardNameHardpoint.y = -40;
                }

        }

        self thread waitForKill();

        if( level.scr_playercards_hardpoints == 1 ) {
                self thread waitTillHardpointCalled();
        }

}

waitForKill()
{
	self endon("disconnect");

	
	// Wait for the player to die
	self waittill( "player_killed", eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, fDistance );

        // Suicide
        if( !isPlayer( attacker ) || attacker == self  ) {
              return;
        }

        // Team Kill
        if( level.teamBased ) {
                if( attacker.pers["team"] == self.pers["team"] ) {
                        return;
                }
        }
     
	// Adjustment to the sWeapon name
	if ( sMeansOfDeath == "MOD_MELEE" ) {
		sWeapon = "knife_mp";
	}

        // Victim Info
        playercardVictim = spawnstruct();
        playercardVictim.name = self.name;
        playercardVictim.rank = self.pers["rank"] + 1;
        playercardVictim.card = self.playerCard;
        playercardVictim.icon = self maps\mp\gametypes\_rank::getRankInfoIcon( self.pers["rank"], self.pers["prestige"] );
        playercardVictim.team = game["icons"][self.team];
        playercardVictim.text = &"OW_KILLCARD_VICTIM";

        //Attacker Info
        playercardAttacker = spawnstruct();
        playercardAttacker.name = attacker.name;
        playercardAttacker.rank = attacker.pers["rank"] + 1;
        playercardAttacker.card = attacker.playerCard;
        playercardAttacker.icon = attacker maps\mp\gametypes\_rank::getRankInfoIcon( attacker.pers["rank"], attacker.pers["prestige"] );
        playercardAttacker.team = game["icons"][attacker.team];
        playercardAttacker.text = &"OW_KILLCARD_ATTACKER";
        playercardAttacker.weapon = sWeapon;
        playercardAttacker.weaponIcon = attacker getWeaponImage( sWeapon );
        playercardAttacker.hudIcon = attacker getHudIconImage( sWeapon );

        // Victim Thread
        if( isDefined( self ) )
                self thread showVictimCard( playercardVictim, playercardAttacker  );
        
        // Attacker Thread
        if( isDefined( attacker ) )
                attacker thread showAttackerCard( playercardVictim, playercardAttacker );

        

}

waitTillHardpointCalled()
{
	self endon ( "death" );
	self endon ( "disconnect" );


	for ( ;; )
	{
		self waittill( "hardpoint_called", hardpointName );

                // Set up info
                playercardHp = spawnstruct();
                playercardHp.name = self.name;
                playercardHp.rank = self.pers["rank"] + 1;
                playercardHp.image = self.playerCard;
                playercardHp.icon = self maps\mp\gametypes\_rank::getRankInfoIcon( self.pers["rank"], self.pers["prestige"] );
                playercardHp.hardpoint = hardpointName;

                // Show to self
                if( isDefined( self ) )
                        self thread showFriendlyPlayercardHardpoint( playercardHp );

                // Find all other players
                if( level.teamBased ) {
                        players = level.players;
                        for( i = 0; i < players.size; i++ ) {

                                if( players[i].pers["team"] == self.pers["team"] ) {
                                        if( players[i] != self ) {
                                                if( players[i].sessionstate != "spectator" ) { 
                                                        if( isDefined( players[i] ) )
                                                                players[i] thread showFriendlyPlayercardHardpoint( playercardHp );
                                                }
                                        }
                                } 
                        }

                        for( i = 0; i < players.size; i++ ) {
                                if( level.scr_playercards_hardpoints_enemy_display == 1 ) {
                                        if( players[i].pers["team"] != self.pers["team"] ) {
                                                if( players[i].sessionstate != "spectator" ) {
                                                        if( isDefined( players[i] ) )
                                                                players[i] thread showEnemyPlayercardHardpoint( playercardHp );
                                                }
                                        }
                                }
                        }

                } else {

                        // Not Team based
                        players = level.players;
                        for( i = 0; i < players.size; i++ ) {
 
                                if( level.scr_playercards_hardpoints_enemy_display == 1 ) {
                                        if( players[i] != self ) {
                                                if( players[i].sessionstate != "spectator" ) {
                                                        if( isDefined( players[i] ) )
                                                                players[i] thread showEnemyPlayercardHardpoint( playercardHp );
                                                }
                                        }
                                }
                        }
                }

                wait( 0.05 );
                        
	}

        // Had to thread separate Friendly and Enemy functions all because of the damn text color!
        // If part of the spawnstruct(), color would change if player had Hp message waiting in queue.


}

showVictimCard( playercardVictim, playercardAttacker )
{
	self endon("disconnect");


        // Wait if already showing a card
        while( isDefined( self.showingPlayercard ) && self.showingPlayercard == true ) {
                wait( 0.2 );
        }
/*
        // Return if showing a card........... If get error/ exceeded limit of script variables
        if( isDefined( self.showingPlayercard ) && self.showingPlayercard == true ) {
                return;
        }
*/
        // Self Spectating
        if( self.sessionstate == "spectator" ) {
                return;
        }

        // Game ended or Intermission
        if( level.gameEnded || level.intermission ) {
                return;
        }

        self.showingPlayercard = true;

        // Victim Threads
        if( level.scr_playercards == 3 ) {
                self thread showVictimWeapon( playercardAttacker );
        }

        if( level.scr_playercards == 2 ) {
                self thread showVictimWeapon( playercardAttacker );
        }

        // Set shader and make visable
        self.playercardImage setShader( "playercard_emblem_" + playercardAttacker.card, 256, 40 );
        self.playercardRankIcon setShader( playercardAttacker.icon, 25, 25 );

        self.playercardName setText( playercardAttacker.name );
        self.playercardName.color = ( 1, 1, 1 );

        self.playercardText setText( playercardVictim.text );
        self.playercardText.color = ( 0.98, 0.67, 0.67 );

        self.playercardRankNumber setText( playercardAttacker.rank );
        self.playercardRankNumber.color = ( 0.97, 0.96, 0.34 );

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon setShader( playercardAttacker.team, 25, 25 );
        }

        self.playercardImage.alpha = 0.9;
        self.playercardRankIcon.alpha = 1;
        self.playercardName.alpha = 1;
        self.playercardText.alpha = 1;
        self.playercardRankNumber.alpha = 1;

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon.alpha = 1;
        }
       
        if( level.scr_playercards >= 2 ) {
                self.playercardKillWeapon.alpha = 1;
        }

        // Time shader visible
        wait( level.scr_playercards_time_visible );

        // Move to bottom and set non-visible
        self.playercardImage moveOverTime( 0.40 );
        self.playercardRankIcon moveOverTime( 0.40 );
        self.playercardName moveOverTime( 0.40 );
        self.playercardText moveOverTime( 0.40 );
        self.playercardRankNumber moveOverTime( 0.40 );

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon moveOverTime( 0.40 );
        }

        if( level.scr_playercards >= 2 ) {
                self.playercardKillWeapon moveOverTime( 0.40 );
        }

        self.playercardImage.y = 20;
        self.playercardRankIcon.y = 40;
        self.playercardName.y = 30;
        self.playercardText.y = 0;
        self.playercardRankNumber.y = 30;

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon.y = 40;
        }

        if( level.scr_playercards >= 2 ) {
                self.playercardKillWeapon.y = 40;
        }
     
        // Time wait to move to bottom
        wait( 0.4 );

        // Move back to start position.
        self.playercardImage moveOverTime( 0.40 );
        self.playercardRankIcon moveOverTime( 0.40 );
        self.playercardName moveOverTime( 0.40 );
        self.playercardText moveOverTime( 0.40 );
        self.playercardRankNumber moveOverTime( 0.40 );

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon moveOverTime( 0.40 );
        }

        if( level.scr_playercards >= 2 ) {
                self.playercardKillWeapon moveOverTime( 0.40 );
        }

        self.playercardImage.y = -110;
        self.playercardRankIcon.y = -90;
        self.playercardName.y = -100;
        self.playercardText.y = -130;
        self.playercardRankNumber.y = -100;

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon.y = -90;
        }

        if( level.scr_playercards >= 2 ) {
                self.playercardKillWeapon.y = -90;
        }

        self.playercardImage.alpha = 0;
        self.playercardRankIcon.alpha = 0;
        self.playercardName.alpha = 0;
        self.playercardText.alpha = 0;
        self.playercardRankNumber.alpha = 0;

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon.alpha = 0;
        }

        if( level.scr_playercards >= 2 ) {
                self.playercardKillWeapon.alpha = 0;
        }


        // Time wait to move back
        wait( 0.4 );

        self.showingPlayercard = false;

        // Hint - to make all the hud elements move together in time you must move the SAME number of units
        //        for each element. Start and stop positions must total the same amount each element must move!

}

showAttackerCard( playercardVictim, playercardAttacker ) // attacker is self
{
	self endon("disconnect");


        // Wait if already showing a card
        while( isDefined( self.showingPlayercard ) && self.showingPlayercard == true ) {
                wait( 0.2 );
        }
/*
        // Return if showing a card........... If get error/ exceeded limit of script variables
        if( isDefined( self.showingPlayercard ) && self.showingPlayercard == true ) {
                return;
        }
*/
        // Self Spectating
        if( self.sessionstate == "spectator" ) {
                return;
        }

        // Game ended or Intermission
        if( level.gameEnded || level.intermission ) {
                return;
        }

        self.showingPlayercard = true;

        // Attacker Threads
        if( level.scr_playercards == 3 ) {
                self thread showAttackerWeapon( playercardAttacker );
        }

        if( level.scr_playercards == 2 ) {
                self thread showAttackerWeapon( playercardAttacker );
        }

        // Set shader and make visable
        self.playercardImage setShader( "playercard_emblem_" + playercardVictim.card, 256, 40 );
        self.playercardRankIcon setShader( playercardVictim.icon, 25, 25 );

        self.playercardText setText( playercardAttacker.text );
        self.playercardText.color = ( 0.73, 0.97, 0.71 );

        self.playercardName setText( playercardVictim.name );
        self.playercardName.color = ( 1, 1, 1 );

        self.playercardRankNumber setText( playercardVictim.rank );
        self.playercardRankNumber.color = ( 0.97, 0.96, 0.34 );

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon setShader( playercardVictim.team, 25, 25 );
        }

        self.playercardImage.alpha = 0.9;
        self.playercardRankIcon.alpha = 1;
        self.playercardText.alpha = 1;
        self.playercardName.alpha = 1;
        self.playercardRankNumber.alpha = 1;

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon.alpha = 1;
        }

        if( level.scr_playercards >= 2 ) {
                self.playercardKillWeapon.alpha = 1;
        }

        // Time shader visible
        wait( level.scr_playercards_time_visible );

        // Move to bottom and set non-visible
        self.playercardImage moveOverTime( 0.40 );
        self.playercardRankIcon moveOverTime( 0.40 );
        self.playercardText moveOverTime( 0.40 );
        self.playercardName moveOverTime( 0.40 );
        self.playercardRankNumber moveOverTime( 0.40 );

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon moveOverTime( 0.40 );
        }

        if( level.scr_playercards >= 2 ) {
                self.playercardKillWeapon moveOverTime( 0.40 );
        }

        self.playercardImage.y = 20;
        self.playercardRankIcon.y = 40;
        self.playercardText.y = 0;
        self.playercardName.y = 30;
        self.playercardRankNumber.y = 30;

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon.y = 40;
        }

        if( level.scr_playercards >= 2 ) {
                self.playercardKillWeapon.y = 40;
        }
     
        // Time wait to move to bottom
        wait( 0.4 );

        // Move back to start position
        self.playercardImage moveOverTime( 0.40 );
        self.playercardRankIcon moveOverTime( 0.40 );
        self.playercardText moveOverTime( 0.40 );
        self.playercardName moveOverTime( 0.40 );
        self.playercardRankNumber moveOverTime( 0.40 );

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon moveOverTime( 0.40 );
        }

        if( level.scr_playercards >= 2 ) {
                self.playercardKillWeapon moveOverTime( 0.40 );
        }

        self.playercardImage.y = -110;
        self.playercardRankIcon.y = -90;
        self.playercardText.y = -130;
        self.playercardName.y = -100;
        self.playercardRankNumber.y = -100;

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon.y = -90;
        }

        if( level.scr_playercards >= 2 ) {
                self.playercardKillWeapon.y = -90;
        }

        self.playercardImage.alpha = 0;
        self.playercardRankIcon.alpha = 0;
        self.playercardText.alpha = 0;
        self.playercardName.alpha = 0;
        self.playercardRankNumber.alpha = 0;

        if( level.scr_playercards == 1 ) {
                self.playercardTeamIcon.alpha = 0;
        }

        if( level.scr_playercards >= 2 ) {
                self.playercardKillWeapon.alpha = 0;
        }


        // Time wait to move back
        wait( 0.4 );

        self.showingPlayercard = false;

        // Hint - to make all the hud elements move together in time you must move the SAME number of units
        //        for each element. Start and stop positions must total the same amount each element must move! 

}

showAttackerWeapon( playercardAttacker )
{
	self endon("disconnect");


        // Weapon Image Size
        if( level.scr_playercards == 2 ) {

                imageSize = self getWeaponImageSize( playercardAttacker.weapon );

	        if ( imageSize <= 2 ) {
		        self.playercardKillWeapon setShader( playercardAttacker.weaponIcon, 34, 34 );
                        self.playercardKillWeapon.x = 90;
                }

	        if ( imageSize == 3 ) {
		        self.playercardKillWeapon setShader( playercardAttacker.weaponIcon, 80, 40 );
                        self.playercardKillWeapon.x = 80;
                }

	        if ( imageSize == 4 ) {
		        self.playercardKillWeapon setShader( playercardAttacker.weaponIcon, 64, 64 );
                        self.playercardKillWeapon.x = 80;
                }

       }

       // Icon Image Size
        if( level.scr_playercards == 3 ) {

                iconSize = self getHudIconSize( playercardAttacker.weapon );

	        if ( iconSize <= 2 ) {
		        self.playercardKillWeapon setShader( playercardAttacker.hudIcon, 34, 34 );
                        self.playercardKillWeapon.x = 90;
                }

	        if ( iconSize == 3 ) {
		        self.playercardKillWeapon setShader( playercardAttacker.hudIcon, 72, 18 );
                        self.playercardKillWeapon.x = 80;
                }

	        if ( iconSize == 4 ) {
		        self.playercardKillWeapon setShader( playercardAttacker.hudIcon, 72, 36 );
                        self.playercardKillWeapon.x = 80;
                }
	
        }

}

showVictimWeapon( playercardAttacker )
{
	self endon("disconnect");


        // Weapon Image Size
        if( level.scr_playercards == 2 ) {

                imageSize = self getWeaponImageSize( playercardAttacker.weapon );

	        if ( imageSize <= 2 ) {
		        self.playercardKillWeapon setShader( playercardAttacker.weaponIcon, 34, 34 );
                        self.playercardKillWeapon.x = 90;
                }

	        if ( imageSize == 3 ) {
		        self.playercardKillWeapon setShader( playercardAttacker.weaponIcon, 80, 40 );
                        self.playercardKillWeapon.x = 80;
                }

	        if ( imageSize == 4 ) {
		        self.playercardKillWeapon setShader( playercardAttacker.weaponIcon, 64, 64 );
                        self.playercardKillWeapon.x = 80;
                }

       }

       // Icon Image Size
        if( level.scr_playercards == 3 ) {

                iconSize = self getHudIconSize( playercardAttacker.weapon );

	        if ( iconSize <= 2 ) {
		        self.playercardKillWeapon setShader( playercardAttacker.hudIcon, 34, 34 );
                        self.playercardKillWeapon.x = 90;
                }

	        if ( iconSize == 3 ) {
		        self.playercardKillWeapon setShader( playercardAttacker.hudIcon, 72, 18 );
                        self.playercardKillWeapon.x = 80;
                }

	        if ( iconSize == 4 ) {
		        self.playercardKillWeapon setShader( playercardAttacker.hudIcon, 72, 36 );
                        self.playercardKillWeapon.x = 80;
                }
	
        }

}

showEnemyPlayercardHardpoint( playercardHp )
{
	self endon("disconnect");


        // Wait if already showing a card
        while( isDefined( self.showingPlayercardHp ) && self.showingPlayercardHp == true ) {
                wait( 0.2 );
        }
/*
        // Return if showing a card........... If get error/ exceeded limit of script variables
        if( isDefined( self.showingPlayercardHp ) && self.showingPlayercardHp == true ) {
                return;
        }
*/
        // Self Spectating
        if( self.sessionstate == "spectator" ) {
                return;
        }

        // Game ended or Intermission
        if( level.gameEnded || level.intermission ) {
                return;
        }

        self.showingPlayercardHp = true;

        // Name
        self.playercardNameHardpoint setText( playercardHp.name );
        self.playercardNameHardpoint.color = ( 1, 1, 1 );
        self.playercardNameHardpoint.alpha = 1;

        // Rank Number
        self.playercardRankNumberHardpoint setText( playercardHp.rank );
        self.playercardRankNumberHardpoint.color = ( 0.97, 0.96, 0.34 );
        self.playercardRankNumberHardpoint.alpha = 1;

        // Background Image
        self.playercardImageHardpoint setShader( "playercard_emblem_" + playercardHp.image, 256, 40 );
        self.playercardImageHardpoint.alpha = 1;

        // Rank Icon
        self.playercardRankIconHardpoint setShader( playercardHp.icon, 25, 25 );
        self.playercardRankIconHardpoint.alpha = 1;

        // Hardpoint Text Message...................... Add your extra Hp's here
        if( playercardHp.hardpoint == "radar_mp" ) 
                self.playercardHardpointText setText( &"OW_KILLCARD_UAV_INBOUND" );

        if( playercardHp.hardpoint == "airstrike_mp" ) 
                self.playercardHardpointText setText( &"OW_KILLCARD_AIRSTRIKE_INBOUN" );

        if( playercardHp.hardpoint == "helicopter_mp" ) 
                self.playercardHardpointText setText( &"OW_KILLCARD_AIRSTRIKE_INBOUN" );
        
        self.playercardHardpointText.color = ( 0.98, 0.67, 0.67 ); //Red
        self.playercardHardpointText.alpha = 1;

        // Weapon Icon
        if( level.scr_playercards <= 2 ) {
                self.playercardKillWeaponHardpoint setShader( "killstreak_award_" + playercardHp.hardpoint, 40, 40 );  // 1:1
        }

        if( level.scr_playercards == 3 ) {
                self.playercardKillWeaponHardpoint setShader( self getHudIconImage( playercardHp.hardpoint ), 56, 14 );  // 4:1
        }

        self.playercardKillWeaponHardpoint.alpha = 1;

        // Debug
        // iprintln( self.name + " displayed " + self.playercardHardpointText.color );

        // Time Visable
        wait( level.scr_playercards_hardpoints_time_visible );

        self.playercardNameHardpoint moveOverTime( 0.40 );
        self.playercardRankNumberHardpoint moveOverTime( 0.40 );
        self.playercardImageHardpoint moveOverTime( 0.40 );
        self.playercardRankIconHardpoint moveOverTime( 0.40 );
        self.playercardHardpointText moveOverTime( 0.40 );
        self.playercardKillWeaponHardpoint moveOverTime( 0.40 );

        self.playercardNameHardpoint.x = 70;
        self.playercardRankNumberHardpoint.x = 30;
        self.playercardImageHardpoint.x = 0;
        self.playercardRankIconHardpoint.x = 15;
        self.playercardHardpointText.x = 4;
        self.playercardKillWeaponHardpoint.x = 220;
     
        // Time wait to move to right
        wait( 0.4 );
  
        // Make it disappear
        self.playercardNameHardpoint.alpha = 0;
        self.playercardRankNumberHardpoint.alpha = 0;
        self.playercardImageHardpoint.alpha = 0;
        self.playercardRankIconHardpoint.alpha = 0;
        self.playercardHardpointText.alpha = 0;
        self.playercardKillWeaponHardpoint.alpha = 0;

        // Return Home
        self.playercardNameHardpoint moveOverTime( 0.40 );
        self.playercardRankNumberHardpoint moveOverTime( 0.40 );
        self.playercardImageHardpoint moveOverTime( 0.40 );
        self.playercardRankIconHardpoint moveOverTime( 0.40 );
        self.playercardHardpointText moveOverTime( 0.40 );
        self.playercardKillWeaponHardpoint moveOverTime( 0.40 );

        // Set back to original positions
        self.playercardNameHardpoint.x = -190;
        self.playercardRankNumberHardpoint.x = -230;
        self.playercardImageHardpoint.x = -260;
        self.playercardRankIconHardpoint.x = -245;
        self.playercardHardpointText.x = -256;
        self.playercardKillWeaponHardpoint.x = -40;

        // Time wait to move back
        wait( 0.4 );

        self.showingPlayercardHp = false;

        // Hint - to make all the hud elements move together in time you must move the SAME number of units
        //        for each element. Start and stop positions must total the same amount each element must move!

}

showFriendlyPlayercardHardpoint( playercardHp )
{
	self endon("disconnect");


        // Wait if already showing a card
        while( isDefined( self.showingPlayercardHp ) && self.showingPlayercardHp == true ) {
                wait( 0.2 );
        }
/*
        // Return if showing a card........... If get error/ exceeded limit of script variables
        if( isDefined( self.showingPlayercardHp ) && self.showingPlayercardHp == true ) {
                return;
        }
*/
        // Self Spectating
        if( self.sessionstate == "spectator" ) {
                return;
        }

        // Game ended or Intermission
        if( level.gameEnded || level.intermission ) {
                return;
        }

        self.showingPlayercardHp = true;

        // Name
        self.playercardNameHardpoint setText( playercardHp.name );
        self.playercardNameHardpoint.color = ( 1, 1, 1 );
        self.playercardNameHardpoint.alpha = 1;

        // Rank Number
        self.playercardRankNumberHardpoint setText( playercardHp.rank );
        self.playercardRankNumberHardpoint.color = ( 0.97, 0.96, 0.34 );
        self.playercardRankNumberHardpoint.alpha = 1;

        // Background Image
        self.playercardImageHardpoint setShader( "playercard_emblem_" + playercardHp.image, 256, 40 );
        self.playercardImageHardpoint.alpha = 1;

        // Rank Icon
        self.playercardRankIconHardpoint setShader( playercardHp.icon, 25, 25 );
        self.playercardRankIconHardpoint.alpha = 1;

        // Hardpoint Text Message...................... Add your extra Hp's here
        if( playercardHp.hardpoint == "radar_mp" ) 
                self.playercardHardpointText setText( &"OW_KILLCARD_UAV_INBOUND" );

        if( playercardHp.hardpoint == "airstrike_mp" ) 
                self.playercardHardpointText setText( &"OW_KILLCARD_AIRSTRIKE_INBOUN" );

        if( playercardHp.hardpoint == "helicopter_mp" ) 
                self.playercardHardpointText setText( &"OW_KILLCARD_AIRSTRIKE_INBOUN" );
        
        self.playercardHardpointText.color = ( 0.73, 0.97, 0.71 ); // Green
        self.playercardHardpointText.alpha = 1;

        // Weapon Icon
        if( level.scr_playercards <= 2 ) {
                self.playercardKillWeaponHardpoint setShader( "killstreak_award_" + playercardHp.hardpoint, 40, 40 );  // 1:1
        }

        if( level.scr_playercards == 3 ) {
                self.playercardKillWeaponHardpoint setShader( self getHudIconImage( playercardHp.hardpoint ), 56, 14 );  // 4:1
        }

        self.playercardKillWeaponHardpoint.alpha = 1;

        // Debug
        // iprintln( self.name + " displayed " + self.playercardHardpointText.color );

        // Time Visable
        wait( level.scr_playercards_hardpoints_time_visible );

        self.playercardNameHardpoint moveOverTime( 0.40 );
        self.playercardRankNumberHardpoint moveOverTime( 0.40 );
        self.playercardImageHardpoint moveOverTime( 0.40 );
        self.playercardRankIconHardpoint moveOverTime( 0.40 );
        self.playercardHardpointText moveOverTime( 0.40 );
        self.playercardKillWeaponHardpoint moveOverTime( 0.40 );

        self.playercardNameHardpoint.x = 70;
        self.playercardRankNumberHardpoint.x = 30;
        self.playercardImageHardpoint.x = 0;
        self.playercardRankIconHardpoint.x = 15;
        self.playercardHardpointText.x = 4;
        self.playercardKillWeaponHardpoint.x = 220;
     
        // Time wait to move to right
        wait( 0.4 );
  
        // Make it disappear
        self.playercardNameHardpoint.alpha = 0;
        self.playercardRankNumberHardpoint.alpha = 0;
        self.playercardImageHardpoint.alpha = 0;
        self.playercardRankIconHardpoint.alpha = 0;
        self.playercardHardpointText.alpha = 0;
        self.playercardKillWeaponHardpoint.alpha = 0;

        // Return Home
        self.playercardNameHardpoint moveOverTime( 0.40 );
        self.playercardRankNumberHardpoint moveOverTime( 0.40 );
        self.playercardImageHardpoint moveOverTime( 0.40 );
        self.playercardRankIconHardpoint moveOverTime( 0.40 );
        self.playercardHardpointText moveOverTime( 0.40 );
        self.playercardKillWeaponHardpoint moveOverTime( 0.40 );

        // Set back to original positions
        self.playercardNameHardpoint.x = -190;
        self.playercardRankNumberHardpoint.x = -230;
        self.playercardImageHardpoint.x = -260;
        self.playercardRankIconHardpoint.x = -245;
        self.playercardHardpointText.x = -256;
        self.playercardKillWeaponHardpoint.x = -40;

        // Time wait to move back
        wait( 0.4 );

        self.showingPlayercardHp = false;

        // Hint - to make all the hud elements move together in time you must move the SAME number of units
        //        for each element. Start and stop positions must total the same amount each element must move!

}


getWeaponImage( weapon )
{

  	image = "";       

	// Handguns
	if ( isSubStr( weapon, "beretta_" ) ) {  // 128 x 128
                image = "weapon_m9beretta";
                return image;

        } else if ( isSubStr( weapon, "colt45_" ) ) { // 128 x 128
                image = "weapon_colt_45";
                return image;

        } else if ( isSubStr( weapon, "usp_" ) ) { // 128 x 128
                image = "weapon_usp_45";
                return image;
	
        } else if ( isSubStr( weapon, "deserteagle_" ) ) { // 128 x 128
                image = "weapon_desert_eagle";
                return image;

        } else if ( isSubStr( weapon, "deserteaglegold_" ) ) { // 128 x 128
                image = "weapon_desert_eagle_gold";
                return image;

        // Assault
        } else if ( isSubStr( weapon, "m16_" ) ) { // 256 x 128
                image = "weapon_m16a4";
                return image;

        } else if ( isSubStr( weapon, "ak47_" ) ) { // 256 x 128
                image = "weapon_ak47";
                return image;

        } else if ( isSubStr( weapon, "m4_" ) ) { // 256 x 128
                image = "weapon_m4carbine";
                return image;

        } else if ( isSubStr( weapon, "g3_" ) ) { // 256 x 128
                image = "weapon_g3";
                return image;

        } else if ( isSubStr( weapon, "g36c_" ) ) { // 256 x 128
                image = "weapon_g36c";
                return image;

        } else if ( isSubStr( weapon, "m14_" ) ) { // 256 x 128
                image = "weapon_m14";
                return image;

        } else if ( isSubStr( weapon, "mp44_" ) ) { // 256 x 128
                image = "weapon_mp44";
                return image;

        // Spec Ops
        } else if ( isSubStr( weapon, "mp5_" ) ) {  // 256 x 128
                image = "weapon_mp5";
                return image;

        } else if ( isSubStr( weapon, "skorpion_" ) ) { // 256 x 128
                image = "weapon_skorpion";
                return image;

        } else if ( isSubStr( weapon, "uzi_" ) ) { // 256 x 128
                image = "weapon_mini_uzi";
                return image;

        } else if ( isSubStr( weapon, "ak74u_" ) ) { // 256 x 128
                image = "weapon_aks74u";
                return image;

        } else if ( isSubStr( weapon, "p90_" ) ) { // 256 x 128
                image = "weapon_p90";
                return image;

        // Demoliition
        } else if ( isSubStr( weapon, "m1014_" ) ) { // 256 x 128
                image = "weapon_benelli_m4";
                return image;

        } else if ( isSubStr( weapon, "winchester1200_" ) ) { // 256 x 128
                image = "weapon_winchester1200";
                return image;
     
        // Heavy Gunner
        } else if ( isSubStr( weapon, "saw_" ) ) { // 256 x 128
                image = "weapon_m249saw";
                return image;

        } else if ( isSubStr( weapon, "rpd_" ) ) { // 256 x 128
                image = "weapon_rpd";
                return image;

        } else if ( isSubStr( weapon, "m60e4_" ) ) { // 256 x 128
                image = "weapon_m60e4";
                return image;

        // Sniper
        } else if ( isSubStr( weapon, "dragunov_" ) ) { // 256 x 128
                image = "weapon_dragunovsvd";
                return image;

        } else if ( isSubStr( weapon, "m40a3_" ) ) { // 258 x 128
                image = "weapon_m40a3";
                return image;

        } else if ( isSubStr( weapon, "barrett_" ) ) { // 256 x 128
                image = "weapon_barrett50cal";
                return image;

        } else if ( isSubStr( weapon, "remington700_" ) ) { // 256 x 128
                image = "weapon_remington700";
                return image;

        } else if ( isSubStr( weapon, "m21_" ) ) { // 256 x 128
                image = "weapon_m14_scoped";
                return image;

        // Hardpoint
        } else if ( isSubStr( weapon, "artillery_" ) ) { // 128 x 128
                image = "killstreak_award_airstrike_mp";
                return image;

        } else if ( isSubStr( weapon, "airstrike_" ) ) { // 128 x 128
                image = "killstreak_award_airstrike_mp";
                return image;

        } else if ( isSubStr( weapon, "helicopter_" ) || isSubStr( weapon, "cobra_" ) || isSubStr( weapon, "hind_" ) ) { // 128 x 128
                image = "killstreak_award_helicopter_mp";
                return image;

        // Other
        } else if ( isSubStr( weapon, "frag_grenade_" ) ) { // 128 x 128
                image = "weapon_fraggrenade";
                return image;

        } else if ( isSubStr( weapon, "c4_" ) ) { // 128 x 128
                image = "weapon_c4";
                return image;

        } else if ( isSubStr( weapon, "claymore_" ) ) { // 128 x 128
                image = "weapon_claymore";
                return image;

        } else if ( isSubStr( weapon, "rpg_" ) ) { // 256 x 128
                image = "weapon_rpg7";
                return image;

        } else if ( isSubStr( weapon, "knife_" ) ) { // 256 x 256
                image = "weapon_knife";	
                return image;

        } else if ( weapon == "explodable_barrel" ) { // 64 x 64
                image = "death_barrel";	
                return image;

        } else if ( weapon == "destructible_car" ) { // 64 x 64
                image = "death_auto";	
                return image;

        } else if ( weapon == "none" ) { // 64 x 64
                image = "death_skull";	
                return image;

        // Default
        } else {

                image = "death_skull";	
                return image;
        }
	
}

getHudIconImage( weapon )
{

  	image = "";       

	// Handguns
	if ( isSubStr( weapon, "beretta_" ) ) { // 128 x 64
                image = "hud_icon_m9beretta";
                return image;

        } else if ( isSubStr( weapon, "colt45_" ) ) { // 128 x 64
                image = "hud_icon_colt_45";
                return image;

        } else if ( isSubStr( weapon, "usp_" ) ) { // 64 x 64
                image = "hud_icon_usp_45";
                return image;
	
        } else if ( isSubStr( weapon, "deserteagle_" ) ) { // 128 x 64
                image = "hud_icon_desert_eagle";
                return image;

        } else if ( isSubStr( weapon, "deserteaglegold_" ) ) { // 128 x 64
                image = "hud_icon_desert_eagle";
                return image;

        // Assault
        } else if ( isSubStr( weapon, "m16_" ) ) { // 128 x 32
                image = "hud_icon_m16a4";
                return image;

        } else if ( isSubStr( weapon, "ak47_" ) ) { // 128 x 32
                image = "hud_icon_ak47";
                return image;

        } else if ( isSubStr( weapon, "m4_" ) ) { // 128 x 64
                image = "hud_icon_m4carbine";
                return image;

        } else if ( isSubStr( weapon, "g3_" ) ) { // 128 x 32
                image = "hud_icon_g3";
                return image;

        } else if ( isSubStr( weapon, "g36c_" ) ) { // 128 x 64
                image = "hud_icon_g36c";
                return image;

        } else if ( isSubStr( weapon, "m14_" ) ) { // 128 x 32
                image = "hud_icon_m14";
                return image;

        } else if ( isSubStr( weapon, "mp44_" ) ) { // 128 x 64
                image = "hud_icon_mp44";
                return image;

        // Spec Ops
        } else if ( isSubStr( weapon, "mp5_" ) ) {  // 128 x 64
                image = "hud_icon_mp5";
                return image;

        } else if ( isSubStr( weapon, "skorpion_" ) ) { // 64 x 64
                image = "hud_icon_skorpian";
                return image;

        } else if ( isSubStr( weapon, "uzi_" ) ) { // 64 x 64
                image = "hud_icon_mini_uzi";
                return image;

        } else if ( isSubStr( weapon, "ak74u_" ) ) { // 128 x 64
                image = "hud_icon_ak74u";
                return image;

        } else if ( isSubStr( weapon, "p90_" ) ) { // 128 x 64
                image = "hud_icon_p90";
                return image;

        // Demoliition
        } else if ( isSubStr( weapon, "m1014_" ) ) { // 128 x 32
                image = "hud_icon_benelli_m4";
                return image;

        } else if ( isSubStr( weapon, "winchester1200_" ) ) { // 128 x 32
                image = "hud_icon_winchester_1200";
                return image;
     
        // Heavy Gunner
        } else if ( isSubStr( weapon, "saw_" ) ) { // 128 x 64
                image = "hud_icon_m249saw";
                return image;

        } else if ( isSubStr( weapon, "rpd_" ) ) { // 128 x 64
                image = "hud_icon_rpd";
                return image;

        } else if ( isSubStr( weapon, "m60e4_" ) ) { // 128 x 32
                image = "hud_icon_m60e4";
                return image;

        // Sniper
        } else if ( isSubStr( weapon, "dragunov_" ) ) { // 128 x 32
                image = "hud_icon_dragunov";
                return image;

        } else if ( isSubStr( weapon, "m40a3_" ) ) { // 128 x 32
                image = "hud_icon_m40a3";
                return image;

        } else if ( isSubStr( weapon, "barrett_" ) ) { // 128 x 64
                image = "hud_icon_barrett50cal";
                return image;

        } else if ( isSubStr( weapon, "remington700_" ) ) { // 128 x 32
                image = "hud_icon_remington700";
                return image;

        } else if ( isSubStr( weapon, "m21_" ) ) { // 128 x 32
                image = "hud_icon_m14_scoped";
                return image;

        // Hardpoint
        } else if ( isSubStr( weapon, "radar_" ) ) { // 128 x 128
                image = "death_radar";
                return image;

        } else if ( isSubStr( weapon, "airstrike_" ) ) { // 128 x 32
                image = "death_airstrike";
                return image;

        } else if ( isSubStr( weapon, "artillery_" ) ) { // 128 x 32
                image = "death_airstrike";
                return image;

        } else if ( isSubStr( weapon, "helicopter_" ) || isSubStr( weapon, "cobra_" ) || isSubStr( weapon, "hind_" ) ) { // 128 x 32
                image = "death_helicopter";
                return image;

        // Other
        } else if ( isSubStr( weapon, "frag_grenade_" ) ) { // 64 x 64
                image = "hud_us_grenade";
                return image;

        } else if ( isSubStr( weapon, "c4_" ) ) { // 64 x 64
                image = "hud_icon_c4";
                return image;

        } else if ( isSubStr( weapon, "claymore_" ) ) { // 32 x 32
                image = "hud_icon_claymore";
                return image;

        } else if ( isSubStr( weapon, "rpg_" ) ) { // 128 x 32
                image = "hud_icon_rpg";
                return image;

        } else if ( isSubStr( weapon, "knife_" ) ) { // 64 x 64
                image = "killiconmelee";	
                return image;

        } else if ( weapon == "explodable_barrel" ) { // 32 x 32
                image = "killiconcrush";	
                return image;

        } else if ( weapon == "destructible_car" ) { // 64 x 64
                image = "death_car";	
                return image;

        } else if ( weapon == "none" ) { // 32 x 32
                image = "killicondied";	
                return image;

        // Default
        } else {

                image = "killicondied";	
                return image;
        }
	
}

getHudIconSize( weapon )
{
  	size = "";       

	// Handguns
	if ( isSubStr( weapon, "beretta_" ) ) { // 128 x 64
                size = 4;
                return size;

        } else if ( isSubStr( weapon, "colt45_" ) ) { // 128 x 64
                size = 4;
                return size;

        } else if ( isSubStr( weapon, "usp_" ) ) { // 64 x 64
                size = 2;
                return size;
	
        } else if ( isSubStr( weapon, "deserteagle_" ) ) { // 128 x 64
                size = 4;
                return size;

        } else if ( isSubStr( weapon, "deserteaglegold_" ) ) { // 128 x 64
                size = 4;
                return size;

        // Assault
        } else if ( isSubStr( weapon, "m16_" ) ) { // 128 x 32
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "ak47_" ) ) { // 128 x 32
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "m4_" ) ) { // 128 x 64
                size = 4;
                return size;

        } else if ( isSubStr( weapon, "g3_" ) ) { // 128 x 32
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "g36c_" ) ) { // 128 x 64
                size = 4;
                return size;

        } else if ( isSubStr( weapon, "m14_" ) ) { // 128 x 32
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "mp44_" ) ) { // 128 x 64
                size = 4;
                return size;

        // Spec Ops
        } else if ( isSubStr( weapon, "mp5_" ) ) {  // 128 x 64
                size = 4;
                return size;

        } else if ( isSubStr( weapon, "skorpion_" ) ) { // 64 x 64
                size = 2;
                return size;

        } else if ( isSubStr( weapon, "uzi_" ) ) { // 64 x 64
                size = 2;
                return size;

        } else if ( isSubStr( weapon, "ak74u_" ) ) { // 128 x 64
                size = 4;
                return size;

        } else if ( isSubStr( weapon, "p90_" ) ) { // 128 x 64
                size = 4;
                return size;

        // Demoliition
        } else if ( isSubStr( weapon, "m1014_" ) ) { // 128 x 32
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "winchester1200_" ) ) { // 128 x 32
                size = 3;
                return size;
     
        // Heavy Gunner
        } else if ( isSubStr( weapon, "saw_" ) ) { // 128 x 64
                size = 4;
                return size;

        } else if ( isSubStr( weapon, "rpd_" ) ) { // 128 x 64
                size = 4;
                return size;

        } else if ( isSubStr( weapon, "m60e4_" ) ) { // 128 x 32
                size = 3;
                return size;

        // Sniper
        } else if ( isSubStr( weapon, "dragunov_" ) ) { // 128 x 32
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "m40a3_" ) ) { // 128 x 32
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "barrett_" ) ) { // 128 x 64
                size = 4;
                return size;

        } else if ( isSubStr( weapon, "remington700_" ) ) { // 128 x 32
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "m21_" ) ) { // 128 x 32
                size = 3;
                return size;

        // Hardpoint
        } else if ( isSubStr( weapon, "radar_" ) ) { // 128 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "artillery_" ) ) { // 128 x 32
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "helicopter_" ) || isSubStr( weapon, "cobra_" ) || isSubStr( weapon, "hind_" ) ) { // 128 x 32
                size = 3;
                return size;

        // Other
        } else if ( isSubStr( weapon, "frag_grenade_" ) ) { // 64 x 64
                size = 2;
                return size;

        } else if ( isSubStr( weapon, "c4_" ) ) { // 64 x 64
                size = 2;
                return size;

        } else if ( isSubStr( weapon, "claymore_" ) ) { // 32 x 32
                size = 1;
                return size;

        } else if ( isSubStr( weapon, "rpg_" ) ) { // 128 x 32
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "knife_" ) ) { // 64 x 64
                size = 2;	
                return size;

        } else if ( weapon == "explodable_barrel" ) { // 32 x 32
                size = 1;	
                return size;

        } else if ( weapon == "destructible_car" ) { // 64 x 64
                size = 2;	
                return size;

        } else if ( weapon == "none" ) { // 32 x 32
                size = 1;	
                return size;

        // Default
        } else {

                size = 1;	
                return size;
        }
	
}

getWeaponImageSize( weapon )
{

  	size = "";       

	// Handguns
	if ( isSubStr( weapon, "beretta_" ) ) {  // 128 x 128
                size = 2;
                return size;

        } else if ( isSubStr( weapon, "colt45_" ) ) { // 128 x 128
                size = 2;
                return size;

        } else if ( isSubStr( weapon, "usp_" ) ) { // 128 x 128
                size = 2;
                return size;
	
        } else if ( isSubStr( weapon, "deserteagle_" ) ) { // 128 x 128
                size = 2;
                return size;

        } else if ( isSubStr( weapon, "deserteaglegold_" ) ) { // 128 x 128
                size = 2;
                return size;

        // Assault
        } else if ( isSubStr( weapon, "m16_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "ak47_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "m4_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "g3_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "g36c_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "m14_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "mp44_" ) ) { // 256 x 128
                size = 3;
                return size;

        // Spec Ops
        } else if ( isSubStr( weapon, "mp5_" ) ) {  // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "skorpion_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "uzi_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "ak74u_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "p90_" ) ) { // 256 x 128
                size = 3;
                return size;

        // Demoliition
        } else if ( isSubStr( weapon, "m1014_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "winchester1200_" ) ) { // 256 x 128
                size = 3;
                return size;
     
        // Heavy Gunner
        } else if ( isSubStr( weapon, "saw_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "rpd_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "m60e4_" ) ) { // 256 x 128
                size = 3;
                return size;

        // Sniper
        } else if ( isSubStr( weapon, "dragunov_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "m40a3_" ) ) { // 258 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "barrett_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "remington700_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "m21_" ) ) { // 256 x 128
                size = 3;
                return size;

        // Hardpoint
        } else if ( isSubStr( weapon, "artillery_" ) ) { // 128 x 128
                size = 2;
                return size;

        } else if ( isSubStr( weapon, "helicopter_" ) || isSubStr( weapon, "cobra_" ) || isSubStr( weapon, "hind_" ) ) { // 128 x 128
                size = 2;
                return size;

        // Other
        } else if ( isSubStr( weapon, "frag_grenade_" ) ) { // 128 x 128
                size = 2;
                return size;

        } else if ( isSubStr( weapon, "c4_" ) ) { // 128 x 128
                size = 2;
                return size;

        } else if ( isSubStr( weapon, "claymore_" ) ) { // 128 x 128
                size = 2;
                return size;

        } else if ( isSubStr( weapon, "rpg_" ) ) { // 256 x 128
                size = 3;
                return size;

        } else if ( isSubStr( weapon, "knife_" ) ) { // 256 x 256
                size = 4;	
                return size;

        } else if ( weapon == "explodable_barrel" ) { // 64 x 64
                size = 1;	
                return size;

        } else if ( weapon == "destructible_car" ) { // 64 x 64
                size = 1;	
                return size;

        } else if ( weapon == "none" ) { // 64 x 64
                size = 1;	
                return size;

        // Default
        } else {

                size = 1;	
                return size;
        }
	
}

loadWeaponIcons()
{
	precacheShader( "weapon_m9beretta" );
	precacheShader( "weapon_colt_45" );
	precacheShader( "weapon_usp_45" );
	precacheShader( "weapon_desert_eagle" );
	precacheShader( "weapon_desert_eagle_gold" );
	precacheShader( "weapon_m16a4" );
	precacheShader( "weapon_ak47" );
	precacheShader( "weapon_m4carbine" );
	precacheShader( "weapon_g3" );
	precacheShader( "weapon_g36c" );
	precacheShader( "weapon_m14" );
	precacheShader( "weapon_mp44" );
	precacheShader( "weapon_mp5" );
	precacheShader( "weapon_skorpion" );
	precacheShader( "weapon_mini_uzi" );
	precacheShader( "weapon_aks74u" );
	precacheShader( "weapon_p90" );
	precacheShader( "weapon_benelli_m4" );
	precacheShader( "weapon_winchester1200" );
	precacheShader( "weapon_m249saw" );
	precacheShader( "weapon_rpd" );
	precacheShader( "weapon_m60e4" );
	precacheShader( "weapon_dragunovsvd" );
	precacheShader( "weapon_m40a3" );
	precacheShader( "weapon_barrett50cal" );
	precacheShader( "weapon_remington700" );
	precacheShader( "weapon_m14_scoped" );
	precacheShader( "weapon_fraggrenade" );
	precacheShader( "weapon_c4" );
	precacheShader( "weapon_claymore" );
	precacheShader( "weapon_rpg7" );
	precacheShader( "weapon_knife" );
	precacheShader( "death_auto" );
	precacheShader( "death_barrel" );
	precacheShader( "death_skull" );


}

loadHudIcons()
{
	precacheShader( "hud_icon_m9beretta" );
	precacheShader( "hud_icon_colt_45" );
	precacheShader( "hud_icon_usp_45" );
	precacheShader( "hud_icon_desert_eagle" );
	precacheShader( "hud_icon_m16a4" );
	precacheShader( "hud_icon_ak47" );
	precacheShader( "hud_icon_m4carbine" );
	precacheShader( "hud_icon_g3" );
	precacheShader( "hud_icon_g36c" );
	precacheShader( "hud_icon_m14" );
	precacheShader( "hud_icon_mp44" );
	precacheShader( "hud_icon_mp5" );
	precacheShader( "hud_icon_skorpian" );
	precacheShader( "hud_icon_mini_uzi" );
	precacheShader( "hud_icon_ak74u" );
	precacheShader( "hud_icon_p90" );
	precacheShader( "hud_icon_benelli_m4" );
	precacheShader( "hud_icon_winchester_1200" );
	precacheShader( "hud_icon_m249saw" );
	precacheShader( "hud_icon_rpd" );
	precacheShader( "hud_icon_m60e4" );
	precacheShader( "hud_icon_dragunov" );
	precacheShader( "hud_icon_m40a3" );
	precacheShader( "hud_icon_barrett50cal" );
	precacheShader( "hud_icon_remington700" );
	precacheShader( "hud_icon_m14_scoped" );
	precacheShader( "hud_us_grenade" );
	precacheShader( "hud_icon_c4" );
	precacheShader( "hud_icon_claymore" );
	precacheShader( "hud_icon_rpg" );
	precacheShader( "killiconmelee" );
	precacheShader( "killiconcrush" );
	precacheShader( "death_car" );
	precacheShader( "killiconimpact" );
	precacheShader( "killicondied" );

}

loadHardpointShaders()
{

        // Hardpoint Images
	precacheShader( "killstreak_award_airstrike_mp" );
	precacheShader( "killstreak_award_helicopter_mp" );
	precacheShader( "killstreak_award_radar_mp" );

	precacheShader( "death_radar" );
	precacheShader( "death_airstrike" );
	precacheShader( "death_helicopter" );


}
