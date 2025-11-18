//**************************************************************//
//  _____ _          _    _    _             __                 //
// |  _  | |        | |  | |  | |           / _|                //
// | | | | |__   ___| |  | |  | | __ _ _ __| |_ __ _ _ __ ___   //
// | | | | '_ \ / _ \ |  | |/\| |/ _` | '__|  _/ _` | '__/ _ \  //
// \ \_/ / |_) |  __/ |__\  /\  / (_| | |  | || (_| | | |  __/  //
//  \___/|_.__/ \___|____/\/  \/ \__,_|_|  |_| \__,_|_|  \___|  //
//                                                              //
//            Website: http://cod4.obelardo.ru                  //
//**************************************************************//
// Based on HolyMoly's Playercard mod                           //
// http://www.holymolymods.com                                  //
//**************************************************************//


#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include openwarfare\_eventmanager;
#include openwarfare\_utils;


init()
{
	// Get the main module's dvars
	level.scr_card = getdvarx( "scr_card", "int", 3, 0, 3 );  
	level.scr_card_hardpoints = getdvarx( "scr_card_hardpoints", "int", 1, 0, 1 );  

        // If not activated
	if( level.scr_card == 0 && level.scr_card_hardpoints == 0 )
		return;

        // NO Center Obit
        setDvar( "ui_hud_show_center_obituary", "0" );

        // Dvars Playercards
        level.scr_card_time_visible = getdvarx( "scr_card_time_visible", "float", 1.5, 1.5, 5 );
        level.scr_card_amount = getdvarx( "scr_card_amount", "int", 20, 1, 20 );
        level.scr_card_pers_enabled = getdvarx( "scr_card_pers_enabled", "int", 0, 0, 1 );  
        // 

        // Dvar Playercard Hardpoints
        level.scr_card_hardpoints_time_visible = getdvarx( "scr_card_hardpoints_time_visible", "float", 3.5, 1.5, 5 ); 
	level.scr_card_hardpoints_enemy_display = getdvarx( "scr_card_hardpoints_enemy_display", "int", 1, 0, 1 ); 

        if( !isDefined( level.playerCard ) )
        {
                level.playerCard = spawnStruct();

                if( level.scr_card > 1 ) initWeaponInfo();

                initHudShaders();
        }

        if( level.scr_card_pers_enabled ) //Optional
                scripts\_playercardPers::initCardsInfo();

        precacheString( &"OW_CARD_HELICOPTER_INBOUN" );
        precacheString( &"OW_CARD_AIRSTRIKE_INBOUN" );
        precacheString( &"OW_CARD_UAV_INBOUND" );
        precacheString( &"OW_CARD_ATTACKER" );
	precacheString( &"OW_CARD_VICTIM" );
	
	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


initWeaponInfo()
{
        imageColumn = 4;
        sizeColumn = 5;

        if( level.scr_card == 3 )
        {
                imageColumn = 2;
                sizeColumn = 3;
        }

        level.playerCard.weaponInfo = [];

        weaponsCount = int ( tableLookup( "mp/cardtable.csv", 1, "none", 0 ) );

        for( i = 1; i <= weaponsCount; i++ )
        {
                weaponName = tableLookup( "mp/cardtable.csv", 0, i, 1 );
                weaponSize = int( tableLookup( "mp/cardtable.csv", 0, i, sizeColumn ) );

                if( !isDefined ( weaponName ) || weaponName == "" ) continue;

                level.playerCard.weaponInfo[weaponName] = spawnStruct();
                level.playerCard.weaponInfo[weaponName].hudImage = tableLookup( "mp/cardtable.csv", 0, i, imageColumn );

                precacheShader( level.playerCard.weaponInfo[weaponName].hudImage );

                if( level.scr_card == 2 )
                {
                        if ( weaponSize <= 2 ) level.playerCard.weaponInfo[weaponName].hudSize = ( 34, 34, 96 ); //80
                        if ( weaponSize == 3 ) level.playerCard.weaponInfo[weaponName].hudSize = ( 80, 40, 96 ); //64
                        if ( weaponSize == 4 ) level.playerCard.weaponInfo[weaponName].hudSize = ( 64, 64, 96 ); //64
                }

                if( level.scr_card == 3 )
                {
                        if ( weaponSize <= 2 ) level.playerCard.weaponInfo[weaponName].hudSize = ( 34, 34, 96 );
                        if ( weaponSize == 3 ) level.playerCard.weaponInfo[weaponName].hudSize = ( 72, 18, 96 );
                        if ( weaponSize == 4 ) level.playerCard.weaponInfo[weaponName].hudSize = ( 72, 36, 96 );
                        if ( weaponSize == 5 ) level.playerCard.weaponInfo[weaponName].hudSize = ( 40, 40, 96 );
                }
        }
}

initHudShaders()
{
        for( cards = 0; cards < level.scr_card_amount; cards++ )
        {
                precacheShader( "playercard_emblem_" + cards );
        }

        // Hardpoint Images
	precacheShader( "killstreak_award_airstrike_mp" );
	precacheShader( "killstreak_award_helicopter_mp" );
	precacheShader( "killstreak_award_radar_mp" );

	precacheShader( "death_radar" );
	precacheShader( "death_airstrike" );
	precacheShader( "death_helicopter" );
}


onPlayerConnected()
{
        if( !isDefined( self.playerCard ) ) 
        {
                self.playerCard = spawnStruct();
                self.playerCard.cardName = randomIntRange( 0, level.scr_card_amount );
                self.playerCard.isShowingKill = false;
                self.playerCard.isMoving = false;
                self.playerCard.isShowingHardPoint = false;
                self.playerCard.isMovingHardPoint = false;

                if( level.scr_card_pers_enabled ) //Optional
                        self scripts\_playercardPers::setPlayerCard();
        }
	
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
}


onPlayerSpawned()
{
        // Killed by / You Killed
        if( !isDefined( self.playercard.hudTitle ) )
        {
	        self.playercard.hudTitle = newClientHudElem( self );
	        self.playercard.hudTitle.x = 0; 
                self.playercard.hudTitle.y = -100 -40;
	        self.playercard.hudTitle.alignX = "center";
	        self.playercard.hudTitle.alignY = "top";
	        self.playercard.hudTitle.horzAlign = "center";
	        self.playercard.hudTitle.vertAlign = "bottom";
	        self.playercard.hudTitle.fontScale = 1.6;
	        self.playercard.hudTitle.sort = 1002;
	        self.playercard.hudTitle.glowAlpha = 0;
                self.playercard.hudTitle.alpha = 0;
                self.playercard.hudTitle.archived = true;
                self.playercard.hudTitle.foreground = true;
        }

        // Player Name
        if( !isDefined( self.playercard.hudName ) )
        {
	        self.playercard.hudName = newClientHudElem( self );
	        self.playercard.hudName.x = -97; 
                self.playercard.hudName.y = -77 -40;
	        self.playercard.hudName.alignX = "left";
	        self.playercard.hudName.alignY = "top";
	        self.playercard.hudName.horzAlign = "center";
	        self.playercard.hudName.vertAlign = "bottom";
	        self.playercard.hudName.fontScale = 1.4;
	        self.playercard.hudName.sort = 1002;
	        self.playercard.hudName.glowAlpha = 0;
                self.playercard.hudName.alpha = 0;
                self.playercard.hudName.color = (1, 1, 1);
                self.playercard.hudName.archived = true;
                self.playercard.hudName.foreground = true;
        }

        // Background Image
        if( !isDefined( self.playercard.hudImage ) )
        {
	        // Create the HUD element to display the playercard
	        self.playercard.hudImage = newClientHudElem( self );
	        self.playercard.hudImage.x = 0;
	        self.playercard.hudImage.y = -80 -40;	
	        self.playercard.hudImage.sort = 1001;
                self.playercard.hudImage.alignX = "center";
	        self.playercard.hudImage.alignY = "top";
	        self.playercard.hudImage.horzAlign = "center";
	        self.playercard.hudImage.vertAlign = "bottom";
                self.playercard.hudImage.alpha = 0;
                self.playercard.hudImage.archived = true;
                self.playercard.hudImage.foreground = true;
        }

        // Rank Icon
	if( !isDefined( self.playercard.hudRankIcon ) )
        {
		self.playercard.hudRankIcon = self createIcon( "white", 25, 25 );
		self.playercard.hudRankIcon setPoint( "CENTER", "BOTTOM", -80, -47 -40 );
		self.playercard.hudRankIcon.sort = 1002;
		self.playercard.hudRankIcon.alpha = 0;
		self.playercard.hudRankIcon.archived = true;
		self.playercard.hudRankIcon.foreground = true;
	}

        if( !isDefined( self.playercard.hudWeapIcon ) )
        {
                self.playercard.hudWeapIcon = self createIcon( "white", 25, 25 );
                self.playercard.hudWeapIcon setPoint( "RIGHT", "BOTTOM", 96, -47 -40 );
                self.playercard.hudWeapIcon.sort = 1002;
                self.playercard.hudWeapIcon.alpha = 0;
                self.playercard.hudWeapIcon.archived = true;
                self.playercard.hudWeapIcon.foreground = true;
        }
        
        if( level.scr_card_hardpoints == 1 )
        {
                // Player Name
                if( !isDefined( self.playercard.hudNameHp ) )
                {
	                self.playercard.hudNameHp = newClientHudElem( self );
	                self.playercard.hudNameHp.x = -210; 
                        self.playercard.hudNameHp.y = 113;
	                self.playercard.hudNameHp.alignX = "left";
	                self.playercard.hudNameHp.alignY = "top";
	                self.playercard.hudNameHp.horzAlign = "right";
	                self.playercard.hudNameHp.vertAlign = "top";
	                self.playercard.hudNameHp.fontScale = 1.4;
	                self.playercard.hudNameHp.sort = -1;
	                self.playercard.hudNameHp.glowAlpha = 0;
                        self.playercard.hudNameHp.alpha = 0;
                        self.playercard.hudNameHp.archived = true;
                        self.playercard.hudNameHp.foreground = true;
                }

                // Background Image
                if( !isDefined( self.playercard.hudImageHp ) )
                {
	                // Create the HUD element to display the playercard
	                self.playercard.hudImageHp = newClientHudElem( self );
	                self.playercard.hudImageHp.x = -213;
	                self.playercard.hudImageHp.y = 110;
	                self.playercard.hudImageHp.sort = -2;
                        self.playercard.hudImageHp.alignX = "left";
	                self.playercard.hudImageHp.alignY = "top";
	                self.playercard.hudImageHp.horzAlign = "right";
	                self.playercard.hudImageHp.vertAlign = "top";
                        self.playercard.hudImageHp.alpha = 0;
                        self.playercard.hudImageHp.archived = true;
                        self.playercard.hudImageHp.foreground = true;
                }

                // Rank Icon
	        if( !isDefined( self.playercard.hudRankIconHp ) )
                {
		        self.playercard.hudRankIconHp = self createIcon( "white", 25, 25 );
		        self.playercard.hudRankIconHp setPoint( "CENTER", "TOP RIGHT", -195, 144 );
		        self.playercard.hudRankIconHp.sort = -1;
		        self.playercard.hudRankIconHp.alpha = 0;
		        self.playercard.hudRankIconHp.archived = true;
		        self.playercard.hudRankIconHp.foreground = true;
	        }

                // Hardpoint Text
                if( !isDefined( self.playercard.hudTitleHp ) )
                {
	                self.playercard.hudTitleHp = newClientHudElem( self );
	                self.playercard.hudTitleHp.x = -210; 
                        self.playercard.hudTitleHp.y = 161;
	                self.playercard.hudTitleHp.alignX = "left";
	                self.playercard.hudTitleHp.alignY = "top";
	                self.playercard.hudTitleHp.horzAlign = "right";
	                self.playercard.hudTitleHp.vertAlign = "top";
	                self.playercard.hudTitleHp.fontScale = 1.4;
	                self.playercard.hudTitleHp.sort = -1;
	                self.playercard.hudTitleHp.glowAlpha = 0;
		        self.playercard.hudTitleHp.alpha = 0;
		        self.playercard.hudTitleHp.archived = true;
		        self.playercard.hudTitleHp.foreground = true;
                }

                // Weapon Icon
                if( !isDefined( self.playercard.hudWeapIconHp ) )
                {
		        self.playercard.hudWeapIconHp = self createIcon( "white", 25, 25 );
		        self.playercard.hudWeapIconHp setPoint( "RIGHT", "TOP RIGHT", -16, 144 );
		        self.playercard.hudWeapIconHp.sort = -1;
		        self.playercard.hudWeapIconHp.alpha = 0;
		        self.playercard.hudWeapIconHp.archived = true;
		        self.playercard.hudWeapIconHp.foreground = true;
	        }
        }

        self thread waitForKill();

        if( level.scr_card_hardpoints == 1 )
                self thread waitTillHardpointCalled();
}


waitForKill()
{
	self endon ( "disconnect" );
        level endon( "game_ended" );

	// Wait for the player to die
	self waittill( "player_killed", eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, fDistance );

        // Suicide
        if( !isPlayer( attacker ) || attacker == self  )
                return;

        // Team Kill
        if( level.teamBased && attacker.pers["team"] == self.pers["team"] )
                return;
     
	// Adjustment to the sWeapon name
	if ( sMeansOfDeath == "MOD_MELEE" )
		sWeapon = "knife_mp";

        // Victim Info
        playercardVictim = spawnstruct();
        playercardVictim.name = self.name;
        playercardVictim.rank = self.pers["rank"] + 1;
        playercardVictim.card = self.playerCard.cardName;
        playercardVictim.icon = self maps\mp\gametypes\_rank::getRankInfoIcon( self.pers["rank"], self.pers["prestige"] );
        playercardVictim.team = game["icons"][self.team];
        playercardVictim.text = &"OW_CARD_VICTIM";
        playercardVictim.textcolor = ( 0.98, 0.67, 0.67 );
        playercardVictim.player = self;

        //Attacker Info
        playercardAttacker = spawnstruct();
        playercardAttacker.name = attacker.name;
        playercardAttacker.rank = attacker.pers["rank"] + 1;
        playercardAttacker.card = attacker.playerCard.cardName;
        playercardAttacker.icon = attacker maps\mp\gametypes\_rank::getRankInfoIcon( attacker.pers["rank"], attacker.pers["prestige"] );
        playercardAttacker.team = game["icons"][attacker.team];
        playercardAttacker.text = &"OW_CARD_ATTACKER";
        playercardAttacker.textcolor = ( 0.73, 0.97, 0.71 );
        playercardAttacker.player = attacker;

        //Weapon Info
        weaponInfo = getWeaponInfo( sWeapon );

        // Victim Thread
        if( isDefined( self ) && isPlayer( self ) )
                self thread showKillCard( playercardAttacker, playercardVictim, weaponInfo );
        
        // Attacker Thread
        if( isDefined( attacker ) )
                attacker thread showKillCard( playercardVictim, playercardAttacker, weaponInfo );
}


getWeaponInfo( weaponName )
{
        if ( level.scr_card > 1 && isDefined ( weaponName ) && weaponName != "" )
        {
                weaponPrefix = strTok( weaponName, "_" );

                return level.playerCard.weaponInfo[ weaponPrefix[0] ];
        }
                
        return undefined;
}


showKillCard( playercardVictim, playercardAttacker, weaponInfo )
{
	self endon( "disconnect" );

        // Wait if already showing a card
        //while( isDefined( self.playerCard.isShowingKill ) && self.playerCard.isShowingKill == true )
        //{
        //        wait( 0.2 );
        //}

        // Wait if already showing a card
        while( self.playerCard.isMoving )
        {
                wait( 0.02 );
        }

        // Self Spectating
        if( self.sessionstate == "spectator" )
                return;

        // Game ended or Intermission
        if( level.gameEnded || level.intermission )
                return;

        hintKey = "card_" + playercardVictim.player getEntityNumber();

        self maps\mp\gametypes\_hud_hints::showHint( "  ", hintKey, undefined, true );

        self.playerCard.isShowingKill = true;

        if( level.scr_card == 1 )
                self.playercard.hudWeapIcon setShader( playercardVictim.team, 25, 25 );
        else
                self.playercard.hudWeapIcon showKillCardWeapon( weaponInfo );

        self.playercard.hudRankIcon setShader( playercardVictim.icon, 25, 25 );
        self.playercard.hudTitle setText( playercardAttacker.text );
	self.playercard.hudTitle.color = playercardAttacker.textcolor;
        self.playercard.hudImage setShader( "playercard_emblem_" + playercardVictim.card, 200, 50 );
	self.playercard.hudName setPlayerNameString( playercardVictim.player );

        self.playercard.hudWeapIcon.alpha = 1;
        self.playercard.hudRankIcon.alpha = 1;
        self.playercard.hudTitle.alpha = 1;
        self.playercard.hudImage.alpha = 0.9;
        self.playercard.hudName.alpha = 1;
        
        // Time shader visible
        wait( level.scr_card_time_visible );

        self maps\mp\gametypes\_hud_hints::hideHint( hintKey );

        self.playerCard.isMoving = true; 

        // Move to bottom and set non-visible
        self.playercard.hudWeapIcon moveOverTime( 0.40 );
        self.playercard.hudRankIcon moveOverTime( 0.40 );
        self.playercard.hudTitle moveOverTime( 0.40 );
        self.playercard.hudImage moveOverTime( 0.40 );
        self.playercard.hudName moveOverTime( 0.40 );
        
        self.playercard.hudWeapIcon.y = 53;
        self.playercard.hudRankIcon.y = 53;
        self.playercard.hudTitle.y = 0;
        self.playercard.hudImage.y = 20;
        self.playercard.hudName.y = 23;

        // Time wait to move to bottom
        wait( 0.4 );

        // Move back to start position.
        //self.playercard.hudWeapIcon moveOverTime( 0.05 );
        //self.playercard.hudRankIcon moveOverTime( 0.05 );
        //self.playercard.hudTitle moveOverTime( 0.05 );
        //self.playercard.hudImage moveOverTime( 0.05 );
        //self.playercard.hudName moveOverTime( 0.05 );
        
        self.playercard.hudWeapIcon.y = -47 -40;
        self.playercard.hudRankIcon.y = -47 -40;
        self.playercard.hudTitle.y = -100 -40;
        self.playercard.hudImage.y = -80 -40;
        self.playercard.hudName.y = -77 -40;

        self.playercard.hudWeapIcon.alpha = 0;
        self.playercard.hudRankIcon.alpha = 0;
        self.playercard.hudTitle.alpha = 0;
        self.playercard.hudImage.alpha = 0;
        self.playercard.hudName.alpha = 0;
        
        // Time wait to move back
        //wait( 0.05 );

        self.playerCard.isMoving = false;

        self.playerCard.isShowingKill = false;
}


showKillCardWeapon( weaponInfo )
{
        if( !isDefined ( weaponInfo ) )
        {
                return;
        }

        self setShader( weaponInfo.hudImage, int( weaponInfo.hudSize[0] ), int( weaponInfo.hudSize[1] ) );
        self.x = int( weaponInfo.hudSize[2] );
}


waitTillHardpointCalled()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	for( ;; )
	{
		self waittill( "hardpoint_called", hardpointName );

                // Set up info
                playercardHp = spawnstruct();
                playercardHp.player = self;
                playercardHp.name = self.name;
                playercardHp.rank = self.pers["rank"] + 1;
                playercardHp.team = self.pers["team"];
                playercardHp.image = self.playerCard.cardName;
                playercardHp.icon = self maps\mp\gametypes\_rank::getRankInfoIcon( self.pers["rank"], self.pers["prestige"] );
                playercardHp.hardpoint = hardpointName;
                
                weaponInfo = getWeaponInfo( playercardHp.hardpoint );

                players = level.players;
                for( i = 0; i < players.size; i++ )
                {
                        samePlayer = players[i] == self;
                        sameTeam = players[i].pers["team"] == self.pers["team"];

                        if ( !sameTeam || !samePlayer )
                        {
                                if( level.teamBased && level.scr_card_hardpoints_enemy_display == 0 ) continue;

                                playercardHp.textcolor = ( 0.98, 0.67, 0.67 ); // Red
                        }
                        else
                        {
                                playercardHp.textcolor = ( 0.73, 0.97, 0.71 );
                        }

                        if( isDefined( players[i] ) && isPlayer ( players[i] ) && isAlive ( players[i] ) )
                        {
                                players[i] thread showPlayercardHardpoint( playercardHp, weaponInfo );
                        }
                }

                wait( 0.05 );                        
	}
}


