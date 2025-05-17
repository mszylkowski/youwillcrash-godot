extends Node

enum GameState {MAIN_MENU, GAME, SETTINGS, BOOSTS}

@warning_ignore_start("unused_signal")
signal died()

signal change_state(state: GameState)
