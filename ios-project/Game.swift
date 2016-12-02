//
//  Game.swift
//  ios-project
//
//  Created by Lydia Yu on 2016-10-17.
//  Copyright © 2016 Manjot. All rights reserved.
//

import Foundation

public class Game{
    var mapID: Int!
    var settings: Dictionary<String, String>!
    var currentPlayers: [Player]
    var lobby: Lobby!
    //var lobbySettings = lobby.getSetting()
    
    var prepareTime: Int!
    var gameTime: Int!
    var elapsedTime: Int!
    //var result: [Player : String]
    var OutOfBoundsTimer: Timer!
    
    var gameRunning = false
    let gameBackgroundQueue = DispatchQueue(label: "game.queue",
                                            qos: .background,
                                            target: nil)
    
    //for testing
    public var triggerPlayerCount = false
    public var triggerGameTime = false
    public var triggerZeroHiders = false
    public var triggerHostCancelled = false
    var hidersCount = 0
    
    public enum errorType: Error {
        case negExpGain
    }
    
    //start game
    init(players: [Player], gameTime: Int){
        
        currentPlayers = players
        self.gameTime = gameTime;
    }
    
    
    func startGame(){
        gameRunning = true
        
        gameBackgroundQueue.async {
            self.gameLoop()
        }
        
        
        //        print("out of game")
        quitGame()
    }
    
    func gameLoop() {
        print("time incremented")
        //TODO: implement function to update game variables
        
        // check if game should end
        let currentPlayerCount = self.getCurrentPlayersCount()
        //            let currentHidersCount = getCurrentHidersCount() // roles not implemented, using workaround below
        let hostCancelled = false // not implemented, need multithreading?
        //                let outOfTime = checkOutOfTime(currentTime: (currentTime))
        
        // for testing
        let currentHidersCount = self.hidersCount
        
        //                triggerGameTime = outOfTime
        self.triggerPlayerCount = currentPlayerCount <= 1 ? true : false
        self.triggerZeroHiders = currentHidersCount == 0 ? true : false
        self.triggerHostCancelled = hostCancelled
        // end for testing
        
        //                if (currentPlayerCount <= 1 || currentHidersCount == 0 || outOfTime || hostCancelled){
        if (currentPlayerCount <= 1 || currentHidersCount == 0 || hostCancelled){
            //            self.gameRunning = false
        } else {
            //                    currentTime += 1
            sleep(1)
        }
        
        self.loopGuard()
    }
    
    func loopGuard(){
        print("game running: \(gameRunning)" )
        if (gameRunning){
            sleep(3)
            gameLoop()
        }
    }
    func isGameRunning() -> Bool {
        return gameRunning
    }
    
    func getMapID() -> Int{
        return mapID
    }
    
    func getSettings() -> Dictionary<String, String>{
        return settings
    }
    
    func getPrepareTime() -> Int{
        return prepareTime
    }
    
    func getGameTime() -> Int{
        return gameTime
    }
    
    func getCurrentPlayers() -> [Player]{
        return currentPlayers
    }
    
    func setMap(mapid : Int){
        mapID = mapid
    }
    
    func setSettings(lobbySettings: Dictionary<String, String>){
        settings = lobbySettings
    }
    
    
    func getCurrentPlayersCount() -> Int{
        return currentPlayers.count;
    }
    func getCurrentHidersCount() -> Int{
        var count = 0;
        
        // players dont have roles yet!
        
//        for player in players{
//            if(player.role is Hider){
//                count += 1
//            }
//        }
        
        return count;
    }
    
    //for testing
    func setHidersCount(hiders: Int) {
        hidersCount = hiders
    }
    
    //for testing
    func setExp(player: Player, exp: Int) throws {
        if (exp < 0){
            throw errorType.negExpGain
        }
    }
    
    
    func checkOutOfTime(currentTime: Int) -> Bool{
        return currentTime >= gameTime
    }
    
    func quitGame(){
        //send alert that game is over
        //save stuff
        //reward player
        //return to lobby (killing game)
    }
    
    func rewardPlayer(_ Player : Player){
        
    }
    
    
    func setResult(players: Player){
    
    }
    
    /*
     func testOutOfBounds(_: player,_ map)-> String{
     var x = player.location.getX()
     var y = player.location.getY()
     if(x > map.XUpperBoundary || y > map.YUpperBoundary || x < map.XLowerBoundary || y < map.YLowerBoundary){
     player.OutOfBounds = true
     player.BeginTimingForOutOfBounds()
     return "Out of bounds"
     
     }
     }
     
     */
    
    
}

