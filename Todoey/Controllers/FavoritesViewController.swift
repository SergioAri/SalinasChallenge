//
//  FavoritesViewController.swift
//  
//
//  Created by Sergio Arizaga
//

import UIKit
import CoreData

class FavoritesViewController: UITableViewController {
    
    var favorites = [Favorite]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Favorite Shows";
        
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250.0, height: 44.0))
        let label = UILabel(frame: CGRect(x: 5, y: 0.0, width: 250.0, height: 44.0))
        label.text = "Favorite Shows"
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.right
        label.font = label.font.withSize(30)
        label.textAlignment = NSTextAlignment.left
        customView.addSubview(label)
        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = leftButton
        
        loadFavorites()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        if favorites.count > 0 {
            if let imageURL = favorites[indexPath.row].image {
                if let image = cell.viewWithTag(1) as? UIImageView {
                    image.setImageFromUrl(ImageURL: imageURL)
                }
            }
            if let title = favorites[indexPath.row].title {
                if let label = cell.viewWithTag(2) as? UILabel {
                label.text = title
                }
            }
        }
        return cell
    }

    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if favorites.count > 0 {
            let destinationVC = storyboard!.instantiateViewController(withIdentifier: "showDetail") as! ShowDetailViewController
            let showDict = ["title":self.favorites[indexPath.row].title!, "sinopsis":self.favorites[indexPath.row].summary!, "genres":self.favorites[indexPath.row].genres!, "imdbURL":self.favorites[indexPath.row].imdb!, "imageOriginal":self.favorites[indexPath.row].imageOriginal!, "image":self.favorites[indexPath.row].image!, "idMovie":self.favorites[indexPath.row].idMovie!]
            destinationVC.backButtonText = self.title!
            destinationVC.showDict = showDict
            self.navigationController!.pushViewController(destinationVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let alert = UIAlertController(title: "¿Seguro que quieres eliminar de favoritos?", message: "", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Aceptar", style: .default) { (action) in
                self.deleteFavorite(favorite: self.favorites[indexPath.row])
                self.favorites.remove(at: indexPath.row)
                if indexPath.row == 0 {
                    tableView.reloadData()
                } else {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
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

    }
    
    //MARK: - Data Manipulation Methods
    
    func loadFavorites() {
        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do{
            favorites = try self.context.fetch(request)
            print(favorites.count)
            tableView.reloadData()

        } catch {
            print("Error loading favorites \(error)")
        }
        
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
    
}
