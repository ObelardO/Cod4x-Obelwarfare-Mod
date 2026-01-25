#define INV_ALIGN_L             HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
#define INV_ALIGN_R             HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM
                                
#define INV_ICON_SIZE           20
#define INV_ICON_NONE           "white"

#define INV_SPACING             ( 8 + INV_BACK_PAD * 2 )
#define INV_BINDKEY_SIZE        8 
#define INV_OFFSET_X            ( INV_BACK_PAD )
#define INV_OFFSET_Y            ( 0 - INV_ICON_SIZE - INV_BACK_PAD - INV_BINDKEY_SIZE )


#define INV_SLOT_L1_IS_VISIBLE  1
#define INV_SLOT_L2_IS_VISIBLE  1
#define INV_SLOT_L3_IS_VISIBLE  1

#define INV_SLOT_ANY_VISIABLE_LEFT  ( INV_SLOT_L1_IS_VISIBLE || INV_SLOT_L2_IS_VISIBLE || INV_SLOT_L3_IS_VISIBLE )

#define INV_SLOT_L1_POS_X       ( INV_OFFSET_X )
#define INV_SLOT_L2_POS_X       ( INV_SLOT_L1_POS_X + ( INV_ICON_SIZE + INV_SPACING ) * INV_SLOT_L1_IS_VISIBLE )
#define INV_SLOT_L3_POS_X       ( INV_SLOT_L2_POS_X + ( INV_ICON_SIZE + INV_SPACING ) * INV_SLOT_L2_IS_VISIBLE )


#define INV_SLOT_R1_IS_VISIBLE  1
#define INV_SLOT_R2_IS_VISIBLE  1
#define INV_SLOT_R3_IS_VISIBLE  1

#define INV_SLOT_ANY_VISIABLE_RIGHT ( INV_SLOT_R1_IS_VISIBLE || INV_SLOT_R2_IS_VISIBLE || INV_SLOT_R3_IS_VISIBLE )

#define INV_SLOT_R1_POS_X       ( INV_OFFSET_X )
#define INV_SLOT_R2_POS_X       ( INV_SLOT_R1_POS_X + ( INV_ICON_SIZE + INV_SPACING ) * INV_SLOT_R1_IS_VISIBLE )
#define INV_SLOT_R3_POS_X       ( INV_SLOT_R2_POS_X + ( INV_ICON_SIZE + INV_SPACING ) * INV_SLOT_R2_IS_VISIBLE )


#define INV_BACK_PAD            ( 1 )  
#define INV_BACK_ALPHA          ( HUD_BACK_ALPHA * 0.8 )      
#define INV_BACK_HEIGHT         ( INV_ICON_SIZE + INV_BACK_PAD * 2 )
#define INV_BACK_HEIGHT_HALF    ( INV_BACK_HEIGHT * 0.5 )
#define INV_BACK_SIZE           ( INV_BACK_HEIGHT * 1.25 )
#define INV_BACK_SIZE_HALF      ( INV_BACK_SIZE * 0.5 )
#define INV_BACK_SIZE_QUAD      ( INV_BACK_SIZE * 4.0 )


#define INV_CLR_WHITE           1 1 1
#define INV_CLR_RED             0.9 0 0

#define INV_ALIGN_X_OP_LEFT       ( 0 + 1 )
#define INV_ALIGN_X_OP_RIGHT      ( 0 - 1 )
#define INV_ALIGN_W_MOD_LEFT      0
#define INV_ALIGN_W_MOD_RIGHT     1


#define INV_DPAD_AMMO_OFFSET_X_L ( 7.5 )
#define INV_DPAD_AMMO_OFFSET_Y_L ( 3 )

#define INV_DPAD_AMMO_OFFSET_X_R ( 7.5 * HUD_MINUS_ONE )
#define INV_DPAD_AMMO_OFFSET_Y_R ( 3 )

#define INV_DPAD_ALPHA     	     ( HudFade( "dpad" ) * HUD_FOREGROUND_ALPHA )   


#define INV_SLOT_ICON_L1( iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    INV_SLOT_ICON_LEFT( INV_SLOT_L1_POS_X, INV_SLOT_L1_IS_VISIBLE, iconDrawerDef, iconMaterial, keyBinding, alphaExp )

