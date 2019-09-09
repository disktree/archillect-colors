
#if js

import js.Browser.window;
import js.Browser.document;
import js.html.Element;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.DivElement;
import om.FetchTools;

class App {

	static var numColors : Int;
	static var info : Element;
	//static var tooltip : Tooltip;

	static function updatePositionInfo() {
		var total = numColors;
		var start = Std.int(total - window.scrollY);
		var end = Std.int(total - (window.scrollY+window.innerHeight));
		if( end < 1 ) end = 1;
		info.textContent = start+'-'+end;
	}

	static function main() {

		window.onload = function() {
			
			info = document.createDivElement();
			info.id = 'info';
			info.textContent = 'LOADING COLORS';
			document.body.appendChild( info );
		
			//tooltip = new Tooltip();
			//document.body.appendChild( tooltip.element );

			FetchTools.fetchJson( 'colors.json' ).then( function(colors:Array<String>){

				numColors = colors.length;

				var colorsPerCanvas = 1000;
				var canvas : CanvasElement = null;
				var ctx : CanvasRenderingContext2D = null;
				var lastBlockColors = colors.length % colorsPerCanvas;
				var numBlocks = Std.int( (colors.length - lastBlockColors) / colorsPerCanvas );
				for( i in 0...numBlocks+1 ) {
					var n = (i == numBlocks) ? lastBlockColors : colorsPerCanvas;
					canvas = document.createCanvasElement();
					canvas.setAttribute( 'data-index', Std.string( i ) );
					canvas.width = 1;
					canvas.height = n;
					document.body.appendChild( canvas );
					ctx = canvas.getContext2d();
					for( j in 0...n+1 ) {
						ctx.fillStyle = colors[(i*colorsPerCanvas)+j];
						ctx.fillRect( 0, j, 1, 1 );
					}
				}

				updatePositionInfo();

				window.addEventListener( 'scroll', function(e){
					updatePositionInfo();
				}, false );
				window.addEventListener( 'resize', function(e){
					updatePositionInfo();
				}, false );
				window.addEventListener( 'contextmenu', function(e){
					e.preventDefault();
				}, false );
				document.addEventListener( 'mousemove', function(e){
					var index = numColors - e.pageY + 1;
					document.body.title = ''+index;
					//tooltip.show(index);
				}, false );
				/*				
				document.addEventListener( 'mousedown', function(e){
					if( e.button == 0 ) {
						var index = numColors - e.pageY + 1;
						document.body.title = ''+index;
						window.open( 'http://archillect.com/$index', '_blank' );
					} else {
						e.preventDefault();
					}
					return false;
				}, false );
				*/
			});
		}
	}
}

/*
private class Tooltip {

	public var element(default,null) : DivElement;

	public function new() {
		element = document.createDivElement();
		element.id = 'tooltip';
	}

	public function show( index : Int ) {
		element.textContent = '#'+index;
	}
}
*/

#end
