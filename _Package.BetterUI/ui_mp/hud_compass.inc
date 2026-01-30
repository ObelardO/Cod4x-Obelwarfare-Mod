#define COMPASS_HUD_IS_VISIBLE        ( dvarint( "ui_hud_hardcore" ) == 0 || dvarint( "ui_hud_hardcore_show_compass" ) == 1 )
 
#define COMPASS_HUD_ALIGN             HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
#define COMPASS_HUD_OFFSET_Y          ( spectatingClient() * 32 )
#define COMPASS_HUD_HEIGHT            10

#define COMPASS_HUD_TAPE_WIDTH        160
#define COMPASS_HUD_TAPE_WIDTH_HALF   80

#define COMPASS_HUD_BACK_WIDTH        300
#define COMPASS_HUD_BACK_WIDTH_HALF   150

#define COMPASS_HUD_DIR_WIDTH         80
#define COMPASS_HUD_DIR_WIDTH_HALF    40


#define COMPASS_HUD_ANGLE( color, xOffset, isVisibleExp ) \
    itemDef \
    { \
        rect		xOffset ( COMPASS_HUD_HEIGHT * 0.5 ) 0 0 COMPASS_HUD_ALIGN \
        exp         text( dvarInt( "ui_hud_compass_angle" ) ) \
        textfont	UI_FONT_OBJECTIVE \
        textscale	0.27 \
        textalign	ITEM_ALIGN_MIDDLE_CENTER \
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE \
        forecolor	color \
        visible 	when ( isVisibleExp ) \
        decoration \
    }


// Score Bar
menuDef
{
    name			"scorebar"
    rect			FULLSCREEN COMPASS_HUD_ALIGN
    exp				rect Y( ONLINEGAME_OFFSET_EXP + COMPASS_HUD_OFFSET_Y )
    fullScreen		0
    visible 		when ( HUD_IS_VISIBLE && COMPASS_HUD_IS_VISIBLE )

    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			-COMPASS_HUD_BACK_WIDTH_HALF 0 COMPASS_HUD_BACK_WIDTH COMPASS_HUD_HEIGHT COMPASS_HUD_ALIGN
        background		"line_horizontal"
        forecolor		0 0 0 1
        visible			1
        decoration
    }

    // compass without obj points
    itemDef
    {
        name			"minimapTicker"
        rect			-COMPASS_HUD_TAPE_WIDTH_HALF 0 COMPASS_HUD_TAPE_WIDTH COMPASS_HUD_HEIGHT COMPASS_HUD_ALIGN
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        background		"minimap_tickertape_mp"
        ownerdraw		CG_PLAYER_COMPASS_TICKERTAPE_NO_OBJ
        visible         1
        decoration
    }

    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			-COMPASS_HUD_DIR_WIDTH_HALF 0 COMPASS_HUD_DIR_WIDTH COMPASS_HUD_HEIGHT COMPASS_HUD_ALIGN
        background		"line_horizontal"
        forecolor		0 0 0 1
        visible			1
        decoration
    }

    COMPASS_HUD_ANGLE( 1 1 1 HUD_FOREGROUND_ALPHA, 0, 1 )
}