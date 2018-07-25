INCLUDE "engine/battle/common_text.asm"
INCLUDE "engine/battle/link_battle_versus_text.asm"
INCLUDE "engine/battle/unused_stats_functions.asm"
INCLUDE "engine/battle/scroll_draw_trainer_pic.asm"

StarterPikachuBattleEntranceAnimation:
	coord hl, 0, 5
	ld c, 0
.loop1
	inc c
	ld a, c
	cp 9
	ret z
	ld d, 7 * 13
	push bc
	push hl
.loop2
	call .PlaceColumn
	dec hl
	ld a, d
	sub 7
	ld d, a
	dec c
	jr nz, .loop2
	ld c, 2
	call DelayFrames
	pop hl
	pop bc
	inc hl
	jr .loop1

.PlaceColumn:
	push hl
	push de
	push bc
	ld e, 7
.loop3
	ld a, d
	cp 7 * 7
	jr nc, .okay
	ld a, $7f
.okay
	ld [hl], a
	ld bc, SCREEN_WIDTH
	add hl, bc
	inc d
	dec e
	jr nz, .loop3
	pop bc
	pop de
	pop hl
	ret

INCLUDE "engine/battle/decrement_pp.asm"

ModifyPikachuHappiness::
	ld a, d
	cp PIKAHAPPY_GYMLEADER
	jr z, .checkanywhereinparty
	cp PIKAHAPPY_WALKING
	jr z, .checkanywhereinparty
	push de
	callab IsThisPartymonStarterPikachu_Party
	pop de
	ret nc
	jr .proceed

.checkanywhereinparty
	push de
	callab IsStarterPikachuInOurParty
	pop de
	ret nc

.proceed
	push de
	; Divide [wPikachuHappiness] by 100.  Hold the integer part in e.
	ld e, $0
	ld a, [wPikachuHappiness]
	cp 100
	jr c, .wPikachuHappiness_div_100
	inc e
	cp 200
	jr c, .wPikachuHappiness_div_100
	inc e
.wPikachuHappiness_div_100
	; Get the (d, e) entry from HappinessChangeTable.
	ld c, d
	dec c
	ld b, $0
	ld hl, HappinessChangeTable
	add hl, bc
	add hl, bc
	add hl, bc
	ld d, $0
	add hl, de
	ld a, [hl]
	; If [hl] is positive, take min(0xff, [hl] + [wPikachuHappiness]).
	; If [hl] is negative, take max(0x00, [hl] + [wPikachuHappiness]).
	; Inexplicably, we're using 100 as the threshold for comparison.
	cp 100
	ld a, [wPikachuHappiness]
	jr nc, .negative
	add [hl]
	jr nc, .okay
	ld a, -1
	jr .okay

.negative
	add [hl]
	jr c, .okay
	xor a
.okay
	ld [wPikachuHappiness], a

	; Restore d and get the d'th entry in PikachuMoods.
	pop de
	dec d
	ld hl, PikachuMoods
	ld e, d
	ld d, $0
	add hl, de
	ld a, [hl]
	ld b, a
	; Modify Pikachu's mood
	cp $80
	jr z, .done
	ld a, [wPikachuMood]
	jr c, .decreased
	cp b
	jr nc, .done
	ld a, [wd49c]
	and a
	jr nz, .done
	jr .update_mood

.decreased
	cp b
	jr c, .done
.update_mood
	ld a, b
	ld [wPikachuMood], a
.done
	ret

HappinessChangeTable:
	; Increase
	db   5, 3, 2 ; Gained a level
	db   5, 3, 2 ; HP restore
	db   1, 1, 0 ; Used X item
	db   3, 2, 1 ; Challenged Gym Leader
	db   1, 1, 0 ; Teach TM/HM
	db   2, 1, 1 ; Walking around
	; Decrease
	db  -3, -3, -5 ; Deposited
	db  -1, -1, -1 ; Fainted in battle
	db  -5, -5, -10 ; Fainted due to Poison outside of battle
	db  -5, -5, -10 ; Unknown (d = 10)
	db -10, -10, -20 ; Unknown (d = 11)

