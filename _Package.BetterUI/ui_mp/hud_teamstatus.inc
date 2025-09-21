#define TEAMSTAT_OFFSET_X	-20
#define TEAMSTAT_OFFSET_Y	10
#define TEAMSTAT_SPACING    30
#define TEAMSTAT_SIZE       24

#define TEAMSTAT_SHOULD_DISPLAY     (team( name ) != "TEAM_SPECTATOR") && !isIntermission() && gametype() != "bel" && dvarInt( ui_hud_teamstat_visible ) > 0 && TEAMSTAT_IS_TEAMBASED

#define TEAMSTAT_TEAMCOUNT_ALLIES   dvarint( ui_hud_teamstat_count_allies )
#define TEAMSTAT_TEAMCOUNT_AXIS     dvarint( ui_hud_teamstat_count_axis )


#define TEAMSTAT_IS_AXIS            int( team( name ) == "TEAM_AXIS" )
#define TEAMSTAT_IS_ALLIES          int( team( name ) == "TEAM_ALLIES" )
#define TEAMSTAT_IS_TEAMBASED       dvarInt( ui_hud_teamstat_teambased ) > 0 
#define TEAMSTAT_IS_LOSING_AXIS     ( opforfield( score ) <= marinesfield( score ) )
#define TEAMSTAT_IS_LOSING_ALLIES   ( marinesfield( score ) < opforfield( score ) )

#define TEAMSTAT_POS_Y_AXIS         ( TEAMSTAT_IS_TEAMBASED && TEAMSTAT_IS_LOSING_AXIS ) * TEAMSTAT_SPACING + TEAMSTAT_OFFSET_Y
#define TEAMSTAT_POS_Y_ALLIES       ( TEAMSTAT_IS_TEAMBASED && TEAMSTAT_IS_LOSING_ALLIES ) * TEAMSTAT_SPACING + TEAMSTAT_OFFSET_Y
#define TEAMSTAT_POS_X              TEAMSTAT_OFFSET_X

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

    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			TEAMSTAT_POS_X TEAMSTAT_OFFSET_Y TEAMSTAT_SIZE TEAMSTAT_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp             rect Y(TEAMSTAT_POS_Y_ALLIES)
        origin          (-TEAMSTAT_SIZE+1) 0
        exp				material( dvarString( g_TeamIcon_Allies ) );
        visible			when (TEAMSTAT_SHOULD_DISPLAY);
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        decoration
    }
    itemDef 
    {
        rect		(TEAMSTAT_POS_X - TEAMSTAT_SIZE) TEAMSTAT_OFFSET_Y 1 TEAMSTAT_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp         rect Y(TEAMSTAT_POS_Y_ALLIES + 20)
        origin		-6 0
        exp text	( marinesfield( score ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.3
        textalign	ITEM_ALIGN_RIGHT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        visible 	when( TEAMSTAT_SHOULD_DISPLAY );
        exp forecolor A( 0.6 + 0.4 * TEAMSTAT_IS_ALLIES )
        decoration 
    }
    itemDef
    {
        name			"teamCountAllies"
        rect			TEAMSTAT_POS_X TEAMSTAT_OFFSET_Y 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp             rect Y(TEAMSTAT_POS_Y_ALLIES + TEAMSTAT_SIZE)
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 1 1 1
        exp				text( TEAMSTAT_TEAMCOUNT_ALLIES );
        visible			when( TEAMSTAT_SHOULD_DISPLAY );
        decoration
    }
    itemDef
    {
        name			"teamCountAlliesLast"
        rect			TEAMSTAT_POS_X TEAMSTAT_OFFSET_Y 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp             rect Y(TEAMSTAT_POS_Y_ALLIES + TEAMSTAT_SIZE)
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 0 0 1
        exp				text( TEAMSTAT_TEAMCOUNT_ALLIES );
        exp             forecolor A( 1 - (float(milliseconds() % 1000) / 1000) );
        visible			when( TEAMSTAT_SHOULD_DISPLAY && TEAMSTAT_TEAMCOUNT_ALLIES <= 1 );
        decoration
    }


    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			TEAMSTAT_POS_X TEAMSTAT_OFFSET_Y TEAMSTAT_SIZE TEAMSTAT_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp             rect Y(TEAMSTAT_POS_Y_AXIS)
        origin          (-TEAMSTAT_SIZE+1) 0
        exp				material( dvarString( g_TeamIcon_Axis ) );
        visible			when (TEAMSTAT_SHOULD_DISPLAY);
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        decoration
    }
    itemDef 
    {
        rect		(TEAMSTAT_POS_X - TEAMSTAT_SIZE) TEAMSTAT_OFFSET_Y 1 TEAMSTAT_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp         rect Y(TEAMSTAT_POS_Y_AXIS + 20)
        origin		-6 0
        exp text	( opforfield( score ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.3
        textalign	ITEM_ALIGN_RIGHT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        visible 	when (TEAMSTAT_SHOULD_DISPLAY);
        exp forecolor A( 0.6 + 0.4 * TEAMSTAT_IS_AXIS )
        decoration 
    }
    itemDef
    {
        name			"teamCountAxis"
        rect			TEAMSTAT_POS_X TEAMSTAT_OFFSET_Y 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp             rect Y(TEAMSTAT_POS_Y_AXIS + TEAMSTAT_SIZE)
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 1 1 1
        exp             text( TEAMSTAT_TEAMCOUNT_AXIS );
        visible			when( TEAMSTAT_SHOULD_DISPLAY );

        decoration
    }
    itemDef
    {
        name			"teamCountAxisLast"
        rect			TEAMSTAT_POS_X TEAMSTAT_OFFSET_Y 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp             rect Y(TEAMSTAT_POS_Y_AXIS + TEAMSTAT_SIZE)
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 0 0 1
        exp             text( TEAMSTAT_TEAMCOUNT_AXIS );
        exp             forecolor A( 1 - (float(milliseconds() % 1000) / 1000) );
        visible			when( TEAMSTAT_SHOULD_DISPLAY && TEAMSTAT_TEAMCOUNT_AXIS <= 1 );
        decoration
    }
}