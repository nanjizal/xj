package xj;
import xj.*;
class Attdef{
    public var name: String;
    public var value: String;
    public function new(){}
    inline
    public function str(): String {
        if( name == null ) return '';
        var a = Settings.attributeSymbol;
        var q = Settings.quoteSymbol;
        var n = q + a + name + q;
        var v = q + value + q;  
        return '$n:$v';
    }
}