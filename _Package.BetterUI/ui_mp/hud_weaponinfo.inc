#define WEAPINFO_X -20
#define WEAPINFO_Y -36

#define WEAPINFO_ICON_SIZE              20
#define WEAPINFO_ICON_SIZE_HALF         10
#define WEAPINFO_AMMO_SIZE              25
#define WEAPINFO_ICON_SPACING           10

#define WEAPINFO_INVENTORY_VISIBLE      ( dvarint( ui_hud_show_offhand_items ) == dvarint( ui_hud_hardcore ) + 1 )
#define WEAPINFO_WEAPON_AMMO_VISIBLE    ( dvarint( ui_hud_show_ammodisplay ) == dvarint( ui_hud_hardcore ) + 1 )

#define WEAPINFO_ICON_FRAG_VISIBLE      ( WEAPINFO_INVENTORY_VISIBLE && dvarint( ui_hud_has_frags ) > 0 )
#define WEAPINFO_ICON_SPECIAL_VISIBLE   ( WEAPINFO_INVENTORY_VISIBLE && dvarint( ui_hud_has_spec_gren ) > 0 )
#define WEAPINFO_ICON_BANDAGE_VISIBLE   ( WEAPINFO_INVENTORY_VISIBLE && dvarint( ui_bandages ) == 1 )

#define WEAPINFO_INVENTORY_POS_Y        ( WEAPINFO_Y )
#define WEAPINFO_WEAPON_AMMO_POS_Y      ( -6 - ( ( WEAPINFO_ICON_FRAG_VISIBLE + WEAPINFO_ICON_SPECIAL_VISIBLE + WEAPINFO_ICON_BANDAGE_VISIBLE ) > 0 ) * ( WEAPINFO_ICON_SIZE + WEAPINFO_ICON_SPACING ) )

#define WEAPINFO_ICON_FRAG_POS_X        ( WEAPINFO_ICON_SIZE * WEAPINFO_ICON_FRAG_VISIBLE )
#define WEAPINFO_ICON_SPECIAL_POS_X     ( WEAPINFO_ICON_FRAG_POS_X + WEAPINFO_ICON_SIZE * WEAPINFO_ICON_SPECIAL_VISIBLE + WEAPINFO_ICON_SPACING * WEAPINFO_ICON_FRAG_VISIBLE )
#define WEAPINFO_ICON_BANDAGE_POS_X     ( WEAPINFO_ICON_SPECIAL_POS_X + WEAPINFO_ICON_SIZE * WEAPINFO_ICON_BANDAGE_VISIBLE + WEAPINFO_ICON_SPACING * WEAPINFO_ICON_SPECIAL_VISIBLE )


#define WEAPINFO_ITEM_ICON( vertPos, iconOwnerDraw, iconMaterial, KeyBindingText, visibleExp ) \
    itemDef \
    { \
        rect			WEAPINFO_X WEAPINFO_INVENTORY_POS_Y WEAPINFO_ICON_SIZE WEAPINFO_ICON_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM \
        exp             rect X( WEAPINFO_X - vertPos ) \
        forecolor		1 1 1 HUD_ALPHA \
        iconOwnerDraw \
        style			WINDOW_STYLE_SHADER \
        background		iconMaterial \
        visible			when ( visibleExp ) \
        decoration \
    } \
    itemDef \ 
    { \
        rect		WEAPINFO_X (WEAPINFO_INVENTORY_POS_Y + WEAPINFO_ICON_SIZE + 10) 1 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM \
        exp         rect X( WEAPINFO_X - (vertPos - WEAPINFO_ICON_SIZE_HALF) ) \
        exp         text( KeyBinding( KeyBindingText ) ) \
        forecolor	1 1 0 HUD_ALPHA \
        textfont	UI_FONT_OBJECTIVE \
        textscale	0.18 \
        textalign	ITEM_ALIGN_CENTER \
        textstyle	ITEM_TEXTSTYLE_SHADOWED \
        visible 	when ( visibleExp ) \
        decoration \
    }

#define WEAPINFO_ITEM_AMMO( vertPos, ammoOwnerDraw, baseColor, visibleExp ) \
    itemDef \
    { \
        rect			WEAPINFO_X (WEAPINFO_INVENTORY_POS_Y + WEAPINFO_ICON_SIZE + 3) WEAPINFO_AMMO_SIZE WEAPINFO_AMMO_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM \
        exp             rect X( WEAPINFO_X - (vertPos - WEAPINFO_ICON_SIZE) ) \
        textscale		(TEXTSIZE_SMALL * 0.6) \
        textstyle		ITEM_TEXTSTYLE_SHADOWED \
        textfont		UI_FONT_OBJECTIVE \
        forecolor		baseColor HUD_FOREGROUND_ALPHA \
        ammoOwnerDraw \
        visible			when ( visibleExp ) \
        decoration \
    }

