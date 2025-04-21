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
        initCacInfo( 200, "custom1,0", "cac_assault_ingame" );
        initCacInfo( 210, "custom2,0", "cac_specops_ingame" );

        level.cacIngameItemInfo = [];
        initItemInfo( 1, "primary", "stats_table" );
        initItemInfo( 2, "primary_attachment", "attachment_table" );
        initItemInfo( 3, "secondary", "stats_table" );
        initItemInfo( 4, "secondary_attachment", "attachment_table" );
        initItemInfo( 5, "perk_equipment", "stats_table" );
        initItemInfo( 6, "perk_weapon", "stats_table" );
        initItemInfo( 7, "perk_ability", "stats_table" );
        initItemInfo( 8, "spec_grenade", "stats_table" );
        initItemInfo( 9, "camo", "stats_table" );

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


initCacInfo( statOffset, stockResponse, menuName )
{
    index = level.cacIngameClassInfo.size;

    level.cacIngameClassInfo[index] = spawnStruct();
    level.cacIngameClassInfo[index].statOffset = statOffset;
    level.cacIngameClassInfo[index].stockResponse = stockResponse;
    level.cacIngameClassInfo[index].menuName = menuName;

    precacheMenu( menuName );
}


initItemInfo( statOffset, dataType, tableSource )
{
    index = level.cacIngameItemInfo.size;

    level.cacIngameItemInfo[index] = spawnStruct();
    level.cacIngameItemInfo[index].statOffset = statOffset;
    level.cacIngameItemInfo[index].dataType = dataType;
    level.cacIngameItemInfo[index].tableSource = tableSource;
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
                valueRef = responseTok[2]; // int( tableLookup( "mp/statsTable.csv", 4, responseTok[2], 1 ) );
                
                statValue = getStatValueFromTableByType( dataType, valueRef );

                setTempStatData( dataType, statValue );

                self iPrintLn( "CAC SET: type: ^2" + dataType + "^7  value: ^2" + statValue + "^7 ref: ^2" + valueRef +  "^7 menu: " + menu );
            }

            if ( responseType == "cac_upd" )
            {
                assertex( responseTok.size != 5, "Item update in create-a-class-ingame is sending bad response:" + response );

                dataType = responseTok[1];
                valueRef = responseTok[2];
                //tableSource = responseTok[3];
                condtionStatOffset = responseTok[3];
                condtionValidValue = responseTok[4];

                //TODO SET STAT WITH VALIDATION

                conditionStatValue = int( self getStat( condtionStatOffset ) );

                conditionValidArray = strTok( condtionValidValue, "-" );



                for( i = 0; i < conditionValidArray.size; i++ )
                {
                    self iPrintLn( "CAC UPD: check for: ^2" + conditionStatValue + "^7 == ^2" + conditionValidArray[i] );

                    if ( conditionStatValue == int( conditionValidArray[i] ) )
                    {
                        statValue = getStatValueFromTableByType( dataType, valueRef );

                        setTempStatData( dataType, statValue );

                        self iPrintLn( "CAC UPD: type: ^2" + dataType + "^7  value: ^2" + statValue + "^7 ref: ^2" + valueRef + "^7 condition: ^2" + conditionStatValue + " in " + condtionValidValue + " ^7 menu: " + menu );

                        break;
                    }
                }
            }
        }
    }
}


getStatValueFromTableByType( dataType, valueRef )
{
    for( i = 0; i < level.cacIngameItemInfo.size; i++ )
    {
        if( level.cacIngameItemInfo[i].dataType == dataType )
        {   
            return getStatValueFromTableByRef( level.cacIngameItemInfo[i].tableSource, valueRef );
        }
    }

    return -1;
}


getStatValueFromTableByRef( tableSource, valueRef )
{
    switch( tableSource )
    {
        case "stats_table":
            statValue = int( tableLookup( "mp/statsTable.csv", 4, valueRef, 1 ) );

            //Move from temp stats storage
            if( statValue > 3000 ) 
            {
                self iPrintLn( "CAC 3000 " + statValue ); 
                statValue -= 3000; 
            }

            return statValue;

        case "attachment_table":
            return int( tableLookup( "mp/attachmentTable.csv", 4, valueRef, 9 ) );
    }

    return -1;
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