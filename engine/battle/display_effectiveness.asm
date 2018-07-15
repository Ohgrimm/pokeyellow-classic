DisplayEffectiveness:
	ld a, [wDamageMultipliers]
	and $7F
	and a
	ret z ; neutral
	cp %00000011
	ret z ; SE to one type and NVE to the other type
	and %00000001
	ld hl, SuperEffectiveText	; SE to one type, neutral or SE to the other
	jr z, .done
	ld hl, NotVeryEffectiveText	; NVE to one type, neutral or NVE to the other
.done
	jp PrintText

SuperEffectiveText:
	TX_FAR _SuperEffectiveText
	db "@"

NotVeryEffectiveText:
	TX_FAR _NotVeryEffectiveText
	db "@"
