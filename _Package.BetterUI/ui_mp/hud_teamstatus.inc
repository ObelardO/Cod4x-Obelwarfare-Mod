#define TEAMSTAT_OFFSET_X	-20
#define TEAMSTAT_OFFSET_Y	10
#define TEAMSTAT_SPACING    30
#define TEAMSTAT_SIZE       24

#define TEAMSTAT_SHOULD_DISPLAY (team( name ) != "TEAM_SPECTATOR") && !isIntermission() && gametype() != "bel" && dvarInt( ui_hud_teamstat_visible ) > 0 && dvarInt( ui_hud_teamstat_teambased ) > 0 

#define TEAMSTAT_TEAMCOUNT_ALLIES dvarint( ui_hud_teamstat_count_allies )
#define TEAMSTAT_TEAMCOUNT_AXIS dvarint( ui_hud_teamstat_count_axis )



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
        rect			TEAMSTAT_OFFSET_X TEAMSTAT_OFFSET_Y TEAMSTAT_SIZE TEAMSTAT_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        origin          (-TEAMSTAT_SIZE+1) 0
        exp				material( dvarString( g_TeamIcon_Allies ) );
        visible			when (TEAMSTAT_SHOULD_DISPLAY);
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        decoration
    }
    itemDef 
    {
        rect		(TEAMSTAT_OFFSET_X - TEAMSTAT_SIZE) (TEAMSTAT_OFFSET_Y + 20) 1 TEAMSTAT_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        origin		-6 0
        exp text	( marinesfield( score ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.3
        textalign	ITEM_ALIGN_RIGHT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        visible 	when( TEAMSTAT_SHOULD_DISPLAY );
        exp forecolor A( 0.6 + 0.4 * int( team( name ) == "TEAM_ALLIES" ))
        decoration 
    }
    itemDef
    {
        name			"teamCountAllies"
        rect			(TEAMSTAT_OFFSET_X) (TEAMSTAT_OFFSET_Y + TEAMSTAT_SIZE) 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 1 1 1
        exp				text( TEAMSTAT_TEAMCOUNT_ALLIES );
        visible			when( TEAMSTAT_SHOULD_DISPLAY && TEAMSTAT_TEAMCOUNT_ALLIES > 1 );
        decoration
    }
    itemDef
    {
        name			"teamCountAlliesLast"
        rect			(TEAMSTAT_OFFSET_X) (TEAMSTAT_OFFSET_Y + TEAMSTAT_SIZE) 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 0 0 1
        exp				text( TEAMSTAT_TEAMCOUNT_ALLIES );
        exp             forecolor A( (float(milliseconds() % 1000) / 1000) * 0.4 + 0.6 );
        visible			when( TEAMSTAT_SHOULD_DISPLAY && TEAMSTAT_TEAMCOUNT_ALLIES <= 1 );
        decoration
    }


    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			TEAMSTAT_OFFSET_X (TEAMSTAT_OFFSET_Y + TEAMSTAT_SPACING) TEAMSTAT_SIZE TEAMSTAT_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        origin          (-TEAMSTAT_SIZE+1) 0
        exp				material( dvarString( g_TeamIcon_Axis ) );
        visible			when (TEAMSTAT_SHOULD_DISPLAY);
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        decoration
    }
    itemDef 
    {
        rect		(TEAMSTAT_OFFSET_X - TEAMSTAT_SIZE) (TEAMSTAT_OFFSET_Y + TEAMSTAT_SPACING + 20) 1 TEAMSTAT_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        origin		-6 0
        exp text	( opforfield( score ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.3
        textalign	ITEM_ALIGN_RIGHT
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        visible 	when (TEAMSTAT_SHOULD_DISPLAY);
        exp forecolor A( 0.6 + 0.4 * int( team( name ) == "TEAM_AXIS" ))
        decoration 
    }
    itemDef
    {
        name			"teamCountAxis"
        rect			(TEAMSTAT_OFFSET_X) (TEAMSTAT_OFFSET_Y + TEAMSTAT_SPACING + TEAMSTAT_SIZE) 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 1 1 1
        exp             text( TEAMSTAT_TEAMCOUNT_AXIS );
        visible			when( TEAMSTAT_SHOULD_DISPLAY && TEAMSTAT_TEAMCOUNT_AXIS > 1 );

        decoration
    }
    itemDef
    {
        name			"teamCountAxisLast"
        rect			(TEAMSTAT_OFFSET_X) (TEAMSTAT_OFFSET_Y + TEAMSTAT_SPACING + TEAMSTAT_SIZE) 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 0 0 1
        exp             text( TEAMSTAT_TEAMCOUNT_AXIS );
        exp             forecolor A( (float(milliseconds() % 1000) / 1000) * 0.4 + 0.6 );
        visible			when( TEAMSTAT_SHOULD_DISPLAY && TEAMSTAT_TEAMCOUNT_AXIS <= 1 );
        decoration
    }
}