//
//  UI.swift
//  TicTacToe
//
//  Created by Adrian Bartholomew2 on 3/7/17.
//  Copyright © 2017 GB Software. All rights reserved.
//

import Foundation
import UIKit

/*
* ui object encloses all UI related methods and attributes
*/
class UI {
	var board: [UIButton]?
	
	init(_board: [UIButton]) {
		if (board == nil) {board = _board}
		else {resetBoard()}
	}
	
	func insertAt(i: Int, turn: String) {
		self.board![i].setTitle(turn, for: .normal)
	}
	
	func clearCell(cell: UIButton) {
		cell.setTitle("", for: .normal)
	}
	
	func resetBoard() {
		for cell in board! {
			clearCell(cell: cell)
		}
	}
}
