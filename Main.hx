package;
import xj.Parser;
class Main { static public function main():Void { new Main(); }
    var p: Parser;
    public function new(){
        p = new Parser();
        var tests = [ 'test0','test1','test2','test3','test4','test5','test8'];
        for( test in tests ) testParse( test );
    }
    public function testParse( file: String ){
        trace( '_____________');
        trace( 'testing ' + file );
        trace( '_____________');
        var str = haxe.Resource.getString(file);
        trace( 'xml input >');
        trace( str );
        trace( '......');
        var nodedef = (p).parse( str );
        trace( 'finalOut' );
        trace( p.finalOut );
        trace( 'nodes ' + p.nodes );
        trace( 'contents ' + p.contents );
        trace( '......');
        trace( 'nodedef to string' );
        trace( nodedef.str() );
    }
}