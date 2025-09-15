//	Local Talking Status
menuDef
{
    name				"amitalking"
    rect				BOTTOM_RECT_X BOTTOM_RECT_Y 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
    fullScreen	0
    visible 		when( dvarInt( ui_broadcaster ) == 1 && !ui_active() && team( name ) == "TEAM_SPECTATOR" && !isIntermission() );

    itemDef
    {
        name			"minimapBG"
        rect			(MINIMAP_X_MP - 14) (MINIMAP_Y_MP - 6) COMPASS_SIZE_MP COMPASS_SIZE_MP HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"minimap_background"
        ownerdraw		CG_PLAYER_COMPASS_BACK
        visible 1
        decoration
    }
    itemDef
    {
        name			"minimapTickerBorder"
        rect			MINIMAP_X_MP (MINIMAP_Y_MP - 15) MINIMAP_W_MP 14 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"minimap_tickertape_background"
        ownerdraw		CG_PLAYER_COMPASS_BACK
        visible 1
        decoration
    }
    // compass without obj points
    itemDef
    {
        name			"minimapTicker"
        rect			MINIMAP_X_MP (MINIMAP_Y_MP - 12) MINIMAP_W_MP 9 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"minimap_tickertape_mp"
        ownerdraw		CG_PLAYER_COMPASS_TICKERTAPE_NO_OBJ
        visible 1
        decoration
    }
    itemDef
    {
        name			"mini_map"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"compass_map_default"
        ownerdraw		CG_PLAYER_COMPASS_MAP
        visible 1
        decoration
    }
    // Objective pointers
    itemDef
    {
        name			"compasspointers"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP  HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"objective_line"
        ownerdraw		CG_PLAYER_COMPASS_POINTERS
        visible 1
        decoration
    }
    // Friendlies pointers
    itemDef
    {
        name			"compassfriendlies"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        ownerdraw		CG_PLAYER_COMPASS_FRIENDS
        visible 1
    }
    // Enemy pings
    itemDef
    {
        name			"compassenemies"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        ownerdraw		CG_PLAYER_COMPASS_ENEMIES
        visible 1
    }
    // Helicopter pointers
    itemDef
    {
        name			"compasshelicopters"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        ownerdraw		CG_PLAYER_COMPASS_HELICOPTERS
        visible 1
    }
    // Plane pointers
    itemDef
    {
        name			"compassplanes"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        ownerdraw		CG_PLAYER_COMPASS_PLANES
        visible 1
    }
    // Player direction indicator
    itemDef
    {
        name			"compassplayer"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1//HUD_FOREGROUND_ALPHA
        background		"compassping_player"
        ownerdraw		CG_PLAYER_COMPASS_PLAYER
        visible 1
    }


    // CLAN LOGO
    //itemDef
    //{
    //	style			WINDOW_STYLE_SHADER
    //	rect			-236 6 230 115 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
    //	background		"clanlogo"
    //	forecolor		1 1 1 .8
    //	visible			1
    //	decoration
    //}		


    #define 	SCOREBAR_OFFSET 0 40
    // GAME TIMER
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        origin		SCOREBAR_OFFSET
        rect			-30 35 60 60 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
        exp				material( "hud_suitcase_bomb" );
        visible	when ( dvarBool( ui_bomb_timer ) );
        forecolor	1 1 1 0.7
        decoration
    }
    itemDef
    {
        rect		0 44 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
        origin		SCOREBAR_OFFSET
        exp text	( secondsAsCountdown( timeLeft() ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.5
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        visible 	when ( timeLeft() >= 60 && !dvarBool( ui_bomb_timer ) );
        decoration
    }
    itemDef
    {
        rect		0 44 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
        origin		SCOREBAR_OFFSET
        exp text	( secondsAsCountdown( timeLeft() ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.5
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	1 0.75 0 HUD_FOREGROUND_ALPHA
        visible 	when ( timeLeft() >= 30 && timeLeft() < 60 && !dvarBool( ui_bomb_timer ) );
        decoration
    }
    itemDef
    {
        rect		0 44 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
        origin		SCOREBAR_OFFSET
        exp text	( secondsAsCountdown( timeLeft() ) + "." + (9 - int( (milliseconds() / 100)%10 )) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.5
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	1 0.5 0 1
        visible 	when ( (timeLeft() >= 0 && timeLeft() < 30) || dvarBool( ui_bomb_timer ) );
        decoration
    }		


    #undef SCOREBAR_OFFSET
    #define 	SCOREBAR_OFFSET 0 0
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			0 -3 640 2 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_BOTTOM
        origin			SCOREBAR_OFFSET
        background		"line_horizontal_scorebar"
        forecolor		1 1 1 1
        visible			1
        decoration
    }
    itemDef	
    {
        style			WINDOW_STYLE_SHADER
        rect			0 -1 640 1 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_BOTTOM
        origin			SCOREBAR_OFFSET
        background		"line_horizontal_scorebar"
        forecolor		0 0 0 0.5
        visible			1
        decoration
    }	
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			0 -40 640 37 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_BOTTOM
        origin			SCOREBAR_OFFSET
        background		"line_horizontal_scorebar"
        forecolor		0.1 0.1 0.1 0.8
        visible			1
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			0 -43 640 2 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_BOTTOM
        origin			SCOREBAR_OFFSET
        background		"line_horizontal_scorebar"
        forecolor		1 1 1 1
        visible			1
        decoration
    }
    itemDef	
    {
        style			WINDOW_STYLE_SHADER
        rect			0 -41 640 1 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_BOTTOM
        origin			SCOREBAR_OFFSET
        background		"line_horizontal_scorebar"
        forecolor		0 0 0 0.5
        visible			1
        decoration
    }

    itemDef 
    {
        rect		0 -25 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
        origin		SCOREBAR_OFFSET
        exp				text( dvarstring(lb_ruleset) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.3
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        visible 	1
        decoration 
    }

    itemDef 
    {
        rect		0 -7 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
        origin		SCOREBAR_OFFSET
        exp				text( gametypeName() + locString( "@OW_LB_ROUND", dvarint( "lb_round" ) ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.4
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        visible 	1
        decoration 
    }
            
    // ALLIES ICON AND SCORE		
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			6 -66 60 60 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        origin			SCOREBAR_OFFSET
        exp				material( dvarString( "g_TeamIcon_Allies" ) );
        visible			1
        decoration
    }

    itemDef 
    {
        rect		60 -0 1 1 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        origin		SCOREBAR_OFFSET
        exp text	( marinesfield( score ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.8
        textalign	ITEM_ALIGN_LEFT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        visible 	1
        decoration 
    }


    // AXIS ICON AND SCORE
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			-66 -66 60 60 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM
        origin			SCOREBAR_OFFSET
        exp				material( dvarString( "g_TeamIcon_Axis" ) );
        visible			1
        decoration
    }		

    itemDef 
    {
        rect		-60 0 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM
        origin		SCOREBAR_OFFSET
        exp text	( opforfield( score ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.8
        textalign	ITEM_ALIGN_RIGHT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        visible 	1
        decoration 
    }


    // PLAYERS
    #define LB_HEALTHBAR_WIDTH 157
    #define LB_HEALTHBAR_OFFSET (LB_HEALTHBAR_WIDTH-256)
    #define LB_HEALTHBAR_HEIGHT 16
    #define LB_FONT_SIZE 0.35

    // ALLIES PLAYERS
    #define LB_ALLIES_OFFSET 0 -165
    #define LB_ALLIES_PLAYER( playerItem, playerName, playerHealth ) \
        itemDef \
        { \
            style				WINDOW_STYLE_SHADER \
            rect				LB_HEALTHBAR_OFFSET (-((playerItem-1)*(LB_HEALTHBAR_HEIGHT+1))) 256 LB_HEALTHBAR_HEIGHT HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM \
            origin			LB_ALLIES_OFFSET \
            background	"lb_healthbar" \
            forecolor		.3 .3 .3 .4 \
            border			0 \
            visible			when (dvarString(playerName)!=""); \
            decoration \
        } \
        itemDef \
        { \
            style				WINDOW_STYLE_SHADER \
            rect				0 (-((playerItem-1)*(LB_HEALTHBAR_HEIGHT+1))) 256 LB_HEALTHBAR_HEIGHT HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM \
            exp					rect X(LB_HEALTHBAR_OFFSET - ( LB_HEALTHBAR_WIDTH - (LB_HEALTHBAR_WIDTH*dvarFloat(playerHealth)/dvarfloat(lb_maxhealth)))) \
            origin			LB_ALLIES_OFFSET \
            background	"lb_healthbar" \
            forecolor		0 0 1 1 \
            border			0 \
            visible			when (dvarString(playerName)!="" && dvarFloat(playerHealth)>0); \
            decoration \
        } \
        itemDef \
        { \
            type				ITEM_TYPE_TEXT \
            rect				3 (-(((playerItem-1)*(LB_HEALTHBAR_HEIGHT+1))+1)+LB_HEALTHBAR_HEIGHT/2) 0 0 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM \
            origin			LB_ALLIES_OFFSET \
            exp					text(dvarString(playerName)); \
            textfont		UI_FONT_NORMAL \
            textscale		LB_FONT_SIZE \
            textAlign		ITEM_ALIGN_MIDDLE_LEFT \
            textStyle		ITEM_TEXTSTYLE_SHADOWEDMORE \
            forecolor		1 1 1 1 \
            visible			when (dvarString(playerName)!="" && dvarFloat(playerHealth)>0); \
            decoration \
        } \
        itemDef \
        { \
            type				ITEM_TYPE_TEXT \
            rect				3 (-(((playerItem-1)*(LB_HEALTHBAR_HEIGHT+1))+1)+LB_HEALTHBAR_HEIGHT/2) 0 0 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM \
            origin			LB_ALLIES_OFFSET \
            exp					text(dvarString(playerName)); \
            textfont		UI_FONT_NORMAL \
            textscale		LB_FONT_SIZE \
            textAlign		ITEM_ALIGN_MIDDLE_LEFT \
            textStyle		ITEM_TEXTSTYLE_SHADOWEDMORE \
            forecolor		.5 .5 .5 1 \
            visible			when (dvarString(playerName)!="" && dvarFloat(playerHealth)<=0); \
            decoration \
        }

    itemDef
    {
        style				WINDOW_STYLE_SHADER
        rect				LB_HEALTHBAR_OFFSET (-((1-1)*(LB_HEALTHBAR_HEIGHT+1))) 256 LB_HEALTHBAR_HEIGHT HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        origin			LB_ALLIES_OFFSET
        background	"lb_healthbar"
        forecolor		0 0 1 1
        border			0
        visible			when (dvarString(lb_allies_p1)=="");
        decoration
    }
    itemDef
    {
        type				ITEM_TYPE_TEXT
        rect				3 (-(((1-1)*(LB_HEALTHBAR_HEIGHT+1))+1)+LB_HEALTHBAR_HEIGHT/2) 0 0 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        origin			LB_ALLIES_OFFSET
        text				"@OW_LB_NO_PLAYERS"
        textfont		UI_FONT_NORMAL
        textscale		LB_FONT_SIZE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        textStyle		ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor		1 1 1 1
        visible			when (dvarString(lb_allies_p1)=="");
        decoration
    }
        
    LB_ALLIES_PLAYER( 1, "lb_allies_p1", "lb_allies_h1" )
    LB_ALLIES_PLAYER( 2, "lb_allies_p2", "lb_allies_h2" )
    LB_ALLIES_PLAYER( 3, "lb_allies_p3", "lb_allies_h3" )
    LB_ALLIES_PLAYER( 4, "lb_allies_p4", "lb_allies_h4" )
    LB_ALLIES_PLAYER( 5, "lb_allies_p5", "lb_allies_h5" )
    LB_ALLIES_PLAYER( 6, "lb_allies_p6", "lb_allies_h6" )
    LB_ALLIES_PLAYER( 7, "lb_allies_p7", "lb_allies_h7" )
    LB_ALLIES_PLAYER( 8, "lb_allies_p8", "lb_allies_h8" )
    LB_ALLIES_PLAYER( 9, "lb_allies_p9", "lb_allies_h9" )
    LB_ALLIES_PLAYER( 10, "lb_allies_p10", "lb_allies_h10" )
    LB_ALLIES_PLAYER( 11, "lb_allies_p11", "lb_allies_h11" )
    LB_ALLIES_PLAYER( 12, "lb_allies_p12", "lb_allies_h12" )
    
    // AXIS PLAYERS
    #define LB_AXIS_OFFSET (-LB_HEALTHBAR_WIDTH) -165
    #define LB_AXIS_PLAYER( playerItem, playerName, playerHealth ) \
        itemDef \
        { \
            style				WINDOW_STYLE_SHADER \
            rect				0 (-((playerItem-1)*(LB_HEALTHBAR_HEIGHT+1))) 256 LB_HEALTHBAR_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM \
            origin			LB_AXIS_OFFSET \
            background	"lb_healthbar" \
            forecolor		.3 .3 .3 .4 \				
            border			0 \
            visible			when (dvarString(playerName)!=""); \
            decoration \
        } \
        itemDef \
        { \
            style				WINDOW_STYLE_SHADER \
            rect				0 (-((playerItem-1)*(LB_HEALTHBAR_HEIGHT+1))) 256 LB_HEALTHBAR_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM \
            exp					rect X( -( LB_HEALTHBAR_WIDTH * dvarFloat(playerHealth) / dvarfloat(lb_maxhealth) )) \
            origin			LB_AXIS_OFFSET \
            background	"lb_healthbar" \
            forecolor		1 0 0 1 \
            border			0 \
            visible			when (dvarString(playerName)!="" && dvarFloat(playerHealth)>0); \
            decoration \
        } \
        itemDef \
        { \
            type				ITEM_TYPE_TEXT \
            rect				(LB_HEALTHBAR_WIDTH-3) (-(((playerItem-1)*(LB_HEALTHBAR_HEIGHT+1))+1)+LB_HEALTHBAR_HEIGHT/2) 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM \
            origin			LB_AXIS_OFFSET \
            exp					text(dvarString(playerName)); \
            textfont		UI_FONT_NORMAL \
            textscale		LB_FONT_SIZE \
            textAlign		ITEM_ALIGN_MIDDLE_RIGHT \
            textStyle		ITEM_TEXTSTYLE_SHADOWEDMORE \
            forecolor		1 1 1 1 \
            visible			when (dvarString(playerName)!="" && dvarFloat(playerHealth)>0); \
            decoration \
        } \
        itemDef \
        { \
            type				ITEM_TYPE_TEXT \
            rect				(LB_HEALTHBAR_WIDTH-3) (-(((playerItem-1)*(LB_HEALTHBAR_HEIGHT+1))+1)+LB_HEALTHBAR_HEIGHT/2) 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM \
            origin			LB_AXIS_OFFSET \
            exp					text(dvarString(playerName)); \
            textfont		UI_FONT_NORMAL \
            textscale		LB_FONT_SIZE \
            textAlign		ITEM_ALIGN_MIDDLE_RIGHT \
            textStyle		ITEM_TEXTSTYLE_SHADOWEDMORE \
            forecolor		.5 .5 .5 1 \
            visible			when (dvarString(playerName)!="" && dvarFloat(playerHealth)<=0); \
            decoration \
        }

    itemDef
    {
        style				WINDOW_STYLE_SHADER
        rect				0 (-((1-1)*(LB_HEALTHBAR_HEIGHT+1))) 256 LB_HEALTHBAR_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM
        origin			LB_AXIS_OFFSET
        background	"lb_healthbar"
        forecolor		1 0 0 1
        border			0
        visible			when (dvarString(lb_axis_p1)=="");
        decoration
    }
    itemDef
    {
        type				ITEM_TYPE_TEXT
        rect				(LB_HEALTHBAR_WIDTH-3) (-(((1-1)*(LB_HEALTHBAR_HEIGHT+1))+1)+LB_HEALTHBAR_HEIGHT/2) 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM
        origin			LB_AXIS_OFFSET
        text				"@OW_LB_NO_PLAYERS"
        textfont		UI_FONT_NORMAL
        textscale		LB_FONT_SIZE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        textStyle		ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor		1 1 1 1
        visible			when (dvarString(lb_axis_p1)=="");
        decoration
    }
        
    LB_AXIS_PLAYER( 1, "lb_axis_p1", "lb_axis_h1" )
    LB_AXIS_PLAYER( 2, "lb_axis_p2", "lb_axis_h2" )
    LB_AXIS_PLAYER( 3, "lb_axis_p3", "lb_axis_h3" )
    LB_AXIS_PLAYER( 4, "lb_axis_p4", "lb_axis_h4" )
    LB_AXIS_PLAYER( 5, "lb_axis_p5", "lb_axis_h5" )
    LB_AXIS_PLAYER( 6, "lb_axis_p6", "lb_axis_h6" )
    LB_AXIS_PLAYER( 7, "lb_axis_p7", "lb_axis_h7" )
    LB_AXIS_PLAYER( 8, "lb_axis_p8", "lb_axis_h8" )
    LB_AXIS_PLAYER( 9, "lb_axis_p9", "lb_axis_h9" )
    LB_AXIS_PLAYER( 10, "lb_axis_p10", "lb_axis_h10" )
    LB_AXIS_PLAYER( 11, "lb_axis_p11", "lb_axis_h11" )
    LB_AXIS_PLAYER( 12, "lb_axis_p12", "lb_axis_h12" )
}