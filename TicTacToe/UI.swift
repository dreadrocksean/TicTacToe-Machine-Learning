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
	var currentTask: DispatchWorkItem?
	
	private let RED = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)
	private let YELLOW = UIColor(red: 1, green: 1, blue: 0.8, alpha: 1)
	private let GREEN = UIColor(red: 0.8, green: 1, blue: 0.8, alpha: 1)
	private let BLUE = UIColor(red: 0.9, green: 0.9, blue: 1.0, alpha: 1)
	
	init(_board: [UIButton], _restart: UIButton) {
		if (board == nil) {board = _board}
		else {resetBoard()}
		restart = _restart
	}
	
	static func playDelay(_ factor: Double = 1.0) -> DispatchTime {
		var delay = Double(Int64(Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		delay = delay * factor
		return DispatchTime.now() + delay
	}
	
	func delayedFunc(_ delay: Double, _ closure: @escaping () -> Void) {
		currentTask = DispatchWorkItem {
			closure()
		}
		DispatchQueue.main.asyncAfter(deadline: UI.playDelay(delay), execute: currentTask!)
	}
	
	func insertAt(i: Int?, turn: String?) {
		if (i == nil) {return}
		board![i!].setTitle(turn!, for: .normal)
	}
	
	func clearCell(cell: UIButton) {
		cell.setTitle("", for: .normal)
	}
	
	func resetBoard(difficulty: String = "", delay: Double) {
		delayedFunc(delay) {self.resetBoard(difficulty: difficulty)}
	}
	
	func resetBoard(difficulty: String = "") {
		for cell in board! {
			clearCell(cell: cell)
		}
		setCellsFontColor()
		setCellsAlpha()
		stopAnimations()
		switch difficulty {
		case "master":
			setBoardColor(color: RED); break;
		case "novice":
			setBoardColor(color: YELLOW); break;
		case "blind":
			setBoardColor(color: GREEN); break;
		default:
			setBoardColor()
		}
	}
	
	func setBoardColor(color: UIColor = UIColor(red: 0.9, green: 0.9, blue: 1.0, alpha: 1)) {
		setCellsColor(color: color)
	}
	
	func setCellsColor(color: UIColor, cells: [Int] = []) {
		for (i, cell) in board!.enumerated() {
			if (cells.count == 0 || (cells.count != 0 && cells.contains(i))) {
				cell.backgroundColor = color
			}
		}
	}
	
	func setCellsFontColor(color: UIColor = UIColor.black, cells: [Int] = []) {
		for (i, cell) in board!.enumerated() {
			if (cells.count == 0 || (cells.count != 0 && cells.contains(i))) {
				cell.setTitleColor(color, for: .normal)
			}
		}
	}
	
	func setCellsAlpha(alpha: Double = 1.0, cells: [Int] = []) {
		for (i, cell) in board!.enumerated() {
			if (cells.count == 0 || (cells.count != 0 && cells.contains(i))) {
				cell.alpha = CGFloat(alpha)
			}
		}
	}
	
	func showRestart(show: Bool, title: String = "Again?") {
		restart!.setTitle(title, for: .normal)
		restart!.isHidden = !show
	}

	func animateWin(state: State) {
		delayedFunc(delay: 2.0) {
			self.stopAnimations()
			self.setCellsAlpha()
		}
		UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut, .repeat, .autoreverse], animations: {
				self.setCellsAlpha(alpha: 0.5, cells: state.winningCells!)
				
			}, completion: nil)
	}
	
	func stopAnimations() {
		for cell in board! {
			cell.layer.removeAllAnimations()
		}
	}
	
	func showResults(state: State) {
		if (state.winningCells == nil) {
			setCellsColor(color: UIColor.gray)
			setCellsFontColor(color: UIColor.darkGray)
		} else if(state.result == "O-won") {
			setCellsColor(color: UIColor.red, cells: state.winningCells!)
			setCellsFontColor(color: UIColor.white, cells: state.winningCells!)
			animateWin(state: state)
		} else {
			setCellsColor(color: UIColor.green, cells: state.winningCells!)
			setCellsFontColor(color: UIColor.white, cells: state.winningCells!)
			animateWin(state: state)
		}
	}
}
