#define	DPAD_BASE_SIZE			36
#define	DPAD_BASE_SIZE_HALF		18
#define DPAD_ICON_Y				-10//3
#define DPAD_LABEL_Y			36//44
#define DPAD_ICON_SPACING		40
#define DPAD_ICON_SPACING_HALF	20

#define DPAD_SLOT_A_USABLE		ActionSlotUsable( 1 )
#define DPAD_SLOT_B_USABLE		ActionSlotUsable( 3 )
#define DPAD_SLOT_C_USABLE		ActionSlotUsable( 4 )

#define DPAD_WIDTH				( ( DPAD_SLOT_A_USABLE + DPAD_SLOT_B_USABLE + DPAD_SLOT_C_USABLE ) * DPAD_ICON_SPACING - DPAD_ICON_SPACING )
#define DPAD_WIDTH_HALF			( DPAD_WIDTH / 2 )	

#define DPAD_SLOT_A_POS_X		( 0 - DPAD_WIDTH_HALF - DPAD_BASE_SIZE_HALF )
#define DPAD_SLOT_B_POS_X		( DPAD_SLOT_A_POS_X + DPAD_ICON_SPACING * DPAD_SLOT_A_USABLE )
#define DPAD_SLOT_C_POS_X		( DPAD_SLOT_B_POS_X + DPAD_ICON_SPACING * DPAD_SLOT_B_USABLE )


menuDef
	{
		name			"DPad"
 	   	rect			0 -42 25 25 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
		exp				rect Y( -42 - (ONLINEGAME * ONLINEGAME_OFFSET) );
 	   	fullScreen		0
		visible			when( !inkillcam() && !flashbanged() && !ui_active() && !scoped() && (dvarString( createfx ) != "on") && ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 ) );

		itemDef // Up
        {
			name			"slot1"
			rect			0 DPAD_ICON_Y DPAD_BASE_SIZE DPAD_BASE_SIZE
			exp				rect X( DPAD_SLOT_A_POS_X )
			ownerdraw		CG_PLAYER_ACTIONSLOT_1
			forecolor		1 1 1 HUD_ALPHA
			visible			1
			decoration
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			textalign		ITEM_ALIGN_LEFT
            textalignx      40
			textscale		(TEXTSIZE_SMALL * 0.6)
			textfont		UI_FONT_OBJECTIVE
        }

		itemDef 
		{
			rect		0 DPAD_LABEL_Y 1 1
			exp			rect X( DPAD_SLOT_A_POS_X + DPAD_BASE_SIZE_HALF )
			exp text	( KeyBinding( "+actionslot 1" ) );
			forecolor	1 1 0 0
			exp forecolor A	( HUD_ALPHA * HudFade( "dpad" ) )
			textfont	UI_FONT_OBJECTIVE
			textscale	0.18
			textalign	ITEM_ALIGN_CENTER
			textstyle	ITEM_TEXTSTYLE_SHADOWED
			visible 	when( ActionSlotUsable( 1 ) )
			decoration 
		}

		itemDef // Left
        {
            name			"slot3"
            rect			0 DPAD_ICON_Y DPAD_BASE_SIZE DPAD_BASE_SIZE
			exp				rect X( DPAD_SLOT_B_POS_X )
			ownerdraw		CG_PLAYER_ACTIONSLOT_3
			forecolor		1 1 1 HUD_ALPHA
			visible			1 
			decoration
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			textalign		ITEM_ALIGN_LEFT
            textalignx      40
			textscale		(TEXTSIZE_SMALL * 0.6)
			textfont		UI_FONT_DEFAULT
        }
		itemDef 
		{
			rect		0 DPAD_LABEL_Y 1 1
			exp			rect X( DPAD_SLOT_B_POS_X + DPAD_BASE_SIZE_HALF )
			exp text	( KeyBinding( "+actionslot 3" ) );
			forecolor	1 1 0 0
			exp forecolor A	( HUD_ALPHA * HudFade( "dpad" ) )
			textfont	UI_FONT_OBJECTIVE
			textscale	0.18
			textalign	ITEM_ALIGN_CENTER
			textstyle	ITEM_TEXTSTYLE_SHADOWED
			visible 	when( ActionSlotUsable( 3 ) )
			decoration 
		}

		itemDef // Right
        {
            name			"slot4"
            rect			0 DPAD_ICON_Y DPAD_BASE_SIZE DPAD_BASE_SIZE
			exp				rect X( DPAD_SLOT_C_POS_X )
			ownerdraw		CG_PLAYER_ACTIONSLOT_4
			forecolor		1 1 1 HUD_ALPHA
			visible			1
			decoration
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			textalign		ITEM_ALIGN_LEFT
            textalignx      40
			textscale		(TEXTSIZE_SMALL * 0.6)
			textfont		UI_FONT_DEFAULT
        }
		itemDef 
		{
			rect		0 DPAD_LABEL_Y 1 1
			exp			rect X( DPAD_SLOT_C_POS_X + DPAD_BASE_SIZE_HALF )
			exp text	( KeyBinding( "+actionslot 4" ) );
			forecolor	1 1 0 0
			exp forecolor A	( HUD_ALPHA * HudFade( "dpad" ) )
			textfont	UI_FONT_OBJECTIVE
			textscale	0.18
			textalign	ITEM_ALIGN_CENTER
			textstyle	ITEM_TEXTSTYLE_SHADOWED
			visible 	when( ActionSlotUsable( 4 ) )
			decoration 
		}
    }