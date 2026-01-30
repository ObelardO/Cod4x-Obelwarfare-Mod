#define INV_ALIGN_L             HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
#define INV_ALIGN_R             HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM
                                
#define INV_ICON_SIZE           18
#define INV_ICON_NONE           "white"


#define INV_SPACING             4
#define INV_BINDKEY_SIZE        8 
#define INV_OFFSET_X            ( INV_BACK_PAD )
#define INV_OFFSET_Y            ( 0 - INV_ICON_SIZE - INV_BACK_PAD - INV_BINDKEY_SIZE )


#define INV_SLOT_L1_IS_VISIBLE  0
#define INV_SLOT_L2_IS_VISIBLE  0
#define INV_SLOT_L3_IS_VISIBLE  0

#define INV_SLOT_ANY_VISIABLE_L ( INV_SLOT_L1_IS_VISIBLE || INV_SLOT_L2_IS_VISIBLE || INV_SLOT_L3_IS_VISIBLE )

#define INV_SLOT_L1_POS_X       ( INV_OFFSET_X )
#define INV_SLOT_L2_POS_X       ( INV_SLOT_L1_POS_X + ( INV_BACK_SIZE + INV_SPACING ) * INV_SLOT_L1_IS_VISIBLE )
#define INV_SLOT_L3_POS_X       ( INV_SLOT_L2_POS_X + ( INV_BACK_SIZE + INV_SPACING ) * INV_SLOT_L2_IS_VISIBLE )


#define INV_SLOT_R1_IS_VISIBLE  0
#define INV_SLOT_R2_IS_VISIBLE  0
#define INV_SLOT_R3_IS_VISIBLE  0

#define INV_SLOT_ANY_VISIABLE_R ( INV_SLOT_R1_IS_VISIBLE || INV_SLOT_R2_IS_VISIBLE || INV_SLOT_R3_IS_VISIBLE )

#define INV_SLOT_R1_POS_X       ( INV_OFFSET_X )
#define INV_SLOT_R2_POS_X       ( INV_SLOT_R1_POS_X + ( INV_BACK_SIZE + INV_SPACING ) * INV_SLOT_R1_IS_VISIBLE )
#define INV_SLOT_R3_POS_X       ( INV_SLOT_R2_POS_X + ( INV_BACK_SIZE + INV_SPACING ) * INV_SLOT_R2_IS_VISIBLE )


#define INV_BACK_PAD            ( 2 )  
#define INV_BACK_ALPHA          ( HUD_ALPHA * 0.9 )      
#define INV_BACK_HEIGHT         ( INV_ICON_SIZE + INV_BACK_PAD * 2 )
#define INV_BACK_HEIGHT_HALF    ( INV_BACK_HEIGHT * 0.5 )
#define INV_BACK_SIZE           ( INV_BACK_HEIGHT * 1.25 )
#define INV_BACK_SIZE_HALF      ( INV_BACK_SIZE * 0.5 )
#define INV_BACK_SIZE_DOUBLE    ( INV_BACK_SIZE * 2.0 )
#define INV_BACK_SIZE_QUAD      ( INV_BACK_SIZE * 4.0 )

#define INV_BACK_MAT            "hud_background_quad"
#define INV_BACK_MAT_DOUBLE     "hud_background_line_half"


#define INV_CLR_WHITE           1 1 1
#define INV_CLR_RED             0.795 0.160 0.012
#define INV_CLR_YELLOW          1 1 0.5

#define INV_ALIGN_X_OP_LEFT     ( 0 + 1 )
#define INV_ALIGN_X_OP_RIGHT    ( 0 - 1 )
#define INV_ALIGN_W_MOD_LEFT    0
#define INV_ALIGN_W_MOD_RIGHT   1


#define INV_AMMO_POS_FIX_DPAD   1
#define INV_AMMO_POS_FIX_NONE   0

#define INV_AMMO_POS_FIX_DPAD_X ( 7.5 )
#define INV_AMMO_POS_FIX_DPAD_Y ( 3 )

#define INV_DPAD_ALPHA     	    ( HudFade( "dpad" ) )   


