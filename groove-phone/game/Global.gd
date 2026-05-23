extends Node

var sound_manager : SoundManager

var unlosable : bool = false

##Menu reference
var setting : Settings
var main_menu : MainMenu
var act_selection : ActSelection
var pause_menu : PauseMenu

##Main Game componants
var current_rhythm_manager : RhythmManager
var game_manager : GameManager

##Game score
var act_1_score : int
var act_2_score : int
var act_3_score : int