PikachuMoods:
	; Increase
	db $8a           ; Gained a level
	db $83           ; HP restore
	db $80           ; Teach TM/HM
	db $80           ; Challenged Gym Leader
	db $94           ; Unknown (d = 5)
	db $80           ; Unknown (d = 6)
	; Decrease
	db $62           ; Deposited
	db $6c           ; Fainted
	db $62           ; Unknown (d = 9)
	db $6c           ; Unknown (d = 10)
	db $00           ; Unknown (d = 11)

RedPicBack:       INCBIN "pic/trainer/redb.pic"
OldManPic:	       INCBIN "pic/trainer/oldman.pic"
ProfOakPicBack:   INCBIN "pic/ytrainer/prof.oakb.pic"

SECTION "Trainer Pics 1", ROMX

YoungsterPic:     INCBIN "pic/trainer/youngster.pic"
BugCatcherPic:    INCBIN "pic/trainer/bugcatcher.pic"
LassPic:          INCBIN "pic/trainer/lass.pic"
SailorPic:        INCBIN "pic/trainer/sailor.pic"
JrTrainerMPic:    INCBIN "pic/trainer/jr.trainerm.pic"
JrTrainerFPic:    INCBIN "pic/trainer/jr.trainerf.pic"
PokemaniacPic:    INCBIN "pic/trainer/pokemaniac.pic"
SuperNerdPic:     INCBIN "pic/trainer/supernerd.pic"
HikerPic:         INCBIN "pic/trainer/hiker.pic"
BikerPic:         INCBIN "pic/trainer/biker.pic"
BurglarPic:       INCBIN "pic/trainer/burglar.pic"
EngineerPic:      INCBIN "pic/trainer/engineer.pic"
FisherPic:        INCBIN "pic/trainer/fisher.pic"
SwimmerPic:       INCBIN "pic/trainer/swimmer.pic"
SwimmerFPic:      INCBIN "pic/swtrainer/swimmerf.pic"
CueBallPic:       INCBIN "pic/trainer/cueball.pic"


SECTION "Trainer Pics 2", ROMX

GamblerPic:       INCBIN "pic/trainer/gambler.pic"
BeautyPic:        INCBIN "pic/trainer/beauty.pic"
PsychicPic:       INCBIN "pic/trainer/psychic.pic"
RockerPic:        INCBIN "pic/trainer/rocker.pic"
JugglerPic:       INCBIN "pic/trainer/juggler.pic"
TamerPic:         INCBIN "pic/trainer/tamer.pic"
BirdKeeperPic:    INCBIN "pic/trainer/birdkeeper.pic"
BlackbeltPic:     INCBIN "pic/trainer/blackbelt.pic"
Rival1Pic:        INCBIN "pic/ytrainer/rival1.pic"
ProfOakPic:       INCBIN "pic/trainer/prof.oak.pic"
ChiefPic:
ScientistPic:     INCBIN "pic/trainer/scientist.pic"
GiovanniPic:      INCBIN "pic/trainer/giovanni.pic"
RocketPic:        INCBIN "pic/trainer/rocket.pic"
CooltrainerMPic:  INCBIN "pic/trainer/cooltrainerm.pic"
CooltrainerFPic:  INCBIN "pic/trainer/cooltrainerf.pic"


SECTION "Trainer Pics 3", ROMX

BrunoPic:         INCBIN "pic/trainer/bruno.pic"
BrockPic:         INCBIN "pic/ytrainer/brock.pic"
MistyPic:         INCBIN "pic/ytrainer/misty.pic"
LtSurgePic:       INCBIN "pic/trainer/lt.surge.pic"
ErikaPic:         INCBIN "pic/ytrainer/erika.pic"
KogaPic:          INCBIN "pic/trainer/koga.pic"
BlainePic:        INCBIN "pic/trainer/blaine.pic"
SabrinaPic:       INCBIN "pic/trainer/sabrina.pic"
GentlemanPic:     INCBIN "pic/trainer/gentleman.pic"
Rival2Pic:        INCBIN "pic/ytrainer/rival2.pic"
Rival3Pic:        INCBIN "pic/ytrainer/rival3.pic"
LoreleiPic:       INCBIN "pic/trainer/lorelei.pic"
ChannelerPic:     INCBIN "pic/trainer/channeler.pic"
AgathaPic:        INCBIN "pic/trainer/agatha.pic"
LancePic:         INCBIN "pic/trainer/lance.pic"
JessieJamesPic:   INCBIN "pic/ytrainer/jessiejames.pic"

