//
//  SubController.swift
//  Kuramin
//
//  Created by MD. Zahed on 26/03/2023.
//

import Foundation

class SubController {
    
    
    func send_card_to_next_player(controller: Controller, player: Player, cardIndex: Int) {
        
        var prevLobby = controller.lobbyService.previousLobbyNullable
        
        
        let cardToRemove = player.cards[cardIndex].toString()
        
        player.removeCardAt(index: cardIndex)
        
        
        for (index, crrP) in prevLobby!.players!.enumerated() {
            
            if crrP.pid == player.id {
                prevLobby!.players![index].cards = player.getCardsInStr()
            }
        }
        
        prevLobby!.whoseTurn = player.nextPlayer!.id
        prevLobby!.cardOnBoard = cardToRemove
        
        
        
        
        controller.lobbyService.updateLobby(lobbyNullable: prevLobby!)

    }
    
    
}
