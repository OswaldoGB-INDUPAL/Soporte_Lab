import SwiftUI
struct TechnicianFormView: View {
    @State var presenter: TechnicianFormPresenter
    var body: some View {
        @Bindable var presenter = presenter
        Form {
            TextField("Nombre", text: $presenter.data.name)
            if let error = presenter.errors["name"], !presenter.data.name.isEmpty { Text(error).font(.footnote).foregroundStyle(.red) }
            TextField("Especialidad", text: $presenter.data.specialty)
            if let error = presenter.errors["specialty"], !presenter.data.specialty.isEmpty { Text(error).font(.footnote).foregroundStyle(.red) }
            TextField("Correo", text: $presenter.data.email)
                .keyboardType(.emailAddress).textInputAutocapitalization(.never).autocorrectionDisabled()
            if let error = presenter.errors["email"], !presenter.data.email.isEmpty { Text(error).font(.footnote).foregroundStyle(.red) }
        }
        .navigationTitle(presenter.title)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { presenter.didCancel() } }
            ToolbarItem(placement: .confirmationAction) { Button("Guardar") { presenter.didSave() }.disabled(!presenter.canSave) }
        }
        .alert("Error", isPresented: Binding(get: { presenter.errorMessage != nil }, set: { if !$0 { presenter.errorMessage = nil } })) {
            Button("OK") { presenter.errorMessage = nil }
        } message: { Text(presenter.errorMessage ?? "") }
        .onAppear { presenter.onAppear() }
    }
}

#Preview {
    if let container = try? AppContainer(storage: .inMemory) {
        NavigationStack { TechnicianFormBuilder.build(container: container, mode: .create, onFinish: {}) }
    }
}
