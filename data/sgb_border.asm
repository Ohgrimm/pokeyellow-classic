BorderPalettes:
	INCBIN "gfx/tilemaps/spaceworld/sgbborder.map"

	ds $100

	RGB 28, 28, 28 ; PAL_SGB1
	RGB 31, 27, 14
	RGB 19, 25, 25
	RGB 16, 16, 19

	ds $18

	RGB 28, 28, 28 ; PAL_SGB2
	RGB 31, 20, 15
	RGB 31, 26, 20
	RGB 16, 16, 19

	ds $18

	RGB 28, 28, 28 ; PAL_SGB3
	RGB 29, 23, 24
	RGB 19, 25, 18
	RGB 16, 16, 19

	ds $18

SGBBorderGraphics:
	INCBIN "gfx/spaceworld/sgbborder.2bpp"
