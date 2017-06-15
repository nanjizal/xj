package xj;
import xj.*;
using xj.StringCrop;
@:forward
abstract AttArray( Array<Attdef> ) from Array<Attdef> to Array<Attdef> { 
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
    inline
    public function str( ?space_: String = '', ?lastComma: Bool = true ): String {
        if( this.length == 0 ) return '';
        var e = Settings.lineEndSymbol;
        var commaEnd = ',' + e;
        var out: String = '';
        var count = 0;
        var space: String = space_;
        if( lastComma ){
            for( att in this ) {
                att.str;
                out += '$space' + att.str() + commaEnd;
                count++;
            }
        } else {
            for( att in this ) {
                att.str;
                out += '$space' + att.str();
                if( count < this.length - 1 ) {
                    out += commaEnd;
                } else {
                    out += e;
                }
                count++;
            }
        }
        return out;
    }
    
    static var temp: Attdef;
    inline public function createAtt( s: String ){
        temp = new Attdef();
        temp.name = s;
    }
    inline public function setAttValue( s: String ){
        temp.value = s;
        this[this.length] = temp;
    }
    public static inline function parse( strIter: StringCodeIterator ): AttArray {
        var toggle: Bool = true;
        strIter.resetBuffer();
        var s: String;
        var atdefs = new AttArray();
        while( true ) {
            switch( strIter.c ) {
                case '='.code, ' '.code:
                    s = strIter.toStr();
                    if( s != '' ){
                        if( toggle ){
                            atdefs.createAtt( s );
                        } else {
                            s = StringCrop.firstLast( s );
                            atdefs.setAttValue( s );
                        }
                        toggle = !toggle;
                    } 
                    strIter.resetBuffer();
                case '>'.code:
                    s = strIter.toStr();
                    s = StringCrop.firstLast( s );
                    atdefs.setAttValue( s );
                    strIter.pos--;
                    break;
                default:
                    strIter.addChar();
            }
            strIter.next();
        }
        strIter.resetBuffer();
        return atdefs;
    }
}