package xj;
import xj.Nodedef;

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
        for( i in 0...this.length ){
            if( i < this.length - 1 ){
                out += this[i].str(space_) + ',\n';
            } else {
                out += this[i].str(space_) + '\n';
            }
        }
        return out;
    }
    inline
    public function str2( ?space_: String = '' ): String {
        var out: String = '';
        for( i in 0...this.length ){
            if( i < this.length - 1 ){
                out += this[i].str2() + ',\n';
            } else {
                out += this[i].str2() + '\n';
            }
        }
        return out;
    }
    
}
