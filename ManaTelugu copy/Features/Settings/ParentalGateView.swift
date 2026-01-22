import SwiftUI

struct ParentalGateView: View {
    @EnvironmentObject var session: AppSession
    @Binding var isUnlocked: Bool
    
    @State private var pin: String = ""
    @State private var isSettingPin: Bool
    @State private var newPin: String = ""
    @State private var confirmPin: String = ""
    @State private var errorMessage: String?
    @State private var showingPinReset = false
    @State private var isPinValid = false
    @State private var isConfirmPinValid = false
    @State private var isUnlockButtonEnabled = false
    
    init(isUnlocked: Binding<Bool>) {
        self._isUnlocked = isUnlocked
        // Check if a PIN is already set
        let pinExists = UserDefaults.standard.string(forKey: "parentPin") != nil
        self._isSettingPin = State(initialValue: !pinExists)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if isSettingPin {
                setupPinView
            } else {
                enterPinView
            }
        }
        .padding(30)
        .navigationTitle(isSettingPin ? "Set Up Parent PIN" : "Enter PIN")
        .onAppear {
            // Check if a PIN exists each time the view appears
            let pinExists = UserDefaults.standard.string(forKey: "parentPin") != nil
            isSettingPin = !pinExists
            errorMessage = nil // Clear any previous error messages
            pin = "" // Clear the PIN field
            newPin = "" // Clear the new PIN field
            confirmPin = "" // Clear the confirm PIN field
            updateValidationStates()
        }
        .onChange(of: pin) {
            updateValidationStates()
        }
        .onChange(of: newPin) {
            updateValidationStates()
        }
        .onChange(of: confirmPin) {
            updateValidationStates()
        }
    }
    
    private var enterPinView: some View {
        VStack(spacing: 20) {
            Text("Enter your 4-digit PIN to access Parent Mode.")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 8) {
                SecureField("PIN", text: $pin)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isPinValid ? Color.green : Color.clear, lineWidth: 2)
                    )
                
                if !pin.isEmpty && !isPinValid {
                    Text("PIN must be 4 digits")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button("Unlock", action: {
                HapticsService.shared.importantAction()
                checkPin()
            })
                .buttonStyle(.primary(isEnabled: isUnlockButtonEnabled))
            
            Button("Forgot PIN?", action: {
                HapticsService.shared.buttonTap()
                showingPinReset = true
            })
            .font(.caption)
        }
        .sheet(isPresented: $showingPinReset) {
            PINResetView(isPresented: $showingPinReset, isPinReset: $isSettingPin)
        }
    }
    
    private var setupPinView: some View {
        VStack(spacing: 20) {
            Text("Create a 4-digit PIN to protect the parent section.")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 8) {
                SecureField("New PIN", text: $newPin)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isPinValid ? Color.green : Color.clear, lineWidth: 2)
                    )
                
                if !newPin.isEmpty && !isPinValid {
                    Text("PIN must be 4 digits")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            VStack(spacing: 8) {
                SecureField("Confirm PIN", text: $confirmPin)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isConfirmPinValid ? Color.green : (confirmPin.isEmpty ? Color.clear : Color.red), lineWidth: 2)
                    )
                
                if !confirmPin.isEmpty && !isConfirmPinValid {
                    Text("PINs do not match")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button("Save PIN", action: {
                HapticsService.shared.success()
                savePin()
            })
                .buttonStyle(.primary(isEnabled: isConfirmPinValid))
        }
    }
    
    private func checkPin() {
        let savedPin = UserDefaults.standard.string(forKey: "parentPin")
        print("Debug: Checking PIN. Entered: '\(pin)', Saved: '\(savedPin ?? "nil")'")
        if pin == savedPin {
            print("Debug: PIN matches, unlocking parent mode")
            isUnlocked = true
        } else {
            print("Debug: PIN does not match")
            errorMessage = "Incorrect PIN. Please try again."
            pin = ""
        }
    }
    
    private func savePin() {
        if newPin.count != 4 {
            errorMessage = "PIN must be 4 digits."
            return
        }
        
        if newPin != confirmPin {
            errorMessage = "PINs do not match."
            return
        }
        
        print("Debug: Saving PIN: '\(newPin)'")
        UserDefaults.standard.set(newPin, forKey: "parentPin")
        print("Debug: PIN saved successfully")
        isUnlocked = true
    }
    
    private func updateValidationStates() {
        // Validate PIN for unlock
        isPinValid = pin.count == 4 && pin.allSatisfy { $0.isNumber }
        isUnlockButtonEnabled = isPinValid
        
        // Validate PIN setup
        let newPinValid = newPin.count == 4 && newPin.allSatisfy { $0.isNumber }
        let confirmPinValid = confirmPin.count == 4 && confirmPin == newPin && !newPin.isEmpty
        
        isPinValid = isSettingPin ? newPinValid : isPinValid
        isConfirmPinValid = confirmPinValid
        
        // Clear error message when validation passes
        if isPinValid && isConfirmPinValid {
            errorMessage = nil
        }
    }
}
