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

#include maps\mp\gametypes\_hud_util;

#include openwarfare\_eventmanager;
#include openwarfare\_utils;

init()
{
    level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


onPlayerConnected()
{
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
	self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );
}


onPlayerSpawned()
{
    self endon("disconnect");
    self endon("death");
    
    if( !isDefined( self.customHints ) )
    {
        self.customHints = spawnStruct();

        self.customHints.hudText = createFontString( "default", 1.4 );
        self.customHints.hudText setPoint( "CENTER", "CENTER", 0, 0 );
        self.customHints.hudText setText( "CUSTOM HINT" );
        self.customHints.hudText.alpha = 1;
        self.customHints.hudText.archived = false;
        self.customHints.hudText.foreground = true;

        self.customHints.hintsStack = [];
    }

        
    self notify( "showHint", "welcome_hint" );
}


onPlayerDeath()
{
    self endon("disconnect");
    
    if ( isDefined( self.customHints ) )
    {
        clearHintsStack();
    }
}


showHint( hintText, ownerKey, entityRef )
{
    if( !isDefined( self.customHints ) ) return;

    if( isDefined( self.customHints.hintsStack[ ownerKey ] ) )
    {
        rmeoveKeyFromHintsStack( ownerKey );
    }

    self.customHints.hintsStack[ ownerKey ] = hintText;
    self.customHints.hudText setText( hintText );

    if ( isDefined( entityRef ) )
    {
        self thread hideHintOnEnityDeathThread( entityRef, ownerKey );
    }
}


hideHintOnEnityDeathThread( entityRef, ownerKey )
{
    self endon( "death" );
    level endon( "game_ended" );

    entityRef waittill( "death" );

    self hideHint( ownerKey );
}


hideHint( ownerKey )
{
    if( !isDefined( self.customHints ) ) return;

    if( isDefined( self.customHints.hintsStack[ ownerKey ] ) )
    {
        self.customHints.hudText setText( "" );

        rmeoveKeyFromHintsStack( ownerKey );

        showPrevHint(); 
    }
}


rmeoveKeyFromHintsStack( removingKey )
{
	tempStack = [];

	stackKeys = getArrayKeys( self.customHints.hintsStack );

	for( i = stackKeys.size - 1; i >= 0; i-- )
	{
        if( stackKeys[ i ] != removingKey )
        {
            tempStack[ stackKeys[ i ] ] = self.customHints.hintsStack[ stackKeys[ i ] ]; 
        }
	}

    self.customHints.hintsStack = tempStack;
}


showPrevHint()
{
    stackKeys = getArrayKeys( self.customHints.hintsStack );

    if( stackKeys.size > 0 )
    {
        hintText = self.customHints.hintsStack[ stackKeys[ stackKeys.size - 1 ] ];

        self.customHints.hudText setText( hintText );
    }
}


clearHintsStack()
{
    self.customHints.hintsStack = [];
    self.customHints.hudText setText( "" );
}