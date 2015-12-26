//
//  ViewController.swift
//  App_Patron_MVC_Completo
//
//  Created by User on 21/12/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //1
    //MARK: - VARIBALES LOCALES GLOBALES
    private var allAlbumesMusicales = [ICOAlbumModel]()
    private var currentAlbumMusicalData: (titulos: [String], valores: [String])? //OJO AQUI ES OPTIONAL
    private var currentAlbumIndice = 0

    //MARK: - IBOUTLET
    
    @IBOutlet weak var myTableViewMVC: UITableView!
    @IBOutlet weak var myToolBarMVC: UIToolbar!
    

    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //2 -> Apagamos la translucides de la barra de navegacion
        navigationController?.navigationBar.translucent = false
        currentAlbumIndice = 0
        
        
        //2.1 -> Obtener una lista de todos los Albumes a traves del API debemos recordar que el plan es utilizar el patron fachada de LibraryAPI en lugar de PersistencyManager directamente
        allAlbumesMusicales = ICOLibraryAPI.sharedInstance.getAlbumsMusicales()
        
        
        //2.2 -> Aqui es donde configuramos la TableView que es delegado y Receptor de DataSourse
        myTableViewMVC.delegate = self
        myTableViewMVC.dataSource = self
        myTableViewMVC.backgroundView = nil
        view.addSubview(myTableViewMVC!)
        
        //Metodo Auxiliar que carga el album actual en el lanzamiento de la aplicacion y previo que arranca en el indice 0 pues se nos enseña el primero de los objetos de nuestra libreria de Albumes musicales
        showDataForAlbumesMusicales(currentAlbumIndice)
        

    }

    
    //MARK: - UTILS O AUXILIARES
    //obtiene los datos del Album requerido de la serie de Abumes, cuando queramos presentar nuevos datos solo tenemos que llamar a ReloadData
    func showDataForAlbumesMusicales (albumIndice: Int){
        
        //1. Codigo defensivo es importante asegurarnos que el indice solicitado es inferior a la cantidad de Albumes
        if (albumIndice < allAlbumesMusicales.count && albumIndice > -1){
            
            //2. Traemos el albumMusical
            let album = allAlbumesMusicales[albumIndice]
            //guardar los datos de albumes para presentarlo posteriormente en el table View
            currentAlbumMusicalData = album.icoae_tableRepresentation()
            
        }else{
            currentAlbumMusicalData = nil
        }
        //3. tenemos los datos que necesitamos, vamos a refrescar nuestra tabla
        myTableViewMVC!.reloadData()
    }
    

}


//AMRK: - EXTENSIONES
extension ViewController: UITableViewDelegate{
    

    
}

extension ViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let albumData = currentAlbumMusicalData{
            return albumData.titulos.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let albumData = currentAlbumMusicalData{
            cell.textLabel?.text = albumData.titulos[indexPath.row]
            cell.detailTextLabel?.text = albumData.valores[indexPath.row]
        }
        return cell
    }    
}