#define INV_SLOT_ICON_L1( iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    INV_SLOT_ICON_LEFT( INV_ALIGN_L, INV_SLOT_L1_POS_X, INV_SLOT_L1_IS_VISIBLE, INV_BACK_MAT, INV_BACK_SIZE, iconDrawerDef, iconMaterial, keyBinding, alphaExp )

#define INV_SLOT_ICON_L2( iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    INV_SLOT_ICON_LEFT( INV_ALIGN_L, INV_SLOT_L2_POS_X, INV_SLOT_L2_IS_VISIBLE, INV_BACK_MAT, INV_BACK_SIZE, iconDrawerDef, iconMaterial, keyBinding, alphaExp )

#define INV_SLOT_ICON_L3( iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    INV_SLOT_ICON_LEFT( INV_ALIGN_L, INV_SLOT_L3_POS_X, INV_SLOT_L3_IS_VISIBLE, INV_BACK_MAT, INV_BACK_SIZE, iconDrawerDef, iconMaterial, keyBinding, alphaExp )

#define INV_SLOT_ICON_LEFT( align, xPos, isVisibleExp, backMat, backWidth, iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
	INV_SLOT_ICON( INV_ALIGN_X_OP_LEFT, INV_ALIGN_W_MOD_LEFT, align, xPos, isVisibleExp, backMat, backWidth, iconDrawerDef, iconMaterial, keyBinding, alphaExp )


#define INV_SLOT_ICON_R1( iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    INV_SLOT_ICON_RIGHT( INV_ALIGN_R, INV_SLOT_R1_POS_X, INV_SLOT_R1_IS_VISIBLE, INV_BACK_MAT, INV_BACK_SIZE, iconDrawerDef, iconMaterial, keyBinding, alphaExp )

#define INV_SLOT_ICON_R2( iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    INV_SLOT_ICON_RIGHT( INV_ALIGN_R, INV_SLOT_R2_POS_X, INV_SLOT_R2_IS_VISIBLE, INV_BACK_MAT, INV_BACK_SIZE, iconDrawerDef, iconMaterial, keyBinding, alphaExp )

#define INV_SLOT_ICON_R3( iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    INV_SLOT_ICON_RIGHT( INV_ALIGN_R, INV_SLOT_R3_POS_X, INV_SLOT_R3_IS_VISIBLE, INV_BACK_MAT, INV_BACK_SIZE, iconDrawerDef, iconMaterial, keyBinding, alphaExp )

#define INV_SLOT_ICON_RIGHT( align, xPos, isVisibleExp, backMat, backWidth, iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
	INV_SLOT_ICON( INV_ALIGN_X_OP_RIGHT, INV_ALIGN_W_MOD_RIGHT, align, xPos, isVisibleExp, backMat, backWidth, iconDrawerDef, iconMaterial, keyBinding, alphaExp )


#define INV_SLOT_ICON( xOffsetOp, widthMod, align, xPos, isVisibleExp, backMat, backWidth, iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
    itemDef \
	{ \
        rect			0 ( INV_OFFSET_Y - INV_BACK_PAD ) ( backWidth * xOffsetOp ) INV_BACK_SIZE align \
        forecolor		INV_CLR_WHITE 1 \
        exp	            rect X( xOffsetOp * ( xPos - INV_BACK_PAD + backWidth - INV_BACK_SIZE ) - widthMod * backWidth ) \
		exp             forecolor A( alphaExp * INV_BACK_ALPHA ) \
        background      backMat \ 
        style			WINDOW_STYLE_SHADER \
        visible			when ( isVisibleExp ) \
        decoration \
	} \
    itemDef \
    { \
        rect			0 INV_OFFSET_Y INV_ICON_SIZE INV_ICON_SIZE align \
        exp				rect X( xOffsetOp * xPos - widthMod * INV_ICON_SIZE ) \
        forecolor		INV_CLR_WHITE 1 \
        exp             forecolor A( alphaExp * HUD_FOREGROUND_ALPHA ) \
        iconDrawerDef \
        exp				material( iconMaterial ); \
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
        forecolor	INV_CLR_YELLOW 1 \
        textfont	UI_FONT_OBJECTIVE \
        textscale	0.18 \
        textalign	ITEM_ALIGN_MIDDLE_CENTER \
        textstyle	ITEM_TEXTSTYLE_SHADOWED \
        visible 	when ( isVisibleExp && keyBinding != "" ) \
        decoration \
    }


