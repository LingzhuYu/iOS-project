///Users/a00933336/Desktop/ios-project/ios-project.xcodeproj
//  lobbyTest.swift
//  ios-project
//
//  Created by Jason Cheung on 2016-10-17.
//  Copyright © 2016 Manjot. All rights reserved.
//

import XCTest
@testable import ios_project

class lobbyTest: XCTestCase {
    
    var host : Profile = Profile(userName: "UserName", tag: "TagName")
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test1_DefaultGameSettings(){
        let lobby : Lobby = Lobby(host)
        
        XCTAssertEqual(lobby.settings.time, 6000)
        XCTAssertEqual(lobby.settings.maxPlayers, 1000)
        XCTAssertEqual(lobby.settings.minPlayers, 2)
        XCTAssertEqual(lobby.settings.gameCode, "1")
        
    }
    
    func test2_EditGameSettings(){
        let lobby : Lobby = Lobby(host)
        
        lobby.editSettings(0)
        
        XCTAssertEqual(lobby.settings.time, 6001)
        XCTAssertEqual(lobby.settings.maxPlayers, 10)
        XCTAssertEqual(lobby.settings.minPlayers, 3)
        XCTAssertEqual(lobby.settings.gameCode, "1")
    }
    
    func test3_VariableValidation(){
        let lobby : Lobby = Lobby(host)
        
        lobby.editSettings(0)
        
        //Verify the values before changing
        XCTAssertEqual(lobby.settings.time, 6001)
        XCTAssertEqual(lobby.settings.maxPlayers, 10)
        XCTAssertEqual(lobby.settings.minPlayers, 3)
        XCTAssertEqual(lobby.settings.gameCode, "1")
        
        //Try to change to invalid values
        lobby.settings.time = -1
        lobby.settings.minPlayers = -1
        lobby.settings.maxPlayers = -1
        
        XCTAssertEqual(lobby.settings.time, 6001)
        XCTAssertEqual(lobby.settings.maxPlayers, 10)
        XCTAssertEqual(lobby.settings.minPlayers, 3)
        
        //Change to valid values
        lobby.settings.time = 50
        lobby.settings.minPlayers = 5
        lobby.settings.maxPlayers = 15
        
        XCTAssertEqual(lobby.settings.time, 50)
        XCTAssertEqual(lobby.settings.maxPlayers, 15)
        XCTAssertEqual(lobby.settings.minPlayers, 5)
    }
    
    func test4_HostExists(){
        let lobby : Lobby = Lobby(host)
        
        //this should be done programmatically so if this fails the code messed up
        XCTAssertNotNil(lobby.host)
        
    }
    
    func test5_PlayerListContainsHost(){
        let lobby : Lobby = Lobby(host)
        
        XCTAssertEqual(lobby.playerList.count, 1)
    }
    
    func test6_InviteOrKickPlayerToLobbyList(){
        let lobby : Lobby = Lobby(host)
        let player : Profile = Profile(userName: "test", tag: "test")
        
        XCTAssertEqual(lobby.playerList.count, 1)
        
        lobby.lobbyInvite(player)
        
        XCTAssertEqual(lobby.playerList.count, 2)
        
        lobby.lobbyKick(player)
        
        XCTAssertEqual(lobby.playerList.count, 1)
    }
    
    func test7_ToggleReadyAndResetReady(){
        let lobby : Lobby = Lobby(host)
        let player : Profile = Profile(userName: "test", tag: "test")
        let player2 : Profile = Profile(userName: "test2", tag: "test2")
        
        lobby.lobbyInvite(player)
        lobby.lobbyInvite(player2)
        
        XCTAssertEqual(lobby.playerList[1].isReady, false)
        
        lobby.lobbyToggleReady(player)
        lobby.lobbyToggleReady(player2)
        lobby.lobbyToggleReady(host)
        
        XCTAssertTrue(lobby.playerList[0].isReady)
        XCTAssertTrue(lobby.playerList[1].isReady)

        lobby.lobbyResetReady()
        
        XCTAssertFalse(lobby.playerList[0].isReady)
        XCTAssertFalse(lobby.playerList[1].isReady)

    }
    
    func test8_JoinLobbyInvalidCode() {
        let profile = Profile(userName: "UserName", tag: "GamerTag")
        var lobby: Lobby? = nil
        do {
            lobby = try Lobby.lobbyJoinLobby(profile, "")
        } catch {
            
        }
        XCTAssertNil(lobby)
    }
    
    func test9_JoinLobbyValidCode() {
        let profile = Profile(userName: "UserName", tag: "GamerTag")
        var lobby: Lobby? = nil
        do {
           lobby = try Lobby.lobbyJoinLobby(profile, "1234")!
        } catch {
            
        }
        XCTAssertNotNil(lobby)
    }
}
