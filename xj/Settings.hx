package xj;

class Settings {
    inline public static var attributeSymbol: String = '@';
    #if doubleQuotes
        inline public static var quoteSymbol: String = '"';
    #else 
        inline public static var quoteSymbol: String = '"'; 
    #end
    #if windowLineEnd
        inline public static var lineEndSymbol: String = '\r\n';
    #else 
        inline public static var lineEndSymbol: String = '\n';
    #end
}
