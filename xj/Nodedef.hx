package xj;
import xj.AttArray;
import xj.NodeArr;
import xj.StrArr;
@:enum
abstract NodeType( Int ) {
    var content = 0;
    var multipleValue = 1;
    var node = 2;
    var nodes = 3;
    var empty = 4;
}
class Nodedef{
    public var attArray: AttArray;
    public var name: String = '';
    public var typ: NodeType = empty;
    public var parent: Nodedef;
    // values should only have maximum of one populated
    private var value0: String;
    private var value1: StrArr;
    private var value2: Nodedef;
    private var value3: NodeArr;
    public function new(){}
    public function setValue( s: String ){
        typ = content;
        value0 = s;
    }
    public function setMultipleValue( arr: Array<String> ) {
        typ = multipleValue;
        value1 = arr;
    }
    private function setNode( n: Nodedef ){
        typ = node;
        n.parent = this;
        value2 = n;
    }
    public function addNode( n: Nodedef ){
        switch( typ ) {
            case empty:
                setNode( n );
            case node:
                var ns = new NodeArr();
                ns[0] = value2;
                value1 = null;
                ns[1] = n;
                typ = nodes;
                //n.parent = this;
                value3 = ns;
            case nodes:
                value3[ value3.length ] = n;
            case content:
                
            case multipleValue:
                
        }
    }
    public function nodeType():String {
        return switch( typ ){
            case content:
                'content';
            case multipleValue:
                'multipleValue';
            case node:
                'node';
            case nodes:
                'nodes';
            case empty:
                'empty';
        }
    }
    public function setEmpty() {
        clear();
    }
    public function clear(){
        switch( typ ){
            case content:
                value0 = '';
            case multipleValue:
                value1 = null;
            case node:
                value2 = null;
            case nodes:
                value3 = null;
            case empty:
                
        }
        typ = empty;
    }
    public function str(?space_: String = ''): String {
        var n = name;
        var e = Settings.lineEndSymbol;
        var q = Settings.quoteSymbol;
        var inside = switch( typ ){
                case content:
                    value0;
                case multipleValue:
                    value1.str( space_ + Settings.indentString ); 
                case node:
                    value2.str( space_ + Settings.indentString );
                case nodes:
                    value3.str( space_ + Settings.indentString );
                case empty:
                    'value:empty';
            };
        var out: String = space_ + q + name + q +':' + '{' + e;
        if( attArray != null ){
            out += attArray.str( space_ +'   ' );
        }
        out += inside + '}' + e;
        return out; 
    }
}
