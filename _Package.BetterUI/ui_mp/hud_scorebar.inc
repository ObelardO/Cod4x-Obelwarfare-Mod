#define SCOREBAR_ORIGIN 0 -7
#define ESCOREBAR_ORIGIN 8 -6

#define SCORE_OFFSET_X	4
#define SCORE_OFFSET_Y	2

#define TEAM_IS_TIED	(team(score) == otherteam(score))
#define TEAM_IS_WINNING (team(score) > otherteam(score))
#define TEAM_IS_LOSING	(team(score) < otherteam(score))

#define PLAYER_IS_TIED		(player(score) == scoreatrank(1) && scoreatrank(1) == scoreatrank(2))
#define PLAYER_IS_WINNING	(player(score) > scoreatrank(2))
#define PLAYER_IS_LOSING	(player(score) < scoreatrank(1))

#define SHOULD_DISPLAY_SCOREBAR (team( name ) != "TEAM_SPECTATOR") && !isIntermission()

// Bottom bar
menuDef
{
    name			"scorebars2"
    rect			(BOTTOM_RECT_X+SCORE_OFFSET_X) (BOTTOM_RECT_Y+SCORE_OFFSET_Y) 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
    exp				rect Y( BOTTOM_RECT_Y - (ONLINEGAME * ONLINEGAME_OFFSET) );
    fullScreen		0
    /*visible 		when( !inkillcam() && !ui_active() && ( dvarint( ui_hud_hardcore ) == 0 && dvarint( ui_hud_show_scores ) == 1 ) );*/
    visible 		when( !inkillcam() && !ui_active() && !isIntermission() && ( ( dvarint( ui_hud_hardcore ) == 0 && dvarint( ui_hud_show_scores ) > 0 ) || ( dvarint( ui_hud_hardcore ) == 1 && dvarint( ui_hud_show_scores ) == 2 ) ) );

    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			0 -45 128 64 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -45 + (TEAM_IS_LOSING*20) );
        exp				rect H( 64 - (TEAM_IS_LOSING*128) );
        forecolor		1 1 1 HUD_ALPHA
        background		"scorebar_backdrop"
        visible			when( ( team( name ) != "TEAM_FREE" && gametype() != "bel" ) && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			0 -45 128 64 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -45 + (PLAYER_IS_LOSING*20) );
        exp				rect H( 64 - (PLAYER_IS_LOSING*128) );
        forecolor		1 1 1 HUD_ALPHA
        background		"scorebar_backdrop"
        visible			when( ( team( name ) == "TEAM_FREE" || gametype() == "bel" ) && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			0 -36 36 36 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        origin			5 -5
        exp				material( dvarString( "g_TeamIcon_Allies" ) );
        visible			when ( ( team( name ) == "TEAM_ALLIES" && gametype() != "bel" ) && SHOULD_DISPLAY_SCOREBAR );
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			0 -36 36 36 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        origin			5 -5
        exp				material( dvarString( "g_TeamIcon_Allies" ) );
        visible			when (  team( name ) == "TEAM_SPECTATOR" && SHOULD_DISPLAY_SCOREBAR );
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			0 -36 36 36 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        origin			5 -5
        exp				material( dvarString( "g_TeamIcon_Axis" ) );
        visible			when ( ( team( name ) == "TEAM_AXIS" && gametype() != "bel" ) && SHOULD_DISPLAY_SCOREBAR );
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			0 -36 36 36 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        origin			5 -5
        exp				material( dvarString( "g_TeamIcon_Allies" ) );
        visible			when ( ( team( name ) == "TEAM_FREE" || gametype() == "bel" ) && TEAM_IS_MARINES && SHOULD_DISPLAY_SCOREBAR );
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			0 -36 36 36 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        origin			5 -5
        exp				material( dvarString( "g_TeamIcon_Axis" ) );
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        visible			when ( ( team( name ) == "TEAM_FREE" || gametype() == "bel" ) && TEAM_IS_OPFOR && SHOULD_DISPLAY_SCOREBAR );
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			46 -41 80 12 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -41 + 0-(TEAM_IS_LOSING*24) );
        background		"white"
        forecolor		1 1 1 0.25
        visible			when ( ( team( name ) != "TEAM_FREE" && gametype() != "bel" ) && SHOULD_DISPLAY_SCOREBAR );
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			46 -41 80 12 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -41 + 0-(PLAYER_IS_LOSING*24) );
        background		"white"
        forecolor		1 1 1 0.25
        visible			when ( ( team( name ) == "TEAM_FREE" || gametype() == "bel" ) && SHOULD_DISPLAY_SCOREBAR );
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			128 -47 24 24 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -47 + 0-(TEAM_IS_LOSING*24) );
        background		"hud_arrow_left"
        forecolor		1 1 1 HUD_ALPHA
        visible			when ( ( ( team( name ) == "TEAM_ALLIES" || team( name ) == "TEAM_AXIS" ) && gametype() != "bel" ) && SHOULD_DISPLAY_SCOREBAR );
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			128 -47 24 24 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -47 + 0-(PLAYER_IS_LOSING*24) );
        background		"hud_arrow_left"
        forecolor		1 1 1 HUD_ALPHA
        visible			when ( ( team( name ) == "TEAM_FREE" || gametype() == "bel" ) && SHOULD_DISPLAY_SCOREBAR );
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			48 -39 76 8 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -39 + 0-(TEAM_IS_LOSING*24) );
        exp				rect W( 76 * (team( score ) / dvarInt( "ui_scorelimit" ) ) );
        exp				material( "scorebar_" + dvarString( "scr_allies" ) );
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        visible 		when ( ( ( team( name ) == "TEAM_ALLIES" && gametype() != "bel" ) || team( name ) == "TEAM_SPECTATOR" ) && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			48 -39 76 8 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -39 + 0-(TEAM_IS_LOSING*24) );
        exp				rect W( 76 * (team( score ) / dvarInt( "ui_scorelimit" ) ) );
        exp				material( "scorebar_" + dvarString( "scr_axis" ) );
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        visible 		when ( ( team( name ) == "TEAM_AXIS" && gametype() != "bel" ) && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			48 -39 76 8 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -39 + 0-(PLAYER_IS_LOSING*24) );
        exp				rect W( 76 * (player( score ) / dvarInt( "ui_scorelimit" ) ) );
        exp				material( "scorebar_" + dvarString( "scr_axis" ) );
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        visible 		when ( ( team( name ) == "TEAM_FREE" || gametype() == "bel" ) && TEAM_IS_OPFOR && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			48 -39 76 8 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -39 + 0-(PLAYER_IS_LOSING*24) );
        exp				rect W( 76 * (player( score ) / dvarInt( "ui_scorelimit" ) ) );
        exp				material( "scorebar_" + dvarString( "scr_allies" ) );
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        visible 		when ( ( team( name ) == "TEAM_FREE" || gametype() == "bel" ) && TEAM_IS_MARINES && SHOULD_DISPLAY_SCOREBAR )
        visible	0
        decoration
    }
    itemDef
    {
        rect		50 -27 1 1 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp			rect Y( -27 + 0-(TEAM_IS_LOSING*24) );
        exp text	( team( score ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_LEFT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	1 1 1 HUD_FOREGROUND_ALPHA
        visible 	when ( ( ( team( name ) == "TEAM_ALLIES" || team( name ) == "TEAM_AXIS" ) && gametype() != "bel" ) && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        rect		50 -27 1 1 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp			rect Y( -27 + 0-(PLAYER_IS_LOSING*24) );
        exp text	( player( score ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_LEFT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	1 1 1 HUD_FOREGROUND_ALPHA
        visible 	when ( ( team( name ) == "TEAM_FREE" || gametype() == "bel" ) && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }

    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			46 -22 80 10 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -22 + (TEAM_IS_LOSING*12) );
        background		"white"
        forecolor		1 1 1 0.25
        visible			when ( ( ( team( name ) == "TEAM_ALLIES" || team( name ) == "TEAM_AXIS" ) && gametype() != "bel" ) && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			46 -22 80 10 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -22 + (PLAYER_IS_LOSING*12) );
        background		"white"
        forecolor		1 1 1 0.25
        visible			when ( ( team( name ) == "TEAM_FREE" || gametype() == "bel" ) && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			48 -20 76 6 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -20 + (TEAM_IS_LOSING*12) );
        exp				rect W( 76 * (otherteam( score ) / dvarInt( "ui_scorelimit" ) ) );
        exp				material( "scorebar_" + dvarString( "scr_allies" ) );
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        visible 		when ( ( team( name ) == "TEAM_AXIS" && gametype() != "bel" ) && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			48 -20 76 6 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -20 + (TEAM_IS_LOSING*12) );
        exp				rect W( 76 * (otherteam( score ) / dvarInt( "ui_scorelimit" ) ) );
        exp				material( "scorebar_" + dvarString( "scr_axis" ) );
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        visible 		when ( ( ( team( name ) == "TEAM_ALLIES" || team( name ) == "TEAM_SPECTATOR" ) && gametype() != "bel" ) && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			48 -20 76 6 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -20 + (PLAYER_IS_LOSING*12) );
        exp				rect W( 76 * (scoreatrank( 2 ) / dvarInt( "ui_scorelimit" ) ) );
        exp				material( "scorebar_" + dvarString( "scr_allies" ) );
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        visible 		when ( ( team( name ) == "TEAM_FREE" || gametype() == "bel" ) && TEAM_IS_OPFOR && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			48 -20 76 6 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp				rect Y( -20 + (PLAYER_IS_LOSING*12) );
        exp				rect W( 76 * (scoreatrank( 2 ) / dvarInt( "ui_scorelimit" ) ) );
        exp				material( "scorebar_" + dvarString( "scr_axis" ) );
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        visible 		when ( ( team( name ) == "TEAM_FREE" || gametype() == "bel" ) && TEAM_IS_MARINES && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        rect		50 -8 1 1 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp			rect Y( -8 + (TEAM_IS_LOSING*12) );
        exp text	( otherteam( score ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_LEFT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	1 1 1 HUD_FOREGROUND_ALPHA
        visible 	when ( ( ( team( name ) == "TEAM_ALLIES" || team( name ) == "TEAM_AXIS" ) && gametype() != "bel" ) && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        rect		50 -8 1 1 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp			rect Y( -8 + (PLAYER_IS_LOSING*12) );
        exp text	( scoreatrank( 2 ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_LEFT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	1 1 1 HUD_FOREGROUND_ALPHA
        visible 	when ( ( team( name ) == "TEAM_FREE" || gametype() == "bel" ) && player( score ) == scoreatrank( 1 ) && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        rect		50 -8 1 1 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        exp			rect Y( -8 + (PLAYER_IS_LOSING*12) );
        exp text	( scoreatrank( 1 ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_LEFT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	1 1 1 HUD_FOREGROUND_ALPHA
        visible 	when ( ( team( name ) == "TEAM_FREE" || gametype() == "bel" ) && player( score ) != scoreatrank( 1 ) && SHOULD_DISPLAY_SCOREBAR )
        decoration
    }
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			134 -48 32 32 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
        origin			5 6
        exp				material( "hud_suitcase_bomb" );
        visible			when ( dvarBool( ui_bomb_timer ) && ( team( name ) != "TEAM_SPECTATOR" || dvarInt( ui_broadcaster ) == 0 ) );
        forecolor		1 1 1 0.25
        decoration
    }
    itemDef
    {
        rect		-8 4 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        origin		0 22
        exp text	( secondsAsCountdown( timeLeft() ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_RIGHT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        visible 	when ( timeLeft() >= 60 && !dvarBool( ui_bomb_timer ) && ( team( name ) != "TEAM_SPECTATOR" && dvarInt( ui_broadcaster ) == 0 ) );
        forecolor	1 1 1 HUD_FOREGROUND_ALPHA
        decoration
    }
    itemDef
    {
        rect		-8 4 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        origin		0 22
        exp text	( secondsAsCountdown( timeLeft() ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_RIGHT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	1 0.75 0 HUD_FOREGROUND_ALPHA
        visible 	when ( timeLeft() >= 30 && timeLeft() < 60 && !dvarBool( ui_bomb_timer ) && ( team( name ) != "TEAM_SPECTATOR" && dvarInt( ui_broadcaster ) == 0 ) );
        decoration
    }
    itemDef
    {
        rect		-8 4 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        origin		0 22
        exp text	( secondsAsCountdown( timeLeft() ) + "." + (9 - int( (milliseconds() / 100)%10 )) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_RIGHT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	1 0.5 0 1
        visible 	when ( ( (timeLeft() >= 0 && timeLeft() < 30) || dvarBool( ui_bomb_timer ) ) && ( team( name ) != "TEAM_SPECTATOR" && dvarInt( ui_broadcaster ) == 0 ) );
        decoration
    }
    
    /*
    OBJICON( "TEAM_ALLIES", 0, "compass_waypoint_captureneutral_a", "scr_obj_a", "neutral" )
    OBJICON( "TEAM_ALLIES", 0, "compass_waypoint_defend_a", "scr_obj_a", "allies" )
    OBJICON( "TEAM_ALLIES", 0, "compass_waypoint_capture_a", "scr_obj_a", "axis" )
    OBJICON( "TEAM_AXIS", 0, "compass_waypoint_captureneutral_a", "scr_obj_a", "neutral" )
    OBJICON( "TEAM_AXIS", 0, "compass_waypoint_capture_a", "scr_obj_a", "allies" )
    OBJICON( "TEAM_AXIS", 0, "compass_waypoint_defend_a", "scr_obj_a", "axis" )

    OBJICON( "TEAM_ALLIES", 1, "compass_waypoint_captureneutral_b", "scr_obj_b", "neutral" )
    OBJICON( "TEAM_ALLIES", 1, "compass_waypoint_defend_b", "scr_obj_b", "allies" )
    OBJICON( "TEAM_ALLIES", 1, "compass_waypoint_capture_b", "scr_obj_b", "axis" )
    OBJICON( "TEAM_AXIS", 1, "compass_waypoint_captureneutral_b", "scr_obj_b", "neutral" )
    OBJICON( "TEAM_AXIS", 1, "compass_waypoint_capture_b", "scr_obj_b", "allies" )
    OBJICON( "TEAM_AXIS", 1, "compass_waypoint_defend_b", "scr_obj_b", "axis" )

    OBJICON( "TEAM_ALLIES", 2, "compass_waypoint_captureneutral_c", "scr_obj_c", "neutral" )
    OBJICON( "TEAM_ALLIES", 2, "compass_waypoint_defend_c", "scr_obj_c", "allies" )
    OBJICON( "TEAM_ALLIES", 2, "compass_waypoint_capture_c", "scr_obj_c", "axis" )
    OBJICON( "TEAM_AXIS", 2, "compass_waypoint_captureneutral_c", "scr_obj_c", "neutral" )
    OBJICON( "TEAM_AXIS", 2, "compass_waypoint_capture_c", "scr_obj_c", "allies" )
    OBJICON( "TEAM_AXIS", 2, "compass_waypoint_defend_c", "scr_obj_c", "axis" )

    OBJICON( "TEAM_ALLIES", 3, "compass_waypoint_captureneutral_d", "scr_obj_d", "neutral" )
    OBJICON( "TEAM_ALLIES", 3, "compass_waypoint_defend_d", "scr_obj_d", "allies" )
    OBJICON( "TEAM_ALLIES", 3, "compass_waypoint_capture_d", "scr_obj_d", "axis" )
    OBJICON( "TEAM_AXIS", 3, "compass_waypoint_captureneutral_d", "scr_obj_d", "neutral" )
    OBJICON( "TEAM_AXIS", 3, "compass_waypoint_capture_d", "scr_obj_d", "allies" )
    OBJICON( "TEAM_AXIS", 3, "compass_waypoint_defend_d", "scr_obj_d", "axis" )

    OBJICON( "TEAM_ALLIES", 4, "compass_waypoint_captureneutral_e", "scr_obj_e", "neutral" )
    OBJICON( "TEAM_ALLIES", 4, "compass_waypoint_defend_e", "scr_obj_e", "allies" )
    OBJICON( "TEAM_ALLIES", 4, "compass_waypoint_capture_e", "scr_obj_e", "axis" )
    OBJICON( "TEAM_AXIS", 4, "compass_waypoint_captureneutral_e", "scr_obj_e", "neutral" )
    OBJICON( "TEAM_AXIS", 4, "compass_waypoint_capture_e", "scr_obj_e", "allies" )
    OBJICON( "TEAM_AXIS", 4, "compass_waypoint_defend_e", "scr_obj_e", "axis" )
    */
}