#define INV_SLOT_AMMO_L1( ammoDrawerDef, color, alphaExp, posFixExp ) \
    INV_SLOT_AMMO_LEFT( INV_ALIGN_L, INV_SLOT_R1_POS_X, INV_SLOT_R1_IS_VISIBLE, ammoDrawerDef, color, alphaExp, posFixExp )

#define INV_SLOT_AMMO_L2( ammoDrawerDef, color, alphaExp, posFixExp ) \
    INV_SLOT_AMMO_LEFT( INV_ALIGN_L, INV_SLOT_R2_POS_X, INV_SLOT_R2_IS_VISIBLE, ammoDrawerDef, color, alphaExp, posFixExp )

#define INV_SLOT_AMMO_L3( ammoDrawerDef, color, alphaExp, posFixExp ) \
    INV_SLOT_AMMO_LEFT( INV_ALIGN_L, INV_SLOT_R3_POS_X, INV_SLOT_R3_IS_VISIBLE, ammoDrawerDef, color, alphaExp, posFixExp )

#define INV_SLOT_AMMO_LEFT( align, xPos, isVisibleExp, ammoDrawerDef, color, alphaExp, posFixExp ) \
    INV_SLOT_AMMO( align, INV_ALIGN_X_OP_LEFT, INV_ALIGN_W_MOD_LEFT, xPos, isVisibleExp, ammoDrawerDef, color, alphaExp, posFixExp ) 


#define INV_SLOT_AMMO_R1( ammoDrawerDef, color, alphaExp, posFixExp ) \
    INV_SLOT_AMMO_RIGHT( INV_ALIGN_R, INV_SLOT_R1_POS_X, INV_SLOT_R1_IS_VISIBLE, ammoDrawerDef, color, alphaExp, posFixExp )

#define INV_SLOT_AMMO_R2( ammoDrawerDef, color, alphaExp, posFixExp ) \
    INV_SLOT_AMMO_RIGHT( INV_ALIGN_R, INV_SLOT_R2_POS_X, INV_SLOT_R2_IS_VISIBLE, ammoDrawerDef, color, alphaExp, posFixExp )

#define INV_SLOT_AMMO_R3( ammoDrawerDef, color, alphaExp, posFixExp ) \
    INV_SLOT_AMMO_RIGHT( INV_ALIGN_R, INV_SLOT_R3_POS_X, INV_SLOT_R3_IS_VISIBLE, ammoDrawerDef, color, alphaExp, posFixExp )

#define INV_SLOT_AMMO_RIGHT( align, xPos, isVisibleExp, ammoDrawerDef, color, alphaExp, posFixExp ) \
    INV_SLOT_AMMO( align, INV_ALIGN_X_OP_RIGHT, INV_ALIGN_W_MOD_RIGHT, xPos, isVisibleExp, ammoDrawerDef, color, alphaExp, posFixExp ) 


#define INV_SLOT_AMMO( align, xOffsetOp, widthMod, xPos, isVisibleExp, ammoDrawerDef, color, alphaExp, posFixExp ) \
    itemDef \
    { \
        rect			0 ( INV_OFFSET_Y + INV_ICON_SIZE - ( posFixExp * INV_AMMO_POS_FIX_DPAD_Y ) + 1.5 ) 0 0 align \
        exp             rect X( xOffsetOp * ( xPos + ( xOffsetOp * posFixExp * INV_AMMO_POS_FIX_DPAD_X ) + INV_BACK_SIZE - INV_BACK_PAD * 2 - 5.5 ) - widthMod * 5 ) \
        textscale		( TEXTSIZE_SMALL * 0.6 ) \
        textstyle		ITEM_TEXTSTYLE_SHADOWED \
        textfont		UI_FONT_OBJECTIVE \
        forecolor		color HUD_FOREGROUND_ALPHA \
        textalign       ITEM_ALIGN_BOTTOM_LEFT \
        exp             forecolor A ( alphaExp ) \
        background      INV_ICON_NONE \
        ammoDrawerDef \
        visible			when ( isVisibleExp ) \
        decoration \
    }