// Mantle hint
menuDef
{
    name			"MantleHint"
    rect			0 70 20 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
    fullScreen		0
    visible			when( ( dvarInt( ui_hud_hardcore ) == 0 && dvarInt( ui_hud_show_mantle_hint ) == 1 ) || dvarInt( ui_hud_show_mantle_hint ) == 2 )

    itemDef
    {
        name			"chRect"
        rect			0 0 20 20
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        ownerdraw		CG_MANTLE_HINT
        visible			when( NOT_SPECTATING )
        decoration
    }
}

// Cursor hints TODO add cfg option for display it (ui_hud_show_cursor_hint )
menuDef
{
    name			"Cursorhints"
    rect			0 70 20 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
    fullScreen		0
    visible			when( !ui_active() )

    itemDef
    {
        name			"chRect"
        rect			0 0 20 20 // 64x64
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        ownerdraw		CG_CURSORHINT
        visible			when( NOT_SPECTATING )
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
        visible			when( NOT_SPECTATING )
        decoration
    }
}*/

// Hold breath hint
//Pel - Removed to allow CAC Class in
menuDef
{
    name			"HoldBreathHint"
    rect			0 70 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
    fullScreen		0
    visible 0
    //visible when ( !adsjavelin() && dvarInt( ui_hud_hardcore ) == 0 && !inkillcam() && NOT_SPECTATING );

    itemDef
    {
        name			"chRect"
        rect			0 0 0 0
        textscale		TEXTSIZE_SMALL
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        ownerdraw		CG_HOLD_BREATH_HINT
        visible			1
        decoration
    }
}