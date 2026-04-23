import CoreData

@objc(Entity)
final class MedicalRecord: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var fullName: String?
    @NSManaged var age: Int16
    @NSManaged var weight: Double
    @NSManaged var height: Double
    @NSManaged var bloodPressure: String?
    @NSManaged var comment: String?
    @NSManaged var createdAt: Date?
}
