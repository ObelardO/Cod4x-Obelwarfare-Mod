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

init()
{
    level thread levelPlayerConnectionWatcher();
    level thread levelGameEndWatcher();

    level.showHintAction = ::showHintAction;
}


levelPlayerConnectionWatcher()
{
	for(;;)
	{
		level waittill( "connecting", player );

		player thread playerSpawnWatcher();
		player thread playerDeathWatcher();
	}
}


playerSpawnWatcher()
{
    self endon( "disconnect" );
	level endon( "game_ended" );

	for( ;; ) 
	{
		self waittill( "spawned" );

        if( !isDefined( self.hudHints ) )
        {
            self.hudHints = spawnStruct();

            self.hudHints.hudText = createFontString( "default", 1.4 );
            self.hudHints.hudText setPoint( "CENTER", "CENTER", 0, 130 );
            self.hudHints.hudText.alpha = 1;
            self.hudHints.hudText.width = 300;
            self.hudHints.hudText.archived = false;
            self.hudHints.hudText.foreground = true;
            self.hudHints.hudText.hideWhenInMenu = true;
        }

        if ( !isDefined( self.hudHints.overridingKey ) )
        {
            clearHintsStack();
        }
    }
}


playerDeathWatcher()
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    
    for( ;; ) 
	{
		self waittill( "death" );

        if ( isDefined( self.hudHints ) )
        {
            clearHintsStack();
        }
    }
}

levelGameEndWatcher()
{
    level waittill( "game_ended" );

    for( i = 0; i < level.players.size; i++ )
    {
        player = level.players[ i ];

        if ( isDefined( player.hudHints ) )
        {
            player clearHintsStack();
        }
    }
}


showHint( hintText, ownerKey, entityRef, overrideAll )
{
    if( !isDefined( self.hudHints ) )
    {
        //self iprintlnBold( "^1Can't show hint case not defined" );

        return;
    }

    if( isDefined( self.hudHints.hintsStack[ ownerKey ] ) )
    {
        rmeoveKeyFromHintsStack( ownerKey );
    }

    self.hudHints.hintsStack[ ownerKey ] = hintText;

    if( isDefined( overrideAll ) && overrideAll )
    {
        self.hudHints.overridingKey = ownerKey;
    }

    if( !isDefined( self.hudHints.overridingKey ) || self.hudHints.overridingKey == ownerKey )
    {
        [[level.showHintAction]]( hintText );
    }

    if ( isDefined( entityRef ) )
    {
        self thread entityDeathWatcher( entityRef, ownerKey );
    }
}


entityDeathWatcher( entityRef, ownerKey )
{
    self endon( "death" );
    level endon( "game_ended" );

    entityRef waittill( "death" );

    hideHint( ownerKey );
}


hideHint( ownerKey )
{
    if( !isDefined( self.hudHints ) ) return;

    if( isDefined( self.hudHints.hintsStack[ ownerKey ] ) )
    {
        if ( isDefined( self.hudHints.overridingKey ) && self.hudHints.overridingKey == ownerKey )
        {
            self.hudHints.overridingKey = undefined;
        }

        if( isDefined( self.hudHints.overridingKey ) )
        {
            rmeoveKeyFromHintsStack( ownerKey );
        }
        else
        {
            [[level.showHintAction]]( "" );

            rmeoveKeyFromHintsStack( ownerKey );
            showPrevHint(); 
        }
    }
}


rmeoveKeyFromHintsStack( removingKey )
{
	tempStack = [];

	stackKeys = getArrayKeys( self.hudHints.hintsStack );

	for( i = 0; i < stackKeys.size; i++ )
	{
        if( stackKeys[ i ] != removingKey )
        {
            tempStack[ stackKeys[ i ] ] = self.hudHints.hintsStack[ stackKeys[ i ] ]; 
        }
	}

    self.hudHints.hintsStack = tempStack;
}


showPrevHint()
{
    stackKeys = getArrayKeys( self.hudHints.hintsStack );

    if( stackKeys.size > 0 )
    {
        lastKey = stackKeys[ stackKeys.size - 1 ];
        hintText = self.hudHints.hintsStack[ lastKey ];

        [[level.showHintAction]]( hintText );
    }
}


clearHintsStack()
{
    self.hudHints.hintsStack = [];
    self.hudHints.overridingKey = undefined;

    [[level.showHintAction]]( "" );
}


showHintAction( hintText )
{  
    if( !isDefined( self.hudHints ) ) return;

    self.hudHints.hudText setText( hintText );
}