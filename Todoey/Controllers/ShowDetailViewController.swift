//
//  ShowDetailViewController.swift
//
//  Created by Sergio Arizaga
//

import UIKit
import CoreData

class ShowDetailViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var backButtonText = ""
    var showDict = ["":""]
    var favorites = [Favorite]()
    var isFavorite = false
    var favoriteIndex = 0
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageBlur: UIImageView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var sinopsisLabel: UILabel!
    @IBOutlet weak var imdbButton: UIButton!
    @IBOutlet weak var imdbIcon: UIImageView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    @IBAction func favShow(_ sender: Any) {
        if isFavorite {
            let alert = UIAlertController(title: "¿Seguro que quieres eliminar de favoritos?", message: "", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Aceptar", style: .default) { (action) in
                self.deleteFavorite(favorite: self.favorites[self.favoriteIndex])
                let backButton = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(self.favShow))
                self.navigationController?.navigationBar.topItem?.rightBarButtonItem = backButton
                alert.dismiss(animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "Cancelar", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(accept)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            let newFavorite = Favorite(context: self.context)
            newFavorite.title = showDict["title"]
            newFavorite.imageOriginal = showDict["imageOriginal"]
            newFavorite.image = showDict["image"]
            newFavorite.summary = showDict["sinopsis"]
            newFavorite.idMovie = showDict["idMovie"]
            newFavorite.genres = showDict["genres"]
            newFavorite.imdb = showDict["imdbURL"]
            self.favorites.append(newFavorite)
            self.saveFavorite()
            let backButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(self.favShow))
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem = backButton
            
            let alert = UIAlertController(title: "Añadido a tus favoritos", message: "", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Aceptar", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(accept)
            present(alert, animated: true, completion: nil)
            
        }
    }
    @IBAction func showIMDB(_ sender: Any) {
        if let url = URL(string: showDict["imdbURL"]!) {
            UIApplication.shared.open(url)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.imageBlur.alpha = 1.0
        }) { (success: Bool) in UIImageView.animate(withDuration: 0.7, animations: {
            self.image.alpha = 1.0
        })}
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = showDict["title"]!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.image.alpha = 0.0
        self.imageBlur.alpha = 0.0
        let backButton = UIBarButtonItem()
        backButton.title = backButtonText
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        imageBlur.setImageFromUrl(ImageURL: showDict["imageOriginal"]!)
        image.setImageFromUrl(ImageURL: showDict["imageOriginal"]!)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageBlur.addSubview(blurEffectView)
        if showDict["imdbURL"]! == "" || showDict["imdbURL"]! == "<null>" {
            imdbButton.alpha = 0
            imdbIcon.alpha = 0
        } else {
            imdbButton.alpha = 1
            imdbIcon.alpha = 1
        }
        
        sinopsisLabel.text = showDict["sinopsis"]!
        genresLabel.text = showDict["genres"]!
        loadFavorites()
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
    }
    
    func loadFavorites() {
        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do{
            favorites = try context.fetch(request)
            var counter = 0
            if favorites.count > 0 {
                for favorite in favorites {
                    if favorite.idMovie! == showDict["idMovie"]! {
                        isFavorite = true
                        favoriteIndex = counter
                    }
                    counter += 1
                }
                if self.isFavorite {
                    DispatchQueue.main.async {
                        let backButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(self.favShow))
                        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = backButton
                    }
                } else {
                    DispatchQueue.main.async {
                        let backButton = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(self.favShow))
                        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = backButton
                    }
                }
                } else {
                    DispatchQueue.main.async {
                        let backButton = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(self.favShow))
                        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = backButton
                    }
                }
        } catch {
            print("Error loading categories \(error)")
        }
    }

    
}







