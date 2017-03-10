//
//  ViewController.swift
//  TicTacToe
//
//  Created by Adrian Bartholomew2 on 3/6/17.
//  Copyright © 2017 GB Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	private var player: String
	private var games: [Game]
	private var difficulty: String?
	private var ui: UI?
	private var players: [String]

	
	@IBOutlet var cells: [UIButton]!
	@IBAction func cellsAction(_ sender: UIButton) {
		play(sender: sender)
	}
	@IBAction func start(_ sender: UIButton) {
		start()
	}
	@IBOutlet weak var restart: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		restart.layer.cornerRadius = 7
		start()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	required init?(coder aDecoder: NSCoder) {
		players = ["X", "O"]
		player = players[0]
		difficulty = "master"
		games = [Game]()
		super.init(coder: aDecoder)
	}
	
	/*
	* Difficulty button behavior and control
	* highlight level button and update "ai.level"
	*/
	private func selectLevel(_difficulty: String) {
		difficulty = _difficulty
	}
	
	/*
	* start game behavior and control
	* when start is clicked and a level is chosen, the game status changes to "running"
	* and UI view to switch to indicate that it's the human's turn to play
	*/
	private func start() {
		if (difficulty != nil) {
			let game = Game()
			games += [game]
			let firstTurn = players[1 - (games.count % 2)]
			game.setFirstTurn(_firstTurn: firstTurn)
			if (ui == nil) {
				ui = UI(_board: cells)
			} else {
				ui!.resetBoard()
			}
			let ai = AI(_level: difficulty!, _game: game, _ui: ui!)
			game.assignAI(_ai: ai)
			ai.assignGameToAI(_game: game)
			game.start()
		}
	}
	
	/*
	* Cell click behavior and control
	* if an empty cell is clicked when the game is running and its the human player's turn
	* get the index (tag) of the clicked cell, create the next game state, update the UI, and
	* advance the game to the new created state
	*/
	private func play(sender: UIButton) {
		if (games.count == 0) {return}
		let game = getCurrGame()
		let cell = sender.tag
		if (game.status != "running" ||
			game.currentState.turn != player ||
			game.currentState.isOccupied(cell: cell)
		) {return}
			
		let next = State(old: game.currentState);
		next.board[cell] = player;
		DispatchQueue.main.async {
			sender.setTitle(self.player, for: .normal)
		}
		
		let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: delayTime) {
			next.advanceTurn();
			game.advanceTo(_state: next);
		}
	}
	
	private func getCurrGame() -> Game {
		return games[games.count - 1]
	}
}

