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
        
        
        /****************=========================**********************/
        
        //PATRON NOTIFICACION
        //en este otro lado de la ecuacion el "OBSERVADOR" recibe -> cada vez que un ICOAlbumView notifique un mensaje "ICODescargaImagenesNotificacion" ya que ICOLibraryAPI se ha dado de alta como observador de dicha notificacion en el init, entonces ICOLIbraryAPI llama a "descargaDeImagenes" en respuesta
        
        // Siempre hay que dar de baja la notificacion cuando se cancela la asignacion de su clase, si esto no se hace la App se bloquea
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "descargaDeImagenes:",
            name: "ICODescargaImagenesNotificacion",
            object: nil)

        /****************=========================**********************/
   
    }
    
    //MARK: - UTILS
    //probablemente una mejor idea seria guardar las portadas de los discos localmente para que la App no tenga que descargarlas nuevamente
    //DEBEMOS HACER ESO EN ICOPersistencyManager
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //
    func descargaDeImagenes(notificacion:NSNotification){
        
        //1 esta funcion se ejecuta a traves de notificaciones y por tanto recibe como parametro de entrada la notificacion, el UIImageView y la urlCartula se recuperan de la notificaion
        let userInfo = notificacion.userInfo as! [String: AnyObject]
        let imageView = userInfo["imageView"] as! UIImageView?
        let urlCaratula = userInfo["urlCaratula"] as! String
        
        //2 aqui se recupera la imagen de ICOPersistencyManager si se ha descargado previamente
        if let imageViewDesempaquetada = imageView{
            imageViewDesempaquetada.image = persistencyManager.getImagenesSalvadasLocalmente(urlCaratula.lastPathComponent)
            if imageViewDesempaquetada.image == nil{
                //3 si la imagen no se ha descargado iniciamos un hilo secundario
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    let imagenesDescargadas = self.httpCLient.downloadImage(urlCaratula as String)
                    
                    //4 Llamamos la cola Principal cuando la descarga se haya "completado" debe mostrar la imagen en la ImageView y utiliza el persistencyManager para guardarlo localmente
                    
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        imageViewDesempaquetada.image = imagenesDescargadas
                        self.persistencyManager.salvarLocalmenteImagenes(imagenesDescargadas, fileName: urlCaratula.lastPathComponent)
                    })
                    
                })
            }
        }
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


extension String {
    var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
}
