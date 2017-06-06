package xj;
import xj.AttArray;
import xj.Attdef;
import xj.NodeArr;
import xj.Nodedef;
import xj.StrArr;
import xj.StringCodeIterator;

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
    var indentStr: String = '   ';
    var indent: String = '';
    var indentCount: Int = 0;
    var indentLen: Int = 3;
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
                             tempOut += "'" + s + "',";
                             trace( ' tempOut.... ' + s );
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
                out += '[\n' + removeLastChar( tempOut ) + '\n' + indent + ']' + '\n';
            } else {
                out +=  removeLastChar( tempOut ) + '\n';
            }
            tempCount = 0;
            tempOut = '';
        }
        if( end != '' ) { 
            decIndent();
            out += '\n' + indent + '}';
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
                end += '\n' + indent + '}';
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
                                    out += '[\n' + removeLastChar( tempOut ) + '\n]' + ',\n';
                                } else {
                                    out += tempOut + '\n';
                                }
                                tempCount = 0;
                                tempOut = '';
                            }
                            if( lastOut == tagOut ) {
                                incIndent();
                                out += '{\n';
                                incTags[ incTags.length ] = tags[i-1];
                            }
                            lastOut = tagOut;
                            out += indent + "'" +  s + "':";
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
                            out += '{\n';
                            incTags[ incTags.length ] = tags[i-1];
                        }
                        lastOut = tagOut;
                        out += indent + "'"  + s + "':\n";
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
        indent = indent + indentStr;
    }
    inline function decIndent(){
        indent = indent.substr(0, indent.length - indentLen );
    }
    inline function extractAtt(){
        strIter.resetBuffer();
        var s: String;
        var i = att.length;
        var atdef: Attdef = new Attdef();
        var atdefs = new AttArray();
        var toggle: Bool = true;
        while( true ) {
            switch( strIter.c ) {
                case '='.code, ' '.code:
                    s = strIter.toStr();
                    if( s != '' ){
                        if( toggle ){
                            att[i] = s;
                            lastOut = attOut;
                            atdef = new Attdef();
                            s = attSym + s;
                            atdef.name = s;
                            out += indent + "'" + s + "':";
                        } else {
                            att[i] = s;
                            lastOut = attOut;
                            s = attSym + s;
                            atdef.value = removeFirstLast(s);
                            atdefs.push( atdef );
                            out += "'" + removeFirstLast( s ) + "'\n";
                        }
                        toggle = !toggle;
                        i = att.length;
                    } 
                    strIter.resetBuffer();
                case '>'.code:
                    s = strIter.toStr();
                    att[i] = s;
                    lastOut = attOut;
                    s = attSym + s;
                    atdef.value = removeFirstLast(s);
                    atdefs.push( atdef );
                    out += "'" + removeFirstLast( s ) + "'\n";
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
