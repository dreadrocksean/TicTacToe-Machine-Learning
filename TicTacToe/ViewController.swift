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
	@IBOutlet var levelButtons: [UIButton]!
	@IBAction func cellsAction(_ sender: UIButton) {
		play(sender: sender)
	}
	@IBAction func start(_ sender: UIButton) {
		start()
	}
	@IBOutlet weak var restart: UIButton!

	@IBAction func easy(_ sender: UIButton) {
		selectLevel(_difficulty: "blind")
	}
	@IBAction func hard(_ sender: UIButton) {
		selectLevel(_difficulty: "novice")
	}
	@IBAction func reallyHard(_ sender: UIButton) {
		selectLevel(_difficulty: "master")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		restart.layer.cornerRadius = 7
		for button in levelButtons {
			self.scaleFont(button: button)
		}
		if (ui == nil) {
			ui = UI(_board: cells, _restart: restart)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	required init?(coder aDecoder: NSCoder) {
		players = ["X", "O"]
		player = players[0]
		games = [Game]()
		super.init(coder: aDecoder)
	}
	
	private func scaleFont(button: UIButton) {
		button.titleLabel?.minimumScaleFactor = 0.1
		button.titleLabel?.numberOfLines = 1
		button.titleLabel?.adjustsFontSizeToFitWidth = true
	}
	
	/*
	* Difficulty button behavior and control
	* highlight level button and update "ai.level"
	*/
	private func selectLevel(_difficulty: String) {
		difficulty = _difficulty
		games += [Game(_ui: ui!)]
		getCurrGame().preStart(difficulty: _difficulty)
		start()
	}
	
	/*
	* start game behavior and control
	* when start is clicked and a level is chosen, the game status changes to "running"
	* and UI view to switch to indicate that it's the human's turn to play
	*/
	private func start() {
		if (difficulty == nil) {return}
		let game = getCurrGame()
		let firstTurn = players[1 - (games.count % 2)]
		game.setFirstTurn(_firstTurn: firstTurn)
		ui!.showRestart(show: false)
		DispatchQueue.main.async {
			let ai = AI(_level: self.difficulty!, _game: game)
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
		DispatchQueue.main.asyncAfter(deadline: Game.playDelay()) {
			next.advanceTurn();
			game.advanceTo(_state: next);
		}
	}
	
	private func getCurrGame() -> Game {
		if games.count == 0 {
			games += [Game(_ui: ui!)]
		}
		return games[games.count - 1]
	}
}

