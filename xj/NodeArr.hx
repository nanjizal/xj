package xj;
import xj.*;
@:forward
abstract NodeArr( Array<Nodedef> ) from Array<Nodedef> to Array<Nodedef> { 
    inline 
    public function new( ?arr: Array<Nodedef> = null ){
        if( arr == null ){
            arr = new Array<Nodedef>();
        }
        this = arr;
    }
    inline 
    public function getByName( name: String ){
        var value: String = '';
        for( n in this ){
            if( n.name == name ) {
                value = n.str();
                break;
            }
        }
        return value;
    }
    inline
    public function str( ?space_: String = '' ): String {
        var out: String = '';
        var e = Settings.lineEndSymbol;
        for( i in 0...this.length ){
            if( i < this.length - 1 ){
                out += this[i].str(space_) + ',' + e;
            } else {
                out += this[i].str(space_) + e;
            }
        }
        return out;
    }
}
