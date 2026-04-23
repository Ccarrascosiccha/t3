import CoreData

final class MedicalRecordRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
    }

    func fetchAll() throws -> [MedicalRecord] {
        let request = NSFetchRequest<MedicalRecord>(entityName: "Entity")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return try context.fetch(request)
    }

    func create(
        fullName: String,
        age: Int16,
        weight: Double,
        height: Double,
        bloodPressure: String,
        comment: String
    ) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context) else {
            return
        }

        let record = MedicalRecord(entity: entity, insertInto: context)
        record.id = UUID()
        record.fullName = fullName
        record.age = age
        record.weight = weight
        record.height = height
        record.bloodPressure = bloodPressure
        record.comment = comment
        record.createdAt = Date()
        PersistenceController.shared.save()
    }

    func delete(_ record: MedicalRecord) {
        context.delete(record)
        PersistenceController.shared.save()
    }
}
