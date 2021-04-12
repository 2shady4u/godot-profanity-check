# godot-profanity-check

! DISCLAIMER !
This repository is not production ready at all!

This repository tests out a possible way to implement a profanity filter in Godot using pure GDScript.
The algorithm used is an optimized version of the [Wagner-Fischer algorithm](https://en.wikipedia.org/wiki/Wagner%E2%80%93Fischer_algorithm).

Godot itself implements the [Sørensen–Dice coefficient](https://en.wikipedia.org/wiki/S%C3%B8rensen%E2%80%93Dice_coefficient) natively using the `similarity()`, but this algorithm doesn't seem that capable of performing any profanity checks.

There's some big problems remaining with the algorithm that might (or might not) be fixed at some point.
