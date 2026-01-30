// Center obituary (you killed/were killed by)
menuDef
{
    name			"CenterObituary"
    rect			0 150 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
    fullScreen		0
    visible			when( HUD_IS_VISIBLE && dvarint( "ui_hud_obituaries" ) == 1 && dvarstring( "g_gametype" ) != "vg" );

    itemDef
    {
        name			"chRect"
        rect			0 0 0 0
        textscale		TEXTSIZE_SMALL
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        ownerdraw		CG_CENTER_MESSAGE
        visible			when( dvarint( "ui_hud_show_center_obituary" ) == 1 )
        decoration
    }
}


// game messages
menuDef
{
    name			"gamemessages"
    rect			0 0 10 10 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
    exp				rect Y( ONLINEGAME_OFFSET_EXP )
	exp				rect X( ONLINEGAME_OFFSET_EXP * HUD_MINUS_ONE )
    fullScreen		0
    visible			when( HUD_IS_VISIBLE && dvarint( "ui_hud_obituaries" ) == 1 && dvarstring( "g_gametype" ) != "vg" );

    itemDef
    {
        origin				0 0
        type				ITEM_TYPE_GAME_MESSAGE_WINDOW
        gamemsgwindowindex	0
        gamemsgwindowmode	MODE_TOPDOWN_ALIGN_TOP
        //gamemsgwindowmode	MODE_TOPDOWN_ALIGN_BOTTOM
        textfont			UI_FONT_DEFAULT
        textstyle			ITEM_TEXTSTYLE_SHADOWED
        textalign			ITEM_ALIGN_TOP_RIGHT
        textscale			( TEXTSIZE_SMALL * 0.6 )
        visible				when( 1 );
    }
}

menuDef
{
    name			"boldgamemessages"
    // (todo: use VERTICAL_ALIGN_TOP in SP, origin 0 180)
    rect			0 -40 20 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
    fullScreen		0
    visible			when( HUD_IS_VISIBLE && dvarint( "ui_hud_obituaries" ) == 1 && dvarstring( "g_gametype" ) != "vg" );

    itemDef
    {
        origin				0 0
        type				ITEM_TYPE_GAME_MESSAGE_WINDOW
        gamemsgwindowindex	1
        gamemsgwindowmode	MODE_BOTTOMUP_ALIGN_BOTTOM
        textfont			UI_FONT_OBJECTIVE
        textstyle			ITEM_TEXTSTYLE_SHADOWED
        textalign			ITEM_ALIGN_CENTER
        textscale			( TEXTSIZE_SMALL * 0.9 )
        visible				when( 1 );
    }
}

menuDef
{
    name			"subtitles"
    rect			200 400 10 10 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
    fullScreen		0
    visible			when( HUD_IS_VISIBLE && dvarint( "ui_hud_obituaries" ) == 1 && dvarstring( "g_gametype" ) != "vg" );

    itemDef
    {
        origin				0 0
        type				ITEM_TYPE_GAME_MESSAGE_WINDOW
        gamemsgwindowindex	2
        gamemsgwindowmode	MODE_BOTTOMUP_ALIGN_BOTTOM
        textfont			UI_FONT_DEFAULT
        textstyle			ITEM_TEXTSTYLE_SHADOWED
        textalign			ITEM_ALIGN_LEFT
        textscale			TEXTSIZE_SMALL
        visible				when ( dvarint( ui_hud_obituaries ) == 1 && !ui_active() );
    }
}
