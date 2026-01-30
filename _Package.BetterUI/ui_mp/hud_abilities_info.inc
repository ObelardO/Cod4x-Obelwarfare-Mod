#define DPAD_IS_VISIBLE			 ( dvarint( "ui_hud_show_abilities_info" ) >= dvarint( "ui_hud_hardcore" ) + 1 )

#undef INV_SLOT_L1_IS_VISIBLE
#define INV_SLOT_L1_IS_VISIBLE   ( DPAD_IS_VISIBLE && ActionSlotUsable( 1 ) )

#undef INV_SLOT_L2_IS_VISIBLE
#define INV_SLOT_L2_IS_VISIBLE   ( DPAD_IS_VISIBLE && dvarint( "ui_bandages" ) == 1 )

#undef INV_SLOT_L3_IS_VISIBLE
#define INV_SLOT_L3_IS_VISIBLE   ( DPAD_IS_VISIBLE && ActionSlotUsable( 4 ) )

menuDef
{
	name			"DPad"
	rect			0 0 0 0 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
	exp				rect Y( 0 - ONLINEGAME_OFFSET_EXP )
	exp				rect X( ONLINEGAME_OFFSET_EXP )
	fullScreen		1
	visible			when( HUD_IS_VISIBLE && CLIENT_NOT_DEAD && CLIENT_NOT_FREE_SPECTATING && INV_IS_VISIBLE && dvarInt( "ui_hud_has_weapon" ) == 1 );

	//NIGHT VISION
	INV_SLOT_ICON_L1 ( ownerdraw CG_PLAYER_ACTIONSLOT_1, INV_ICON_NONE, "+actionslot 1", INV_DPAD_ALPHA )
	INV_SLOT_AMMO_L1 ( ownerdraw CG_PLAYER_ACTIONSLOT_1, INV_CLR_WHITE, INV_DPAD_ALPHA, INV_AMMO_POS_FIX_DPAD )

	//BANDAGES (MOVED FROM WEAPONINFO)
	INV_SLOT_ICON_L2 ( style WINDOW_STYLE_SHADER, "hud_us_bandages", "openScriptMenu modkeybind bandage", INV_DPAD_ALPHA )
	INV_SLOT_AMMO_LEFT ( INV_ALIGN_L, INV_SLOT_L2_POS_X, INV_SLOT_L2_IS_VISIBLE && dvarint( "ui_bandages_qty" ) > 0, exp text( dvarint( "ui_bandages_qty" ) ), INV_CLR_WHITE, INV_DPAD_ALPHA, INV_AMMO_POS_FIX_NONE )	
	INV_SLOT_AMMO_LEFT ( INV_ALIGN_L, INV_SLOT_L2_POS_X, INV_SLOT_L2_IS_VISIBLE && dvarint( "ui_bandages_qty" ) < 1, exp text( dvarint( "ui_bandages_qty" ) ), INV_CLR_RED,   INV_DPAD_ALPHA, INV_AMMO_POS_FIX_NONE )	
	
	//KILL STREAK
	INV_SLOT_ICON_L3 ( ownerdraw CG_PLAYER_ACTIONSLOT_4, INV_ICON_NONE, "+actionslot 4", INV_DPAD_ALPHA )
	INV_SLOT_AMMO_L3 ( ownerdraw CG_PLAYER_ACTIONSLOT_4, INV_CLR_WHITE, INV_DPAD_ALPHA, INV_AMMO_POS_FIX_DPAD )	
}