//#define WEAPINFO_X -150
//#define WEAPINFO_Y -60
#define WEAPINFO_X -4
#define WEAPINFO_Y -36

menuDef
{
    name			"weaponinfo"
    rect			BOTTOM_RECT_X BOTTOM_RECT_Y 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM
    exp				rect Y( BOTTOM_RECT_Y - (ONLINEGAME * ONLINEGAME_OFFSET) );
    fullScreen		0
    visible			when( !inkillcam() && dvarBool( ammoCounterHide ) == 0 && !flashbanged() && !ui_active() && NOT_SPECTATING );

    itemDef
    {
        name			"clipGraphic"
        rect			(WEAPINFO_X - 30) (WEAPINFO_Y + 32 -6) 1 1
        forecolor		1 1 1 HUD_ALPHA
        ownerdraw		CG_PLAYER_WEAPON_AMMO_CLIP_GRAPHIC
        visible			when ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) == 2 );
        decoration
    }

    itemDef
    {
        name			"ammoStock"
        rect			(WEAPINFO_X - 30) (WEAPINFO_Y + 34) 1 1
        textscale		TEXTSIZE_SMALL
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_PLAYER_WEAPON_AMMO_STOCK
        visible			when ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) == 2 );
        decoration
    }

    itemDef
    {
        name			"offhandFragIcon"
        rect			(WEAPINFO_X -36) (WEAPINFO_Y -5) 24 24
        forecolor		1 1 1 HUD_ALPHA
        ownerdraw		CG_OFFHAND_WEAPON_ICON_FRAG
        background		"hud_us_grenade" // default texture
        visible			when ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 );
        decoration
    }

    itemDef
    {
        name			"offhandSmokeIcon"
        rect			(WEAPINFO_X -66) (WEAPINFO_Y -5) 24 24
        forecolor		1 1 1 HUD_ALPHA
        ownerdraw		CG_OFFHAND_WEAPON_ICON_SMOKEFLASH
        background		"hud_us_smokegrenade" // default texture
        visible			when ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 );
        decoration
    }
    
    itemDef
    {
        name			"bandagesIcon"
        style			WINDOW_STYLE_SHADER
        rect			(WEAPINFO_X -96) (WEAPINFO_Y -5) 24 24
        forecolor		1 1 1 HUD_ALPHA
        background "hud_us_bandages" // default texture
        visible			when ( dvarint( ui_bandages ) == 1 && ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 ) );
        decoration
    }
            
    itemDef
    {
        name			"offHandFragAmmo"
        rect			(WEAPINFO_X -14) (WEAPINFO_Y +20) 25 25
        textscale		TEXTSIZE_SMALL
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_OFFHAND_WEAPON_AMMO_FRAG
        visible			when ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 );
        decoration
    }

    itemDef
    {
        name			"offHandSmokeAmmo"
        rect			(WEAPINFO_X -45) (WEAPINFO_Y +20) 25 25
        textscale		TEXTSIZE_SMALL
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_OFFHAND_WEAPON_AMMO_SMOKEFLASH
        visible			when ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 );
        decoration
    }

    itemDef
    {
        name			"bandagesQty"
        rect			(WEAPINFO_X -76) (WEAPINFO_Y +20) 25 25
        textscale		TEXTSIZE_SMALL
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        exp					text( dvarint( ui_bandages_qty ) );
        visible			when ( dvarint( ui_bandages ) == 1 && ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 ) );
        decoration
    }

//		itemDef
//		{
//			name			"weapname"
//			rect			(WEAPINFO_X - 40) (WEAPINFO_Y + 20) 1 1
//			textstyle		ITEM_TEXTSTYLE_SHADOWED
//			textscale		TEXTSIZE_SMALL
//			textfont		UI_FONT_OBJECTIVE
//			forecolor		1 1 1 HUD_FOREGROUND_ALPHA
//			ownerdraw		CG_PLAYER_WEAPON_NAME
//			visible when ( dvarBool( hiDef ) == 1 );
//			visible 		when ( dvarint( ui_hud_hardcore ) == 0 );
//			decoration
//		}
}