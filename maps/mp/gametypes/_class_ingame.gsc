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

#include openwarfare\_utils;

init()
{
    level.ow_cac_allow_ingame_ranked = getdvarx( "ow_cac_allow_ingame_ranked", "int", 1, 0, 1 );

    if( !level.ow_cac_allow_ingame_ranked || level.oldschool || level.console )
        return;

    if( !isDefined( level.cacIngameInitialized ) )
    {
        level.cacIngameClassInfo = [];
        initCacInfo( "custom1,0", "cac_assault_ingame", 200 );

        level.cacIngameItemInfo = [];
        initItemInfo( "primary", "stats_table", 1 );
        initItemInfo( "primary_attachment", "attachment_table", 2 );
        initItemInfo( "secondary", "stats_table", 3 );
        initItemInfo( "secondary_attachment", "attachment_table", 4 );
        initItemInfo( "perk_equipment", "stats_table", 5 );
        initItemInfo( "perk_weapon", "stats_table", 6 );
        initItemInfo( "perk_ability", "stats_table", 7 );
        initItemInfo( "spec_grenade", "stats_table", 8 );

        level.cacIngameInitialized = true;

        /*
        level.cacIngameStatDataClassOffset = [];
        level.cacIngameStatDataClassOffset["customclass1"] = 200;
        level.cacIngameStatDataClassOffset["customclass2"] = 210;
        level.cacIngameStatDataClassOffset["customclass3"] = 220;
        level.cacIngameStatDataClassOffset["customclass4"] = 230;
        level.cacIngameStatDataClassOffset["customclass5"] = 240;
        */

        //game["cac_ingame_initialized"] = true;
    }

    level thread onPlayerConnecting();
}


initCacInfo( stockResponse, menuName, statOffset )
{
    index = level.cacIngameClassInfo.size;

    level.cacIngameClassInfo[index] = spawnStruct();

    level.cacIngameClassInfo[index].stockResponse = stockResponse;
    level.cacIngameClassInfo[index].menuName = menuName;
    level.cacIngameClassInfo[index].statOffset = statOffset;

    precacheMenu( menuName );
}


initItemInfo( dataType, tableSource, statOffset )
{
    index = level.cacIngameItemInfo.size;

    level.cacIngameItemInfo[index] = spawnStruct();
    level.cacIngameItemInfo[index].dataType = dataType;
    level.cacIngameItemInfo[index].tableSource = tableSource;
    level.cacIngameItemInfo[index].statOffset = statOffset;
}


onPlayerConnecting()
{
	for(;;)
	{
		level waittill( "connecting", player );

        player.cacTempStatData = [];

        player flushTempStatData();
        
        player thread onMenuResponse();
	}
}


onMenuResponse()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("menuresponse", menu, response);

        self iPrintLn( "RAW RES: " + response );

        if( menu == game["menu_changeclass"] )
        {
            self closeMenu();
			self closeInGameMenu();

            cacMenu = undefined;

            for( i = 0; i < level.cacIngameClassInfo.size; i++ )
            {
                if( level.cacIngameClassInfo[i].stockResponse == response )
                {
                    cacMenu = level.cacIngameClassInfo[i].menuName;
                    break;
                }
            }

            //Override open CAC menu for selected custom class
            if( isDefined( cacMenu ) )
            {
                flushTempStatData();

                self openMenu( cacMenu );
            }
            //Othervise stock logic
            else
            {
				self.selectedClass = true;
				self [[level.class]]( response );
            }

            continue;
        } 

        if ( response == "cac_go" )
        {
            self iPrintLn( "CAC GO! menu: ^7" + menu );

            for( i = 0; i < level.cacIngameClassInfo.size; i++ )
            {
                if( level.cacIngameClassInfo[i].menuName == menu )
                {
                    self iPrintLn( "CAC GO! menu match: ^2" + menu ); 

                    //saveTempStatData( level.cacIngameClassInfo[i].statOffset );

                    self closeMenu();
                    self closeInGameMenu();

                    self.selectedClass = true;
                    self [[level.class]]( level.cacIngameClassInfo[i].stockResponse );
                }
            }
        }

        responseTok = strTok( response, "," );

    	if( isdefined( responseTok ) && responseTok.size > 1 )
		{
			responseType = responseTok[0];

            if( responseType == "cac_set" )
            {
                // primary weapon selection
                assertex( responseTok.size != 3, "Item selection in create-a-class-ingame is sending bad response:" + response );

                dataType = responseTok[1];
                valueRaw = responseTok[2]; // int( tableLookup( "mp/statsTable.csv", 4, responseTok[2], 1 ) );
                statValue = -1;

                for( i = 0; i < level.cacIngameItemInfo.size; i++ )
                {
                    if( level.cacIngameItemInfo[i].dataType == dataType )
                    {
                        switch( level.cacIngameItemInfo[i].tableSource )
                        {
                            case "stats_table":
                                statValue = int( tableLookup( "mp/statsTable.csv", 4, valueRaw, 1 ) );

                                //Move from temp stats storage
                                if( statValue > 3000 ) statValue -= 3000; 

                                break;

                            case "attachment_table":
                                statValue = int( tableLookup( "mp/attachmentTable.csv", 4, valueRaw, 9 ) );
                                break;
                        }

                        setTempStatData( dataType, statValue );
                        
                        break;
                    }

                }
                 
                self iPrintLn( "CAC SET: type: ^2" + dataType + "^7  value: ^2" + statValue + "^7 raw: ^2" + valueRaw +  "^7 menu: " + menu );
            }
        }
    }
}


flushTempStatData()
{
    for( i = 0; i < level.cacIngameItemInfo.size; i++ )
    {
        self.cacTempStatData[level.cacIngameItemInfo[i].dataType] = -1;
    }
}


setTempStatData( dataType, value )
{
    if( isDefined( self.cacTempStatData[dataType] ) )
    {
        self.cacTempStatData[dataType] = value;
    }
}


saveTempStatData( classStatOffset )
{
    for( i = 0; i < level.cacIngameItemInfo.size; i++ )
    {
        dataType = level.cacIngameItemInfo[i].dataType;

        if( self.cacTempStatData[dataType] < 0 )
        {
            continue;
        }

        itemStatOffset = level.cacIngameItemInfo[i].statOffset;

        self setStat ( classStatOffset + itemStatOffset, self.cacTempStatData[dataType] );
    }

    flushTempStatData();
}