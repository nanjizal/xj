package xj;
import xj.Attdef;

@:forward
abstract AttArray( Array<Attdef> ) from Array<Attdef> to Array<Attdef> { 
    public static inline var singleQuote: Bool = true;
    public static var attributeSymbol: String = '@';
    inline 
    public function new( ?arr: Array<Attdef> = null ){
        if( arr == null ){
            arr = new Array<Attdef>();
        }
        this = arr;
    }
    inline 
    public function getByName( name: String ){
        var value: String = '';
        for( att in this ){
            if( att.name == name ) {
                value = att.value;
                break;
            }
        }
        return value;
    }
    /* inline */
    public function str( ?space_: String = '' ): String {
        if( this.length == 0 ) return '';
        var out: String = '';
        var count = 0;
        var space: String = space_;
        for( att in this ) {
            att.str;
            out += '$space' + att.str();
            if( count < this.length - 1 ) {
                out += ',\n';
            } else {
                out += '\n';
            }
            count++;
        }
        return out;
    }
    /* inline */
    public function str2( ?space_: String = '' ): String {
        var out: String = '';
        var count = 0;
        var space: String = space_;
        for( att in this ) {
            out += '$space' + att.str2();
            if( count < this.length - 1 ) {
                out += ',\n';
            } else {
                out += '\n';
            }
            count++;
        }
        return out;
    }
}
