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


#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;


init()
{
    level.finalKillcamInProgress = false;
    level.finalKillcamInfo = [];
    level.finalKillcamHUD = spawnStruct();
    
    precacheString( &"OW_FINALCAM_PLAYER_SUICIDE" );
    precacheString( &"OW_FINALCAM_PLAYER_VS_PLAYER" );
    precacheString( &"OW_FINALCAM_ROUND_WIN" );
    precacheString( &"OW_FINALCAM_MATCH_WIN" );
}


onPlayerKilled( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, viewEntityNum, iAttackerNum )
{
    switch( sMeansOfDeath )
    {
        //Don't record explosions witn none weapons
        case "MOD_EXPLOSIVE":
            if( sWeapon == "none" )
                return;

            break;

        //Override killcam entity (like a burrel)
        /*case "MOD_CRUSH":
            if( isDefined( eInflictor ) )
                killcamentity = eInflictor getEntityNumber();

            break;*/

        //Override attacker for suicides
        case "MOD_SUICIDE":
        case "MOD_FALLING":
        case "MOD_TRIGGER_HURT":
            eAttacker = self;

            break;
    }

    if( ! isDefined( eAttacker ) )
    {
        return;
    }

    attackerNum = eAttacker getEntityNumber();

    if( ! isPlayer( eAttacker ) && iAttackerNum > 0 )
    {
        attackerNum = iAttackerNum;
    }

    if( isDefined( eAttacker.team ) && isDefined ( level.otherTeam[eAttacker.team] ) )
    {    
        if( level.teamBased && level.gametype != "bel" )
        {
            killerId = eAttacker.team;

            //Hack to show player suicide. switch team for displaying self kill 
            if ( eAttacker == self ) killerId = level.otherTeam[eAttacker.team];
        }
        else
        {
            killerId = "player";
        }

        isSuicide = false;

        if ( eAttacker == self )
        {
            viewEntityNum = -1;
            isSuicide = true;
        }

        level.finalKillcamInfo[killerId]["attackerNum"] = attackerNum;
        level.finalKillcamInfo[killerId]["attackerName"] = eAttacker.name;

        level.finalKillcamInfo[killerId]["victimNum"] = self getEntityNumber();
        level.finalKillcamInfo[killerId]["victimName"] = self.name;

        level.finalKillcamInfo[killerId]["deathTime"] = getTime()/1000;
        level.finalKillcamInfo[killerId]["isSuicide"] = isSuicide;
        level.finalKillcamInfo[killerId]["weapon"] = sWeapon;
        level.finalKillcamInfo[killerId]["viewEntityNum"] = viewEntityNum;
    }
}


startFinalKillcam( winner, mode )
{
    level endon("end_killcam");
    
    killInfo = getFinalKillcamInfo( winner );

    if( ! isDefined( killInfo ) )
    {
        return;
    }
    
    viewTimeLength = getViewDuration( killInfo["weapon"] );
    viewEntityDist = getViewDistance( killInfo["weapon"] );
    upperTitleText = getTitleText( mode );

    startDelay = getTime()/1000 - killInfo["deathTime"];
    finalDelay = 1;
    timeLength = viewTimeLength + finalDelay;
    timeOffset = viewTimeLength + startDelay;

    //if we're not looking back in time far enough to even see the death, cancel (check for 400 frames = 20 seconds for 20 fps)
    if( timeOffset >= 400 / getDvarInt( "sv_fps" ) )
    {
        return;
    }
    
    level.finalKillcamInProgress = true;
    level notify("begin_killcam");

    showFinalKillcamHUD( killInfo["victimName"], killInfo["attackerName"], killInfo["isSuicide"] );
    visionSetNaked( maps\mp\gametypes\_globallogic::getNakedVision(), 0.5 );
    //Use it only with FinalKillcamEntityCamera plugin: https://github.com/ObelardO/Cod4x-Server/tree/final-killcam-plugin/plugins/FinalKillcamEntityCamera
    setFinalKillcamTargetEntity( killInfo["victimNum"] );
    
    for( i = 0; i < level.players.size; i++ )
    {
        player = level.players[i];

        player setClientDvar ("cg_airstrikeKillCamDist", viewEntityDist );
        player setClientDvar ("ui_hud_killcam_title", upperTitleText );
        
        player thread playerFinalKillcamThread( killInfo["attackerNum"], killInfo["viewEntityNum"], timeOffset, timeLength );
    }

    wait timeLength;

    hideFinalKillcamHUD();
    visionSetNaked( "mpOutro", 0.2 );
    //Use it only with FinalKillcamEntityCamera
    setFinalKillcamTargetEntity( -1 );
    wait 0.2;

    level.finalKillcamInProgress = false;
    level notify("end_killcam");
}


playerFinalKillcamThread( attackerNum, viewEntityNum, timeOffset, timeLength )
{
    level endon( "end_killcam" );
    self endon( "disconnect" );

    self notify( "reset_outcome" );

    wait 0.05;
    self notify( "begin_killcam", getTime() );
    
    self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
    
    self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.killcamentity = viewEntityNum;
	self.archivetime = timeOffset;
	self.killcamlength = timeLength;
	self.psoffsettime = 0;
    self.killcam = true;    
    
    wait timeLength;

    if ( ! isDefined( self ) )
        return;
    
    self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
    self.killcam = undefined;

    wait 0.05;
    self notify("end_killcam");
}


showFinalKillcamHUD( victimName, attackerName, isSuicide )
{
    if ( ! isDefined( level.finalKillcamHUD.textLowerElem ) )
    {
        level.finalKillcamHUD.textLowerElem = createServerFontString( "default", 1.4 );
        level.finalKillcamHUD.textLowerElem setPoint( "CENTER", "BOTTOM", 0, -30 );
        level.finalKillcamHUD.textLowerElem.archived = false;
        level.finalKillcamHUD.textLowerElem.foreground = true;
    }

    level.finalKillcamHUD.textLowerElem.alpha = 1;

    if ( isSuicide )
    {
        level.finalKillcamHUD.textLowerElem setText( &"OW_FINALCAM_PLAYER_SUICIDE", victimName );
    }
    else
    {
        level.finalKillcamHUD.textLowerElem setText( &"OW_FINALCAM_PLAYER_VS_PLAYER", attackerName, victimName );
    }
}


hideFinalKillcamHUD()
{
    level.finalKillcamHUD.textLowerElem.alpha = 0;
}


getFinalKillcamInfo( winner )
{
    if( level.teamBased && level.gametype != "bel" )
    {
        return level.finalKillcamInfo[winner];
    }
    else if( isPlayer( winner ) )
    {
        return level.finalKillcamInfo["player"];
    }

    return undefined;
}


getTitleText( mode )
{
    switch( mode )
    {
        case "round":
            return "OW_FINALCAM_ROUND_WIN";
        case "match":
            return "OW_FINALCAM_MATCH_WIN";
        default:
            return "OW_KILLCAM_TITLE";
    }
}


getViewDistance( weapon )
{
    switch( weapon )
    {
        case "artillery_mp":
            return 60;
        case "airstrike_mp":
            return 60;
        case "claymore_mp":
            return 20;
        case "frag_grenade_mp":
            return 60;
        default:
            return 40;
    }
}


getViewDuration( weapon )
{
    switch( weapon )
    {
        case "artillery_mp":
            return 3;
        case "airstrike_mp":
            return 3;
        case "claymore_mp":
            return 3;
        case "frag_grenade_mp":
            return 4;
        default:
            return 5;
    }
}