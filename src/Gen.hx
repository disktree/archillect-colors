
#if sys

import om.Json;
import om.color.space.RGB;
import Sys.print;
import Sys.println;
import sys.FileSystem;
import sys.io.File;

class Gen {

	static function main() {

		var start = 1, end : Null<Int>;
		var metaPath : String, outFile = 'bin/colors.json';

		var argsHandler : {getDoc:Void->String,parse:Array<Dynamic>->Void};
		argsHandler = hxargs.Args.generate([
			@doc("Path to meta directory") ["-meta"] => (path:String) -> metaPath = path,
            @doc("Start index")["-start"] => (i:Int) -> start = i,
            @doc("End index")["-end"] => (i:Int) -> end = i,
            _ => (arg:String) -> {
                println( 'Unknown command: $arg' );
                println( argsHandler.getDoc() );
                Sys.exit(1);
	        }
        ]);
		argsHandler.parse( Sys.args() );

		if( metaPath == null ) throw 'meta data path not specified';
		if( !FileSystem.exists( metaPath ) ) {
			println( 'meta data path [$metaPath] not found' );
		}
		if( end == null ) end = FileSystem.readDirectory( metaPath ).length;

		var out = File.write( outFile );
		out.writeString( '[' );
		for( i in start...end ) {
			var path = '$metaPath/$i.json';
			if( !FileSystem.exists( path ) ) {
				println( 'meta data path [$path] not found' );
				continue;
			}
			var color = Json.readFile( path ).color;
			if( color == null ) {
				println( '$i NULL' );
				color = { r : 0, g : 0, b : 0, a : 1.0 };
			}
			out.writeString( '"#' );
			out.writeString( RGB.create( color.r, color.g, color.b ).toHex().substr(1) );
			out.writeString( '"' );
			if( i < end-1 ) out.writeString( ',' );
		}
		out.writeString( ']' );
		out.close();
	}
}

#end
