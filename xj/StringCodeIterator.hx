package xj;

class StringCodeIterator {
    var str : String = '';
    var b: StringBuf;
    public var pos: Int;
    public var c: Int;
    public var last2: String;
    public var last: String;
    public var length: Int;
    public function new( str_: String, ?pos_: Int = 0 ){
        pos = pos_;
        str = str_;
        length = str.length;
        b = new StringBuf();
    }
    inline 
    public function addChar(){
        b.addChar( c );
    }
    inline 
    public function toStr(){
        last2 = last;
        last = b.toString();
        return last;
    }
    inline
    public function isRepeat(){
        var out: Bool;
        // may need to check null and ''?
        return( last == last2 );
    }
    inline 
    public function resetBuffer(){
        b = new StringBuf();
    }
    inline
    public function reset(){
        pos = 0;
    }
    inline
    public function hasNext(){
        return pos < length;
    }
    inline
    public function next(){
        c = StringTools.fastCodeAt( str, pos++ );
        return c;
    }
    inline function removeLastChar( s: String ){
        return last.substr( 0, last.length-1 );
    }
    inline function removeFirstLast( s: String ){
        return last.substr( 1, last.length-2 );
    }
    
}