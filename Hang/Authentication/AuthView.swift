import SwiftUI
import FirebaseSignInWithApple

struct AuthView: View {
    @State private var showingAlert = false
    @Environment(\.firebaseSignInWithApple) private var firebaseSignInWithApple

    var body: some View {
        VStack {
            Button {
                showingAlert = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "apple.logo")
                        .font(.title3)
                    Text("Sign in with Apple")
                        .font(.headline)
                }
                .foregroundStyle(Color(uiColor: .systemBackground))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.primary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("We need you to sign in so we can keep track of your calendar events!"),
                    primaryButton: .default(Text("Confirm")) {
                        firebaseSignInWithApple.authenticate()
                    },
                    secondaryButton: .cancel()
                )
            }
            .padding()
        }
    }
}

#Preview {
    AuthView()
}
