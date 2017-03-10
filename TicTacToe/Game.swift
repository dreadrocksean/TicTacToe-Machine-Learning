//
//  Game.swift
//  TicTacToe
//
//  Created by Adrian Bartholomew2 on 3/7/17.
//  Copyright © 2017 GB Software. All rights reserved.
//

import Foundation

/*
* Constructs a game object to be played
*/
class Game {
	
	//private : ai player for this game
	private var ai: AI?
	
	// public: game status [beginning, running, ended]
	var status: String
	
	// public : game current state
	var currentState: State
	
	init() {
		status = "beginning"
		currentState = State()
		// "E" stands for empty board cell
		currentState.board = ["E", "E", "E",
		                      "E", "E", "E",
		                      "E", "E", "E"]
	}
	
	func setFirstTurn(_firstTurn: String) {
		currentState.turn = _firstTurn
	}
	
	/*
	* public function that assigns an AI to the game
	* @param _ai [AI]: the AI player to play the game with	*/
	func assignAI(_ai: AI) {
		ai = _ai
	}
	
	/*
	* public function that advances the game to a new state
	* @param _state [State]: the new state to advance the game to
	*/
	func advanceTo(_state: State) {
		currentState = _state;
		if(_state.isTerminal()) {
			status = "ended";		}
		else if(currentState.turn == "O") {
			ai?.notify(turn: "O")
		}
	}
	
	/*
	* Public function that starts the game
	*/
	func start() {
		if(status == "beginning") {
			//invoke advanceTo with the initial state
			advanceTo(_state: currentState)
			status = "running"
		}
	}
	
	/*
	 * public static function that calculates the score of the x player in a terminal state
	 * @param _state [State]: the state in which the score is calculated
	 * @return [Number]: the score calculated for the human player
	 */
	static func score(_state: State) -> Int {
		if (_state.result == "X-won") {
			return 10 - _state.oMovesCount;
		}
		else if (_state.result == "O-won") {
			return -10 + _state.oMovesCount;
		}
		return 0
	}
}
