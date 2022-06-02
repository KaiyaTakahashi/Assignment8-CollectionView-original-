//
//  ViewController.swift
//  Assignment8
//
//  Created by Kaiya Takahashi on 2022-05-28.
//

import UIKit

private var menus: [Restaurant] = [
    Restaurant(country: Restaurant.Country.japan, name: "Minami", description: "Sushi Restaurant", price: "$$", image: UIImage(named: "Japanese")!),
    Restaurant(country: Restaurant.Country.japan, name: "Nobu", description: "Sushi Restaurant", price: "$$$$", image: UIImage(named: "Japanese2")!),
    Restaurant(country: Restaurant.Country.japan, name: "Japanese 3", description: "Sushi Restaurant", price: "$$$$", image: UIImage(named: "Japanese2")!),
    Restaurant(country: Restaurant.Country.china, name: "Egg fried rice", description: "fried rice with eggs", price: "$", image: UIImage(named: "Chinese")!),
    Restaurant(country: Restaurant.Country.korea, name: "Korean BBQ", description: "very spicy", price: "$$", image: UIImage(named: "Korean")!),
    Restaurant(country: Restaurant.Country.indian, name: "Curry", description: "spicy", price: "$", image: UIImage(named: "Indian")!),
    Restaurant(country: Restaurant.Country.british, name: "Cheers Mate", description: "Chinese and Pizza", price: "$", image: UIImage(named: "British")!),
    Restaurant(country: Restaurant.Country.french, name: "Mercy", description: "anything", price: "$$$", image: UIImage(named: "French")!),
    Restaurant(country: Restaurant.Country.italian, name: "Bonapetito", description: "pizza", price: "$$$", image: UIImage(named: "Italian")!),
    Restaurant(country: Restaurant.Country.spanish, name: "Ola", description: "famous for paella", price: "$$", image: UIImage(named: "Spanish")!),
    Restaurant(country: Restaurant.Country.american, name: "McDonald", description: "burger", price: "$", image: UIImage(named: "American")!),
    Restaurant(country: Restaurant.Country.mexican, name: "Taco Bell", description: "Taco Restaurant", price: "$", image: UIImage(named: "Mexican")!),
]

private var foodTypes: [(country: String, enumCountry: Restaurant.Country, isTapped: Bool)] = [
    ("Japanese", Restaurant.Country.japan, false),
    ("Chinese", Restaurant.Country.china, false),
    ("Korea", Restaurant.Country.korea, false),
    ("Indian", Restaurant.Country.indian, false),
    ("British", Restaurant.Country.british, false),
    ("French", Restaurant.Country.french, false),
    ("Italian", Restaurant.Country.italian, false),
    ("Spanish", Restaurant.Country.spanish, false),
    ("American", Restaurant.Country.american, false),
    ("Mexican", Restaurant.Country.mexican, false),
    
]

class ViewController: UIViewController {
    
    enum MenuSection: CaseIterable {
        case main
    }
    
    @IBOutlet var typeCollectionView: UICollectionView!
    @IBOutlet var menuCollectionView: UICollectionView!
    
    var filteredMenus: [Restaurant] = []
    var menuCollectionViewDataSource: UICollectionViewDiffableDataSource<MenuSection, Restaurant>!
    var filteredSnapshot: NSDiffableDataSourceSnapshot<MenuSection, Restaurant> {
        var snapshot = NSDiffableDataSourceSnapshot<MenuSection, Restaurant>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredMenus)
        return snapshot
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTypeCellLayout()
        setupMenuCellLayout()
        generateDataSourceForMenu()
    }

    func setupTypeCellLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: typeCollectionView.frame.width / 3, height: typeCollectionView.frame.height / 2)
        layout.sectionInset = UIEdgeInsets(
            top: 5,
            left: 5,
            bottom: 5,
            right: 5
        )
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 100
        layout.minimumLineSpacing = 10
        typeCollectionView.collectionViewLayout = layout
    }
    
    func setupMenuCellLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: menuCollectionView.frame.height/30,
            left: menuCollectionView.frame.width * 0.03,
            bottom: menuCollectionView.frame.height/30,
            right: menuCollectionView.frame.width * 0.03
        )
        layout.itemSize = CGSize(width: menuCollectionView.frame.width * 0.45, height: menuCollectionView.frame.height / 3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = menuCollectionView.frame.width * 0.04
        menuCollectionView.collectionViewLayout = layout
    }
    
    private func generateDataSourceForMenu() {
        menuCollectionViewDataSource = UICollectionViewDiffableDataSource<MenuSection, Restaurant>(collectionView: menuCollectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            let cell = self.menuCollectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCollectionViewCell
            cell.configure(itemIdentifier, with: self.menuCollectionView)
            cell.backgroundColor = .white
            return cell
        })
     
        menuCollectionViewDataSource.apply(filteredSnapshot)
         }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = typeCollectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as! TypeCollectionViewCell
        let foodType = foodTypes[indexPath.item]
        cell.configure(foodType.country, foodType.isTapped)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // updata my model
        let cell = collectionView.cellForItem(at: indexPath) as! TypeCollectionViewCell

        if collectionView == typeCollectionView {
            addOrRemoveMenu(at: cell, country: foodTypes[indexPath.item].enumCountry, indexPath)
        }
        // update my view
        menuCollectionViewDataSource.apply(filteredSnapshot, animatingDifferences: true)
    }
    
    func addOrRemoveMenu(at cell: TypeCollectionViewCell, country: Restaurant.Country, _ indexPath: IndexPath){
        if foodTypes[indexPath.item].isTapped == false {
            for i in 0..<menus.count {
                if menus[i].country == country {
                    filteredMenus.append(menus[i])
                }
            }
            cell.backgroundColor = .gray
        } else {
            filteredMenus = filteredMenus.filter { (menu) -> Bool in
                menu.country != country
            }
            cell.backgroundColor = .white
        }
        // change data
        foodTypes[indexPath.item].isTapped.toggle()
    }
}

