//
//  KuraminTests.swift
//  KuraminTests
//
//  Created by Numan Bashir on 16/02/2023.
//

import XCTest
@testable import Kuramin.Game

final class KuraminTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
       XCTAssertEqual(2, 2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    
    
//    func testAddPlayer() throws {
//        var controller = Controller()
//        let LOBBY = "lobby"
//
//        var game = controller.game
//
//
//
//
//
//
//        var p1 = Player(id: UUID())
//        var p2 = Player(id: UUID())
//        var p3 = Player(id: UUID())
//        var p4 = Player(id: UUID())
//        var p5 = Player(id: UUID())
//        var p6 = Player(id: UUID())
//        var p7 = Player(id: UUID())
//
//
//        game.addPlayer(player: p1)
//        game.addPlayer(player: p2)
//        game.addPlayer(player: p3)
//
//        XCTAssertEqual(game.actualPlayerSize, 3)
//        XCTAssertEqual(game.players.count, 3)
//
//
//        XCTAssertEqual(true, game.players.contains(where: {$0.id == p1.id}))
//        XCTAssertEqual(true, game.players.contains(where: {$0.id == p2.id}))
//        XCTAssertEqual(true, game.players.contains(where: {$0.id == p3.id}))
//
//
//
//        game.addPlayer(player: p4)
//        game.addPlayer(player: p5)
//        game.addPlayer(player: p6)
//        game.addPlayer(player: p7)
//
//
//        XCTAssertEqual(game.actualPlayerSize, 7)
//        XCTAssertEqual(game.players.count, 7)
//        // Adding players checked
//
//
//        var p8 = Player(id: UUID())
//        game.addPlayer(player: p8)
//
//        XCTAssertEqual(false, game.players.contains(where: {$0.id == p8.id}))
//
//
//
//
//
//
//        var p9 = Player(id: UUID())
//        var p10 = Player(id: UUID())
//
//
//        var lobby = Lobby(host: p1.id, [p8, p9, p10])
//
//
//
//
//
//
//
//
//
//
//    }
}
