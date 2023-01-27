import SwiftUI

extension Int {
    public func toStringWithComma() -> String? {
        let numberFormmater = NumberFormatter()
        numberFormmater.numberStyle = .decimal
        
        if let numberToString: String = numberFormmater.string(from:NSNumber(value: self)) {
            return numberToString
        }
        return nil
    }
}

extension String {
    public func toIntNoneComma() -> NSNumber? {
        let numberFormmater = NumberFormatter()
        numberFormmater.numberStyle = .decimal
        
        if let stringToNumber: NSNumber = numberFormmater.number(from: self) {
            return stringToNumber
        }
        return nil
    }
}

extension NSNumber {
    func toString() -> String {
        return NumberFormatter().string(from: self) ?? ""
    }
}


struct CalculatorView: View {
    @ObservedObject private var brain:CalculatorModel = CalculatorModel()
    
    @State private var result: String = "0"
    @State var calculator: CalculatorModel = CalculatorModel()
    
    func inputToken(token:String) {
        brain.inputToken(input: token)
    }
    var Buttons: some View {
        ForEach(Array(brain.getButtonCodeList().enumerated()), id: \.offset) { vIdx, line in
            HStack {
                let hLast = line.count - 1
                ForEach(Array(line.enumerated()), id: \.offset) { hIdx, buttonTitle in
                    Button(action: {inputToken(token: buttonTitle)}) {
                        Text(buttonTitle)
                            .frame(width: (buttonTitle == "0" ? 170 : 80), height: 80)
                            .background(hIdx  == hLast ? .orange : vIdx == 0 ? .gray : .secondary)
                            .cornerRadius(40)
                            .foregroundColor(.white)
                            .font(.system(size: 33))
                    }
                    
                }
            }
        }
    }
    
    var Result: some View {
        HStack {
            Spacer()
            Text(brain.displayValue)
                .padding(10)
                .font(.system(size: 75))
                .foregroundColor(Color.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Spacer()
                Result
                Buttons
            }
        }
    }
}

struct CalculatorView_Preview: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
