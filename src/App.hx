
#if js
import js.Browser.window;
import js.Browser.document;
import js.html.Element;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
#end

class App {

	macro static function getColors( path : String, start : Int, end : Int ) {
		var colors = new Array<String>();
		for( i in start...end+1 ) {
			var data = haxe.Json.parse( sys.io.File.getContent( '$path/$i.json' ) );
			var c = data.color;
			var rgba = om.color.space.RGB.create( c.r, c.g, c.b );
			colors.push( rgba.toHex() );
		}
		return macro $v{colors};
	}

	#if js

	static var colors = getColors( '/home/tong/dev/pro/archillect/meta', 1, 4000 );
	static var info : Element;

	static function updatePositionInfo() {
		info.textContent = (colors.length - window.scrollY)+'-'+(colors.length - (window.scrollY+window.innerHeight)+1);
	}

	static function main() {

		var colorsPerCanvas = 1000;
		var canvas : CanvasElement = null;
		var ctx : CanvasRenderingContext2D = null;
		var py = 0;
		for( i in 0...colors.length ) {
			if( i == 0 || i % colorsPerCanvas == 0 ) {
				canvas = document.createCanvasElement();
				canvas.setAttribute( 'data-index', Std.string(i) );
				canvas.width = window.innerWidth;
				canvas.height = colorsPerCanvas;
				document.body.appendChild( canvas );
				ctx = canvas.getContext2d();
				py = 0;
			}
			var c = colors[colors.length-i];
			ctx.fillStyle = c;
			ctx.fillRect( 0, py, canvas.width, 1 );
			py++;
		}

		info = document.createDivElement();
		info.id = 'info';
		document.body.appendChild( info );

		updatePositionInfo();

		window.addEventListener( 'scroll', function(e){
			updatePositionInfo();
		}, false );
		window.addEventListener( 'resize', function(e){
			updatePositionInfo();
		}, false );
	}

	#end

}
