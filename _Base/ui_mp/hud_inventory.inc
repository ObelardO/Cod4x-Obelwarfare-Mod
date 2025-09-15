#define	DPAD_BASE_SIZE		28
#define	DPAD_BASE_SIZE_HALF	14
#define DPAD_ICON_Y			-1//3
#define DPAD_LABEL_Y		40//44
#define DPAD_ICON_SPACING	60

menuDef
{
    name			"DPad"
// 	   	rect			BOTTOM_RECT_X (BOTTOM_RECT_Y-42) 25 25 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
//		exp				rect Y( (BOTTOM_RECT_Y-42) - (ONLINEGAME * ONLINEGAME_OFFSET) );
    rect			BOTTOM_RECT_X BOTTOM_RECT_Y 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM
    exp				rect Y( BOTTOM_RECT_Y - (ONLINEGAME * ONLINEGAME_OFFSET) );
    fullScreen		0
    visible			when( !inkillcam() && !flashbanged() && !ui_active() && !scoped() && (dvarString( createfx ) != "on") );

//		itemDef // Up
//        {
//			name			"slot1"
//			rect			-DPAD_BASE_SIZE_HALF DPAD_ICON_Y DPAD_BASE_SIZE DPAD_BASE_SIZE
//			ownerdraw		CG_PLAYER_ACTIONSLOT_1
//			forecolor		1 1 1 HUD_ALPHA
//			visible			when ( dvarint( ui_hud_hardcore ) == 0 );
//			decoration
//			textstyle		ITEM_TEXTSTYLE_SHADOWED
//			textalign		ITEM_ALIGN_LEFT
//			textscale		TEXTSIZE_SMALL
//			textfont		UI_FONT_OBJECTIVE
//      }

//		itemDef
//		{
//			rect		0 DPAD_LABEL_Y 1 1
//			exp text	( "[" + KeyBinding( "+actionslot 1" ) + "]" );
//			forecolor	1 1 1 0
//			exp forecolor A	( HUD_ALPHA * HudFade( "dpad" ) )
//			textfont	UI_FONT_OBJECTIVE
//			textscale	0.25
//			textalign	ITEM_ALIGN_CENTER
//			textstyle	ITEM_TEXTSTYLE_SHADOWED
//			visible 	when( ActionSlotUsable( 1 ) && dvarint( ui_hud_hardcore ) == 0 )
//			decoration
//		}

    itemDef
    {
        name			"slot3"
        rect			(WEAPINFO_X -128) (WEAPINFO_Y -7) DPAD_BASE_SIZE DPAD_BASE_SIZE
        textscale		TEXTSIZE_SMALL
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textalign		ITEM_ALIGN_LEFT
        textfont		UI_FONT_DEFAULT
        forecolor		1 1 1 HUD_ALPHA
        ownerdraw		CG_PLAYER_ACTIONSLOT_3
        visible			when ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 );
        decoration
    }
    
//		itemDef // Left
//        {
//            name			"slot3"
//            rect			(-DPAD_ICON_SPACING - DPAD_BASE_SIZE) DPAD_ICON_Y DPAD_BASE_SIZE DPAD_BASE_SIZE
//			ownerdraw		CG_PLAYER_ACTIONSLOT_3
//			forecolor		1 1 1 HUD_ALPHA
//			visible			when ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 );
//			decoration
//			textstyle		ITEM_TEXTSTYLE_SHADOWED
//			textalign		ITEM_ALIGN_LEFT
//			textscale		TEXTSIZE_SMALL
//			textfont		UI_FONT_DEFAULT
//       }
//		itemDef
//		{
//			rect		(-DPAD_ICON_SPACING - DPAD_BASE_SIZE_HALF) DPAD_LABEL_Y 1 1
//			exp text	( "[" + KeyBinding( "+actionslot 3" ) + "]" );
//			forecolor	1 1 1 0
//			exp forecolor A	( HUD_ALPHA * HudFade( "dpad" ) )
//			textfont	UI_FONT_OBJECTIVE
//			textscale	0.25
//			textalign	ITEM_ALIGN_CENTER
//			textstyle	ITEM_TEXTSTYLE_SHADOWED
//			visible 	when( ActionSlotUsable( 3 ) && ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 ) )
//			decoration
//		}

    itemDef
    {
        name			"slot4"
        rect			(WEAPINFO_X -156) (WEAPINFO_Y -7) DPAD_BASE_SIZE DPAD_BASE_SIZE
        textscale		TEXTSIZE_SMALL
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        textalign		ITEM_ALIGN_LEFT
        textfont		UI_FONT_DEFAULT
        forecolor		1 1 1 HUD_ALPHA
        ownerdraw		CG_PLAYER_ACTIONSLOT_4
        visible			when ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 );
        decoration
    }

//		itemDef // Right
//        {
//            name			"slot4"
//            rect			DPAD_ICON_SPACING DPAD_ICON_Y DPAD_BASE_SIZE DPAD_BASE_SIZE
//			ownerdraw		CG_PLAYER_ACTIONSLOT_4
//			forecolor		1 1 1 HUD_ALPHA
//			visible			when ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 );
//			decoration
//			textstyle		ITEM_TEXTSTYLE_SHADOWED
//			textalign		ITEM_ALIGN_LEFT
//			textscale		TEXTSIZE_SMALL
//			textfont		UI_FONT_DEFAULT
//        }

//		itemDef
//		{
//			rect		(DPAD_ICON_SPACING + DPAD_BASE_SIZE_HALF) DPAD_LABEL_Y 1 1
//			exp text	( "[" + KeyBinding( "+actionslot 4" ) + "]" );
//			forecolor	1 1 1 0
//			exp forecolor A	( HUD_ALPHA * HudFade( "dpad" ) )
//			textfont	UI_FONT_OBJECTIVE
//			textscale	0.25
//			textalign	ITEM_ALIGN_CENTER
//			textstyle	ITEM_TEXTSTYLE_SHADOWED
//			visible 	when( ActionSlotUsable( 4 ) && ( dvarint( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0 ) )
//			decoration
//		}
}