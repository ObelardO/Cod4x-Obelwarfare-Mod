#define TS_HUD_OFFSET_X	      20
#define TS_HUD_OFFSET_Y	      6
#define TS_HUD_SPACING_Y      30
#define TS_HUD_SIZE           24
#define TS_HUD_SPACING_X      72
#define TS_HUD_SPACING_X_HALF 36

#define TS_HUD_BACK_SIZE_Y    ( TS_HUD_SIZE + 6 )
#define TS_HUD_BACK_SIZE_X    ( TS_HUD_BACK_SIZE_Y * 2 )

#define TS_TEAMCOUNT_ALLIES   dvarint( ui_hud_teamstat_count_allies )
#define TS_TEAMCOUNT_AXIS     dvarint( ui_hud_teamstat_count_axis )

#define TS_IS_AXIS            int( team( name ) == "TEAM_AXIS" )
#define TS_IS_ALLIES          int( team( name ) == "TEAM_ALLIES" )
#define TS_IS_TEAMBASED       ( dvarInt( ui_hud_teamstat_teambased ) > 0 )
#define TS_IS_NOT_TEAMBASED   ( dvarInt( ui_hud_teamstat_teambased ) == 0 )
#define TS_IS_LOSING_AXIS     ( TS_IS_TEAMBASED && opforfield( score ) <= marinesfield( score ) )
#define TS_IS_LOSING_ALLIES   ( TS_IS_TEAMBASED && marinesfield( score ) < opforfield( score ) )

#define TS_HUD_POS_Y_AXIS     ( TS_IS_LOSING_AXIS * TS_HUD_SPACING_Y + TS_HUD_OFFSET_Y )
#define TS_HUD_POS_Y_ALLIES   ( TS_IS_LOSING_ALLIES * TS_HUD_SPACING_Y + TS_HUD_OFFSET_Y )
#define TS_HUD_POS_X          ( TS_HUD_OFFSET_X )

//#define TS_HUD_POS_X_AXIS     ( TS_HUD_POS_X + TS_HUD_SPACING_X_HALF )
//#define TS_HUD_POS_X_AXIS     30
//#define TS_HUD_POS_X_ALLIES   ( TS_HUD_POS_X - TS_HUD_SPACING_X_HALF - TS_HUD_SIZE )
//#define TS_HUD_POS_X_ALLIES   30

#define TS_HUD_ALIGN_X_OP_AXIS    ( 0 - 1 )
#define TS_HUD_ALIGN_X_OP_ALLIES  ( 0 + 1 )
#define TS_HUD_ALIGN_W_MOD_AXIS   1
#define TS_HUD_ALIGN_W_MOD_ALLIES 0


#define TS_SCORE_PLAYER_RANK  ( dvarint( ui_hud_teamstat_player_rank ) )

#define TS_IS_LOSING_PLAYER   ( TS_IS_NOT_TEAMBASED && TS_SCORE_PLAYER_RANK > 1 )
#define TS_IS_WINNING_PLAYER  ( TS_IS_NOT_TEAMBASED && TS_SCORE_PLAYER_RANK == 1 )

#define TS_HUD_POS_Y_PLAYER_1 ( 0 * TS_HUD_SPACING_Y + TS_HUD_OFFSET_Y )
//#define TS_HUD_POS_Y_PLAYER_2 ( 1 * TS_HUD_SPACING_Y + TS_HUD_OFFSET_Y )
#define TS_HUD_POS_Y_PLAYER_2 ( 1 * TS_HUD_SPACING_Y + TS_HUD_OFFSET_Y )

#define TS_HUD_SCORE_PLAYER_1 ( scoreatrank( 1 ) )
#define TS_HUD_SCORE_PLAYER_2 ( TS_IS_LOSING_PLAYER * player ( score ) ) + ( TS_IS_WINNING_PLAYER * scoreatrank( 2 ) )

