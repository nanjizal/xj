package xj;
import xj.*;
@:forward
abstract StrArr( Array<String> ) from Array<String> to Array<String> { 
    inline
    public function new( ?arr: Array<String> = null ){
        if( arr == null ){
            this = new Array<String>();
        }
        this = arr;
    }
    inline
    public function str( ?space_: String = '' ){
        var out = '';
        var e = Settings.lineEndSymbol;
        var q = Settings.quoteSymbol;
        for( i in 0...this.length ){
            if( i < this.length - 1 ){
                out += space_ + q + this[i] + q +',' + e;
            } else {
                out += space_ + q +  this[i] + q + e;
            }
        }
        return out;
    }
}
