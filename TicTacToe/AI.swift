//
//  AI.swift
//  TicTacToe
//
//  Created by Adrian Bartholomew2 on 3/7/17.
//  Copyright © 2017 GB Software. All rights reserved.
//

import Foundation

/*
* Constructs an AI player with a specific level of intelligence
* @param level [String]: the desired level of intelligence
*/
class AI {
	
	//private attribute: level of intelligence the player has
	private var level: String
	
	//private attribute: the game the player is playing
	private var game: Game
	
	init(_level: String, _game: Game) {
		level = _level
		game = _game
	}
	
	private func getRandomInt(upper: Int) -> Int {
		return Int(arc4random_uniform(UInt32(upper)))
	}
	
	/*
	* private recursive function that computes the minimax value of a game state
	* @param state [State]: the state to calculate its minimax value
	* @returns [Number]: the minimax value of the state
	*/
	private func minimaxValue(state: State) -> Int {
		if(state.isTerminal()) {
			return Game.score(_state: state)
		}
		else {
			var stateScore: Int; // this stores the minimax value
			if(state.turn == "X") {
				// X maximizes --> initialize to a value smaller than any possible score
				stateScore = -1000
			}
			else {
				// O minimizes --> initialize to a value larger than any possible score
				stateScore = 1000
			}
			let availablePositions = state.emptyCells()
			
			//enumerate next available states from available positions
			let availableNextStates = availablePositions.map({
				(pos: Int) -> State in
					return AIAction(pos: pos).applyTo(state: state)
			})
			
			/* calculate the minimax value for all available next states
			* and evaluate the current state's value */
			availableNextStates.forEach({
				(nextState: State) -> Void in
					let nextScore = minimaxValue(state: nextState); //recursive call
					if(state.turn == "X") {
						// X wants to maximize --> update stateScore if nextScore is larger
						if(nextScore > stateScore) {
							stateScore = nextScore
						}
					}
					else {
						// O wants to minimize --> update stateScore iff nextScore is smaller
						if(nextScore < stateScore) {
							stateScore = nextScore
						}
					}
			})
			//backup the minimax value
			return stateScore
		}
	}
	
	/*
	* private function that gathers and sorts all available actions by minimax
	* @param turn [String]: the turn, X or O
	* @returns [AIAction]: the minimax value of the state
	*/
	private func getOptimizedMoves(turn: String) -> [AIAction] {
		var available = game.currentState.emptyCells()
		if (available.count == 9) {
			available = [getRandomInt(upper: 9)]
		}
		
		//enumerate and calculate the score for each available actions to the ai player
		var availableActions = available.map({
			(pos) -> AIAction in
			let action =  AIAction(pos: pos)
			let nextState = action.applyTo(state: game.currentState)
			action.minimaxVal = minimaxValue(state: nextState)
			return action
		})
		
		//sort the enumerated actions list by score
		if(turn == "X") {
			//X maximizes --> descend sort the actions by minimax
			availableActions.sort {
				$0.minimaxVal > $1.minimaxVal
			}
		}
		else {
			//O minimizes --> ascend sort the actions by minimum minimax
			availableActions.sort {
				$0.minimaxVal < $1.minimaxVal
			}
		}
		return availableActions;
	}
	
	/*
	* private function: generate move to ui and advance game
	* @param chosenAction [AIAction]: the AIAction to apply
	* @param turn [String]: the turn, X or O
	*/
	private func makeMove(chosenAction: AIAction, turn: String) {
		let next = chosenAction.applyTo(state: game.currentState);
		game.advanceTo(_state: next);
	}
	
	/*
	* private function: make the ai player make a random move
	* @param turn [String]: the player to play, either X or O
	*/
	private func makeABlindMove(turn: String) {
		let available = game.currentState.emptyCells()
		let randomCell = available[getRandomInt(upper: available.count)]
		let action = AIAction(pos: randomCell)
		makeMove(chosenAction: action, turn: turn)
	}
	
	/*
	* private function: make the ai player make a novice move,
	* that is: mix between choosing the optimal and suboptimal minimax decisions
	* @param turn [String]: the player to play, either X or O
	*/
	private func makeANoviceMove(turn: String) {
		let availableActions = getOptimizedMoves(turn: turn);
		/*
		* make the optimal action 40% of the time
		* make the 1st suboptimal action 60% of the time
		*/
		var chosenAction: AIAction
		if(arc4random_uniform(100) <= 40) {
			chosenAction = availableActions[0]
		}
		else {
			if(availableActions.count >= 2) {
				chosenAction = availableActions[1];
			}
			else {
				chosenAction = availableActions[0];
			}
		}
		makeMove(chosenAction: chosenAction, turn: turn)
	}
	
	/*
	* private function: make the ai player make a master move,
	* that is: choose the optimal minimax decision
	* @param turn [String]: the player to play, either X or O
	*/
	private func makeAMasterMove(turn: String) {
		let availableActions = getOptimizedMoves(turn: turn);
		//make optimal move
		let chosenAction = availableActions[0];
		makeMove(chosenAction: chosenAction, turn: turn)
	}
	
	
	/*
	* public method to specify the game the ai player will play
	* @param _game [Game]: the game the ai will play
	*/
	func assignGameToAI(_game: Game) {
		game = _game;
	}
	
	/*
	* public function: notify the ai player to move
	* @param turn [String]: the player to play, either X or O
	*/
	func notify(turn: String) {
		switch(level) {
		case "blind": return makeABlindMove(turn: turn)
		case "novice": return makeANoviceMove(turn: turn)
		case "master": return makeAMasterMove(turn: turn)
		default: return makeABlindMove(turn: turn)
		}
	}
}
