import Foundation
enum TechnicianFormMode: Equatable { case create, edit(UUID) }
struct TechnicianFormData {
    var name = ""
    var specialty = ""
    var email = ""
}
@MainActor protocol TechnicianFormInteractorProtocol {
    func load(mode: TechnicianFormMode) throws -> TechnicianFormData
    func validate(_ data: TechnicianFormData) -> [String: String]
    func save(_ data: TechnicianFormData, mode: TechnicianFormMode) throws
}
@MainActor protocol TechnicianFormRouterProtocol { func finish() }
