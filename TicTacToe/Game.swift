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
	
	//private: ai player for this game
	private var ai: AI?
	//private: UI to update
	private var ui: UI
	
	// public: game status [beginning, running, ended]
	var status: String
	
	// public : game current state
	var currentState: State
	
	init(_ui: UI) {
		ui = _ui
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
		//adds an X or an O to the board
		ui.insertAt(i: _state.lastMove, turn: _state.lastTurn);
		if(_state.isTerminal()) {
			end(state: _state)
		}
		else if(currentState.turn == "O") {
			ai?.notify(turn: "O")
		}
	}
	
	/*
	* Public function that starts the game
	*/
	func start() {
		if(status == "beginning") {
			advanceTo(_state: currentState)
			status = "running"
		}
	}
	
	func preStart(difficulty: String) {
		ui.currentTask?.cancel()
		self.ui.resetBoard(difficulty: difficulty)

	}
	
	func end(state: State) {
		status = "ended"
		ui.showResults(state: state)
		ui.resetBoard(delay: Game.playDelay(factor: 8))
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
	
	static func playDelay(factor: Double = 1.0) -> DispatchTime {
		var delay = Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		delay = delay * factor
		return DispatchTime.now() + delay
	}
}
