
#if js
import js.Browser.window;
import js.Browser.document;
import js.html.Element;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
#end

class App {

	macro static function getColors( path : String, start : Int, end : Int, split : Int ) {
		var total = end - start;
		var parts = new Array<Array<String>>();
		var i = 0;
		while( true ) {
			var j = 0;
			var part = new Array<String>();
			parts.push( part );
			while( j < split ) {
				var k = start+i;
				var data = haxe.Json.parse( sys.io.File.getContent( '$path/'+k+'.json' ) ).color;
				if( data == null ) {
					trace( 'NULL! [$k]' );
					data = { r : 0, g : 0, b : 0, a : 1.0 };
				}
				var rgb = om.color.space.RGB.create( data.r, data.g, data.b );
				part.push( rgb.toHex() );
				j++;
				if( ++i > total )
					return macro $v{parts};
			}
		}
		return macro null;
	}

	#if js

	static inline var INDEX_START = 1;
	static inline var INDEX_END = 199795;

	static var numColors = INDEX_END - INDEX_START;
	static var info : Element;

	static function updatePositionInfo() {
		var total = numColors;
		var start = (total - window.scrollY);
		var end = (total - (window.scrollY+window.innerHeight));
		if( end < 1 ) end = 1;
		info.textContent = start+'-'+end;
	}

	static function main() {

		window.onload = function() {

			var colorBlocks = getColors( '/home/tong/dev/pro/archillect/meta', 1, 199795, 1000 );

			info = document.createDivElement();
			info.id = 'info';
			document.body.appendChild( info );

			for( i in 0...colorBlocks.length ) {
				var colors = colorBlocks[i];
				var canvas = document.createCanvasElement();
				canvas.width = 1; //window.innerWidth;
				canvas.height = colors.length;
				document.body.appendChild( canvas );
				var ctx = canvas.getContext2d();
				for( j in 0...colors.length ) {
					var c = colors[j];
					ctx.fillStyle = c;
					ctx.fillRect( 0, j, canvas.width, 1 );
				}
			}

			updatePositionInfo();

			window.addEventListener( 'scroll', function(e){
				updatePositionInfo();
			}, false );
			window.addEventListener( 'resize', function(e){
				updatePositionInfo();
			}, false );
		}
	}

	#end

}
