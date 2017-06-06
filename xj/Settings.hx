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
    
    #if indent0
        inline public static var indentString: String = '';
    #elseif indent1
        inline public static var indentString: String = ' ';
    #elseif indent2
        inline public static var indentString: String = '  ';
    #elseif indent3
        inline public static var indentString: String = '   ';
    #elseif indent4
        inline public static var indentString: String = '    ';
    #else  
        inline public static var indentString: String = '   ';
    #end
}
