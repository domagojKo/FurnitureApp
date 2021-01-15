//
//  Furniture.swift
//  AR Furniture
//
//  Created by Domagoj Kolaric on 28.12.2020..
//

import Foundation

struct Furniture {
    var image: UIImage
    var furnitureDae: String
    var furnitureModelName: String
}

struct Chair {
    static let chairModels = [Furniture(image: #imageLiteral(resourceName: "chair01"), furnitureDae: "greenChair.scn", furnitureModelName: "parentNode"), Furniture(image: #imageLiteral(resourceName: "wodenChair"), furnitureDae: "simpleWoodenChair.scn", furnitureModelName: "ParentSimpleChair"), Furniture(image: #imageLiteral(resourceName: "simpleChair"), furnitureDae: "simpleChair.scn", furnitureModelName: "basicChair"), Furniture(image: UIImage(named: "woodenChair")!, furnitureDae: "woodenChair.scn", furnitureModelName: "woodenChair")]
    
    static let tableModels = [Furniture(image: #imageLiteral(resourceName: "table"), furnitureDae: "table.scn", furnitureModelName: "table"), Furniture(image: #imageLiteral(resourceName: "basicTable"), furnitureDae: "basicTable.scn", furnitureModelName: "basic"), Furniture(image: #imageLiteral(resourceName: "moroccanTable"), furnitureDae: "moroccanTable.scn", furnitureModelName: "moroccanTable"), Furniture(image: #imageLiteral(resourceName: "modernTable"), furnitureDae: "modernTable.scn", furnitureModelName: "modernTable")]
    
    static let lampModels = [Furniture(image: UIImage(named: "floorLamp")!, furnitureDae: "floorLamp.scn", furnitureModelName: "floorLamp"), Furniture(image: #imageLiteral(resourceName: "tableLamp"), furnitureDae: "tableLamp.scn", furnitureModelName: "glassTableLamp"), Furniture(image: #imageLiteral(resourceName: "lamp"), furnitureDae: "lamp.scn", furnitureModelName: "Lamp")]
}
