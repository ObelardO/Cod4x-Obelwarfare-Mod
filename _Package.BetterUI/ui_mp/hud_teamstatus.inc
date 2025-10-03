#define TEAMSTAT_HUD_OFFSET_X	    -20
#define TEAMSTAT_HUD_OFFSET_Y	    20
#define TEAMSTAT_HUD_SPACING        30
#define TEAMSTAT_HUD_SIZE           24


#define TEAMSTAT_TEAMCOUNT_ALLIES   dvarint( ui_hud_teamstat_count_allies )
#define TEAMSTAT_TEAMCOUNT_AXIS     dvarint( ui_hud_teamstat_count_axis )

#define TEAMSTAT_IS_AXIS            int( team( name ) == "TEAM_AXIS" )
#define TEAMSTAT_IS_ALLIES          int( team( name ) == "TEAM_ALLIES" )
#define TEAMSTAT_IS_TEAMBASED       ( dvarInt( ui_hud_teamstat_teambased ) > 0 )
#define TEAMSTAT_IS_NOT_TEAMBASED   ( dvarInt( ui_hud_teamstat_teambased ) == 0 )
#define TEAMSTAT_IS_LOSING_AXIS     ( TEAMSTAT_IS_TEAMBASED && opforfield( score ) <= marinesfield( score ) )
#define TEAMSTAT_IS_LOSING_ALLIES   ( TEAMSTAT_IS_TEAMBASED && marinesfield( score ) < opforfield( score ) )

#define TEAMSTAT_HUD_POS_Y_AXIS     ( TEAMSTAT_IS_LOSING_AXIS * TEAMSTAT_HUD_SPACING + TEAMSTAT_HUD_OFFSET_Y )
#define TEAMSTAT_HUD_POS_Y_ALLIES   ( TEAMSTAT_IS_LOSING_ALLIES * TEAMSTAT_HUD_SPACING + TEAMSTAT_HUD_OFFSET_Y )
#define TEAMSTAT_HUD_POS_X          ( TEAMSTAT_HUD_OFFSET_X )


#define TEAMSTAT_SCORE_PLAYER_RANK  ( dvarint( ui_hud_teamstat_player_rank ) )

#define TEAMSTAT_IS_LOSING_PLAYER   ( TEAMSTAT_IS_NOT_TEAMBASED && TEAMSTAT_SCORE_PLAYER_RANK > 1 )
#define TEAMSTAT_IS_WINNING_PLAYER  ( TEAMSTAT_IS_NOT_TEAMBASED && TEAMSTAT_SCORE_PLAYER_RANK == 1 )

#define TEAMSTAT_HUD_POS_Y_PLAYER_1 ( 0 * TEAMSTAT_HUD_SPACING + TEAMSTAT_HUD_OFFSET_Y )
#define TEAMSTAT_HUD_POS_Y_PLAYER_2 ( 1 * TEAMSTAT_HUD_SPACING + TEAMSTAT_HUD_OFFSET_Y )

#define TEAMSTAT_HUD_SCORE_PLAYER_1 ( scoreatrank( 1 ) )
#define TEAMSTAT_HUD_SCORE_PLAYER_2 ( TEAMSTAT_IS_LOSING_PLAYER * player ( score ) ) + ( TEAMSTAT_IS_WINNING_PLAYER * scoreatrank( 2 ) )

#define TEAMSTAT_HUD_PLAYER_INDEX   ( TEAMSTAT_IS_LOSING_PLAYER * TEAMSTAT_SCORE_PLAYER_RANK ) + ( TEAMSTAT_IS_WINNING_PLAYER * 2 )

#define TEAMSTAT_HUD_VISIBLE        ( !isIntermission() && dvarInt( ui_hud_teamstat_visible ) > 0 )