#define INV_SLOT_ICON_L2( iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    INV_SLOT_ICON_LEFT( INV_SLOT_L2_POS_X, INV_SLOT_L2_IS_VISIBLE, iconDrawerDef, iconMaterial, keyBinding, alphaExp )

#define INV_SLOT_ICON_L3( iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    INV_SLOT_ICON_LEFT( INV_SLOT_L3_POS_X, INV_SLOT_L3_IS_VISIBLE, iconDrawerDef, iconMaterial, keyBinding, alphaExp )

#define INV_SLOT_ICON_LEFT( xPos, isVisibleExp, iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
	INV_SLOT_ICON( INV_ALIGN_L, INV_ALIGN_X_OP_LEFT, INV_ALIGN_W_MOD_LEFT, xPos, isVisibleExp, iconDrawerDef, iconMaterial, keyBinding, alphaExp )


#define INV_SLOT_ICON_R1( iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    INV_SLOT_ICON_RIGHT( INV_SLOT_R1_POS_X, INV_SLOT_R1_IS_VISIBLE, iconDrawerDef, iconMaterial, keyBinding, alphaExp )

#define INV_SLOT_ICON_R2( iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    INV_SLOT_ICON_RIGHT( INV_SLOT_R2_POS_X, INV_SLOT_R2_IS_VISIBLE, iconDrawerDef, iconMaterial, keyBinding, alphaExp )

#define INV_SLOT_ICON_R3( iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    INV_SLOT_ICON_RIGHT( INV_SLOT_R3_POS_X, INV_SLOT_R3_IS_VISIBLE, iconDrawerDef, iconMaterial, keyBinding, alphaExp )

#define INV_SLOT_ICON_RIGHT( xPos, isVisibleExp, iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
	INV_SLOT_ICON( INV_ALIGN_R, INV_ALIGN_X_OP_RIGHT, INV_ALIGN_W_MOD_RIGHT, xPos, isVisibleExp, iconDrawerDef, iconMaterial, keyBinding, alphaExp )


#define INV_SLOT_ICON( align, xOffsetOp, widthMod, xPos, isVisibleExp, iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    itemDef \
	{ \
        rect			0 ( INV_OFFSET_Y - INV_BACK_PAD ) ( INV_BACK_SIZE * xOffsetOp ) INV_BACK_SIZE align \
        exp				rect X( xOffsetOp * ( xPos - INV_BACK_PAD ) - widthMod * INV_BACK_SIZE ) \
        forecolor		1 1 1 HUD_BACK_ALPHA \
		exp             forecolor A( alphaExp * INV_BACK_ALPHA ) \
        style			WINDOW_STYLE_SHADER \
        background		"hud_background_quad" \
        visible			when ( isVisibleExp ) \
        decoration \
	} \
	itemDef \
	{ \
        rect			0 INV_OFFSET_Y INV_ICON_SIZE INV_ICON_SIZE align \
        exp				rect X( xOffsetOp * xPos - widthMod * INV_ICON_SIZE ) \
        forecolor		0 1 0 0 \
        style			WINDOW_STYLE_SHADER \
        background		INV_ICON_NONE \
        visible			when ( isVisibleExp ) \
		decoration \
    } \
    itemDef \
    { \
        rect			0 INV_OFFSET_Y INV_ICON_SIZE INV_ICON_SIZE align \
        exp				rect X( xOffsetOp * xPos - widthMod * INV_ICON_SIZE ) \
        forecolor		1 1 1 HUD_ALPHA \
        exp             forecolor A( alphaExp * HUD_FOREGROUND_ALPHA ) \
        iconDrawerDef \
        background		iconMaterial \
        visible			when ( isVisibleExp ) \
        textscale       0 \
        decoration \
    } \
    itemDef \ 
    { \
        rect		0 ( INV_OFFSET_Y + INV_ICON_SIZE + INV_BACK_PAD + 5 ) 0 0 align \
        exp         rect X( xOffsetOp * ( xPos + INV_BACK_SIZE_HALF - 2 ) ) \
        exp         text( KeyBinding( keyBinding ) ) \
        exp         forecolor A( alphaExp * HUD_FOREGROUND_ALPHA ) \
        forecolor	1 1 0 0 \
        textfont	UI_FONT_OBJECTIVE \
        textscale	0.18 \
        textalign	ITEM_ALIGN_MIDDLE_CENTER \
        textstyle	ITEM_TEXTSTYLE_SHADOWED \
        visible 	when ( isVisibleExp && keyBinding != "" ) \
        decoration \
    } \
    HUD_DEBUG_DOT( xOffsetOp * xPos, INV_OFFSET_Y, align ) \


