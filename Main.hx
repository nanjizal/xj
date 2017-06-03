package;
import xj.Parser;
class Main { static public function main():Void { new Main(); }
    public function new(){
        trace( haxe.Resource.getString("sample") );
        (new Parser()).parse( haxe.Resource.getString("sample") );
    }
}