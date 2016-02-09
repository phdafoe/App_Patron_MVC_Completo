//
//  ICOAlbumExtension.swift
//  App_Patron_MVC_Completo
//
//  Created by User on 26/12/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import Foundation

extension ICOAlbumModel{
    
    //observemos que precede las letras ae (Album_Extesion) -> convenios como estos evitaran colisiones con los metodos
    func icoae_tableRepresentation() -> (titulos: [String], valores: [String]){
        
        return (["Artista", "Album Musical", "Genero", "Año"], [artista!, tituloAlbum!, generoMusical!, anyoDisco!])
    }
    
}
