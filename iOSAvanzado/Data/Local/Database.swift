import Foundation
import UIKit
import CoreData

struct Database {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}
