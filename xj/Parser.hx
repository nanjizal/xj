package xj;
import xj.*;
@:enum
abstract OutType( Int ) {
    var nodeType = 0;
    var attType = 1;
    var contentType = 2;
    var nullType = 4;
}
class Parser{
    var incNodes: Array<String>;
    var out: String  = '';
    var end: String = '';
    var outTag: String = '';
    public var finalOut: String = '';
    var indent: String = '';
    var indentCount: Int = 0;
    var indentLen: Int;
    public var nodes: Array<String>;
    public var contents: Array<String>;
    var last: String;
    var lastOut: OutType = nullType;
    var tempOut: String;
    var tempCount: Int;
    var nodedef: Nodedef;
    var curNode: Nodedef;
    var prevNode: Nodedef;
    var strIter: StringCodeIterator;
    public function new(){}
    public function parse( str_: String ): Nodedef {
        indentLen = Settings.indentString.length;
        nodes = new Array<String>();
        contents = new Array<String>();
        incNodes = new Array<String>();
        nodedef = new Nodedef();
        curNode = nodedef;
        indentCount = 0;
        lastOut = nullType;
        indent = '';
        finalOut = '';
        out = '';
        tempOut = '';
        tempCount = 0;
        outerLoop( str_ );
        processEnd();
        finalOut += out + '}';
        return nodedef;
    }
    public inline function getOutType( o: OutType ): String {
        return switch( o ){
            case nodeType:
                'nodeType';
            case attType:
                'attType';
            case contentType:
                'contentType';
            case nullType:
                'nullType';
        }
    }
    inline function outerLoop( str_: String ){
        var s: String;
        var spaces: Int = 0;
        strIter = new StringCodeIterator( str_ );
        strIter.next();
        while( strIter.hasNext() ){
            switch( strIter.c ){
                case '\n'.code, '\r'.code:
                    // new line ignore
                case '<'.code:
                    s = strIter.toStr();
                    if( spaces != s.length ) addContent( s );
                    spaces = 0;
                    strIter.next();
                    strIter.resetBuffer();
                    if( !endTag() ) extractTag();
                default:
                    if( strIter.c == ' '.code ) spaces++; // keeps track of spaces added
                    strIter.addChar();
            }
            strIter.next();
        }
    }
    inline function processEnd(){
        var e = Settings.lineEndSymbol;
        if( tempCount > 0 ){
            if( tempCount > 1 ){
                var c1 = contents.length;
                var c0 = c1 - tempCount;
                var tempContent = new Array<String>() ;
                var ci = 0;
                for( i in c0...c1 ) tempContent[ ci++ ] = contents[ i ];
                curNode.setMultipleValue( tempContent );
                parentNode();
                out += '[' + e + StringCrop.last( tempOut ) + e + indent + ']' + e;
            } else {
                curNode.setValue( contents[ contents.length - 1 ] );
                parentNode();
                out +=  StringCrop.last( tempOut ) + e;
            }
            tempCount = 0;
            tempOut = '';
        }
        if( end != '' ) { 
            decIndent();
            out += e + indent + '}';
            end = '';
        }
    }
    function traceResults(){
        trace( 'nodes ' + nodes );
        trace( 'contents ' + contents );
        finalOut += out + '}';
        trace( 'out ' );
        trace( finalOut );
        trace( 'nodedef ......');
        trace( nodedef );
        trace( nodedef.str() );
        trace( '..............');
        
    }
    inline function addContent( s: String ){
        var q = Settings.quoteSymbol;
        if( s != '' ){
             //curNode.setValue( s );//
             //parentNode();
             contents[ contents.length ] = s;
             lastOut = contentType;
             tempCount++;
             if( tempCount > 1 ){   
                 incIndent();
                 tempOut = indent + tempOut + '\n' + indent;
             }
             tempOut += q + s + q + ',';
        }
    }
    inline function parentNode(){
        if( curNode.parent != null ) curNode = curNode.parent;
    }
    inline function endTag(){
        var s: String;
        var exists: Bool = false;
        var e = Settings.lineEndSymbol;
        if( strIter.c == '?'.code || strIter.c == '/'.code ) {
            strIter.next();
            while( strIter.c  != '>'.code ){
                strIter.next();
            }
            s = strIter.toStr();
            if( s == incNodes[incNodes.length-1] ){
                incNodes.pop();
                end += e + indent + '}';
            } else {}
            strIter.resetBuffer();
            exists = true;
        }
        return exists;
    }
    inline function extractTag() {
        var q = Settings.quoteSymbol;
        var e = Settings.lineEndSymbol;
        var s: String;
        var i = nodes.length;
        var tagStored = false;
        var atdefs: AttArray = [];
        while( true ) {
            switch( strIter.c ) {
                case '>'.code:
                    if( !tagStored ){
                        s = strIter.toStr();
                        if( last != s ) {
                            if( lastOut == nodeType ){
                                incIndent();
                                //out += '{'+ e;
                                if( !curNode.hasAt() ){
                                    out += '{'+ e;
                                }
                                incNodes[ incNodes.length ] = nodes[i-1];
                            } else if( lastOut == contentType ){
                                if( tempCount > 1 ){
                                    var c1 = contents.length;
                                    var c0 = c1 - tempCount;
                                    var tempContent = new Array<String>();
                                    var ci = 0;
                                    for( i in c0...c1 ) tempContent[ ci++ ] = contents[ i ];
                                    curNode.setMultipleValue( tempContent );
                                    parentNode();
                                    out += '[' + e + StringCrop.last( tempOut ) + e + ']' + ',' + e;
                                } else {
                                    curNode.setValue( contents[ contents.length - 1 ] );
                                    parentNode();
                                    out += tempOut + e;
                                }
                                tempCount = 0;
                                tempOut = '';
                            }
                            addNode( s );
                            nodes[i++] = s;
                            lastOut = nodeType;
                            if( s == '' ) {
                                out += indent + q +  '#value' + q + ':';
                            } else {
                                out += indent + q +  s + q + ':';
                            }
                        } else {}
                        last = s;
                    }
                    break;
                case ' '.code:
                    tagStored = true;
                    s = strIter.toStr();
                    if( last != s ) {
                        addNode( s );
                        nodes[i++] = s;
                        if( lastOut == nodeType ) {
                            incIndent();
                            out += '{' + e;
                            incNodes[ incNodes.length ] = nodes[ i - 1 ];
                        }
                        lastOut = nodeType;
                        out += indent + q  + s + q + ':' + e;
                    } else {}
                    last = s;
                    atdefs = AttArray.parse( strIter );
                    out += indent + e + atdefs.str( indent );
                    curNode.attArray = atdefs;
                default:
                    strIter.addChar();
            }
            tagStored = false;
            strIter.next();
        }
        strIter.resetBuffer();
        return atdefs;
    }
    inline function addNode( s: String ){
        if( s != '' ){
            if( curNode.name == '' ){
                curNode.name = s;
            } else {
                var n2 = new Nodedef();
                n2.name = s;
                curNode.addNode( n2 );
                prevNode = curNode;
                curNode = n2;
            }
        } else {}
    }
    inline function incIndent(){
        indent = indent + Settings.indentString;
    }
    inline function decIndent(){
        indent = indent.substr(0, indent.length - indentLen );
    }
}