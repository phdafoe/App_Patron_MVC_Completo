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
    private var indiceAlbumActual = 0

    //MARK: - IBOUTLET
    @IBOutlet weak var myTableViewMVC: UITableView!
    @IBOutlet weak var myToolBarMVC: UIToolbar!
    @IBOutlet weak var miPropioDesplazadorHorizontal: ICOHorizontalScroller!

    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //2 -> Apagamos la translucides de la barra de navegacion
        navigationController?.navigationBar.translucent = false
        indiceAlbumActual = 0
        
        
        //2.1 -> Obtener una lista de todos los Albumes a traves del API debemos recordar que el plan es utilizar el patron fachada de LibraryAPI en lugar de PersistencyManager directamente
        allAlbumesMusicales = ICOLibraryAPI.sharedInstance.getAlbumsMusicales()
        
        
        //2.2 -> Aqui es donde configuramos la TableView que es delegado y Receptor de DataSourse
        myTableViewMVC.delegate = self
        myTableViewMVC.dataSource = self
        

        //myTableViewMVC.backgroundView = nil
        //view.addSubview(myTableViewMVC!)
        
        
        
        
        //2.3 ->Metodo Auxiliar que carga el album actual en el lanzamiento de la aplicacion y previo que arranca en el indice 0 pues se nos enseña el primero de los objetos de nuestra libreria de Albumes musicales
        showDataForAlbumesMusicales(indiceAlbumActual)
        
        
        //=====================****************
        //Carga de PATRON MEMENTO
        
        //Pero que carga el estado guardado previamente cuando se inicia la App, (NOTIFICACION)
        cargaDelEstadoPrevio()
        //=====================****************
        
        
        //DELEGADO DE SCROLL HORIZONTAL
        miPropioDesplazadorHorizontal.icoDelegate = self
        // Metodo de recarga de las imagenes
        recargaScrollerHorizontal()
        
        
        
        
        //=====================****************
        //PATRON NOTIFICACION CARGA DE DATOS
        
        //Cuando la App va a entrar en background el ViewController va a guardar automaticamente el estado actual de "salvarEstadoActual"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "salvarEstadoActual", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        //=====================****************
        
        //print("\(NSBundle.mainBundle())")
        

    }
    //=====================****************
    //PATRON NOTIFICACION CARGA DE DATOS
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //=====================****************
    
    

    
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
    
    
    
    
    //Recarga de Scroller
    //este metodo carga datos a traves de ICOLibraryAPI y selecciona la vista que se muestra actualmente en funcion del valor actual si el indice actual es inferior a "0" lo que significa que no se ha seleccionado ninguna vista a continuacion se muestra el primer album de la lista de lo contrario se muestra el ultimo
    func recargaScrollerHorizontal(){
        
        allAlbumesMusicales = ICOLibraryAPI.sharedInstance.getAlbumsMusicales()
        if indiceAlbumActual < 0 || indiceAlbumActual >= allAlbumesMusicales.count{
            indiceAlbumActual = allAlbumesMusicales.count
        }
        
        miPropioDesplazadorHorizontal.recargaDatosDelHorizontalScroller()
        showDataForAlbumesMusicales(indiceAlbumActual)
    }
    
    
    
    
    //=====================**************** PATRON MEMENTO **************=========================//
    
    func salvarEstadoActual(){
        //1 -> cuando el usuario sale de la aplicacion y luego vuelve otra vez, lo que quiere es que sea el punto exacto en donde se dejo lo que estaba viendo e invocaremos a nuestro NSUSerDefault
        NSUserDefaults.standardUserDefaults().setInteger(indiceAlbumActual, forKey: "currentAlbumMusicalData")
        
    }
    
    
    func cargaDelEstadoPrevio(){
        
        indiceAlbumActual = NSUserDefaults.standardUserDefaults().integerForKey("currentAlbumMusicalData")
        showDataForAlbumesMusicales(indiceAlbumActual)
    }
    
    
    
    //=====================**************** PATRON MEMENTO **************=========================//
    
    

}






//MARK: - EXTENSIONES
extension ViewController: UITableViewDelegate{
    

    
}

extension ViewController: UITableViewDataSource{

    //METODOS DE DATA SOURCE
    
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
        
        /*
        let albumData = currentAlbumMusicalData

        cell.textLabel?.text = albumData!.titulos[indexPath.row]
        cell.detailTextLabel?.text = albumData!.valores[indexPath.row]
        */
        
        
        return cell
    }
    
}





extension ViewController: ICOHorizontalScrollerDelegate{
    
    //1 aqui nos devuelve el numero de vistas en el escroller horizontal dependiendo del numero de registros en el array allAlbumesMusicales
    func numeroVistasEnHorizontalScroller(scroller: ICOHorizontalScroller) -> Int {
        
        return allAlbumesMusicales.count
    }
    
    
    //2 aqui se crea un nuevo "ICOalbumView" -> entonces establecemos como destaca su seleccion o no?
    func vistaPorIndiceEnHorizontalScroller(scroller: ICOHorizontalScroller, indice: Int) -> UIView {
        
        //1 -> primero cogemos el abum musical del indice
        let albumMusical = allAlbumesMusicales[indice]
        
        let vistaAlbumMusical = ICOAbumView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), caratulaAlbum: albumMusical.urlCaratula!)
        
        if indiceAlbumActual == indice{
            
            vistaAlbumMusical.highligthAlbum(didHighlightView: true)
            
        }else{
            
            vistaAlbumMusical.highligthAlbum(didHighlightView: false)
        }
        
        return vistaAlbumMusical
    }
    
    
    
    func clickEnAlgunaVistaPorIndiceEnHorizontalScroller(scroller: ICOHorizontalScroller, indice: Int) {
        
        //1 -> primero cogemos el album musical seleccionado previamente y anulamos la seleccion es decir si marca el "highligthAlbum"
        let vistaAlbumMusicalPrevio = scroller.vistaDelIndiceDelObjeto(indiceAlbumActual) as! ICOAbumView
        
        vistaAlbumMusicalPrevio.highligthAlbum(didHighlightView: false)
        
        //2 -> Guardamos el indice de la cubierta en la que acabamos de hacer click
        indiceAlbumActual = indice
        
        //3 -> coge la portada del album seleccionado por tanto en ese momento lo resalta
        let vistaAlbumMusicalSeleccionado = scroller.vistaDelIndiceDelObjeto(indiceAlbumActual) as! ICOAbumView
        vistaAlbumMusicalSeleccionado.highligthAlbum(didHighlightView: true)
        
        //4 -> visualiza los datos para el nuevo album en la vista de tabla SINCRONIZACION DE DATOS VISTA/TABLA DE DATOS
        showDataForAlbumesMusicales(indice)
    }
    
    
    func vistaInicialPorIndice(scrolle: ICOHorizontalScroller) -> Int {
        
        return indiceAlbumActual
    }
    
    
    /************==================================*******************/
    
    //CUANDO LLEGUEMOS AQUI DEBEMOS RECARGAR EL SCROLLER OJOOOO func recargaScrollerHorizontal y lo memtemos en el ViewDidLoad
    
    /************==================================*******************/
}



