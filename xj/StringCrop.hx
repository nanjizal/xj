package xj;

class StringCrop {
    public static inline function firstLast( s: String ){
        return s.substr( 1, s.length-2 );
    }
    public static inline function last( s: String ){
        return s.substr( 0, s.length-1 );
    }
}