Bank3D_CopyBox:
; copy cxb (xy) screen area from de to hl
.row
	push bc
	push hl
.col
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

PokemonLogoGraphics:	     INCBIN "gfx/custom/pokemon_logo.2bpp"
PokemonLogoGraphicsEnd:
YellowLogoGraphics:	      INCBIN "gfx/yellow_titlescreen.2bpp"
YellowLogoGraphicsEnd:
GottaCatchEmAllTiles:           INCBIN "gfx/custom/gotta_catch_em_all.2bpp"
GottaCatchEmAllTilesEnd:

INCLUDE "engine/menu/link_menu.asm"

HandleMenuInputDouble:
	xor a
	ld [wPartyMenuAnimMonEnabled], a

HandleMenuInputPokemonSelectionDouble:
	ld a, [H_DOWNARROWBLINKCNT1]
	push af
	ld a, [H_DOWNARROWBLINKCNT2]
	push af ; save existing values on stack
	xor a
	ld [H_DOWNARROWBLINKCNT1], a ; blinking down arrow timing value 1
	ld a, $06
	ld [H_DOWNARROWBLINKCNT2], a ; blinking down arrow timing value 2
.loop1
	xor a
	ld [wAnimCounter], a ; counter for pokemon shaking animation
	call .UpdateCursorTile
	call JoypadLowSensitivity
	ld a, [hJoy5]
	and a ; was a key pressed?
	jr nz, .keyPressed
	pop af
	ld [H_DOWNARROWBLINKCNT2], a
	pop af
	ld [H_DOWNARROWBLINKCNT1], a ; restore previous values
	xor a
	ld [wMenuWrappingEnabled], a ; disable menu wrapping
	ret
.keyPressed
	xor a
	ld [wCheckFor180DegreeTurn], a
	ld a, [hJoy5]
	ld b, a
	bit 6, a ; pressed Up key?
	jr z, .checkIfDownPressed
.upPressed
	ld a, [wCurrentMenuItem] ; selected menu item
	and a ; already at the top of the menu?
	jr z, .checkOtherKeys
.notAtTop
	dec a
	ld [wCurrentMenuItem], a ; move selected menu item up one space
	jr .checkOtherKeys
.checkIfDownPressed
	bit 7, a
	jr z, .checkOtherKeys
.downPressed
	ld a, [wCurrentMenuItem]
	inc a
	ld c, a
	ld a, [wMaxMenuItem]
	cp c
	jr c, .checkOtherKeys
	ld a, c
	ld [wCurrentMenuItem], a
.checkOtherKeys
	ld a, [wMenuWatchedKeys]
	and b ; does the menu care about any of the pressed keys?
	jp z, .loop1
.checkIfAButtonOrBButtonPressed
	ld a, [hJoy5]
	and A_BUTTON | B_BUTTON
	jr z, .skipPlayingSound
.AButtonOrBButtonPressed
	ld a, SFX_PRESS_AB
	call PlaySound ; play sound
.skipPlayingSound
	pop af
	ld [H_DOWNARROWBLINKCNT2], a
	pop af
	ld [H_DOWNARROWBLINKCNT1], a ; restore previous values
	ld a, [hJoy5]
	ret

.UpdateCursorTile:
	ld a, [wTopMenuItemY]
	and a
	jr z, .asm_f5ac0
	coord hl, 0, 0
	ld bc, SCREEN_WIDTH
.loop
	add hl, bc
	dec a
	jr nz, .loop
.asm_f5ac0
	ld a, [wTopMenuItemX]
	ld b, $0
	ld c, a
	add hl, bc
	push hl
	ld a, [wLastMenuItem]
	and a
	jr z, .asm_f5ad5
	ld bc, $28
.loop2
	add hl, bc
	dec a
	jr nz, .loop2
