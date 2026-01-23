#define DPAD_VISIBLE			( dvarint( ui_hud_show_inventory ) >= dvarint( ui_hud_hardcore ) + 1 )
#define DPAD_ALPHA     			( HUD_FOREGROUND_ALPHA * HudFade( "dpad" ) )   
#define DPAD_AMMO_OFFSET_X		( 7 )
#define DPAD_AMMO_OFFSET_Y		( 3 )

//#undef INV_SLOT_L1_IS_VISIBLE
//#define INV_SLOT_L1_IS_VISIBLE  ( DPAD_VISIBLE && ActionSlotUsable( 1 ) )

//#undef INV_SLOT_L2_IS_VISIBLE
//#define INV_SLOT_L2_IS_VISIBLE  ( DPAD_VISIBLE && ActionSlotUsable( 3 ) )

//#undef INV_SLOT_L3_IS_VISIBLE
//#define INV_SLOT_L3_IS_VISIBLE  ( DPAD_VISIBLE && ActionSlotUsable( 4 ) )

menuDef
{
	name			"DPad"
	rect			0 0 0 0 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
	exp				rect Y( 0 - ONLINEGAME_OFFSET_EXP )
	exp				rect X( ONLINEGAME_OFFSET_EXP )
	fullScreen		1
	visible			when( team( name ) != "TEAM_SPECTATOR" && !inkillcam() && !flashbanged() && !ui_active() && !scoped() && (dvarString( createfx ) != "on") && DPAD_VISIBLE );

	//INV_SLOT_ICON_LEFT ( INV_SLOT_L1_POS_X, INV_SLOT_L1_IS_VISIBLE, ownerdraw CG_PLAYER_ACTIONSLOT_1, INV_ICON_NONE, "+actionslot 1", DPAD_ALPHA )
	//INV_SLOT_AMMO_LEFT ( INV_SLOT_L1_POS_X, INV_SLOT_L1_IS_VISIBLE, ownerdraw CG_PLAYER_ACTIONSLOT_1, INV_CLR_WHITE, DPAD_AMMO_OFFSET_X )

	INV_SLOT_ICON_LEFT ( INV_SLOT_L2_POS_X, INV_SLOT_L2_IS_VISIBLE, ownerdraw CG_PLAYER_ACTIONSLOT_3, INV_ICON_NONE, "+actionslot 3", DPAD_ALPHA )
	INV_SLOT_AMMO_LEFT ( INV_SLOT_L2_POS_X, INV_SLOT_L2_IS_VISIBLE, ownerdraw CG_PLAYER_ACTIONSLOT_3, INV_CLR_WHITE, DPAD_ALPHA, DPAD_AMMO_OFFSET_X, DPAD_AMMO_OFFSET_Y )	

	//INV_SLOT_ICON_LEFT ( INV_SLOT_L3_POS_X, INV_SLOT_L3_IS_VISIBLE, ownerdraw CG_PLAYER_ACTIONSLOT_4, INV_ICON_NONE, "+actionslot 4", INV_BACK_ALPHA_DPAD )
	//INV_SLOT_AMMO_LEFT ( INV_SLOT_L3_POS_X, INV_SLOT_L3_IS_VISIBLE, ownerdraw CG_PLAYER_ACTIONSLOT_4, INV_CLR_WHITE, DPAD_ALPHA, DPAD_AMMO_OFFSET_X )	
}