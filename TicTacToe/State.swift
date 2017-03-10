//
//  State.swift
//  TicTacToe
//
//  Created by Adrian Bartholomew2 on 3/6/17.
//  Copyright © 2017 GB Software. All rights reserved.
//

import Foundation
/*
* Represents a state in the game
* @param old [State]: old state to intialize the new state
*/
class State {
	
	//public: the player who has the turn to player
	var turn: String
	
	//public: the number of moves of the AI player
	var oMovesCount: Int
	
	//public: the result of the game in this State
	var result: String
	
	//public: the board configuration in this state
	var board: [String]
	
	init() {
		turn = ""
		oMovesCount = 0
		result = "still running"
		board = [String]()
	}
	convenience init(old: State) {
		self.init()
		board = [String]()
		for cell in old.board {
			board.append(cell)
		}
		oMovesCount = old.oMovesCount
		result = old.result
		turn = old.turn
	}
	
	/*
	* public: advances the turn in a the state
	*/
	func advanceTurn() {
		turn = turn == "X" ? "O" : "X"
	}
	
	/*
	* public function that enumerates the empty cells in state
	* @return [Array]: indices of all empty cells
	*/
	func emptyCells() -> Array<Int> {
		var indxs = [Int]()
		for (i, cell) in board.enumerated() {
			if(cell == "E") {
				indxs += [i]
			}
		}
		return indxs
	}
	
	/*
	* public function that checks for cell occupancy
	* @parameter cell [Int]: cell to check
	* @return [Boolean]: true if occupied
	*/
	func isOccupied(cell: Int) -> Bool {
		return board[cell] != "E"
	}
	
	/*
	* public  function that checks if the state is a terminal state or not
	* the state result is updated to reflect the result of the game
	* @returns [Boolean]: true if terminal
	*/
	func isTerminal() -> Bool {
		var B = board
		
		//check rows
		for i in stride(from: 0, through: 6, by: 3) {
			if(B[i] != "E" && B[i] == B[i + 1] && B[i + 1] == B[i + 2]) {
				result = B[i] + "-won" //update the state result
				return true
			}
		}
		
		//check columns
		for i in stride(from: 0, through: 2, by: 1) {
			if(B[i] != "E" && B[i] == B[i + 3] && B[i + 3] == B[i + 6]) {
				result = B[i] + "-won"
				return true
			}
		}
		
		//check diagonals
		var j = 4
		for i in 0...2 where i%2==0 {
			if(B[i] != "E" && B[i] == B[i + j] && B[i + j] == B[i + 2*j]) {
				result = B[i] + "-won"
				return true
			}
			j = j - 2
		}
		
		if(emptyCells().count == 0) {
			//the game is a draw
			result = "draw"
			return true
		}
		return false
	}
}
