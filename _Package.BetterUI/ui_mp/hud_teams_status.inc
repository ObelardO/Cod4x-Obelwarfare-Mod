#define TS_HUD_ALIGN              HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM

#define TS_HUD_SIZE               20
#define TS_HUD_OFFSET_X	          0
#define TS_HUD_OFFSET_Y	          ( -TS_HUD_SIZE - 24 )
#define TS_HUD_SPACING_X          60
#define TS_HUD_SPACING_X_HALF     30

#define TS_HUD_VISIBLE            ( ( dvarint( ui_hud_show_teams_status ) >= dvarint( ui_hud_hardcore ) + 1 ) )

#define TS_HUD_POS_X              ( TS_HUD_SPACING_X_HALF * HUD_MINUS_ONE - INV_BACK_SIZE )

#define TS_HUD_BACK_SIZE_Y        ( TS_HUD_SIZE + 6 )
#define TS_HUD_BACK_SIZE_X        ( TS_HUD_BACK_SIZE_Y * 2 )


#define TS_HUD_ICON_TEAM_AXIS     dvarString( g_TeamIcon_Axis )
#define TS_HUD_ICON_TEAM_ALLIES   dvarString( g_TeamIcon_Allies )


#define TS_HUD_ALIGN_X_OP_LEFT    ( 0 - 1 )
#define TS_HUD_ALIGN_X_OP_RIGHT   ( 0 + 1 )
#define TS_HUD_ALIGN_W_MOD_LEFT   1
#define TS_HUD_ALIGN_W_MOD_RIGHT  0


#define TS_IS_FREE                ( int( team( name ) == "TEAM_SPECTATOR" ) )
#define TS_IS_AXIS                ( int( team( name ) == "TEAM_AXIS" ) )
#define TS_IS_ALLIES              ( int( team( name ) == "TEAM_ALLIES" ) )
#define TS_IS_TEAMBASED           ( dvarInt( ui_hud_teams_status_teambased ) > 0 )
#define TS_IS_NOT_TEAMBASED       ( dvarInt( ui_hud_teams_status_teambased ) == 0 )

#define TS_IS_TEAM_TIE            ( TS_IS_TEAMBASED && team( score ) > 0 && team( score ) == otherteam( score ) )
#define TS_IS_TEAM_TIE_AXIS       ( TS_IS_AXIS && TS_IS_TEAM_TIE )
#define TS_IS_TEAM_TIE_ALLIES     ( TS_IS_ALLIES && TS_IS_TEAM_TIE )

#define TS_IS_TEAM_LOSING         ( TS_IS_TEAMBASED && ( team( score ) < otherteam( score ) ) )
#define TS_IS_TEAM_LOSING_AXIS    ( TS_IS_AXIS && TS_IS_TEAM_LOSING )
#define TS_IS_TEAM_LOSING_ALLIES  ( TS_IS_ALLIES && TS_IS_TEAM_LOSING )

#define TS_IS_TEAM_WINNING        ( TS_IS_TEAMBASED && ( team( score ) > otherteam( score ) ) )
#define TS_IS_TEAM_WINNING_AXIS   ( TS_IS_AXIS && TS_IS_TEAM_WINNING )
#define TS_IS_TEAM_WINNING_ALLIES ( TS_IS_ALLIES && TS_IS_TEAM_WINNING )

#define TS_TEAMCOUNT_AXIS         dvarint( ui_hud_teams_status_count_axis )
#define TS_TEAMCOUNT_ALLIES       dvarint( ui_hud_teams_status_count_allies )

#define TS_TEAMCOUNT_BLINK_EXP    ( ( sin ( milliseconds() *0.005 ) + 1 ) / 2 )

#define TS_TEAMSCORE_AXIS         opforfield( score )
#define TS_TEAMSCORE_ALLIES       marinesfield( score )

#define TS_PLAYER_SCORE_RANK      ( dvarint( ui_hud_teams_status_player_rank ) )
 
