//
//  ICOLibraryAPI.swift
//  App_Patron_MVC_Completo
//
//  Created by User on 24/12/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit

class ICOLibraryAPI: NSObject {
    
    
    //MARK: - VARIABLES LOCALES GLOBALES
    
    private let persistencyManager: ICOPersistencyManager
    private let httpCLient: HTTPClient
    private let IsOnline: Bool // Determina si el servidor debe actualizarse con los cambios en la lista de Albumes, como albumes añadios o eliminados
    
    //MARK: - INIT 
    //Inicializamos la clase abstracta
    
    override init() {
        persistencyManager = ICOPersistencyManager()// Alloc init
        httpCLient = HTTPClient()
        IsOnline = false // es una prueba aqui no hay conexion con ningun servidor
        super.init()
    }
    
    
    //MARK: - SINGLETON
    //1 -> Creamos una variable de clase como un variable de tipo computarizada (Metodos en OBJC)
    class var sharedInstance : ICOLibraryAPI {
        //2 -> Anidamos dentro de la variable de clase una estructura llamada Singleton
        struct Singleton {
            //3 -> envuelve una constante estatica, esto quiere decir que esta constante solo existe una vez y son implicitamente perezosos, lo que se conluye que no se crea sino hasta que sea necesario, y solo se creará una unica vez, el inicializador no se llama de nuevo una vez que se ha creado una instancia
            static let instance = ICOLibraryAPI()
        }
        //4 -> devuelve la propiedadde tipo computarizado
        return Singleton.instance
    }
    
    
    //MARK: - METODOS DE PERSISTENCYMANAGER
    
    //3 -> Debemos añadir 3 metodos que nos permitiran obtener, añadir y borrar albumes
    //MARK: - UTILS
    func getAlbumsMusicales () -> [ICOAlbumModel]{
        
        return persistencyManager.getAlbumsMusicales()
    }
    
    func addAlbumsMusicales (album: ICOAlbumModel, indice: Int){
        
        persistencyManager.addAlbumsMusicales(album, indice: indice)
            if IsOnline{
                httpCLient.postRequest ("/api/addAlbumsMusicales", body: album.description)
        }
        
    }
    
    func deleteAlbumsMusicales (indice: Int){
        
        persistencyManager.deleteAlbumsMusicales(indice)
        if IsOnline{
            httpCLient.postRequest("/api/deleteAlbumsMusicales", body: "\(indice)")
            
        }
    }
}
