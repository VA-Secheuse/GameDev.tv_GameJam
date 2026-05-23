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
var score_dic : Dictionary = {'act_1' : 0,'act_2' : 0, 'act_3' : 0}

##Unlocks
var act_2_unlocked : bool = false
var act_3_unlocked : bool = false
