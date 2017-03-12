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
	var restart: UIButton?
	
	private let RED = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)
	private let YELLOW = UIColor(red: 1, green: 1, blue: 0.8, alpha: 1)
	private let GREEN = UIColor(red: 0.8, green: 1, blue: 0.8, alpha: 1)
	private let BLUE = UIColor(red: 0.9, green: 0.9, blue: 1.0, alpha: 1)
	
	init(_board: [UIButton], _restart: UIButton) {
		if (board == nil) {board = _board}
		else {resetBoard()}
		restart = _restart
	}
	
	func insertAt(i: Int?, turn: String?) {
		if (i == nil) {return}
		board![i!].setTitle(turn!, for: .normal)
	}
	
	func clearCell(cell: UIButton) {
		cell.setTitle("", for: .normal)
	}
	
	func resetBoard(difficulty: String = "") {
		for cell in board! {
			clearCell(cell: cell)
		}
		switch difficulty {
		case "master":
			setBoardColor(color: RED); break;
		case "novice":
			setBoardColor(color: YELLOW); break;
		case "blind":
			setBoardColor(color: GREEN); break;
		default:
			setBoardColor(color: BLUE)
		}
	}
	
	func setBoardColor(color: UIColor) {
		setCellsColor(color: color)
	}
	
	func setCellsColor(color: UIColor) {
		for cell in board! {
			cell.backgroundColor = color
		}
	}
	
	func showRestart(show: Bool, title: String = "Again?") {
		restart!.setTitle(title, for: .normal)
		restart!.isHidden = !show
	}
}
