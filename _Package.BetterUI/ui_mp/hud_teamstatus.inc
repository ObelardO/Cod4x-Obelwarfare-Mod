#define TEAMSTAT_OFFSET_X	-20
#define TEAMSTAT_OFFSET_Y	10
#define TEAMSTAT_SPACING    30
#define TEAMSTAT_SIZE       24

#define TEAMSTAT_SHOULD_DISPLAY (team( name ) != "TEAM_SPECTATOR") && !isIntermission() && gametype() != "bel" && dvarInt( ui_hud_teamstat_visible ) > 0 && dvarBool( ui_hud_teamstat_teambased ) 

menuDef
{
    name			"scorebars"
    rect			0 0 649 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
    fullScreen		0
    /* TODO add ui_hud_show_teamstatus dvar */
    /*visible 		when( !inkillcam() && !ui_active() && !isIntermission() && ( ( dvarint( ui_hud_hardcore ) == 0 && dvarint( ui_hud_show_teamstatus ) > 0 ) || ( dvarint( ui_hud_hardcore ) == 1 && dvarint( ui_hud_show_teamstatus ) == 2 ) ) );*/
    visible         when( !inkillcam() && !ui_active() && !isIntermission() );

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
        visible 	when (TEAMSTAT_SHOULD_DISPLAY);
        decoration 
    }
    itemDef
    {
        name			"teamCountQtyA"
        rect			(TEAMSTAT_OFFSET_X) (TEAMSTAT_OFFSET_Y + TEAMSTAT_SIZE) 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        exp				text( dvarint( ui_hud_teamstat_count_allies ) );
        visible			when (TEAMSTAT_SHOULD_DISPLAY);
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
        decoration 
    }
    itemDef
    {
        name			"teamCountQtyB"
        rect			(TEAMSTAT_OFFSET_X) (TEAMSTAT_OFFSET_Y + TEAMSTAT_SPACING + TEAMSTAT_SIZE) 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        exp             text( dvarint( ui_hud_teamstat_count_axis ) );
        visible			when (TEAMSTAT_SHOULD_DISPLAY);
        decoration
    }
}