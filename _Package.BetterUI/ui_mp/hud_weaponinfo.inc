//#define WEAPINFO_X -150
//#define WEAPINFO_Y -60
//#define WEAPINFO_X -4
#define WEAPINFO_X -20
#define WEAPINFO_Y -36


#define WEAPINFO_ICON_SIZE              20
#define WEAPINFO_ICON_SIZE_HALF         10
#define WEAPINFO_AMMO_SIZE              25
#define WEAPINFO_ICON_SPACING           10

#define WEAPINFO_INVENTORY_VISIBLE      ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 )

#define WEAPINFO_ICON_FRAG_VISIBLE      ( WEAPINFO_INVENTORY_VISIBLE && dvarint( ui_hud_has_frags ) > 0 )
#define WEAPINFO_ICON_SPECIAL_VISIBLE   ( WEAPINFO_INVENTORY_VISIBLE && dvarint( ui_hud_has_spec_gren ) > 0 )
#define WEAPINFO_ICON_BANDAGE_VISIBLE   ( WEAPINFO_INVENTORY_VISIBLE && dvarint( ui_bandages ) == 1 )

#define WEAPINFO_INVENTORY_POS_Y        WEAPINFO_Y

#define WEAPINFO_ICON_FRAG_POS_X        ( WEAPINFO_ICON_SIZE * WEAPINFO_ICON_FRAG_VISIBLE )
#define WEAPINFO_ICON_SPECIAL_POS_X     ( WEAPINFO_ICON_FRAG_POS_X + WEAPINFO_ICON_SIZE * WEAPINFO_ICON_SPECIAL_VISIBLE + WEAPINFO_ICON_SPACING * WEAPINFO_ICON_FRAG_VISIBLE )
#define WEAPINFO_ICON_BANDAGE_POS_X     ( WEAPINFO_ICON_SPECIAL_POS_X + WEAPINFO_ICON_SIZE * WEAPINFO_ICON_BANDAGE_VISIBLE + WEAPINFO_ICON_SPACING * WEAPINFO_ICON_SPECIAL_VISIBLE )

