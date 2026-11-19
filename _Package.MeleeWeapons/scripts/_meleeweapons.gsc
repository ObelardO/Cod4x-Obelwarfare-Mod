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
//                                             MELEE WEAPONS                                               //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Entry point. Register the fire-button swing for weapons in level.meleeWeapons.
init()
{
    level.scr_melee_fire = getdvarx( "scr_melee_fire", "int", 1, 0, 1 );

    level.meleeWeapons = [];
    level.meleeWeapons[ "knife_mp" ] = true;

    if ( !level.scr_melee_fire )
        return;

    level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}

onPlayerConnected()
{
    self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
}

onPlayerSpawned()
{
    self thread watchMeleeFire();
}

// Fire button swings a listed melee weapon. +melee and -melee stay in one client command so a tap is sampled.
watchMeleeFire()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned_player" );

    for ( ;; )
    {
        if ( isAlive( self ) && isMeleeWeapon( self getCurrentWeapon() ) && self attackButtonPressed() && !self meleeButtonPressed() )
        {
            self execClientCommand( "+melee; wait 1; -melee" );
            wait 0.65;
            continue;
        }

        wait 0.05;
    }
}

isMeleeWeapon( weapon )
{
    return isDefined( weapon ) && weapon != "" && isDefined( level.meleeWeapons[ weapon ] );
}
