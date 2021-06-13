import UIKit

class MessageDecryptor: NSObject {
    
    func decryptMessage(_ message: String) -> String {
        //2[s2[e2[c2[r2[e2[t2[m]]]]]]essage]
        var decrypted = ""
        let preprocessed = message.split{$0 == "]"}.map{String($0)}
        for i in 0...preprocessed.count-1{
            let item = preprocessed[i]
            let subItems = matches(for: "([a-zA-Z-]+)?[0-9]+\\[([a-zA-Z-]+)?", in: item)
            
            if(subItems.count < 1){
                decrypted = decrypted + item.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
                
                if(preprocessed.count == 1){
                    return decrypted
                }
            }
            
            if(subItems.count > 1){
                var phrase = ""
                for k in (0...subItems.count - 1).reversed(){
                    phrase = constructPhrase(subItems[k], phrase)
                }
                decrypted.append(phrase)
            }
            if(subItems.count == 1){
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
        
        let prefix = matches(for: "[a-zA-Z-]+", in: actors[0])
        
        let multipliers = matches(for: "[0-9]+", in: actors[0])
        
        if let multiplier = Int(multipliers[0]){
            if(multiplier > 0){
                for _ in 1...multiplier {
                    if(actors.count > 1){
                        subMsg.append(actors[1])
                    }
                    subMsg.append(phrase)
                }
                phrase = subMsg
            }
            else{
                phrase = ""
            }
        }
        
        if(prefix.count > 0){
            let prefixToAdd = prefix[0]
            return prefixToAdd + phrase
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