.asm_f5ad5
	ld a, [hl]
	cp "▶"
	jr nz, .asm_f5ade
	ld a, [wTileBehindCursor]
	ld [hl], a
.asm_f5ade
	pop hl
	ld a, [wCurrentMenuItem]
	and a
	jr z, .asm_f5aec
	ld bc, $28
.loop3
	add hl, bc
	dec a
	jr nz, .loop3
.asm_f5aec
	ld a, [hl]
	cp "▶"
	jr z, .asm_f5af4
	ld [wTileBehindCursor], a
.asm_f5af4
	ld a, "▶"
	ld [hl], a
	ld a, l
	ld [wMenuCursorLocation], a
	ld a, h
	ld [wMenuCursorLocation + 1], a
	ld a, [wCurrentMenuItem]
	ld [wLastMenuItem], a
	ret

PrintStrengthTxt:
	ld hl, wd728
	set 0, [hl]
	ld hl, Text_f5b17
	call PrintText
	ld hl, Text_f5b28
	jp PrintText

Text_f5b17:
	TX_FAR _UsedStrengthText
	TX_ASM
	ld a, [wcf91]
	call PlayCry
	call Delay3
	jp TextScriptEnd

Text_f5b28:
	TX_FAR _CanMoveBouldersText
	db "@"

IsSurfingAllowed:
; Returns whether surfing is allowed in bit 1 of wd728.
; Surfing isn't allowed on the Cycling Road or in the lowest level of the
; Seafoam Islands before the current has been slowed with boulders.
	ld hl, wd728
	set 1, [hl]
	ld a, [wd732]
	bit 5, a
	jr nz, .forcedToRideBike
	ld a, [wCurMap]
	cp SEAFOAM_ISLANDS_5
	ret nz
	CheckBothEventsSet EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE
	ret z
	ld hl, CoordsData_f5b64
	call ArePlayerCoordsInArray
	ret nc
	ld hl, wd728
	res 1, [hl]
	ld hl, CurrentTooFastText
	jp PrintText
.forcedToRideBike
	ld hl, wd728
	res 1, [hl]
	ld hl, CyclingIsFunText
	jp PrintText

CoordsData_f5b64:
	db 11, 07
	db $ff

CurrentTooFastText:
	TX_FAR _CurrentTooFastText
	db "@"

CyclingIsFunText:
	TX_FAR _CyclingIsFunText
	db "@"

AddItemToInventory_:
	ld a, [wItemQuantity] ; a = item quantity
	push af
	push bc
	push de
	push hl
	push hl
	ld d, PC_ITEM_CAPACITY ; how many items the PC can hold
	ld a, wNumBagItems & $FF
	cp l
	jr nz, .checkIfInventoryFull
	ld a, wNumBagItems >> 8
	cp h
	jr nz, .checkIfInventoryFull
; if the destination is the bag
	ld d, BAG_ITEM_CAPACITY ; how many items the bag can hold
.checkIfInventoryFull
	ld a, [hl]
	sub d
	ld d, a
	ld a, [hli]
	and a
	jr z, .addNewItem
.notAtEndOfInventory
	ld a, [hli]
	ld b, a ; b = ID of current item in table
	ld a, [wcf91] ; a = ID of item being added
	cp b ; does the current item in the table match the item being added?
	jp z, .increaseItemQuantity ; if so, increase the item's quantity
	inc hl
.loop
	ld a, [hl]
	cp a, $ff ; is it the end of the table?
	jr nz, .notAtEndOfInventory
.addNewItem ; add an item not yet in the inventory
	pop hl
	ld a, d
	and a ; is there room for a new item slot?
	jr z, .done
; if there is room
	inc [hl] ; increment the number of items in the inventory
	ld a, [hl] ; the number of items will be the index of the new item
	add a
	dec a
	ld c, a
	ld b, 0
	add hl, bc ; hl = address to store the item
	ld a, [wcf91]
	ld [hli], a ; store item ID
	ld a, [wItemQuantity]
	ld [hli], a ; store item quantity
	ld [hl], $ff ; store terminator
	jp .success
