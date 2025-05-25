extends Node

enum GameState {MAIN_MENU, GAME, SETTINGS, BOOSTS}

@warning_ignore_start("unused_signal")

signal died() ## When player died
signal score_change(value: int) ## When the score changed
signal change_state(state: GameState) ## When the game state changed

signal picked_currency() ## When the player picked up a currency
signal currency_changed(currency: int) ## When the currency changed
signal highscore_changed(highscore: int) ## When a new highscore was set
