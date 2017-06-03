package xj;

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
        for( i in 0...this.length ){
            if( i < this.length - 1 ){
                out += space_ + "'" + this[i] + "',\n";
            } else {
                out += space_ + "'" +  this[i] + "'\n";
            }
        }
        return out;
    }
    inline
    public function str2( ?space_: String = '' ){
        var out = '';
        for( i in 0...this.length ){
            if( i < this.length - 1 ){
                out += space_ + '"' + this[i] + '",\n';
            } else {
                out += space_ + '"' +  this[i] + '"\n';
            }
        }
        return out;
    }
    
}