#define TS_IS_PLAYER_TIE          ( TS_IS_NOT_TEAMBASED && player ( score ) > 0 && TS_PLAYER_SCORE_RANK != 1 && player ( score ) == scoreatrank ( 1 ) )
#define TS_IS_PLAYER_LOSING       ( TS_IS_NOT_TEAMBASED && player ( score ) > 0 && TS_PLAYER_SCORE_RANK > 1 )
#define TS_IS_PLAYER_WINNING      ( TS_IS_NOT_TEAMBASED && player ( score ) > 0 && TS_PLAYER_SCORE_RANK == 1 )

#define TS_HUD_PLAYER_SCORE_1     ( scoreatrank( 1 ) )
#define TS_HUD_PLAYER_SCORE_2     ( TS_IS_PLAYER_LOSING * player ( score ) ) + ( TS_IS_PLAYER_WINNING * scoreatrank( 2 ) )

#define TS_HUD_PLAYER_INDEX       ( TS_IS_PLAYER_LOSING * TS_PLAYER_SCORE_RANK ) + ( TS_IS_PLAYER_WINNING * 2 )


#define TS_HUD_SCORECOLOR_BASE    1.0 1.0 1.0 0.6
#define TS_HUD_SCORECOLOR_WIN     0.3 1.0 0.3 1.0
#define TS_HUD_SCORECOLOR_LOSE    1.0 0.2 0.2 1.0
#define TS_HUD_SCORECOLOR_TIE     1.0 1.0 1.0 1.0


#define TS_HUD_TIMER_VISIBLE      ( ( dvarInt( "ui_timelimit" ) == 0 || ( dvarInt( "ui_timelimit" ) * 60 - timeLeft() > 5 ) ) )
#define TS_HUD_BOMB_SIZE          36
#define TS_HUD_BOMB_SIZE_HALF     18


#define TS_HUD_TEAM_LEFT( isVisibleExp, iconMaterial, count, isCountBlinkingExp, score, isWinExp, isLoseExp, isTieExp ) \
    INV_SLOT_ICON_LEFT( TS_HUD_ALIGN, TS_HUD_POS_X, isVisibleExp, INV_BACK_MAT_DOUBLE, INV_BACK_SIZE_DOUBLE, style WINDOW_STYLE_SHADER, iconMaterial, "", 1 ) \
    INV_SLOT_AMMO_LEFT( TS_HUD_ALIGN, TS_HUD_POS_X, isVisibleExp, exp text( count ), INV_CLR_WHITE, 1, INV_AMMO_POS_FIX_NONE ) \
    INV_SLOT_AMMO_LEFT( TS_HUD_ALIGN, TS_HUD_POS_X, isVisibleExp && isCountBlinkingExp == 1, exp text( count ), INV_CLR_RED, TS_TEAMCOUNT_BLINK_EXP, INV_AMMO_POS_FIX_NONE ) \
    TS_HUD_TEAM_SCORE( INV_ALIGN_X_OP_RIGHT, ITEM_ALIGN_LEFT, isVisibleExp, score, isWinExp, isLoseExp, isTieExp )


#define TS_HUD_TEAM_RIGHT( isVisibleExp, iconMaterial, count, isCountBlinkingExp, score, isWinExp, isLoseExp, isTieExp ) \
    INV_SLOT_ICON_RIGHT( TS_HUD_ALIGN, TS_HUD_POS_X, isVisibleExp, INV_BACK_MAT_DOUBLE, INV_BACK_SIZE_DOUBLE, style WINDOW_STYLE_SHADER, iconMaterial, "", 1 ) \
    INV_SLOT_AMMO_RIGHT( TS_HUD_ALIGN, TS_HUD_POS_X, isVisibleExp, exp text( count ), INV_CLR_WHITE, 1, INV_AMMO_POS_FIX_NONE ) \
    INV_SLOT_AMMO_RIGHT( TS_HUD_ALIGN, TS_HUD_POS_X, isVisibleExp && isCountBlinkingExp == 1, exp text( count ), INV_CLR_RED, TS_TEAMCOUNT_BLINK_EXP, INV_AMMO_POS_FIX_NONE ) \
    TS_HUD_TEAM_SCORE( INV_ALIGN_X_OP_LEFT, ITEM_ALIGN_RIGHT, isVisibleExp, score, isWinExp, isLoseExp, isTieExp )