menuDef
{
    name			"weaponinfo"
    rect			BOTTOM_RECT_X BOTTOM_RECT_Y 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM
    exp				rect Y( BOTTOM_RECT_Y - (ONLINEGAME * ONLINEGAME_OFFSET) );
    fullScreen		0
    visible			when( !inkillcam() && dvarBool( ammoCounterHide ) == 0 && !flashbanged() && !ui_active() && team( name ) != "TEAM_SPECTATOR" );

    itemDef
    {
        name			"clipGraphic"
        rect			(WEAPINFO_X -35) (WEAPINFO_Y -12) 1 1
        forecolor		1 1 1 HUD_ALPHA
        ownerdraw		CG_PLAYER_WEAPON_AMMO_CLIP_GRAPHIC
        visible			when ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) == 2 );
        decoration
    }

    itemDef
    {
        name			"ammoStock"
        rect			(WEAPINFO_X -29) (WEAPINFO_Y -6) 1 1
        textscale		(TEXTSIZE_SMALL * 1.2)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        textalign	    ITEM_ALIGN_RIGHT
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_PLAYER_WEAPON_AMMO_STOCK
        visible			when ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) == 2 );
        decoration
    }

    itemDef
    {
        name			"offhandFragIcon"
        rect			WEAPINFO_X WEAPINFO_INVENTORY_POS_Y WEAPINFO_ICON_SIZE WEAPINFO_ICON_SIZE
        exp             rect X( WEAPINFO_X - WEAPINFO_ICON_FRAG_POS_X )
        forecolor		1 1 1 HUD_ALPHA
        ownerdraw		CG_OFFHAND_WEAPON_ICON_FRAG
        background		"hud_us_grenade" // default texture
        visible			when ( WEAPINFO_ICON_FRAG_VISIBLE );
        decoration
    }

    itemDef 
    {
        rect		WEAPINFO_X (WEAPINFO_INVENTORY_POS_Y + WEAPINFO_ICON_SIZE + 10) 1 1
        exp         rect X( WEAPINFO_X - (WEAPINFO_ICON_FRAG_POS_X - WEAPINFO_ICON_SIZE_HALF) );
        exp         text( KeyBinding( "+frag" ) );
        forecolor	1 1 0 HUD_ALPHA
        textfont	UI_FONT_OBJECTIVE
        textscale	0.18
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWED
        visible 	when ( WEAPINFO_ICON_FRAG_VISIBLE );
        decoration 
    }

    itemDef
    {
        name			"offhandSmokeIcon"
        rect			WEAPINFO_X WEAPINFO_INVENTORY_POS_Y WEAPINFO_ICON_SIZE WEAPINFO_ICON_SIZE
        exp             rect X( WEAPINFO_X - WEAPINFO_ICON_SPECIAL_POS_X );
        forecolor		1 1 1 HUD_ALPHA
        ownerdraw		CG_OFFHAND_WEAPON_ICON_SMOKEFLASH
        background		"hud_us_smokegrenade" // default texture
        visible			when ( WEAPINFO_ICON_SPECIAL_VISIBLE );
        decoration
    }

    itemDef 
    {
        rect		WEAPINFO_X (WEAPINFO_INVENTORY_POS_Y + WEAPINFO_ICON_SIZE + 10) 1 1
        exp         rect X( WEAPINFO_X - (WEAPINFO_ICON_SPECIAL_POS_X - WEAPINFO_ICON_SIZE_HALF) );
        exp         text( KeyBinding( "+smoke" ) );
        forecolor	1 1 0 HUD_ALPHA
        textfont	UI_FONT_OBJECTIVE
        textscale	0.18
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWED
        visible 	when ( WEAPINFO_ICON_SPECIAL_VISIBLE && WEAPINFO_HAS_SPECIAL );
        decoration 
    }
    
    itemDef
    {
        rect			WEAPINFO_X WEAPINFO_INVENTORY_POS_Y WEAPINFO_ICON_SIZE WEAPINFO_ICON_SIZE
        exp             rect X( WEAPINFO_X - WEAPINFO_ICON_BANDAGE_POS_X );
        name			"bandagesIcon"
        style			WINDOW_STYLE_SHADER
        forecolor		1 1 1 HUD_ALPHA
        background      "hud_us_bandages" // default texture
        visible			when( WEAPINFO_ICON_BANDAGE_VISIBLE );
        decoration
    }

    itemDef 
    {
        rect		WEAPINFO_X (WEAPINFO_INVENTORY_POS_Y + WEAPINFO_ICON_SIZE + 10) 1 1
        exp         rect X( WEAPINFO_X - (WEAPINFO_ICON_BANDAGE_POS_X - WEAPINFO_ICON_SIZE_HALF) );
        exp         text( KeyBinding( "openScriptMenu modkeybind bandage" ) );
        forecolor	1 1 0 HUD_ALPHA
        textfont	UI_FONT_OBJECTIVE
        textscale	0.18
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWED
        visible 	when ( WEAPINFO_ICON_BANDAGE_VISIBLE );
        decoration 
    }
            
    itemDef
    {
        name			"offHandFragAmmo"
        rect			WEAPINFO_X (WEAPINFO_INVENTORY_POS_Y + WEAPINFO_ICON_SIZE + 3) WEAPINFO_AMMO_SIZE WEAPINFO_AMMO_SIZE
        exp             rect X( WEAPINFO_X - (WEAPINFO_ICON_FRAG_POS_X - WEAPINFO_ICON_SIZE) );
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_OFFHAND_WEAPON_AMMO_FRAG
        visible			when ( WEAPINFO_ICON_FRAG_VISIBLE );
        decoration
    }

    itemDef
    {
        name			"offHandSmokeAmmo"
        rect			WEAPINFO_X (WEAPINFO_INVENTORY_POS_Y + WEAPINFO_ICON_SIZE + 3) WEAPINFO_AMMO_SIZE WEAPINFO_AMMO_SIZE
        exp             rect X( WEAPINFO_X - (WEAPINFO_ICON_SPECIAL_POS_X - WEAPINFO_ICON_SIZE) );
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_OFFHAND_WEAPON_AMMO_SMOKEFLASH
        visible			when ( WEAPINFO_ICON_SPECIAL_VISIBLE );
        decoration
    }

    itemDef
    {
        name			"bandagesQty"
        rect			WEAPINFO_X (WEAPINFO_INVENTORY_POS_Y + WEAPINFO_ICON_SIZE + 3) WEAPINFO_AMMO_SIZE WEAPINFO_AMMO_SIZE
        exp             rect X( WEAPINFO_X - (WEAPINFO_ICON_BANDAGE_POS_X - WEAPINFO_ICON_SIZE) );
        textscale		(TEXTSIZE_SMALL * 0.6)
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        exp					text( dvarint( ui_bandages_qty ) );
        visible			when ( WEAPINFO_ICON_BANDAGE_VISIBLE  );
        decoration
    }

    itemDef
    {
        name			"weapname"
        rect			(WEAPINFO_X -8) (WEAPINFO_Y -15) 1 1
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textscale		(TEXTSIZE_SMALL * 0.4)
        textfont		UI_FONT_OBJECTIVE
        textalign	    ITEM_ALIGN_RIGHT
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_PLAYER_WEAPON_NAME
        visible         when ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) == 2 );
        decoration
    }
}