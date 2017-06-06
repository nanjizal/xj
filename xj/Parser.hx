package xj;
import xj.AttArray;
import xj.Attdef;
import xj.NodeArr;
import xj.Nodedef;
import xj.StrArr;
import xj.StringCodeIterator;
import xj.Settings;

@:enum
abstract OutType( Int ) {
    var tagOut = 0;
    var attOut = 1;
    var contentOut = 2;
    var nullOut = 4;
}

class Parser{
    var attSym: String = '@';
    var incTags: Array<String>;
    var out: String  = '';
    var end: String = '';
    var outTag: String = '';
    var finalOut: String = '';
    var indent: String = '';
    var indentCount: Int = 0;
    var indentLen: Int;
    var tags: Array<String>;
    var att: Array<String>;
    var contents: Array<String>;
    var last: String;
    var lastOut: OutType = nullOut;
    var tempOut: String;
    var tempCount: Int;
    var nodedef: Nodedef;
    var curNode: Nodedef;
    var strIter: StringCodeIterator;
    
    public function new(){}
    public function parse( str_: String ){
        indentLen = Settings.indentString.length;
        att = new Array<String>();
        tags = new Array<String>();
        contents = new Array<String>();
        incTags = new Array<String>();
        nodedef = new Nodedef();
        curNode = nodedef;
        strIter = new StringCodeIterator( str_ );
        strIter.next();
        indentCount = 0;
        finalOut = '';
        out = '';
        tempOut = '';
        tempCount = 0;
        var s: String;
        var i: Int = 0;
        var spaces: Int = 0;
        var q = Settings.quoteSymbol;
        var e = Settings.lineEndSymbol;
        while( strIter.hasNext() ){
            switch( strIter.c ){
                case '\n'.code, '\r'.code:
                case '<'.code:
                    s = strIter.toStr();
                    if( s != '' && spaces != s.length ){
                            //curNode.setValue( s );
                            //parentNode();
                             contents[ i ] = s;
                             lastOut = contentOut;
                             tempCount++;
                             if( tempCount > 1 ) 
                             {   
                                 incIndent();
                                 tempOut = indent + tempOut + '\n' + indent;
                             }
                             tempOut += q + s + q + ',';
                             i = contents.length;
                    }
                    spaces = 0;
                    strIter.resetBuffer();
                    extractTag();
                default:
                    if( strIter.c == ' '.code ) spaces++; // keeps track of spaces added
                    strIter.addChar();
            }
            strIter.next();
            
        }
        if( tempCount > 0 ){
            if( tempCount > 1 ){
                out += '[' + e + removeLastChar( tempOut ) + e + indent + ']' + e;
            } else {
                out +=  removeLastChar( tempOut ) + e;
            }
            tempCount = 0;
            tempOut = '';
        }
        if( end != '' ) { 
            decIndent();
            out += e + indent + '}';
            end = '';
        }
        traceResults();
    }
    function traceResults(){
        trace( 'tags ' + tags );
        trace( 'att ' + att );
        trace( 'contents ' + contents );
        finalOut += out + '}';
        trace( 'out ' );
        trace( finalOut );
        trace( 'nodedef ......');
        trace( nodedef.str() );
        trace( '..............');
        
    }
    inline function parentNode(){
        if( curNode.parent != null ) curNode = curNode.parent;
    }
    inline function removeLastChar( s: String ){
        return s.substr( 0, s.length-1 );
    }
    inline function removeFirstLast( s: String ){
        return s.substr( 1, s.length-2 );
    }
    inline function extractTag() {
        strIter.next();
        strIter.resetBuffer();
        var q = Settings.quoteSymbol;
        var e = Settings.lineEndSymbol;
        var s: String;
        if( strIter.c == '?'.code || strIter.c == '/'.code ) {
            strIter.next();
            while( strIter.c  != '>'.code ){
                strIter.next();
            }
            s = strIter.toStr();
            trace( 'out ' + s + 'incTagLast ' + incTags[incTags.length-1] );
            if( s == incTags[incTags.length-1] ){
                incTags.pop();
                end += e + indent + '}';
            } else {}
            strIter.resetBuffer();
            return;
        }
        strIter.resetBuffer();
        var i = tags.length;
        var tagStored = false;
        while( true ) {
            switch( strIter.c ) {
                case '>'.code:
                    if( !tagStored ){
                        s = strIter.toStr();
                        if( last != s ) {
                            if( curNode.name != '' ){
                                var n2 = new Nodedef();
                                n2.name = s;
                                curNode.addNode( n2 );
                                curNode = n2;
                            } else {
                                curNode.name = s;
                            }
                            tags[i++] = s;
                            if( lastOut == tagOut ){
                            } else if( lastOut == contentOut ){
                                if( tempCount > 1 ){
                                    out += '[' + e + removeLastChar( tempOut ) + e + ']' + ',' + e;
                                } else {
                                    out += tempOut + e;
                                }
                                tempCount = 0;
                                tempOut = '';
                            }
                            if( lastOut == tagOut ) {
                                incIndent();
                                out += '{'+ e;
                                incTags[ incTags.length ] = tags[i-1];
                            }
                            lastOut = tagOut;
                            out += indent + q +  s + q + ':';
                        } else {}
                        last = s;
                    }
                    break;
                case ' '.code:
                    tagStored = true;
                    s = strIter.toStr();
                    if( last != s ) {
                        if( curNode.name != '' ){
                            var n2 = new Nodedef();
                            n2.name = s;
                            curNode.addNode( n2 );
                            curNode = n2;
                        } else {
                            curNode.name = s;
                        }
                        
                        
                        tags[i++] = s;
                        trace( 'tag... ' + s );
                        if( lastOut == tagOut ) {
                            incIndent();
                            out += '{' + e;
                            incTags[ incTags.length ] = tags[i-1];
                        }
                        lastOut = tagOut;
                        out += indent + q  + s + q + ':' + e;
                    } else {
                    }
                    last = s;
                    var atdefs = extractAtt();
                    curNode.attArray = atdefs;
                    trace( 'atdefs \n' + atdefs.str( indent ) );
                default:
                    strIter.addChar();
            }
            tagStored = false;
            strIter.next();
        }
        strIter.resetBuffer();
    }
    inline function incIndent(){
        indent = indent + Settings.indentString;
    }
    inline function decIndent(){
        indent = indent.substr(0, indent.length - indentLen );
    }
    
    inline function extractAtt(){
        strIter.resetBuffer();
        var s: String;
        var i = att.length;
        var atdefs = new AttArray();
        var toggle: Bool = true;
        var q = Settings.quoteSymbol;
        var e = Settings.lineEndSymbol;
        while( true ) {
            switch( strIter.c ) {
                case '='.code, ' '.code:
                    s = strIter.toStr();
                    if( s != '' ){
                        if( toggle ){
                            att[i] = s;
                            atdefs.createAtt( s );
                            lastOut = attOut;
                            s = attSym + s;
                            out += indent + q + s + q + ':';
                        } else {
                            att[i] = s;
                            lastOut = attOut;
                            s = removeFirstLast( s );
                            atdefs.setAttValue( s );
                            s = attSym + s;
                            out += q + s + q + e;
                        }
                        toggle = !toggle;
                        i = att.length;
                    } 
                    strIter.resetBuffer();
                case '>'.code:
                    s = strIter.toStr();
                    att[i] = s;
                    lastOut = attOut;
                    s = removeFirstLast( s );
                    atdefs.setAttValue( s );
                    s = attSym + s;
                    out += q + s + q + e;
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