#define TS_HUD_TEAM_SCORE( xOffsetOp, textAlign, isVisibleExp, score, isWinExp, isLoseExp, isTieExp ) \
    TS_HUD_ITEM_SCORE( xOffsetOp, textAlign, TS_HUD_SCORECOLOR_BASE, score, isVisibleExp ) \
    TS_HUD_ITEM_SCORE( xOffsetOp, textAlign, TS_HUD_SCORECOLOR_WIN,  score, isVisibleExp && isWinExp ) \
    TS_HUD_ITEM_SCORE( xOffsetOp, textAlign, TS_HUD_SCORECOLOR_LOSE, score, isVisibleExp && isLoseExp ) \
    TS_HUD_ITEM_SCORE( xOffsetOp, textAlign, TS_HUD_SCORECOLOR_TIE,  score, isVisibleExp && isTieExp )


#define TS_HUD_ITEM_SCORE( xOffsetOp, textAlign, color, score, isVisibleExp ) \
    itemDef \
    { \
        rect		TS_HUD_OFFSET_X TS_HUD_OFFSET_Y 1 1 TS_HUD_ALIGN \
        exp         rect Y( TS_HUD_OFFSET_Y ) \
        exp         rect X( xOffsetOp * ( TS_HUD_SPACING_X_HALF + INV_BACK_SIZE ) ) \
        exp         text( score ) \
        textfont	UI_FONT_OBJECTIVE \
        textscale	0.3 \
        textalign	textAlign \
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE \
        forecolor   color \
        visible 	when( isVisibleExp ); \
        decoration \
    }


#define TS_HUD_TIMER( textExp, color, xOffset, isVisibleExp ) \
    itemDef \
    { \
        rect		xOffset TS_HUD_OFFSET_Y 0 0 TS_HUD_ALIGN \
        exp         text( textExp ); \
        textfont	UI_FONT_OBJECTIVE \
        textscale	0.3 \
        textalign	ITEM_ALIGN_MIDDLE_CENTER \
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE \
        forecolor	color \
        visible 	when ( isVisibleExp && TS_HUD_TIMER_VISIBLE ) \
        decoration \
    }


