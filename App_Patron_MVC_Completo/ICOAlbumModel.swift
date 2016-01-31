//
//  ICOAlbumModel.swift
//  App_Patron_MVC_Completo
//
//  Created by User on 21/12/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit

class ICOAlbumModel: NSObject {
    
    //VARIABLES 
    var tituloAlbum: String?
    var artista: String?
    var generoMusical: String?
    var urlCaratula: String?
    var anyoDisco:String?
    
    
    //Inicializador o constructor designado
    // este codigo crea una inicializacion para el ICOAlbumModel
    init(aTituloAlbum: String, aArtista:String, aGeneroMusical:String, aUrlCaratula:String, aAnyoDisco:String) {
        super.init()
        self.tituloAlbum = aTituloAlbum
        self.artista = aArtista
        self.generoMusical = aGeneroMusical
        self.urlCaratula = aUrlCaratula
        self.anyoDisco = aAnyoDisco
    }
    
    //El metodo description devuelve una representacion de cadena de atributos de ICOAlbumModel
    override var description: String{
        return "tituloAlbum: \(tituloAlbum)" + "artista: \(artista)" + "generoMusical: \(generoMusical)" + "urlCaratula: \(urlCaratula)" + "anyoDisco: \(anyoDisco)"
    }
   

}
