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

#include openwarfare\_eventmanager;
#include openwarfare\_utils;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                               FINAL DUEL                                                //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Entry point, initialize variables and register events
init()
{
    level.scr_finalduel_enable = getdvarx( "scr_finalduel_enable", "int", 1, 0, 1 );

    level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );

    if( !level.scr_finalduel_enable )
        return;

    level.scr_finalduel_vote_time = getdvarx( "scr_finalduel_vote_time", "int", 15, 5, 60 );
    level.scr_finalduel_min_alive = getdvarx( "scr_finalduel_min_alive", "int", 2, 2, 64 );
    level.scr_finalduel_weapon = toLower( getdvarx( "scr_finalduel_weapon", "string", "knife_mp" ) );
    level.scr_finalduel_weapon_ammo = getdvarx( "scr_finalduel_weapon_ammo", "int", 0, 0, 999 );
    level.scr_finalduel_radar = getdvarx( "scr_finalduel_radar", "int", 1, 0, 2 );
    level.scr_finalduel_time = getdvarx( "scr_finalduel_time", "int", 60, 10, 300 );

    //Initialize final duel data once
    if( !isDefined( level.finalDuel ) )
    {
        //Base module struct
        level.finalDuel = spawnStruct();
        level.finalDuel.menu = "finalduel_vote";
        level.finalDuel.active = false;
        level.finalDuel.voting = false;
        level.finalDuel.voteUsed = false;
        level.finalDuel.yes = 0;
        level.finalDuel.no = 0;
        level.finalDuel.needed = 0;
        level.finalDuel.timeLeft = 0;
        level.finalDuel.loadoutHooked = false;
        level.finalDuel.prevOnLoadoutGiven = undefined;

        precacheMenu( level.finalDuel.menu );
        precacheItem( level.scr_finalduel_weapon );
        precacheString( &"OW_FINALDUEL_CALLVOTE" );
        precacheString( &"OW_FINALDUEL_VOTE_TITLE" );
        precacheString( &"OW_FINALDUEL_VOTE_YES" );
        precacheString( &"OW_FINALDUEL_VOTE_NO" );
        precacheString( &"OW_FINALDUEL_STARTED" );
        precacheString( &"OW_FINALDUEL_PASSED" );
        precacheString( &"OW_FINALDUEL_FAILED" );
        precacheString( &"OW_FINALDUEL_ALREADY" );
        precacheString( &"OW_FINALDUEL_NOT_ALIVE" );
        precacheString( &"OW_FINALDUEL_NEED_PLAYERS" );
        precacheString( &"OW_FINALDUEL_UAV" );
        precacheString( &"OW_FINALDUEL_COMPASS" );
    }

    level thread watchRoundReset();
}

//Initialize player specific data and register events
onPlayerConnected()
{
    self setClientDvar( "ui_allowvote_finalduel", level.scr_finalduel_enable );

    if( !level.scr_finalduel_enable )
        return;

    //Base module struct for player specific data
    self.finalDuel = spawnStruct();
    self.finalDuel.vote = "";
    self.finalDuel.canVote = false;

    yesCount = 0;
    noCount = 0;
    if( isDefined( level.finalDuel ) )
    {
        yesCount = level.finalDuel.yes;
        noCount = level.finalDuel.no;
    }

    self setClientDvars( "ui_finalduel_yes", yesCount, "ui_finalduel_no", noCount, "ui_finalduel_vote", "none", "ui_finalduel_time", 0 );

    self thread addNewEvent( "onMenuResponse", ::onMenuResponse );
    self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
    self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );
}

onPlayerSpawned()
{
    if( isDefined( level.finalDuel ) && level.finalDuel.active )
        self thread applyDuelPlayer();
}

onPlayerDeath()
{
    if( !isDefined( level.finalDuel ) || !level.finalDuel.active )
        return;

    self takeAllWeapons();
    self closeMenu();
    self closeInGameMenu();
}

onMenuResponse( menu, response )
{
    if( response == "finalduel" )
    {
        self thread tryStartVote();
        return;
    }

    if( menu != level.finalDuel.menu )
        return;

    if( !level.finalDuel.voting )
        return;

    if( response == "yes" )
        self registerVote( "yes" );
    else if( response == "no" )
        self registerVote( "no" );
}

