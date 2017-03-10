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

	//holds the state of the intial controls visibility
	var intialControlsVisible: Bool

	//holds the setInterval handle for the robot flickering
	var robotFlickeringHandle: Int

	//holds the current visible view
	var currentView: String
	
	var board: [UIButton]?
	
	init(_board: [UIButton]) {
		intialControlsVisible = true
		robotFlickeringHandle = 0
		currentView = ""
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

	/*
	* starts the flickering effect of the robot image
	*/
//	func startRobotFlickering() {
//		var robotFlickeringHandle = setInterval({() -> Void in
//			$("#robot").toggleClass('robot');
//		}, 500);
//	}

	/*
	* stops the flickering effect on the robot image
	*/
//	func stopRobotFlickering() {
//		clearInterval(robotFlickeringHandle);
//	}

	/*
	* switchs the view on the UI depending on who's turn it switchs
	* @param turn [String]: the player to switch the view to
	*/
//	func switchViewTo(turn: String) {
//		
//		//helper function for async calling
//		func _switch(_turn: String) {
//			var currentView = "#" + _turn;
//			$(currentView).fadeIn("fast");
//			
//			if(_turn == "ai") {
//				startRobotFlickering()
//			}
//		}
//		
//		if(intialControlsVisible) {
//			//if the game is just starting
//			intialControlsVisible = false;
//			
//			$('.intial').fadeOut({
//				duration : "slow",
//				done : function() {
//					_switch(turn);
//				}
//			});
//		}
//		else {
//			//if the game is in an intermediate state
//			$(currentView).fadeOut({
//				duration: "fast",
//				done: function() {
//					_switch(turn);
//				}
//			});
//		}
//	};
}
