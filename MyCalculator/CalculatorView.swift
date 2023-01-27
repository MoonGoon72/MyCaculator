import SwiftUI

enum ButtonType: String {
    case first, second, third, fourth, fifth, sixth, seventh, eighth, nineth, zero
    case dot, equal, plus, minus, multiply, divide
    case clear, opposite, percentage
    
    var buttonDisplayName: String {
        switch self {
        case .first:
            return "1"
        case .second:
            return "2"
        case .third:
            return "3"
        case .fourth:
            return "4"
        case .fifth:
            return "5"
        case .sixth:
            return "6"
        case .seventh:
            return "7"
        case .eighth:
            return "8"
        case .nineth:
            return "9"
        case .zero:
            return "0"
        case .dot:
            return "."
        case .equal:
            return "="
        case .plus:
            return "+"
        case .minus:
            return "-"
        case .multiply:
            return "X"
        case .divide:
            return "÷"
        case .clear:
            return "C"
        case .opposite:
            return "±"
        case .percentage:
            return "%"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .first,.second,.third,.fourth,.fifth,.sixth,.seventh,.eighth,.nineth,.zero,.dot:
            return Color("NumberButton")
        case .equal, .plus, .minus, .multiply, .divide:
            return Color.orange
        case .clear, .opposite, .percentage:
            return Color.gray
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .first,.second,.third,.fourth,.fifth,.sixth,.seventh,.eighth,.nineth,.zero,.dot, .equal, .plus, .minus, .multiply, .divide:
            return Color.white
        case .clear, .opposite, .percentage:
            return Color.black
        }
    }
}

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
    
    @State private var result: String = "0"
    @State var tmpNumber: Int = 0
    @State var calculator: CalculatorModel = CalculatorModel()
    @State var operatorType: ButtonType = .clear
    @State var isNotEditing: Bool = true
    
    private let buttonData: [[ButtonType]] = [
        [.clear, .opposite, .percentage, .divide],
        [.seventh, .eighth, .nineth, .multiply],
        [.fourth, .fifth, .sixth, .minus],
        [.first, .second, .third, .plus],
        [.zero, .dot, .equal],
    ]
    var Buttons: some View {
        ForEach(buttonData, id: \.self) { line in
            HStack {
                ForEach(line, id: \.self) { item in
                    Button {
                        if isNotEditing {
                            if item == .clear {
                                result = "0"
                                isNotEditing = true
                            } else if
                                item == .plus ||
                                    item == .minus ||
                                    item == .divide ||
                                    item == .multiply ||
                                    item == .percentage ||
                                    item == .opposite
                            {
                                result = "Error"
                            } else {
                                result = item.buttonDisplayName
                                isNotEditing = false  // 이미 입력 받고 있음
                            }
                            isNotEditing = false
                        } else {
                            if item == .clear {
                                isNotEditing = true
                                result = "0"
                            }
                            // 단위수 콤마가 들어가면 타입캐스팅 오류로 0이 되어 이 부분 수정
                            else if item == .plus {
                                tmpNumber = (Int(result.toIntNoneComma()?.toString() ?? "0") ?? 0)
                                operatorType = .plus
                                isNotEditing = true  // 새로 입력받기 위함
                            } else if item == .minus {
                                tmpNumber = (Int(result.toIntNoneComma()?.toString() ?? "0") ?? 0)
                                operatorType = .minus
                                isNotEditing = true
                            } else if item == .multiply {
                                tmpNumber = (Int(result.toIntNoneComma()?.toString() ?? "0") ?? 0)
                                operatorType = .multiply
                                isNotEditing = true
                            } else if item == .divide {
                                tmpNumber = (Int(result.toIntNoneComma()?.toString() ?? "0") ?? 0)
                                operatorType = .divide
                                isNotEditing = true
                            } else if item == .opposite {
                                tmpNumber = (Int(result.toIntNoneComma()?.toString() ?? "0") ?? 0)
                                operatorType = .opposite
                                result = String(calculator.oppositeNum(Int(result.toIntNoneComma()?.toString() ?? "0") ?? 0))
                            } else if item == .equal {
                                switch operatorType {
                                case .plus:
                                    result = calculator.addNum((Int(result.toIntNoneComma()?.toString() ?? "0") ?? 0), tmpNumber).toStringWithComma() ?? "0"
                                case .minus:
                                    result = calculator.subNum(tmpNumber, (Int(result.toIntNoneComma()?.toString() ?? "0") ?? 0)).toStringWithComma() ?? "0"
                                    // 먼저 써놨던 수에서 나중 수를 빼야하니까!
                                case .multiply:
                                    result = calculator.multNum((Int(result.toIntNoneComma()?.toString() ?? "0") ?? 0), tmpNumber).toStringWithComma() ?? "0"
                                case .divide:
                                    result = calculator.divNum(tmpNumber, (Int(result.toIntNoneComma()?.toString() ?? "0") ?? 0)).toStringWithComma() ?? "0"
                                case .percentage:
                                    result = result
                                default:
                                    result = result
                                }
                            } else {
                                if result == "0" {
                                    result = item.buttonDisplayName
                                } else {
                                    result = result.toIntNoneComma()?.toString() ?? "777"
                                    result += item.buttonDisplayName
                                    result = (Int(result) ?? 0).toStringWithComma() ?? "0"
                                }
                            }
                        }
                    } label: {
                        Text(item.buttonDisplayName)
                            .bold()
                            .frame(width: calculateButtonWidth(button: item),height: calculateButtonHeigth(button: item))
                            .background(item.backgroundColor)
                            .cornerRadius(40).foregroundColor(item.foregroundColor)
                            .font(.system(size: 30))
                    }
                }
            }
        }
    }
    
    private func calculateButtonWidth(button buttonType: ButtonType) -> CGFloat {
        switch buttonType {
        case .zero:
            return (UIScreen.main.bounds.width - 5*10) / 4 * 2.1
        default:
            return ((UIScreen.main.bounds.width - 5*10) / 4)
        }
        // (전체너비 - 5*10)/4
    }
    private func calculateButtonHeigth(button buttonType: ButtonType) -> CGFloat {
        return (UIScreen.main.bounds.width - 5*10) / 4
    }
    
    var Result: some View {
        HStack {
            Spacer()
            Text(result)
                .padding(10)
                .font(.system(size: 75))
                .foregroundColor(Color.white)
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
