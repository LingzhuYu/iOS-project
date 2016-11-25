//
//  Menu.swift
//  ios-project
//
//  Created by Jason Cheung on 2016-10-31.
//  Copyright © 2016 Manjot. All rights reserved.
//
//  Description:
//  Main menu of the app, or the page the user will start on.
//  Here the user can create a lobby, join a lobby, and view their profile.

import Foundation

class Menu
{
    var currentProfile: Profile
    
    init() {
        // TODO
        currentProfile = Profile(userName: "LoginCredentials", tag: "GamerTag")
    }
    
    func menuJoinLobby(_ gameCode: String)
    {
        var lobby: Lobby? = nil
        
        do {
            try lobby = Lobby.lobbyJoinLobby(currentProfile, gameCode)!
        } catch Lobby.LobbyJoinErrors.LobbyFull {
            // Lobby is full, display appropriate message
        } catch {
            // default catch all other erros
        }
        
        if (lobby == nil) {
            return // lobby was not found
        } else {
            // TODO: change screen ( lobby )
        }
    }
    
    
}