#define TEAMSTAT_HUD( yOffset, icon, visibleFlag, score, highlightFlag, count, blinkFlag ) \
    itemDef \
    { \
        style			WINDOW_STYLE_SHADER \
        rect			TEAMSTAT_HUD_POS_X TEAMSTAT_HUD_OFFSET_Y TEAMSTAT_HUD_SIZE TEAMSTAT_HUD_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP \
        origin		    1 0 \
        exp             rect Y( yOffset ) \
        origin          (-TEAMSTAT_HUD_SIZE+1) 0 \
        exp				material( icon ); \
        visible			when ( visibleFlag ); \
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA \
        decoration \
    } \
    itemDef \ 
    { \
        rect		( TEAMSTAT_HUD_POS_X - TEAMSTAT_HUD_SIZE ) TEAMSTAT_HUD_OFFSET_Y 1 TEAMSTAT_HUD_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP \
        exp         rect Y( yOffset ) \
        origin		-4 0 \
        exp         text( score ); \
        textfont	UI_FONT_OBJECTIVE \
        textscale	0.3 \
        textalign	ITEM_ALIGN_MIDDLE_RIGHT \
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE \
        visible 	when( visibleFlag ); \
        exp         forecolor A( 0.6 + 0.4 * highlightFlag ) \
        decoration \
    } \
    itemDef \
    { \
        name			"teamCount" \
        rect			TEAMSTAT_HUD_POS_X TEAMSTAT_HUD_OFFSET_Y 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP \
        exp             rect Y( yOffset + TEAMSTAT_HUD_SIZE ) \
        textscale		( TEXTSIZE_SMALL * 0.6 ) \
        textstyle		ITEM_TEXTSTYLE_SHADOWED \
        textfont		UI_FONT_OBJECTIVE \
        forecolor		1 1 1 1 \
        exp				text( count ); \
        visible			when( visibleFlag ); \
        decoration \
    } \
    itemDef \
    { \
        name			"teamCountLast" \
        rect			TEAMSTAT_HUD_POS_X TEAMSTAT_HUD_OFFSET_Y 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP \
        exp             rect Y( yOffset + TEAMSTAT_HUD_SIZE ) \
        textscale		(TEXTSIZE_SMALL * 0.6) \
        textstyle		ITEM_TEXTSTYLE_SHADOWED \
        textfont		UI_FONT_OBJECTIVE \
        forecolor		1 0 0 1 \
        exp				text( count ); \
        exp             forecolor A( 1 - ( float ( milliseconds() % 1000 ) / 1000 ) ); \
        visible			when( visibleFlag && blinkFlag && count <= 1 ); \
        decoration \
    }

menuDef
{
    name			"scorebars"
    rect			0 0 649 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
    fullScreen		0
    visible         when( !inkillcam() && !ui_active() && !isIntermission() && !flashbanged() && !scoped() );

    itemDef
    {
        rect 0 100 200 380 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        ownerdraw CG_SPECTATORS
        textscale 4
    }

    //TEAMBASED HUD
    TEAMSTAT_HUD( TEAMSTAT_HUD_POS_Y_ALLIES, dvarString( g_TeamIcon_Allies ), TEAMSTAT_HUD_VISIBLE && TEAMSTAT_IS_TEAMBASED, marinesfield( score ), TEAMSTAT_IS_ALLIES, TEAMSTAT_TEAMCOUNT_ALLIES, 1 )
    TEAMSTAT_HUD( TEAMSTAT_HUD_POS_Y_AXIS,   dvarString( g_TeamIcon_Axis ),   TEAMSTAT_HUD_VISIBLE && TEAMSTAT_IS_TEAMBASED, opforfield( score ),   TEAMSTAT_IS_AXIS,   TEAMSTAT_TEAMCOUNT_AXIS,   1 )

    //FREE GAMEMODE HUD
    TEAMSTAT_HUD( TEAMSTAT_HUD_POS_Y_PLAYER_1, "hud_match_cup_gold", TEAMSTAT_HUD_VISIBLE && TEAMSTAT_IS_NOT_TEAMBASED, TEAMSTAT_HUD_SCORE_PLAYER_1, TEAMSTAT_IS_WINNING_PLAYER, 1, 0 )
    TEAMSTAT_HUD( TEAMSTAT_HUD_POS_Y_PLAYER_2, "hud_match_cup",      TEAMSTAT_HUD_VISIBLE && TEAMSTAT_IS_NOT_TEAMBASED, TEAMSTAT_HUD_SCORE_PLAYER_2, TEAMSTAT_IS_LOSING_PLAYER,  TEAMSTAT_HUD_PLAYER_INDEX, 0 )
}