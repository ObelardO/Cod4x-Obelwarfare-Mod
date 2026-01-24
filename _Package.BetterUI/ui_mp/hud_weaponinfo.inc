#define WEAPINFO_OFFSET_X        2

#define WEAPINFO_ITIMS_VISIBLE   ( dvarint( ui_hud_show_offhand_items ) >= dvarint( ui_hud_hardcore ) + 1 )
#define WEAPINFO_AMMOS_VISIBLE   ( dvarint( ui_hud_show_ammodisplay ) >= dvarint( ui_hud_hardcore ) + 1 )

#define WEAPINFO_AMMOS_POS_Y      ( ( INV_SLOT_ANY_VISIABLE_RIGHT + 1 ) * ( INV_BACK_SIZE + 5 ) * HUD_MINUS_ONE + WEAPINFO_OFFSET_X )

#undef INV_SLOT_R1_IS_VISIBLE
#define INV_SLOT_R1_IS_VISIBLE   ( WEAPINFO_ITIMS_VISIBLE && dvarint( ui_hud_has_frags ) > 0 )

#undef INV_SLOT_R2_IS_VISIBLE
#define INV_SLOT_R2_IS_VISIBLE   ( WEAPINFO_ITIMS_VISIBLE && dvarint( ui_hud_has_spec_gren ) > 0 )

#undef INV_SLOT_R3_IS_VISIBLE
#define INV_SLOT_R3_IS_VISIBLE   ( WEAPINFO_ITIMS_VISIBLE && dvarint( ui_bandages ) == 1 )


menuDef
{
    name			"weaponinfo"
	rect			0 0 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM
	exp				rect Y( 0 - ONLINEGAME_OFFSET_EXP )
	exp				rect X( 0 - ONLINEGAME_OFFSET_EXP )
    fullScreen		1
    visible			when( !isIntermission() && !inkillcam() && dvarBool( ammoCounterHide ) == 0 && !flashbanged() && !ui_active() && team( name ) != "TEAM_SPECTATOR" && dvarInt( ui_hud_show_weapon ) == 1 && dvarInt( ui_hud_show_weaponinfo ) == 1 && dvarInt( ui_show_timeout ) == 0 )

    // WEAPON
    itemDef
    {
        rect			( INV_BACK_SIZE_QUAD * HUD_MINUS_ONE ) 0 INV_BACK_SIZE_QUAD INV_BACK_SIZE
        exp             rect Y( WEAPINFO_AMMOS_POS_Y )
        forecolor		1 1 1 HUD_BACK_ALPHA
        style			WINDOW_STYLE_SHADER
        background		"hud_background_line"
        visible			when ( WEAPINFO_AMMOS_VISIBLE )
        decoration
    }

    itemDef
    {
        name			"ammoStock"
        rect			0 0 1 1
        //exp             rect Y( WEAPINFO_AMMOS_POS_Y - INV_BACK_SIZE_HALF )
        textscale		( TEXTSIZE_SMALL * 1.2 )
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textfont		UI_FONT_OBJECTIVE
        textalign	    ITEM_ALIGN_RIGHT
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_PLAYER_WEAPON_AMMO_STOCK
        visible			when ( WEAPINFO_AMMOS_VISIBLE )
        decoration
    }

    
    /*




    itemDef
    {
        name			"clipGraphic"
        rect			(0 -35) (0 -12) 1 1
        exp             rect Y( WEAPINFO_AMMOS_POS_Y - 12 )
        forecolor		1 1 1 HUD_ALPHA
        ownerdraw		CG_PLAYER_WEAPON_AMMO_CLIP_GRAPHIC
        visible			when ( WEAPINFO_AMMOS_VISIBLE )
        decoration
    }



    itemDef
    {
        name			"weapname"
        rect			(0 -8) (0 -15) 1 1
        exp             rect Y( WEAPINFO_AMMOS_POS_Y - 15 )
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textscale		(TEXTSIZE_SMALL * 0.4)
        textfont		UI_FONT_OBJECTIVE
        textalign	    ITEM_ALIGN_RIGHT
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_PLAYER_WEAPON_NAME
        visible         when ( WEAPINFO_AMMOS_VISIBLE )
        decoration
    }

    */

    //FRAG
	INV_SLOT_ICON_R1 ( ownerdraw CG_OFFHAND_WEAPON_ICON_FRAG, "hud_us_grenade", "+frag", 1 )
	INV_SLOT_AMMO_R1 ( ownerdraw CG_OFFHAND_WEAPON_AMMO_FRAG, INV_CLR_WHITE, HUD_FOREGROUND_ALPHA, 0, 0 )

    //SPECIAL
	INV_SLOT_ICON_R2 ( ownerdraw CG_OFFHAND_WEAPON_ICON_SMOKEFLASH, "hud_us_smokegrenade", "+smoke", 1 )
	INV_SLOT_AMMO_R2 ( ownerdraw CG_OFFHAND_WEAPON_AMMO_SMOKEFLASH, INV_CLR_WHITE, HUD_FOREGROUND_ALPHA, 0, 0 )	

    //BANDAGES
	INV_SLOT_ICON_R3 ( style WINDOW_STYLE_SHADER, "hud_us_bandages", "openScriptMenu modkeybind bandage", 1 )
	INV_SLOT_AMMO_RIGHT ( INV_SLOT_R3_POS_X, INV_SLOT_R3_IS_VISIBLE && dvarint( ui_bandages_qty ) > 0, exp text( dvarint( ui_bandages_qty ) ), INV_CLR_WHITE, HUD_FOREGROUND_ALPHA, 0, 0 )	
	INV_SLOT_AMMO_RIGHT ( INV_SLOT_R3_POS_X, INV_SLOT_R3_IS_VISIBLE && dvarint( ui_bandages_qty ) < 1, exp text( dvarint( ui_bandages_qty ) ), INV_CLR_RED,   HUD_FOREGROUND_ALPHA, 0, 0 )	
}