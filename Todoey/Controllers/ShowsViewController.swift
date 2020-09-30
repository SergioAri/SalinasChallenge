//
//  ShowsViewController.swift
//  
//
//  Created by Sergio Arizaga
//

import UIKit
import CoreData

class ShowsViewController: UITableViewController {
    
    var showsManager = ShowsManager()
    var showList = [Dictionary<String, Any>]()
    var favorites = [Favorite]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80.0
        loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "TV Shows";
        
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 150.0, height: 44.0))
        let label = UILabel(frame: CGRect(x: 5, y: 0.0, width: 150.0, height: 44.0))
        label.text = "TV Shows"
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.right
        label.font = label.font.withSize(30)
        label.textAlignment = NSTextAlignment.left
        customView.addSubview(label)
        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = leftButton
        showsManager.fetchData(completion: populateData)
    }
    
    //MARK: - TableView Datasource Methods
            
    func populateData(array: [Dictionary<String, Any>]?, error: Error?) {
        if array == nil {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Ocurrió un error al consultar el servicio.\n¿Quieres intentar nuevamente?", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Intentar de nuevo", style: .default) { [self] (action) in
                    showsManager.fetchData(completion: self.populateData)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            self.showList = array!
                DispatchQueue.main.async {
                        self.tableView.reloadData()
                }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showList.count > 0 {
            return showList.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell", for: indexPath)
        if showList.count > 0 {
                print(show)
                if let images = showList[indexPath.row]["image"] as? Dictionary<String, Any> {
                    if let imageURL = images["medium"] as? String {
                        if let image = cell.viewWithTag(1) as? UIImageView {
                            image.setImageFromUrl(ImageURL: imageURL)
                        }
                    }
                }
                if let title = showList[indexPath.row]["name"] as? String {
                    if let label = cell.viewWithTag(2) as? UILabel {
                    label.text = title
                    }
                }
        }
        return cell
    }

    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var genres = ""
        var sinopsis = ""
        var detailImageURL = ""
        var imageURL = ""
        var imdbURL = ""
        var idMovie = ""
        var title = ""

        tableView.deselectRow(at: indexPath, animated: true)
        if let images = showList[indexPath.row]["image"] as? Dictionary<String, Any> {
            if let imageURL = images["original"] as? String {
                detailImageURL = imageURL
            }
            if let imageURL2 = images["medium"] as? String {
                imageURL = imageURL2
            }
        }
        if let summary = showList[indexPath.row]["summary"] as? String {
            sinopsis = summary
        }
        if let name = showList[indexPath.row]["name"] as? String {
            title = name
        }
        if let idM = showList[indexPath.row]["id"] as? Int {
            idMovie = "\(idM)"
        }
        if let externals = showList[indexPath.row]["externals"] as? Dictionary<String, Any> {
            if let imdb = externals["imdb"] as? String {
                imdbURL = "https://www.imdb.com/title/"+imdb
            }
        }
        if let genresArray = showList[indexPath.row]["genres"] as? Array<String> {
            genres = genresArray.joined(separator: ", ")
        }
        let destinationVC = storyboard!.instantiateViewController(withIdentifier: "showDetail") as! ShowDetailViewController
        let showDict = ["title":title, "sinopsis":sinopsis, "genres":genres, "imdbURL":imdbURL, "imageOriginal":detailImageURL, "image":imageURL, "idMovie":idMovie]
        destinationVC.backButtonText = self.title!
        destinationVC.showDict = showDict
        self.navigationController!.pushViewController(destinationVC, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let id = showList[indexPath.row]["id"] as! Int
        var isFavorite = false
        var counter = 0
        var favoriteIndex = 0
        for favorite in favorites {
            if favorite.idMovie == "\(id)" {
                isFavorite = true
                favoriteIndex = counter
            }
            counter += 1
        }
        if isFavorite {
                    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                        let alert = UIAlertController(title: "¿Seguro que quieres eliminar de favoritos?", message: "", preferredStyle: .alert)
                        let accept = UIAlertAction(title: "Aceptar", style: .default) { (action) in
                            self.deleteFavorite(favorite: self.favorites[favoriteIndex])
                            alert.dismiss(animated: true, completion: nil)
                        }
                        let cancel = UIAlertAction(title: "Cancelar", style: .default) { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(accept)
                        alert.addAction(cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                    return [delete]
                } else {
                    let favorite = UITableViewRowAction(style: .default, title: "Favorite") { [self] (action, indexPath) in
                        let newFavorite = Favorite(context: self.context)
                            if let images = showList[indexPath.row]["image"] as? Dictionary<String, Any> {
                                if let imageURL = images["original"] as? String {
                                    newFavorite.imageOriginal = imageURL
                                }
                                if let imageURL2 = images["medium"] as? String {
                                    newFavorite.image = imageURL2
                                }
                            }
                            if let name = showList[indexPath.row]["name"] as? String {
                                newFavorite.title = name
                            }
                            if let id = showList[indexPath.row]["id"] as? Int {
                                newFavorite.idMovie = "\(id)"
                            }
                            if let summary = showList[indexPath.row]["summary"] as? String {
                                newFavorite.summary = summary
                            }
                            if let externals = showList[indexPath.row]["externals"] as? Dictionary<String, Any> {
                                if let imdb = externals["imdb"] as? String {
                                    newFavorite.imdb = "https://www.imdb.com/title/"+imdb
                                }
                            }
                            if let genresArray = showList[indexPath.row]["genres"] as? Array<String> {
                                newFavorite.genres = genresArray.joined(separator: ", ")
                            }
                            self.favorites.append(newFavorite)
                            self.saveFavorite()
                            let alert = UIAlertController(title: "Añadido a tus favoritos", message: "", preferredStyle: .alert)
                            let accept = UIAlertAction(title: "Aceptar", style: .default) { (action) in
                                alert.dismiss(animated: true, completion: nil)
                            }
                            alert.addAction(accept)
                            present(alert, animated: true, completion: nil)
                    }
                    favorite.backgroundColor = UIColor.green
                    return [favorite]
                }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveFavorite() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
            let alert = UIAlertController(title: "Hubo un problema al guardar este show de TV.\n¿Quieres intentar nuevamente?", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Intentar de nuevo", style: .default) { (action) in
                
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        tableView.reloadData()
    }
    
    func deleteFavorite(favorite: Favorite) {
        context.delete(favorite)
        do {
            try context.save()
        } catch {
            print("Error saving favorite \(error)")
            let alert = UIAlertController(title: "Hubo un problema al borrar este show de TV.\n¿Quieres intentar nuevamente?", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Intentar de nuevo", style: .default) { (action) in
                
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
        tableView.reloadData()
    }
    
    func loadFavorites() {
        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do{
            favorites = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
    }
    
}

//MARK: - UIImageViewDonwload

extension UIImageView {
    func setImageFromUrl(ImageURL :String) {
       URLSession.shared.dataTask( with: NSURL(string:ImageURL)! as URL, completionHandler: {
          (data, response, error) -> Void in
          DispatchQueue.main.async {
             if let data = data {
                self.image = UIImage(data: data)
             }
          }
       }).resume()
    }
}