#define INV_SLOT_AMMO_L1( ammoDrawerDef, color, alphaExp, xOffset, yOffset ) \
    INV_SLOT_AMMO_LEFT( INV_SLOT_R1_POS_X, INV_SLOT_R1_IS_VISIBLE, ammoDrawerDef, color, alphaExp, xOffset, yOffset )

#define INV_SLOT_AMMO_L2( ammoDrawerDef, color, alphaExp, xOffset, yOffset ) \
    INV_SLOT_AMMO_LEFT( INV_SLOT_R2_POS_X, INV_SLOT_R2_IS_VISIBLE, ammoDrawerDef, color, alphaExp, xOffset, yOffset )

#define INV_SLOT_AMMO_L3( ammoDrawerDef, color, alphaExp, xOffset, yOffset ) \
    INV_SLOT_AMMO_LEFT( INV_SLOT_R3_POS_X, INV_SLOT_R3_IS_VISIBLE, ammoDrawerDef, color, alphaExp, xOffset, yOffset )

#define INV_SLOT_AMMO_LEFT( xPos, isVisibleExp, ammoDrawerDef, color, alphaExp, xOffset, yOffset ) \
    INV_SLOT_AMMO( INV_ALIGN_L, INV_ALIGN_X_OP_LEFT, INV_ALIGN_W_MOD_LEFT, xPos, isVisibleExp, ammoDrawerDef, color, alphaExp, xOffset, yOffset ) 


#define INV_SLOT_AMMO_R1( ammoDrawerDef, color, alphaExp, xOffset, yOffset ) \
    INV_SLOT_AMMO_RIGHT( INV_SLOT_R1_POS_X, INV_SLOT_R1_IS_VISIBLE, ammoDrawerDef, color, alphaExp, xOffset, yOffset )

#define INV_SLOT_AMMO_R2( ammoDrawerDef, color, alphaExp, xOffset, yOffset ) \
    INV_SLOT_AMMO_RIGHT( INV_SLOT_R2_POS_X, INV_SLOT_R2_IS_VISIBLE, ammoDrawerDef, color, alphaExp, xOffset, yOffset )

#define INV_SLOT_AMMO_R3( ammoDrawerDef, color, alphaExp, xOffset, yOffset ) \
    INV_SLOT_AMMO_RIGHT( INV_SLOT_R3_POS_X, INV_SLOT_R3_IS_VISIBLE, ammoDrawerDef, color, alphaExp, xOffset, yOffset )

#define INV_SLOT_AMMO_RIGHT( xPos, isVisibleExp, ammoDrawerDef, color, alphaExp, xOffset, yOffset ) \
    INV_SLOT_AMMO( INV_ALIGN_R, INV_ALIGN_X_OP_RIGHT, INV_ALIGN_W_MOD_RIGHT, xPos, isVisibleExp, ammoDrawerDef, color, alphaExp, xOffset, yOffset ) 


#define INV_SLOT_AMMO( align, xOffsetOp, widthMod, xPos, isVisibleExp, ammoDrawerDef, color, alphaExp, xOffset, yOffset ) \
    itemDef \
    { \
        rect			0 ( INV_OFFSET_Y + INV_ICON_SIZE - yOffset + 1.5 ) 0 0 align \
        exp             rect X( xOffsetOp * ( xPos + xOffset + INV_ICON_SIZE - 0.5 ) - widthMod * 5 ) \
        textscale		( TEXTSIZE_SMALL * 0.6 ) \
        textstyle		ITEM_TEXTSTYLE_SHADOWED \
        textfont		UI_FONT_OBJECTIVE \
        forecolor		color HUD_FOREGROUND_ALPHA \
        textalign       ITEM_ALIGN_BOTTOM_LEFT \
        exp             forecolor A ( alphaExp * HUD_FOREGROUND_ALPHA ) \
        background      INV_ICON_NONE \
        ammoDrawerDef \
        visible			when ( isVisibleExp ) \
        decoration \
    } \
    HUD_DEBUG_DOT( xOffsetOp * ( xPos + xOffset + INV_ICON_SIZE ) - widthMod * 5, INV_OFFSET_Y + INV_ICON_SIZE - 1 , align )


