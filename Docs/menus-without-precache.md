# Menus without a precache slot

`precacheMenu` has 32 slots. A menu that only needs to open from another menu, and to send a response, does not need one.

## Load the menu

The client does not read `ui_mp/ingame.txt` from an iwd or from a `rawfile`. Stock compiles it with `menufile` into `common_mp`. The frontend list `ui_mp/menus.txt` is compiled into `ui_mp`.

To add a menu in-game, put `menufile,ui_mp/ingame.txt` in `mod.csv` and add a `loadMenu` line for the `.menu` file. That replaces the stock menu list. `open some_menu` works only if that menu is already on the loaded list (`menus.txt` or `ingame.txt`).

Compiling `ingame.txt` also compiles every `loadMenu` target. Do not also `menufile` a second file that emits the same `menuDef` name. `ui/options_graphics_pc.menu` and `ui_mp/options_graphics_pc.menu` both use the name `options_graphics`.

## Send a response

`scriptMenuResponse "some_action"` sends `mr` only while `allowScriptMenuResponse` is set. The server sets that flag with `openMenu` on a precached menu. In a match the class menu is that menu, and it stays set after the UI command `open` shows a menu from `ingame.txt`.

The server reports the last script menu, not the menu that drew the button. `Cmd_MenuResponse_f` turns argument 0–31 into configstring `1970 + index` (the precache slot). A check for `menu == "popup_prestige"` drops the response.

Handle a unique response string and ignore the menu name:

```
scriptMenuResponse "prestige_enter";
```

```
if ( response == "prestige_enter" )
```

From the main menu the flag is off until some precached script menu has been opened, so `scriptMenuResponse` sends nothing there.

`openScriptMenu <name> <response>` is the other path. The name must be precached. Keybinds use it and receive `menu == "-1"`.
