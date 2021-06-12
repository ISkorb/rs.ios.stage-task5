import UIKit

class MessageDecryptor: NSObject {
    
    func decryptMessage(_ message: String) -> String {
        var decrypted = ""
//        let pattern = "\\[([a-zA-Z-]+)\\]"
//        let pattern2 = "([0-9]+\\[([a-zA-Z-]+)\\])"
//        let pattern3 = "([0-9]+\\[(\\[?[a-zA-Z-]+\\]?)\\])"
//        let matched = matches(for: pattern3, in: message)
//        print(matched)
        
        let preprocessed = message.split{$0 == "]"}.map{String($0)}
        for i in 0...preprocessed.count-1{
            let item = preprocessed[i]
            let subItems = matches(for: "[0-9]+\\[([a-zA-Z-]+)", in: item)
            
            if(subItems.count < 1){
                let phrase = item.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
                return decrypted + phrase
            }
            
            if(subItems.count > 1){
                var phrase = ""
                for k in (0...subItems.count - 1).reversed(){
//                    let actors = subItems[k].split{$0 == "["}.map{String($0)}
//                    var subMsg = ""
//                    if let multiplier = Int(actors[0]){
//                        for r in 1...multiplier {
//                            subMsg.append(actors[1])
//                            subMsg.append(phrase)
//                        }
//                        phrase = subMsg
//                    }
                    phrase = constructPhrase(subItems[k], phrase)
                }
                decrypted.append(phrase)
            }
            else{
                let phrase = constructPhrase(subItems[0], "")
                decrypted.append(phrase)
            }
        }
        
        return decrypted
    }
    
    func constructPhrase(_ subMessage: String, _ previousMessage: String) -> String {
        var phrase = previousMessage
        let actors = subMessage.split{$0 == "["}.map{String($0)}
        var subMsg = ""
        if let multiplier = Int(actors[0]){
            if(multiplier > 0){
                for _ in 1...multiplier {
                    subMsg.append(actors[1])
                    subMsg.append(phrase)
                }
                phrase = subMsg
            }
            else{
                phrase = ""
            }
        }
        return phrase
    }
    
    func matches(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