showPlayercardHardpoint( playercardHp, weaponInfo )
{
	self endon( "disconnect" );

        // Wait if already showing a card
        //while( isDefined( self.playerCard.isShowingHardPoint ) && self.playerCard.isShowingHardPoint == true )
        //{
        //        wait( 0.2 );
        //}

        // Wait if already showing a card
        while( self.playerCard.isMovingHardPoint )
        {
                wait( 0.02 );
        }

        // Self Spectating
        if( self.sessionstate == "spectator" )
                return;

        // Game ended or Intermission
        if( level.gameEnded || level.intermission )
                return;
                
        self.playerCard.isShowingHardPoint = true;

        // Weapon Icon
        if( level.scr_card == 1 )
                self.playercard.hudWeapIconHp setShader( playercardHp.team, 25, 25 );
        else
                self.playercard.hudWeapIconHp showKillCardWeapon( weaponInfo );

        self.playercard.hudWeapIconHp.x = -16;

        // Rank Icon
        self.playercard.hudRankIconHp setShader( playercardHp.icon, 25, 25 );

        // Hardpoint Text Message...................... Add your extra Hp's here
        if( playercardHp.hardpoint == "radar_mp" ) 
                self.playercard.hudTitleHp setText( &"OW_CARD_UAV_INBOUND" );

        if( playercardHp.hardpoint == "airstrike_mp" ) 
                self.playercard.hudTitleHp setText( &"OW_CARD_AIRSTRIKE_INBOUN" );

        if( playercardHp.hardpoint == "helicopter_mp" ) 
                self.playercard.hudTitleHp setText( &"OW_CARD_AIRSTRIKE_INBOUN" );

        self.playercard.hudTitleHp.color = playercardHp.textcolor;

        // Background Image
        self.playercard.hudImageHp setShader( "playercard_emblem_" + playercardHp.image, 200, 50 );
        
        // Name
        self.playercard.hudNameHp setPlayerNameString( playercardHp.player );
        self.playercard.hudNameHp.color = ( 1, 1, 1 );
                
        self.playercard.hudWeapIconHp.alpha = 1;
        self.playercard.hudRankIconHp.alpha = 1;
        self.playercard.hudTitleHp.alpha = 1;
        self.playercard.hudImageHp.alpha = 0.75;
        self.playercard.hudNameHp.alpha = 1;

        // Time Visable
        wait( level.scr_card_hardpoints_time_visible );

        self.playercard.isMovingHardPoint = true;

        self.playercard.hudWeapIconHp moveOverTime( 0.40 );
        self.playercard.hudRankIconHp moveOverTime( 0.40 );
        self.playercard.hudTitleHp moveOverTime( 0.40 );
        self.playercard.hudImageHp moveOverTime( 0.40 );
        self.playercard.hudNameHp moveOverTime( 0.40 );

        self.playercard.hudWeapIconHp.x = 207;
        self.playercard.hudRankIconHp.x = 28;
        self.playercard.hudTitleHp.x = 13;
        self.playercard.hudImageHp.x = 10;
        self.playercard.hudNameHp.x = 13;
     
        // Time wait to move to right
        wait( 0.4 );
  
        // Make it disappear
        self.playercard.hudWeapIconHp.alpha = 0;
        self.playercard.hudRankIconHp.alpha = 0;
        self.playercard.hudTitleHp.alpha = 0;
        self.playercard.hudImageHp.alpha = 0;
        self.playercard.hudNameHp.alpha = 0;

        // Return Home
        self.playercard.hudWeapIconHp moveOverTime( 0.40 );
        self.playercard.hudRankIconHp moveOverTime( 0.40 );
        self.playercard.hudTitleHp moveOverTime( 0.40 );
        self.playercard.hudImageHp moveOverTime( 0.40 );
        self.playercard.hudNameHp moveOverTime( 0.40 );

        // Set back to original positions
        self.playercard.hudWeapIconHp.x = -16;
        self.playercard.hudRankIconHp.x = -195;
        self.playercard.hudTitleHp.x = -210;
        self.playercard.hudImageHp.x = -213;
        self.playercard.hudNameHp.x = -210;

        // Time wait to move back
        wait( 0.4 );

        self.playercard.isMovingHardPoint = false;

        self.playerCard.isShowingHardPoint = false;
}