.increaseItemQuantity ; increase the quantity of an item already in the inventory
	ld a, [wItemQuantity]
	ld b, a ; b = quantity to add
	ld a, [hl] ; a = existing item quantity
	add b ; a = new item quantity
	cp a, 100
	jp c, .storeNewQuantity ; if the new quantity is less than 100, store it
; if the new quantity is greater than or equal to 100,
; try to max out the current slot and add the rest in a new slot
	sub a, 99
	ld [wItemQuantity], a ; a = amount left over (to put in the new slot)
	ld a, d
	and a ; is there room for a new item slot?
	jr z, .increaseItemQuantityFailed
; if so, store 99 in the current slot and store the rest in a new slot
	ld a, 99
	ld [hli], a
	jp .loop
.increaseItemQuantityFailed
	pop hl
	and a
	jr .done
.storeNewQuantity
	ld [hl], a
	pop hl
.success
	scf
.done
	pop hl
	pop de
	pop bc
	pop bc
	ld a, b
	ld [wItemQuantity], a ; restore the initial value from when the function was called
	ret

; function to remove an item (in varying quantities) from the player's bag or PC box
; INPUT:
; hl = address of inventory (either wNumBagItems or wNumBoxItems)
; [wWhichPokemon] = index (within the inventory) of the item to remove
; [wItemQuantity] = quantity to remove
RemoveItemFromInventory_:
	push hl
	inc hl
	ld a, [wWhichPokemon] ; index (within the inventory) of the item being removed
	add a
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	inc hl
	ld a, [wItemQuantity] ; quantity being removed
	ld e, a
	ld a, [hl] ; a = current quantity
	sub e
	ld [hld], a ; store new quantity
	ld [wMaxItemQuantity], a
	and a
	jr nz, .skipMovingUpSlots
; if the remaining quantity is 0,
; remove the emptied item slot and move up all the following item slots
.moveSlotsUp
	ld e, l
	ld d, h
	inc de
	inc de ; de = address of the slot following the emptied one
.loop ; loop to move up the following slots
	ld a, [de]
	inc de
	ld [hli], a
	cp a, $ff
	jr nz, .loop
; update menu info
	xor a
	ld [wListScrollOffset], a
	ld [wCurrentMenuItem], a
	ld [wBagSavedMenuItem], a
	ld [wSavedListScrollOffset], a
	pop hl
	ld a, [hl] ; a = number of items in inventory
	dec a ; decrement the number of items
	ld [hl], a ; store new number of items
	ld [wListCount], a
	cp a, 2
	jr c, .done
	ld [wMaxMenuItem], a
	jr .done
.skipMovingUpSlots
	pop hl
.done
	ret

TrainerInfoTextBoxTileGraphics:	INCBIN "gfx/trainer_info.2bpp"
TrainerInfoTextBoxTileGraphicsEnd:
BlankLeaderNames:				INCBIN "gfx/blank_leader_names.2bpp"
CircleTile:						INCBIN "gfx/circle_tile.2bpp"
BadgeNumbersTileGraphics:		INCBIN "gfx/badge_numbers.2bpp"

ReadSuperRodData:
	ld a, [wCurMap]
	ld c, a
	ld hl, FishingSlots
.loop
	ld a, [hli]
	cp $ff
	jr z, .notfound
	cp c
	jr z, .found
	ld de, $8
	add hl, de
	jr .loop
.found
	call GenerateRandomFishingEncounter
	ret
.notfound
	ld de, $0
	ret

GenerateRandomFishingEncounter:
	call Random
	cp $66
	jr c, .asm_f5ed6
	inc hl
	inc hl
	cp $b2
	jr c, .asm_f5ed6
	inc hl
	inc hl
	cp $e5
	jr c, .asm_f5ed6
	inc hl
	inc hl
.asm_f5ed6
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret

INCLUDE "data/super_rod.asm"
INCLUDE "engine/battle/bank3d_battle.asm"
INCLUDE "engine/items/tm_prices.asm"
INCLUDE "engine/multiply_divide.asm"
INCLUDE "engine/give_pokemon.asm"
INCLUDE "engine/battle/get_trainer_name.asm"
INCLUDE "engine/random.asm"
INCLUDE "engine/predefs.asm"
