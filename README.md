# Pokémon Yellow

This is a disassembly of Pokémon Yellow.

It builds the following rom:

* Pokemon Yellow (UE) [C][!].gbc  `md5: d9290db87b1f0a23b89f99ee4469e34b`

To set up the repository, see [**INSTALL.md**](INSTALL.md).

## Development Optimizations
* add dedicated bank for Trainer Data
* Pokémon sprites can be in any bank
* optimize Mart inventory data
* remove unnecessary Japanese grammar checks
* remove unnecessary `SaveTrainerName` routine
* Trainer sprites can be in any bank

## Included Bugfixes
* 100% Accuracy moves no longer accidentally have a 1/256 chance of missing
* breaking a substitute no longer negates effects of sacrificial moves
* correct Bide damage glitch
* correct Critical Hit ratio error
* correct dual-type damage misinformation
* correct Exp. All oversight
* correct Hyper Beam + Sleep move glitch
* correct invulnerability glitch
* correct Reflect/Light Screen stat overflow glitch
* correct Substitute ¼ HP glitch
* damage is cleared when Pokémon enter the field so Counter/Bide cannot bounce back damage from non-active Pokémon or a previous battle
* Defense cannot become 0 after stat scaling
* prevent evolutionary stone bypassing
* prevent HP recovery move failure
* prevent level-up learnset skipping
* prevent partial trapping move Mirror Move link battle glitch
* prevent Psywave desynchronization
* prevent Struggle bypassing
* reset Toxic counter with Rest
* revise `BallFactor` behaviour for Ultra Balls

## New Features
* item descriptions in Bag
* Trainer classes each have their own DVs
* replace Beauties on water routes with female Swimmers
* replace SGB border with a variation on that of the '97 Silver beta

## Restored Content
* display Gym Leader names on Badges screen
* display Rival dialogue after losing a battle to him

## Quality of Life Improvements
* changed Struggle to be ???-Type so nothing can be immune to it
* Focus Energy now uses a previously unused animation
* increase Pikachu's happiness upon healing
* turn to face opponent trainers who have noticed you
* user will now awaken from Rest three turns after it is used and can attack on the third


## See also

* Disassembly of [**Pokémon Red/Blue**][pokered]
* Disassembly of [**Pokémon Gold**][pokegold]
* Disassembly of [**Pokémon Crystal**][pokecrystal]
* Disassembly of [**Pokémon Pinball**][pokepinball]
* Disassembly of [**Pokémon TCG**][poketcg]
* Disassembly of [**Pokémon Ruby**][pokeruby]
* Disassembly of [**Pokémon Fire Red**][pokefirered]
* Disassembly of [**Pokémon Emerald**][pokeemerald]
* Discord: [**pret**][Discord]
* irc: **irc.freenode.net** [**#pret**][irc]

[pokered]: https://github.com/pret/pokered
[pokegold]: https://github.com/pret/pokegold
[pokecrystal]: https://github.com/pret/pokecrystal
[pokepinball]: https://github.com/pret/pokepinball
[poketcg]: https://github.com/pret/poketcg
[pokeruby]: https://github.com/pret/pokeruby
[pokefirered]: https://github.com/pret/pokefirered
[pokeemerald]: https://github.com/pret/pokeemerald
[Discord]: https://discord.gg/cJxDDVP
[irc]: https://kiwiirc.com/client/irc.freenode.net/?#pret