#define TS_HUD_PLAYER_INDEX   ( TS_IS_LOSING_PLAYER * TS_SCORE_PLAYER_RANK ) + ( TS_IS_WINNING_PLAYER * 2 )

#define TS_HUD_VISIBLE        ( !isIntermission() && ( dvarint( ui_hud_show_teamstat ) >= dvarint( ui_hud_hardcore ) + 1 ) )

#define TS_HUD_TIMER_VISIBLE  ( TS_HUD_VISIBLE && ( team( name ) != "TEAM_SPECTATOR" || ( team( name ) == "TEAM_SPECTATOR" && dvarInt( ui_broadcaster ) == 0 ) ) && !inkillcam() && !ui_active() && !flashbanged() && !scoped() && ( dvarInt( "ui_timelimit" ) == 0 || ( dvarInt( "ui_timelimit" ) * 60 - timeLeft() > 5 ) ) )
#define TS_HUD_TIMER_POS_X    ( TS_HUD_POS_X - ( dvarBool( ui_bomb_timer ) * ( TS_HUD_SIZE + 4 ) ) )
#define TS_HUD_TIMER_POS_Y    ( 2 * TS_HUD_SPACING_Y + TS_HUD_OFFSET_Y )
#define TS_HUD_TIMER_W        60
#define TS_HUD_TIMER_W_HALF   30

#define TS_HUD_TIMER( textExp, color, xOffset, visibleExp ) \
    itemDef \
    { \
        rect		xOffset TS_HUD_OFFSET_Y 0 TS_HUD_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP \
        exp         text( textExp ); \
        textfont	UI_FONT_OBJECTIVE \
        textscale	0.3 \
        textalign	ITEM_ALIGN_MIDDLE_CENTER \
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE \
        forecolor	color \
        visible 	when ( visibleExp && TS_HUD_TIMER_VISIBLE ) \
        decoration \
    }

/*



    */

#define TS_HUD_ITEM( xOffsetOp, widthMod, textAlign, icon, backImagePostfix, visibleExp, score, highlightFlag, count, blinkExp ) \
    itemDef \
    { \
        rect			TS_HUD_OFFSET_X TS_HUD_OFFSET_Y TS_HUD_BACK_SIZE_X TS_HUD_BACK_SIZE_Y HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP \
        exp             rect Y( TS_HUD_OFFSET_Y - 6 ) \
        exp             rect X( xOffsetOp * ( TS_HUD_SPACING_X_HALF - 6 ) - widthMod * TS_HUD_BACK_SIZE_X ) \
        forecolor		1 1 1 ( HUD_BACK_ALPHA * 0.65 ) \
        style			WINDOW_STYLE_SHADER \
        background		"hud_background_line_half"backImagePostfix \
        visible			when ( visibleExp ) \
        decoration \
    } \
    itemDef \
    { \
        style			WINDOW_STYLE_SHADER \
        rect			TS_HUD_OFFSET_X TS_HUD_OFFSET_Y TS_HUD_SIZE TS_HUD_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP \
        exp             rect Y( TS_HUD_OFFSET_Y ); \
        exp             rect X( xOffsetOp * TS_HUD_SPACING_X_HALF - widthMod * TS_HUD_SIZE ); \
        origin          0 0; \
        exp				material( icon ); \
        visible			when ( visibleExp ); \
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA \
        decoration \
    } \
    itemDef \ 
    { \
        rect		TS_HUD_OFFSET_X TS_HUD_OFFSET_Y 1 TS_HUD_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP \
        exp         rect Y( TS_HUD_OFFSET_Y ) \
        exp         rect X( xOffsetOp * ( TS_HUD_SPACING_X_HALF + TS_HUD_SIZE + 4 ) ) \
        exp         text( score ) \
        textfont	UI_FONT_OBJECTIVE \
        textscale	0.3 \
        textalign	textAlign \
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE \
        visible 	when( visibleExp ); \
        exp         forecolor A( 0.6 + 0.4 * highlightFlag ) \
        decoration \
    } \
    itemDef \
    { \
        name			"teamCount" \
        rect			TS_HUD_POS_X TS_HUD_OFFSET_Y 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP \
        exp             rect Y( TS_HUD_OFFSET_Y + TS_HUD_SIZE - 5 ) \
        exp             rect X( xOffsetOp * ( TS_HUD_SPACING_X_HALF - 4 ) - 1 ) \
        textalign	    textAlign \
        textscale		( TEXTSIZE_SMALL * 0.6 ) \
        textstyle		ITEM_TEXTSTYLE_SHADOWED \
        textfont		UI_FONT_OBJECTIVE \
        forecolor		1 1 1 1 \
        exp				text( count ); \
        visible			when( visibleExp ); \
        decoration \
    } \
    itemDef \
    { \
        name			"teamCountLast" \
        rect			TS_HUD_POS_X TS_HUD_OFFSET_Y 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP \
        exp             rect Y( TS_HUD_OFFSET_Y + TS_HUD_SIZE - 5 ) \
        exp             rect X( xOffsetOp * ( TS_HUD_SPACING_X_HALF - 4 ) - 1 ) \
        textalign	    textAlign \
        textscale		(TEXTSIZE_SMALL * 0.6) \
        textstyle		ITEM_TEXTSTYLE_SHADOWED \
        textfont		UI_FONT_OBJECTIVE \
        forecolor		0.9 0 0 1 \
        exp				text( count ); \
        exp             forecolor A( 1 - ( float ( milliseconds() % 1000 ) / 1000 ) ); \
        visible			when( visibleExp && blinkExp && count <= 1 ); \
        decoration \
    }

