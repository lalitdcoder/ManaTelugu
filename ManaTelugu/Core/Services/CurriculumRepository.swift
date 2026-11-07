import Foundation

@MainActor
final class CurriculumRepository: ObservableObject {
    @Published var stages: [CurriculumStage] = []
    @Published var modules: [CurriculumModule] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let supabaseManager = SupabaseManager.shared

    init() {
        Task {
            await fetchCurriculum()
        }
    }

    // MARK: - Fetch Published Modules from Supabase REST API
    func fetchCurriculum() async {
        isLoading = true
        errorMessage = nil

        do {
            // 1. Fetch Stages ordered by order_index
            let fetchedStages: [CurriculumStage] = try await supabaseManager.fetch(
                table: "curriculum_stages",
                queryItems: [
                    URLQueryItem(name: "select", value: "*"),
                    URLQueryItem(name: "order", value: "order_index.asc")
                ]
            )
            self.stages = fetchedStages

            // 2. Fetch Published Curriculum Modules ordered by module_number
            let fetchedModules: [CurriculumModule] = try await supabaseManager.fetch(
                table: "curriculum_modules",
                queryItems: [
                    URLQueryItem(name: "select", value: "*"),
                    URLQueryItem(name: "is_published", value: "eq.true"),
                    URLQueryItem(name: "order", value: "module_number.asc")
                ]
            )

            self.modules = fetchedModules
            self.isLoading = false
            print("✅ Supabase REST fetch success: \(fetchedModules.count) published modules received.")
        } catch {
            print("❌ Supabase REST fetch failed: \(error.localizedDescription)")
            self.errorMessage = "Failed to connect to Supabase: \(error.localizedDescription)"
            self.modules = []
            self.isLoading = false
        }
    }

    // MARK: - Query Helpers
    func modules(forStage stageId: String) -> [CurriculumModule] {
        modules.filter { $0.stageId == stageId }
    }

    func modules(forLevel level: Int) -> [CurriculumModule] {
        modules.filter { $0.level == level }
    }

    func module(byNumber number: Int) -> CurriculumModule? {
        modules.first { $0.moduleNumber == number }
    }
}
