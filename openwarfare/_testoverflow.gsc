//******************************************************************************
//  _____                  _    _             __
// |  _  |                | |  | |           / _|
// | | | |_ __   ___ _ __ | |  | | __ _ _ __| |_ __ _ _ __ ___
// | | | | '_ \ / _ \ '_ \| |/\| |/ _` | '__|  _/ _` | '__/ _ \
// \ \_/ / |_) |  __/ | | \  /\  / (_| | |  | || (_| | | |  __/
//  \___/| .__/ \___|_| |_|\/  \/ \__,_|_|  |_| \__,_|_|  \___|
//       | |               We don't make the game you play.
//       |_|                 We make the game you play BETTER.
//
//            Website: http://openwarfaremod.com/
//******************************************************************************

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

#include openwarfare\_utils;
#include openwarfare\_eventmanager;

init()
{
	//level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


onPlayerConnected()
{
	if ( !isDefined( level.sl_started ))
	{
		self setupOverflowAnchor();

		level thread overflowMonitorThread();
	}


	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
}


onPlayerSpawned()	
{
	/*
		self.testOverFlowText = createFontString( "objective", 1.5 );
	self.testOverFlowText = createFontString( "objective", 1.5 );
	self.testOverFlowText setPoint( "CENTER", "CENTER", 0, 18 );
	self.testOverFlowText.sort = 1001;
	self.testOverFlowText.color = ( .42, 1, 0.42 );			
	self.testOverFlowText.foreground = false;
	self.testOverFlowText.hidewheninmenu = true;	
	*/


	/*
	self.testOverFlowText = newClientHudElem(self);
    self.testOverFlowText.archived = true;
    self.testOverFlowText.x = 0;
    self.testOverFlowText.y = -85;
    self.testOverFlowText.alignX = "center";
    self.testOverFlowText.alignY = "bottom";
    self.testOverFlowText.horzAlign = "center_safearea";
    self.testOverFlowText.vertAlign = "bottom";
    self.testOverFlowText.sort = 1; // force to draw after the bars
    self.testOverFlowText.font = "objective";
    self.testOverFlowText.fontscale = 1.4;
    self.testOverFlowText.foreground = true;
	*/

	self thread overflowTestThread();
}

overflowTestThread()
{
	self endon("disconnect");

	huds = [];


    for(i = 0;; i++)
    {
		//self.testOverFlowText setText("overflow: " + i);
		//wait 0.05;

		count = huds.size;

		huds[count] = newClientHudElem(self);
        huds[count].archived = false;
        huds[count].alignX = "center";
        huds[count].alignY = "middle";
        huds[count].horzAlign = "center_safearea";
        huds[count].vertAlign = "middle";
        huds[count].font = "objective";
        huds[count].fontscale = 1.4;
        huds[count].foreground = true;
		huds[count].y = 20 * count;
        //huds[count] bindConfigString("Overflow test: " + i); // каждая строка уникальна
        huds[count] setText("Overflow test: " + i); // каждая строка уникальна
		
		if ( count == 10 )
		{
			for( j = 0; j <= count; j++ )
			{
				huds[j] destroy();
			}

			huds = [];
		}

        wait 0.05;
	}
}


bindConfigString(string)
{
	level.sl_strings = ArrayAdd(level.sl_strings, string, 0);
	level.sl_huds = ArrayAdd(level.sl_huds, self, 0);
	self.text = string;

	iPrintLn ( "bind " + string + " #" + level.sl_strings.size );

	if (level.sl_strings.size > 10)
	{
		iPrintLn ( "overflow" );
		level notify( "sl_overflow" );
		return;
	}

	self setText( string );
	level notify( "sl_new_text" );
}

setupOverflowAnchor()
{
	level.sl_anchor = "sl_$" + RandomInt(65536);

	text = self createFontString("default", 2);
	text setText( level.sl_anchor );
	text destroy();

	level.sl_started = true;
}

overflowMonitorThread()
{
	level endon( "game_ended" );

	/*
	level.sl_anchor = "sl_$" + RandomInt(65536);

	text = level createFontString("default", 2);
	text setText( level.sl_anchor );
	text destroy();
	*/

	level.sl_strings = [];
	level.sl_huds = [];

	for(;;)
	{
		level textMonitor();
		wait 0.025;
		level.sl_huds = ArrayRemoveUndefined( level.sl_huds );
	}
}

textMonitor()
{
	level endon( "game_ended" );

	level endon( "sl_new_text" );

	for( i = 0; i < level.sl_huds.size; i++ )
	{
		level.sl_huds[i] endon( "death" );
	}

	level waittill( "sl_overflow" );

	level.sl_huds[0] setText( level.sl_anchor );
	level.sl_huds[0] ClearAllTextAfterHudElem();

	level.sl_strings = [];
	iPrintLn ( "clear strings" );

	for( i = 0; i < level.sl_huds.size; i++ )
	{
		if ( !isDefined( level.sl_huds[i] ))
		{
			continue;
		}

		if ( !isDefined( level.sl_huds[i].text ))
		{
			continue;
		}

		level.sl_strings = ArrayAdd( level.sl_strings, level.sl_huds[i].text, 0);
		level.sl_huds[i] setText( level.sl_huds[i].text );
	}
}


// [CALLER] none
// [array] array to modify
// [item] item to add to the array
// [?allow_dupes] if false, the element will only be added if it is not already in the array
// Add an element to an array and return the new array.  
ArrayAdd(array, item, allow_dupes)
{
    if(isdefined(item))
    {
        if(allow_dupes || !IsInArray(array, item))
        {
            array[array.size] = item;
        }
    }
    return array;
}

// [CALLER] none
// [array] array to clean
// Remove any undefined values from an array and return the new array.
ArrayRemoveUndefined(array)
{
    a_new = [];
 
	for( i = 0; i < array.size; i++ )
	{
		 if( isdefined( array[i] ) )
		 	a_new[a_new.size] = array[i];
	}
 
    return a_new;
}

// [CALLER] none
// [array] array to clean
// [value] value to remove from the array
// Remove all instances of value in array
ArrayRemove(array, value)
{
    a_new = [];
    
	for( i = 0; i < array.size; i++ )
	{
		 if( value != array[i] )
		 	a_new[a_new.size] = array[i];
	}
            
    return a_new;
}

IsInArray(array, value)
{

	if ( !isDefined(value) )
	{
		return false;
	}

    
	for( i = 0; i < array.size; i++ )
	{
		 if( value == array[i] )
		 	return true;
	}
            
    return false;
}


// [CALLER] none
// [array] array to change
// [index] index to use to insert the value
// [value] value to insert into the array
// Insert a value into an array
ArrayInsertValue(array, index, value)
{
    a_new = [];
    
    for(i = 0; i < index; i++)
    {
        a_new[i] = array[i];
    }
    
    a_new[index] = value;
    
    for(i = index + 1; i <= array.size; i++)
    {
        a_new[i] = array[i - 1];
    }
    
    return a_new;
}

// [CALLER] none
// [array] array to search
// [value] value to search for
// Find the index of a value in an array. If the value isnt found, return -1
ArrayIndexOf(array, value)
{
     for(i = 0; i < array.size; i++)
        if(isdefined(array[i]) && value == array[i])
            return i;
            
    return -1;
}