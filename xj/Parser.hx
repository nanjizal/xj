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
    // var str : String = '';
    // var pos: Int;
    // var c: Int;
    // var l: Int;
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
        // str = str_;
        // pos = 0;
        // l = str.length;
        // c = nextChar();
        strIter.next();
        
        indentCount = 0;
        finalOut = '';
        out = '';
        tempOut = '';
        tempCount = 0;
        //var b = new StringBuf();
        var s: String;
        var i: Int = 0;
        var spaces: Int = 0;
        while( strIter.hasNext() ){
        //while( pos < l ){
            switch( strIter.c ){
                case '\n'.code, '\r'.code:
                case '<'.code:
                    s = strIter.toStr(); //b.toString();
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
                    // b = new StringBuf();
                    strIter.resetBuffer();
                    extractTag();
                default:
                    if( strIter.c == ' '.code ) spaces++; // keeps track of spaces added
                    strIter.addChar();
                    //b.addChar( c );
            }
            strIter.next();
            //c = nextChar();
            
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
        //c = nextChar();
        strIter.next();
        //var b = new StringBuf();
        strIter.resetBuffer();
        var s: String;
        if( strIter.c == '?'.code || strIter.c == '/'.code ) {
            //c = nextChar();
            strIter.next();
            while( strIter.c  != '>'.code ){
                // b.addChar( c );
                // c = nextChar();
                strIter.next();
            }
            //s = b.toString();
            s = strIter.toStr();
            //out+='dec ' + s;
            trace( 'out ' + s + 'incTagLast ' + incTags[incTags.length-1] );
            if( s == incTags[incTags.length-1] ){
                incTags.pop();
                end += '\n' + indent + '}';
                
                //decIndent();
            } else {
                
            }
            strIter.resetBuffer();
            return;
        }
        // b = new StringBuf();
        strIter.resetBuffer();
        var i = tags.length;
        var tagStored = false;
        while( true ) {
            switch( strIter.c ) {//, ' '.code
                case '>'.code:
                
                
                    if( !tagStored ){
                        
                        s = strIter.toStr();//b.toString();
                        if( last != s ) {
                            trace( 'tag2... ' + s );
                            
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
                                
                                //out+= '\n';
                                //out += '[' + tempOut + ']' + '\n';
                                //tempOut = '';
                                
                            } else if( lastOut == contentOut ){
                                if( tempCount > 1 ){
                                    out += '[\n' + removeLastChar( tempOut ) + '\n]' + ',\n';
                                } else {
                                    out += tempOut + '\n';
                                }
                                tempCount = 0;
                                tempOut = '';
                            }
                            
                                //
                            if( lastOut == tagOut ) {
                                incIndent();
                                out += '{\n';
                                incTags[ incTags.length ] = tags[i-1];
                            }
                            lastOut = tagOut;
                            out += indent + "'" +  s + "':";
                        } else {
                            //out += "\n";//+indent+"[";
                        }
                        last = s;
                    }
                    /*
                    trace('lastOut ' + lastOut );
            var z = lastOut;
            finalOut += '$z{\n'+out;
            out = ''; 
                    */
                    
                    
                    break;
                case ' '.code:
                    tagStored = true;
                    s = strIter.toStr(); // b.toString();
                      
                    
                    
                    
                    
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
                        //  finalOut += '{\n'+out;
                        //  out = '';
                    } else {
                        //decIndent();
                        //out += " pie \n";//+indent+"[";
                    }
                    last = s;
                    //indent = indent + indentStr;
                    var atdefs = extractAtt();
                    curNode.attArray = atdefs;
                    trace( 'atdefs \n' + atdefs.str( indent ) );
                default:
                    strIter.addChar();
                    //b.addChar( c );
            }
            tagStored = false;
            //c = nextChar();
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
        //var b = new StringBuf();
        strIter.resetBuffer();
        var s: String;
        var i = att.length;
        var atdef: Attdef = new Attdef();
        var atdefs = new AttArray();
        var toggle: Bool = true;
        while( true ) {
            switch( strIter.c ) {
                case '='.code, ' '.code:
                    s = strIter.toStr();//b.toString();
                    //if( s == 'name' ) s = '-name';
                    if( s != '' ){
                        //s = attSym + s;
                        if( toggle ){
                            att[i] = s;
                            lastOut = attOut;
                            atdef = new Attdef();
                            atdef.name = s;
                            out += indent + "'" + s + "':";
                        } else {
                            att[i] = s;
                            lastOut = attOut;
                            atdef.value = removeFirstLast(s);
                            atdefs.push( atdef );
                            out += "'" + removeFirstLast( s ) + "'\n";
                        }
                        toggle = !toggle;
                        i = att.length;
                    } 
                    //b = new StringBuf();
                    strIter.resetBuffer();
                case '>'.code:
                    //s = b.toString();
                    
                    s = strIter.toStr();
                    att[i] = s;
                    lastOut = attOut;
                    atdef.value = removeFirstLast(s);
                    atdefs.push( atdef );
                    out += "'" + removeFirstLast( s ) + "'\n";
                    strIter.pos--;
                    break;
                default:
                    strIter.addChar();
                    //b.addChar( c );
            }
            
            //c = nextChar();
            strIter.next();
        }
        return atdefs;
        
    }
    /*inline function nextChar() {
        return StringTools.fastCodeAt( str, pos++ );
    }*/
}