watchRoundReset()
{
    for(;;)
    {
        level waittill( "game_ended" );

        level.finalDuel.active = false;
        level.finalDuel.voting = false;
        level.finalDuel.voteUsed = false;
        closeVoteMenus();
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                   VOTE                                                  //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

tryStartVote()
{
    if( !isAlive( self ) || self.sessionstate != "playing" )
    {
        self iprintln( &"OW_FINALDUEL_NOT_ALIVE" );
        return;
    }

    if( level.finalDuel.active || level.finalDuel.voting || level.finalDuel.voteUsed )
    {
        self iprintln( &"OW_FINALDUEL_ALREADY" );
        return;
    }

    if( game["state"] != "playing" )
        return;

    if( isDefined( level.inReadyUpPeriod ) && level.inReadyUpPeriod )
        return;

    if( isDefined( level.inStrategyPeriod ) && level.inStrategyPeriod )
        return;

    if( isDefined( level.inPrematchPeriod ) && level.inPrematchPeriod )
        return;

    if( isDefined( level.inTimeoutPeriod ) && level.inTimeoutPeriod )
        return;

    voters = getAlivePlayers();
    if( voters.size < level.scr_finalduel_min_alive )
    {
        self iprintln( &"OW_FINALDUEL_NEED_PLAYERS" );
        return;
    }

    level thread runVote( self, voters );
}

runVote( caller, voters )
{
    level endon( "game_ended" );

    level.finalDuel.voting = true;
    level.finalDuel.voteUsed = true;
    level.finalDuel.yes = 0;
    level.finalDuel.no = 0;
    level.finalDuel.needed = int( voters.size / 2 ) + 1;
    level.finalDuel.timeLeft = level.scr_finalduel_vote_time;

    for( i = 0; i < voters.size; i++ )
    {
        if( !isDefined( voters[i].finalDuel ) )
        {
            voters[i].finalDuel = spawnStruct();
        }

        voters[i].finalDuel.vote = "";
        voters[i].finalDuel.canVote = true;
        voters[i] setClientDvar( "ui_finalduel_vote", "none" );
    }

    iprintln( &"OW_FINALDUEL_STARTED", caller.name );
    updateVoteHud();

    for( i = 0; i < voters.size; i++ )
    {
        if( isDefined( voters[i] ) && isPlayer( voters[i] ) )
        {
            voters[i] openMenu( level.finalDuel.menu );
            voters[i] thread keepVoteMenuOpen();
        }
    }

    caller registerVote( "yes" );

    for( t = level.scr_finalduel_vote_time; t > 0; t-- )
    {
        level.finalDuel.timeLeft = t;
        updateVoteHud();

        if( level.finalDuel.yes >= level.finalDuel.needed )
            break;

        if( level.finalDuel.yes + remainingVotes() < level.finalDuel.needed )
            break;

        wait 1;
    }

    level.finalDuel.voting = false;
    closeVoteMenus();

    if( level.finalDuel.yes >= level.finalDuel.needed )
    {
        showDuelStartNotify();
        level thread startDuel();
    }
    else
    {
        iprintln( &"OW_FINALDUEL_FAILED" );
    }
}

registerVote( vote )
{
    if( !isDefined( level.finalDuel ) || !level.finalDuel.voting )
        return;

    if( !isDefined( self.finalDuel ) || !self.finalDuel.canVote )
        return;

    if( self.finalDuel.vote != "" )
        return;

    self.finalDuel.vote = vote;
    self.finalDuel.canVote = false;
    self setClientDvar( "ui_finalduel_vote", vote );

    if( vote == "yes" )
        level.finalDuel.yes++;
    else
        level.finalDuel.no++;

    updateVoteHud();
}

remainingVotes()
{
    count = 0;
    players = level.players;

    for( i = 0; i < players.size; i++ )
    {
        player = players[i];
        if( !isDefined( player ) || !isDefined( player.finalDuel ) )
            continue;

        if( player.finalDuel.canVote )
            count++;
    }

    return count;
}

getAlivePlayers()
{
    alive = [];
    players = level.players;

    for( i = 0; i < players.size; i++ )
    {
        player = players[i];
        if( !isDefined( player ) || !isPlayer( player ) )
            continue;

        if( !isAlive( player ) || player.sessionstate != "playing" )
            continue;

        if( !isDefined( player.pers["team"] ) || player.pers["team"] == "spectator" )
            continue;

        alive[alive.size] = player;
    }

    return alive;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                   HUD                                                   //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

updateVoteHud()
{
    players = level.players;
    for( i = 0; i < players.size; i++ )
    {
        if( !isDefined( players[i] ) )
            continue;

        players[i] setClientDvars(
            "ui_finalduel_yes", level.finalDuel.yes,
            "ui_finalduel_no", level.finalDuel.no,
            "ui_finalduel_time", level.finalDuel.timeLeft
        );
    }
}

keepVoteMenuOpen()
{
    self endon( "disconnect" );
    level endon( "game_ended" );

    while( isDefined( level.finalDuel ) && level.finalDuel.voting )
    {
        if( !isDefined( self.finalDuel ) || !self.finalDuel.canVote || self.finalDuel.vote != "" )
            return;

        self openMenu( level.finalDuel.menu );
        wait 0.5;
    }
}

showDuelStartNotify()
{
    notifyText = undefined;
    if( level.scr_finalduel_radar == 1 )
        notifyText = &"OW_FINALDUEL_UAV";
    else if( level.scr_finalduel_radar == 2 )
        notifyText = &"OW_FINALDUEL_COMPASS";

    players = level.players;
    for( i = 0; i < players.size; i++ )
    {
        if( !isDefined( players[i] ) || !isPlayer( players[i] ) )
            continue;

        players[i] thread maps\mp\gametypes\_hud_message::oldNotifyMessage( &"OW_FINALDUEL_PASSED", notifyText, undefined, ( 1, 0, 0 ), "mp_last_stand" );
    }
}

closeVoteMenus()
{
    players = level.players;
    for( i = 0; i < players.size; i++ )
    {
        if( !isDefined( players[i] ) )
            continue;

        if( isDefined( players[i].finalDuel ) )
            players[i].finalDuel.canVote = false;

        players[i] closeMenu();
        players[i] closeInGameMenu();
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                   DUEL                                                  //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

startDuel()
{
    level.finalDuel.active = true;

    if( !level.finalDuel.loadoutHooked )
    {
        level.finalDuel.prevOnLoadoutGiven = level.onLoadoutGiven;
        level.onLoadoutGiven = ::onLoadoutGiven;
        level.finalDuel.loadoutHooked = true;
    }

    level.numLives = 1;

    abortPlantedBomb();
    setDuelRoundTimer();
    disableObjectives();
    deleteMapWeapons();
    enablePermanentUav();

    players = level.players;
    for( i = 0; i < players.size; i++ )
    {
        player = players[i];
        if( !isDefined( player ) || !isPlayer( player ) )
            continue;

        if( isAlive( player ) && player.sessionstate == "playing" )
            player thread applyDuelPlayer();
        else
            player.pers["lives"] = 0;
    }

    level thread keepMapClear();
}

onLoadoutGiven()
{
    if( isDefined( level.finalDuel.prevOnLoadoutGiven ) )
        self [[level.finalDuel.prevOnLoadoutGiven]]();

    if( isDefined( level.finalDuel ) && level.finalDuel.active )
        self giveDuelLoadout();
}

applyDuelPlayer()
{
    self endon( "disconnect" );
    self endon( "death" );

    self.pers["lives"] = 0;

    self clearPlayerDebuffs();
    self restorePlayerHealth();
    self giveDuelLoadout();
    self enablePlayerUav();
}

giveDuelLoadout()
{
    self endon( "disconnect" );
    self endon( "death" );

    weapon = level.scr_finalduel_weapon;
    ammo = level.scr_finalduel_weapon_ammo;

    self thread maps\mp\gametypes\_gameobjects::_disableWeapon();
    wait 0.25;

    self takeAllWeapons();
    self deleteExplosives();

    self clearPerks();
    self.specialty = [];
    self.specialty[0] = "specialty_null";
    self.specialty[1] = "specialty_null";
    self.specialty[2] = "specialty_null";

    self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_specops_movespeed", "float", 1.0, 0.5, 1.5 ) );

    self giveWeapon( weapon );
    self setWeaponAmmoClip( weapon, ammo );
    self setWeaponAmmoStock( weapon, 0 );
    self switchToWeapon( weapon );

    wait 0.35;
    self thread maps\mp\gametypes\_gameobjects::_enableWeapon();
}

clearPlayerDebuffs()
{
    self openwarfare\_damageeffect::clearAllDamageEffects();
    self thread openwarfare\_speedcontrol::setModifierSpeed( "_healthsystem", 0 );
    self thread openwarfare\_speedcontrol::setModifierSpeed( "_tkmonitor", 0 );
    self thread openwarfare\_speedcontrol::setModifierSpeed( "ftag", 0 );

    self.flashEndTime = 0;
    self.concussionEndTime = 0;

    if( isDefined( self.bleedingRate ) )
        self.bleedingRate = 0;
}

restorePlayerHealth()
{
    if( isDefined( self.maxhealth ) && self.maxhealth > 0 )
        self.health = self.maxhealth;
    else if( isDefined( level.maxhealth ) )
        self.health = level.maxhealth;
}

enablePermanentUav()
{
    if( level.scr_finalduel_radar == 0 )
        return;

    if( level.scr_finalduel_radar == 1 && level.teamBased )
    {
        setTeamRadar( "allies", true );
        setTeamRadar( "axis", true );
        setDvar( "ui_uav_allies", 1 );
        setDvar( "ui_uav_axis", 1 );
    }

    players = level.players;
    for( i = 0; i < players.size; i++ )
    {
        if( isDefined( players[i] ) )
            players[i] enablePlayerUav();
    }
}

enablePlayerUav()
{
    if( level.scr_finalduel_radar == 0 )
        return;

    if( level.scr_finalduel_radar == 1 )
    {
        self.hasRadar = true;
        self setClientDvar( "ui_uav_client", 1 );
        return;
    }

    self setClientDvar( "g_compassShowEnemies", 1 );
}

abortPlantedBomb()
{
    if( !isDefined( level.bombPlanted ) || !level.bombPlanted )
        return;

    level.bombPlanted = false;
    level notify( "bomb_defused" );

    if( isDefined( level.tickingObject ) )
        level.tickingObject maps\mp\gametypes\_globallogic::stopTickingSound();

    if( isDefined( level.sdBombModel ) )
        level.sdBombModel hide();

    setDvar( "ui_bomb_timer", 0 );
    maps\mp\gametypes\_globallogic::resumeTimer();
}

setDuelRoundTimer()
{
    desiredMs = level.scr_finalduel_time * 1000;

    if( isDefined( level.timerStopped ) && level.timerStopped )
        maps\mp\gametypes\_globallogic::resumeTimer();

    level.timeLimitOverride = false;

    if( !isDefined( level.timeLimit ) || level.timeLimit <= 0 )
    {
        minutes = int( ( level.scr_finalduel_time + 59 ) / 60 );
        if( minutes < 1 )
            minutes = 1;

        level.timeLimit = minutes;
    }

    if( !isDefined( level.startTime ) )
        return;

    limitMs = level.timeLimit * 60 * 1000;
    level.discardTime = ( getTime() - level.startTime ) - ( limitMs - desiredMs );

    setGameEndTime( getTime() + desiredMs );
}

disableObjectives()
{
    disableGameObject( level.sdBomb );
    disableGameObject( level.defuseObject );
    disableGameObject( level.sabBomb );
    disableGameObject( level.radioObject );

    disableGameObjectArray( level.bombZones );
    disableGameObjectArray( level.domFlags );

    if( isDefined( level.flags ) )
    {
        if( isDefined( level.flags["allies"] ) )
            disableGameObject( level.flags["allies"] );

        if( isDefined( level.flags["axis"] ) )
            disableGameObject( level.flags["axis"] );
    }
}

disableGameObjectArray( objects )
{
    if( !isDefined( objects ) )
        return;

    for( i = 0; i < objects.size; i++ )
        disableGameObject( objects[i] );
}

disableGameObject( object )
{
    if( !isDefined( object ) )
        return;

    object maps\mp\gametypes\_gameobjects::disableObject();
}

deleteMapWeapons()
{
    if( !isDefined( level.weaponList ) )
        return;

    for( i = 0; i < level.weaponList.size; i++ )
    {
        ents = getEntArray( "weapon_" + level.weaponList[i], "classname" );
        for( e = 0; e < ents.size; e++ )
        {
            if( isDefined( ents[e] ) )
                ents[e] delete();
        }
    }

    players = level.players;
    for( i = 0; i < players.size; i++ )
    {
        if( isDefined( players[i] ) )
            players[i] deleteExplosives();
    }
}

keepMapClear()
{
    level endon( "game_ended" );

    while( isDefined( level.finalDuel ) && level.finalDuel.active )
    {
        wait 1;
        deleteMapWeapons();
    }
}