#define WEAPINFO_ITEM_AMMO_BANDAGES name "offhandAmmo" \ 
    exp text( dvarint( ui_bandages_qty ) )


menuDef
{
    name			"weaponinfo"
    rect			0 0 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM
    exp				rect Y( 0 - (ONLINEGAME * ONLINEGAME_OFFSET) )
    fullScreen		0
    visible			when( !inkillcam() && dvarBool( ammoCounterHide ) == 0 && !flashbanged() && !ui_active() && team( name ) != "TEAM_SPECTATOR" && dvarInt( ui_hud_show_weapon ) == 1 )

    // WEAPON
    itemDef
    {
        name			"clipGraphic"
        rect			(WEAPINFO_X -35) (WEAPINFO_Y -12) 1 1
        exp             rect Y( WEAPINFO_WEAPON_AMMO_POS_Y - 12 )
        forecolor		1 1 1 HUD_ALPHA
        ownerdraw		CG_PLAYER_WEAPON_AMMO_CLIP_GRAPHIC
        visible			when ( WEAPINFO_WEAPON_AMMO_VISIBLE )
        decoration
    }

    itemDef
    {
        name			"ammoStock"
        rect			(WEAPINFO_X -29) (WEAPINFO_Y -6) 1 1
        exp             rect Y( WEAPINFO_WEAPON_AMMO_POS_Y - 6 )
        textscale		(TEXTSIZE_SMALL * 1.2)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        textalign	    ITEM_ALIGN_RIGHT
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_PLAYER_WEAPON_AMMO_STOCK
        visible			when ( WEAPINFO_WEAPON_AMMO_VISIBLE )
        decoration
    }

    itemDef
    {
        name			"weapname"
        rect			(WEAPINFO_X -8) (WEAPINFO_Y -15) 1 1
        exp             rect Y( WEAPINFO_WEAPON_AMMO_POS_Y - 15 )
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textscale		(TEXTSIZE_SMALL * 0.4)
        textfont		UI_FONT_OBJECTIVE
        textalign	    ITEM_ALIGN_RIGHT
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_PLAYER_WEAPON_NAME
        visible         when ( WEAPINFO_WEAPON_AMMO_VISIBLE )
        decoration
    }

    //FRAG
    WEAPINFO_ITEM_ICON( WEAPINFO_ICON_FRAG_POS_X, ownerdraw CG_OFFHAND_WEAPON_ICON_FRAG, "hud_us_grenade", "+frag", WEAPINFO_ICON_FRAG_VISIBLE )
    WEAPINFO_ITEM_AMMO( WEAPINFO_ICON_FRAG_POS_X, ownerdraw CG_OFFHAND_WEAPON_AMMO_FRAG, 1 1 1, WEAPINFO_ICON_FRAG_VISIBLE )

    //SPECIAL
    WEAPINFO_ITEM_ICON( WEAPINFO_ICON_SPECIAL_POS_X, ownerdraw CG_OFFHAND_WEAPON_ICON_SMOKEFLASH, "hud_us_smokegrenade", "+smoke", WEAPINFO_ICON_SPECIAL_VISIBLE )
    WEAPINFO_ITEM_AMMO( WEAPINFO_ICON_SPECIAL_POS_X, ownerdraw CG_OFFHAND_WEAPON_AMMO_SMOKEFLASH, 1 1 1, WEAPINFO_ICON_SPECIAL_VISIBLE )

    //BANDAGES
    WEAPINFO_ITEM_ICON( WEAPINFO_ICON_BANDAGE_POS_X, name "offhandIcon", "hud_us_bandages", "openScriptMenu modkeybind bandage", WEAPINFO_ICON_BANDAGE_VISIBLE )
    WEAPINFO_ITEM_AMMO( WEAPINFO_ICON_BANDAGE_POS_X, WEAPINFO_ITEM_AMMO_BANDAGES, 1.0 1 1, WEAPINFO_ICON_BANDAGE_VISIBLE && dvarint( ui_bandages_qty ) > 0 )
    WEAPINFO_ITEM_AMMO( WEAPINFO_ICON_BANDAGE_POS_X, WEAPINFO_ITEM_AMMO_BANDAGES, 0.9 0 0, WEAPINFO_ICON_BANDAGE_VISIBLE && dvarint( ui_bandages_qty ) == 0 )
}