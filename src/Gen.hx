
import om.color.space.RGB;
import sys.FileSystem;
import sys.io.File;

class Gen {

	static function main() {
		var path = '/home/tong/dev/pro/archillect/meta';
		var start = 1;
		var end = 199795;
		var out = File.write( 'bin/colors.json' );
		out.writeString( '[' );
		for( i in start...end ) {
			var data = haxe.Json.parse( File.getContent( '$path/'+i+'.json' ) ).color;
			if( data == null ) {
				Sys.println( 'NULL! [$i]' );
				data = { r : 0, g : 0, b : 0, a : 1.0 };
			}
			out.writeString( '"#' );
			out.writeString( RGB.create( data.r, data.g, data.b ).toHex().substr(1) );
			out.writeString( '"' );
			if( i < end-1 ) out.writeString( ',' );
		}
		out.writeString( ']' );
		out.close();
	}
}
