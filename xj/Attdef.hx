package xj;
import xj.AttArray;
class Attdef{
    public var name: String;
    public var value: String;
    public function new(){}
    inline
    public function str(): String {
        if( name == null ) return '';
        var a = AttArray.attributeSymbol;
        var n = "'" + a + name + "'";
        var v = "'" + value + "'";  
        return '$n:$v';
    }
    inline
    public function str2(): String {
        if( name == null ) return '';
        var a = AttArray.attributeSymbol;
        var n = name;
        var v = value;
        return '"$a$n":"$v"';
    }
}