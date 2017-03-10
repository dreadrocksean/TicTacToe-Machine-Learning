//
//  AIAction.swift
//  TicTacToe
//
//  Created by Adrian Bartholomew2 on 3/7/17.
//  Copyright © 2017 GB Software. All rights reserved.
//

import Foundation

/*
* Constructs an action that the ai player could make
* @param pos [Number]: the cell position the ai would make its action in
* made that action
*/
class AIAction {
	
	// public : the position on the board that the action would put the letter on
	var movePosition: Int
	
	//public : the minimax value of the state that the action leads to when applied
	var minimaxVal: Int
	
	init(pos: Int) {
		movePosition = pos
		minimaxVal = 0
	}
	
	/*
	* public : applies the action to a state to get the next state
	* @param state [State]: the state to apply the action to
	* @return [State]: the next state
	*/
	func applyTo(state: State) -> State {
		let next = State(old: state)
		next.board[movePosition] = state.turn;
		if(state.turn == "O") {
			next.oMovesCount = next.oMovesCount + 1;
		}
		next.advanceTurn()
		return next
	}
}
