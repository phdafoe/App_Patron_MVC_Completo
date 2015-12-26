//
//  ICOAlbumExtension.swift
//  App_Patron_MVC_Completo
//
//  Created by User on 26/12/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import Foundation

extension ICOAlbumModel{
    func icoae_tableRepresentation() -> (titulos: [String], valores: [String]){
        return (["Artista", "Album Musical", "Genero", "Año"], [artista!, tituloAlbum!, generoMusical!, anyoDisco!])
    }
}