menuDef
{
    name			"scorebars"
    rect			0 0 649 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
    fullScreen		0
    visible         when( !inkillcam() && !ui_active() && !isIntermission() && !flashbanged() && !scoped() );

    //TEAMBASED HUD
    TS_HUD_ITEM( TS_HUD_ALIGN_X_OP_ALLIES,  TS_HUD_ALIGN_W_MOD_ALLIES,  ITEM_ALIGN_MIDDLE_LEFT,     dvarString( g_TeamIcon_Allies ),    "_inv", TS_HUD_VISIBLE && TS_IS_TEAMBASED, marinesfield( score ), TS_IS_ALLIES, TS_TEAMCOUNT_ALLIES, 1 )
    TS_HUD_ITEM( TS_HUD_ALIGN_X_OP_AXIS,    TS_HUD_ALIGN_W_MOD_AXIS,    ITEM_ALIGN_MIDDLE_RIGHT,    dvarString( g_TeamIcon_Axis ),      "",     TS_HUD_VISIBLE && TS_IS_TEAMBASED, opforfield( score ),   TS_IS_AXIS,   TS_TEAMCOUNT_AXIS,   1 )

    //FREE GAMEMODE HUD
    TS_HUD_ITEM( TS_HUD_ALIGN_X_OP_AXIS,    TS_HUD_ALIGN_W_MOD_AXIS,    ITEM_ALIGN_MIDDLE_RIGHT,    "hud_match_cup_gold", "", TS_HUD_VISIBLE && TS_IS_NOT_TEAMBASED, TS_HUD_SCORE_PLAYER_1, TS_IS_WINNING_PLAYER, 1, 0 )
    TS_HUD_ITEM( TS_HUD_ALIGN_X_OP_ALLIES,  TS_HUD_ALIGN_W_MOD_ALLIES,  ITEM_ALIGN_MIDDLE_LEFT,     "hud_match_cup",  "_inv", TS_HUD_VISIBLE && TS_IS_NOT_TEAMBASED, TS_HUD_SCORE_PLAYER_2, TS_IS_LOSING_PLAYER,  TS_HUD_PLAYER_INDEX, 0 )


    //TEAMBASED HUD
    //TS_HUD_ITEM( TS_HUD_POS_Y_ALLIES, TS_HUD_ALIGN_X_OP_AXIS,     TS_HUD_ALIGN_W_MOD_AXIS,    ITEM_ALIGN_MIDDLE_LEFT,     dvarString( g_TeamIcon_Allies ),    "_inv", TS_HUD_VISIBLE && TS_IS_TEAMBASED, marinesfield( score ), TS_IS_ALLIES, TS_TEAMCOUNT_ALLIES, 1 )
    //TS_HUD_ITEM( TS_HUD_POS_Y_AXIS,   TS_HUD_ALIGN_X_OP_ALLIES,   TS_HUD_ALIGN_W_MOD_ALLIES,  ITEM_ALIGN_MIDDLE_RIGHT,    dvarString( g_TeamIcon_Axis ),      "",     TS_HUD_VISIBLE && TS_IS_TEAMBASED, opforfield( score ),   TS_IS_AXIS,   TS_TEAMCOUNT_AXIS,   1 )

    //FREE GAMEMODE HUD
    //TS_HUD_ITEM( TS_HUD_POS_Y_PLAYER_1, TS_HUD_ALIGN_X_OP_AXIS, TS_HUD_ALIGN_W_MOD_AXIS, ITEM_ALIGN_MIDDLE_RIGHT, "hud_match_cup_gold", "", TS_HUD_VISIBLE && TS_IS_NOT_TEAMBASED, TS_HUD_SCORE_PLAYER_1, TS_IS_WINNING_PLAYER, 1, 0 )
    //TS_HUD_ITEM( TS_HUD_POS_Y_PLAYER_2, TS_HUD_ALIGN_X_OP_ALLIES, TS_HUD_ALIGN_W_MOD_ALLIES, ITEM_ALIGN_MIDDLE_LEFT, "hud_match_cup",  "_inv", TS_HUD_VISIBLE && TS_IS_NOT_TEAMBASED, TS_HUD_SCORE_PLAYER_2, TS_IS_LOSING_PLAYER,  TS_HUD_PLAYER_INDEX, 0 )


    //RAUND TIMER
    /*itemDef
    {
        rect			( TS_HUD_POS_X - TS_HUD_BACK_SIZE_X + 6 ) ( TS_HUD_TIMER_POS_Y - 6 ) TS_HUD_BACK_SIZE_X TS_HUD_BACK_SIZE_Y HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        forecolor		1 1 1 ( HUD_BACK_ALPHA * 0.65 )
        style			WINDOW_STYLE_SHADER
        background		"hud_background_line_half"
        visible			when ( TS_HUD_TIMER_VISIBLE )
        decoration
    }*/
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			TS_HUD_POS_X TS_HUD_TIMER_POS_Y TS_HUD_SIZE TS_HUD_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        origin			-22 0
        exp				material( "hud_suitcase_bomb" );
        visible			when ( dvarBool( ui_bomb_timer ) && TS_HUD_TIMER_VISIBLE );
        forecolor		1 1 1 HUD_ALPHA
        decoration
    }

    TS_HUD_TIMER( "--:--", 1 1 1 HUD_FOREGROUND_ALPHA, 0, dvarInt( "ui_timelimit" ) == 0 )
    TS_HUD_TIMER( secondsAsCountdown( timeLeft() ), 1 1 1 HUD_FOREGROUND_ALPHA, -2, dvarInt( "ui_timelimit" ) > 0 && timeLeft() >= 60 && !dvarBool( ui_bomb_timer ) )
    TS_HUD_TIMER( secondsAsCountdown( timeLeft() ), 1 0.75 0 HUD_FOREGROUND_ALPHA, -2, dvarInt( "ui_timelimit" ) > 0 && timeLeft() >= 30 && timeLeft() < 60 && !dvarBool( ui_bomb_timer ) )
    TS_HUD_TIMER( secondsAsCountdown( timeLeft() ) + "." + ( 9 - int( ( milliseconds() / 100 ) % 10 ) ), 1 0.5 0 1, -2, (timeLeft() >= 0 && timeLeft() < 30) || dvarBool( ui_bomb_timer ) )
}