menuDef
{
    name			"scorebars"
    rect			0 0 649 480 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
    exp				rect Y( 0 - ONLINEGAME_OFFSET_EXP )
    fullScreen		0
    visible         when( HUD_IS_VISIBLE && TS_HUD_VISIBLE );

    ////TEAMBASED HUD
    ////TS_HUD_ITEM( TS_HUD_ALIGN_X_OP_LEFT,  TS_HUD_ALIGN_W_MOD_LEFT,  ITEM_ALIGN_MIDDLE_RIGHT, dvarString( g_TeamIcon_Allies ), TS_IS_TEAMBASED, marinesfield( score ), TS_IS_TEAM_WINNING_ALLIES, TS_IS_TEAM_LOSING_ALLIES, TS_IS_TEAM_TIE_ALLIES, TS_TEAMCOUNT_ALLIES, 1 )
    ////TS_HUD_ITEM( TS_HUD_ALIGN_X_OP_RIGHT, TS_HUD_ALIGN_W_MOD_RIGHT, ITEM_ALIGN_MIDDLE_LEFT,  dvarString( g_TeamIcon_Axis ),   TS_IS_TEAMBASED, opforfield( score ),   TS_IS_TEAM_WINNING_AXIS,   TS_IS_TEAM_LOSING_AXIS,   TS_IS_TEAM_TIE_AXIS,   TS_TEAMCOUNT_AXIS,   1 )

    //TEAMBASED HUD: PLAYER'S TEAM ALWAYS ON LEFT
    TS_HUD_TEAM_LEFT(  TS_IS_TEAMBASED && ( TS_IS_ALLIES || TS_IS_FREE ), TS_HUD_ICON_TEAM_ALLIES, TS_TEAMCOUNT_ALLIES, TS_TEAMCOUNT_ALLIES < 2, TS_TEAMSCORE_ALLIES, TS_IS_TEAM_WINNING_ALLIES, TS_IS_TEAM_LOSING_ALLIES, TS_IS_TEAM_TIE_ALLIES )
    TS_HUD_TEAM_RIGHT( TS_IS_TEAMBASED && ( TS_IS_ALLIES || TS_IS_FREE ), TS_HUD_ICON_TEAM_AXIS,   TS_TEAMCOUNT_AXIS,   TS_TEAMCOUNT_AXIS   < 2, TS_TEAMSCORE_AXIS,   TS_IS_TEAM_WINNING_AXIS,   TS_IS_TEAM_LOSING_AXIS,   TS_IS_TEAM_TIE_AXIS   )

    TS_HUD_TEAM_RIGHT( TS_IS_TEAMBASED && TS_IS_AXIS, TS_HUD_ICON_TEAM_ALLIES, TS_TEAMCOUNT_ALLIES, TS_TEAMCOUNT_ALLIES < 2, TS_TEAMSCORE_ALLIES, TS_IS_TEAM_WINNING_ALLIES, TS_IS_TEAM_LOSING_ALLIES, TS_IS_TEAM_TIE_ALLIES )
    TS_HUD_TEAM_LEFT(  TS_IS_TEAMBASED && TS_IS_AXIS, TS_HUD_ICON_TEAM_AXIS,   TS_TEAMCOUNT_AXIS,   TS_TEAMCOUNT_AXIS   < 2, TS_TEAMSCORE_AXIS,   TS_IS_TEAM_WINNING_AXIS,   TS_IS_TEAM_LOSING_AXIS,   TS_IS_TEAM_TIE_AXIS   )

    //FREE GAMEMODE HUD
    TS_HUD_TEAM_LEFT(  TS_IS_NOT_TEAMBASED, "hud_match_cup_gold", "1",                 0, TS_HUD_PLAYER_SCORE_1, TS_IS_PLAYER_WINNING, 0,                   0 )
    TS_HUD_TEAM_RIGHT( TS_IS_NOT_TEAMBASED, "hud_match_cup",      TS_HUD_PLAYER_INDEX, 0, TS_HUD_PLAYER_SCORE_2, 0,                    TS_IS_PLAYER_LOSING, TS_IS_PLAYER_TIE )

    //RAUND TIMER
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			TS_HUD_OFFSET_X TS_HUD_OFFSET_Y TS_HUD_BOMB_SIZE TS_HUD_BOMB_SIZE TS_HUD_ALIGN
        origin			-TS_HUD_BOMB_SIZE_HALF -6
        exp				material( "hud_suitcase_bomb" )
        visible			when ( TS_HUD_TIMER_VISIBLE && dvarBool( ui_bomb_timer ) )
        forecolor		1 1 1 ( HUD_ALPHA * 0.4 )
        decoration
    }

    TS_HUD_TIMER( "--:--", 1 1 1 HUD_FOREGROUND_ALPHA, 0, dvarInt( "ui_timelimit" ) == 0 )
    TS_HUD_TIMER( secondsAsCountdown( timeLeft() ), 1 1 1 HUD_FOREGROUND_ALPHA, -2, dvarInt( "ui_timelimit" ) > 0 && timeLeft() >= 60 && !dvarBool( ui_bomb_timer ) )
    TS_HUD_TIMER( secondsAsCountdown( timeLeft() ), 1 0.75 0 HUD_FOREGROUND_ALPHA, -2, dvarInt( "ui_timelimit" ) > 0 && timeLeft() >= 30 && timeLeft() < 60 && !dvarBool( ui_bomb_timer ) )
    TS_HUD_TIMER( secondsAsCountdown( timeLeft() ) + "." + ( 9 - int( ( milliseconds() / 100 ) % 10 ) ), 1 0.5 0 1, -2, (timeLeft() >= 0 && timeLeft() < 30) || dvarBool( ui_bomb_timer ) )
}