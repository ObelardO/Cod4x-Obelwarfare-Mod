#define DPAD_IS_VISIBLE			 ( dvarint( "ui_hud_show_abilities_info" ) >= dvarint( "ui_hud_hardcore" ) + 1 )

#undef INV_SLOT_L1_IS_VISIBLE
#define INV_SLOT_L1_IS_VISIBLE   ( DPAD_IS_VISIBLE && ActionSlotUsable( 1 ) )

#undef INV_SLOT_L2_IS_VISIBLE
#define INV_SLOT_L2_IS_VISIBLE   ( DPAD_IS_VISIBLE && dvarint( "ui_bandages" ) == 1 )

#undef INV_SLOT_L3_IS_VISIBLE
#define INV_SLOT_L3_IS_VISIBLE        ( DPAD_IS_VISIBLE && ActionSlotUsable( 4 ) )
#define INV_SLOT_L3_LOCKED            ( INV_SLOT_L3_IS_VISIBLE && dvarint( "ui_hud_hp_lock_time" ) != 0 )
#define INV_SLOT_L3_ALPHA             ( INV_DPAD_ALPHA * ( 1 - ( dvarint( "ui_hud_hp_lock_time" ) != 0 ) * 0.5 ) )
#define INV_SLOT_L3_BIND_IS_VISIBLE   ( INV_SLOT_L3_IS_VISIBLE && CLIENT_NOT_SPECTATING && dvarint( "ui_hud_hp_lock_time" ) == 0 )
#define INV_SLOT_L3_TIMER_IS_VISIBLE  ( INV_SLOT_L3_IS_VISIBLE && dvarint( "ui_hud_hp_lock_time" ) > 0 )

#undef INV_SLOT_L3_AMMO_IS_VISIBLE
#define INV_SLOT_L3_AMMO_IS_VISIBLE   ( INV_SLOT_L3_IS_VISIBLE && dvarint( "ui_hud_hp_lock_time" ) == 0 )

#undef INV_SLOT_L4_IS_VISIBLE
#define INV_SLOT_L4_IS_VISIBLE   ( DPAD_IS_VISIBLE && dvarint( "ui_hud_hp_next" ) > 0 )

#define INV_HP_NEXT_BAR_X        ( INV_SLOT_L4_POS_X - INV_BACK_PAD )
#define INV_HP_NEXT_BAR_Y        ( INV_OFFSET_Y + INV_ICON_SIZE + INV_BACK_PAD + 5 - ( INV_HP_NEXT_BAR_H / 2 ) )
#define INV_HP_NEXT_BAR_W        INV_BACK_SIZE
#define INV_HP_NEXT_BAR_H        2

#define INV_HP_NEXT_BAR \
	itemDef \
	{ \
		rect			0 INV_HP_NEXT_BAR_Y INV_HP_NEXT_BAR_W INV_HP_NEXT_BAR_H INV_ALIGN_L \
		exp				rect X( INV_HP_NEXT_BAR_X ) \
		style			WINDOW_STYLE_SHADER \
		background		"white" \
		forecolor		0 0 0 1 \
		exp				forecolor A( INV_DPAD_ALPHA * INV_BACK_ALPHA ) \
		visible			when ( INV_SLOT_L4_IS_VISIBLE ) \
		decoration \
	} \
	itemDef \
	{ \
		rect			0 INV_HP_NEXT_BAR_Y 0 INV_HP_NEXT_BAR_H INV_ALIGN_L \
		exp				rect X( INV_HP_NEXT_BAR_X ) \
		exp				rect W( INV_HP_NEXT_BAR_W * dvarint( "ui_hud_hp_next_done" ) / dvarint( "ui_hud_hp_next_need" ) ) \
		style			WINDOW_STYLE_SHADER \
		background		"white" \
		forecolor		INV_CLR_WHITE 1 \
		exp				forecolor A( INV_DPAD_ALPHA * HUD_FOREGROUND_ALPHA ) \
		visible			when ( INV_SLOT_L4_IS_VISIBLE && dvarint( "ui_hud_hp_next_done" ) > 0 ) \
		decoration \
	}

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
	
	//HARDPOINT (OWNED)
	INV_SLOT_ICON_L3 ( ownerdraw CG_PLAYER_ACTIONSLOT_4, INV_ICON_NONE, "", INV_SLOT_L3_ALPHA )
	INV_SLOT_AMMO_L3 ( exp text( 1 ), INV_CLR_WHITE, INV_DPAD_ALPHA, INV_AMMO_POS_FIX_NONE )
	INV_SLOT_LOCK_LEFT ( INV_ALIGN_L, INV_SLOT_L3_POS_X, INV_SLOT_L3_LOCKED, INV_DPAD_ALPHA )
	INV_SLOT_HINT_LEFT ( INV_SLOT_L3_POS_X, INV_SLOT_L3_BIND_IS_VISIBLE, KeyBinding( "+actionslot 4" ), INV_CLR_YELLOW, INV_DPAD_ALPHA )
	INV_SLOT_HINT_LEFT ( INV_SLOT_L3_POS_X, INV_SLOT_L3_TIMER_IS_VISIBLE, dvarint( "ui_hud_hp_lock_time" ) + "s.", INV_CLR_WHITE, INV_DPAD_ALPHA )

	//HARDPOINT TRACKER (NEXT, DISABLED)
	INV_SLOT_ICON_L4 ( style WINDOW_STYLE_SHADER, dvarString( "ui_hud_hp_next_icon" ), "", INV_DPAD_ALPHA * 0.45 )
	INV_SLOT_AMMO_L4 ( exp text( dvarint( "ui_hud_hp_next_kills" ) ), INV_CLR_WHITE, INV_DPAD_ALPHA, INV_AMMO_POS_FIX_NONE )
	INV_HP_NEXT_BAR
}
