#define HINT_MANTLE_IS_VISIBLE      ( dvarint( "ui_hud_show_mantle_hint" ) >= dvarint( "ui_hud_hardcore" ) + 1 )
#define HINT_BREATH_IS_VISIBLE      ( dvarint( "ui_hud_show_breath_hint" ) >= dvarint( "ui_hud_hardcore" ) + 1 )

// Mantle hint
menuDef
{
    name			"MantleHint"
    rect			0 100 20 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
    fullScreen		0
    visible			when( HUD_IS_VISIBLE )

    itemDef
    {
        name			"chRect"
        rect			0 0 20 20
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        ownerdraw		CG_MANTLE_HINT
        visible			when( NOT_SPECTATING_CLIENT && HINT_MANTLE_IS_VISIBLE && dvarString ( "ui_hud_hint_text" ) == "" )
        decoration
    }
}

// Cursor hints TODO add cfg option for display it (ui_hud_show_cursor_hint )
menuDef
{
    name			"Cursorhints"
    rect			0 130 20 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
    fullScreen		0
    visible			when( HUD_IS_VISIBLE )

    itemDef
    {
        name			"chRect"
        rect			0 0 20 20 // 64x64
        textscale		(TEXTSIZE_SMALL * 0.9)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        ownerdraw		CG_CURSORHINT
        visible			when( NOT_SPECTATING_CLIENT && dvarString ( "ui_hud_hint_text" ) == "" )
        decoration
    }
}

// Invalid cmd hint
/*menuDef
{
    name			"InvalidCmdHint"
    rect			0 -150 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
    fullScreen		0
    visible			1

    itemDef
    {
        name			"chRect"
        rect			0 0 0 0
        textscale		TEXTSIZE_SMALL
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        ownerdraw		CG_INVALID_CMD_HINT
        textfont		UI_FONT_NORMAL
        visible			when( NOT_SPECTATING_CLIENT )
        decoration
    }
}*/

// Hold breath hint
//Pel - Removed to allow CAC Class in
menuDef
{
    name			"HoldBreathHint"
    rect			0 110 20 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
    fullScreen		0
    visible         when( HUD_IS_VISIBLE )

    itemDef
    {
        name			"chRect"
        rect			0 0 0 0
        textscale		TEXTSIZE_SMALL
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        ownerdraw		CG_HOLD_BREATH_HINT
        visible			when( HINT_BREATH_IS_VISIBLE )
        decoration
    }
}