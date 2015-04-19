package sys.io;

import js.Node;

import haxe.io.Eof;

class NodeFileInput extends FileInput 
{
	private var stream:Int; 
	private var binary:Bool;
	public function new(stream:Int, ?binary : Bool )
	{
		this.binary = binary; 
		this.stream = stream;
	}

	override public function readByte():Int
	{
		var ret = 0;
		
		var bytes = haxe.io.Bytes.alloc(1);
		Node.fs.readSync(this.stream, bytes.getData(), 0, 1, null);
		ret = bytes.get(0);
		
		if ( ret == -1 )
			throw new Eof();
		return ret;
	}

	
	override public function close():Void
	{
		Node.fs.closeSync(this.stream);

	}


}
class NodeFileOutput extends FileOutput 
{
	private var stream:Int; 
	private var binary:Bool;
	public function new(stream:Int, ?binary : Bool )
	{
		this.stream = stream;
		this.binary = binary;
	}


	override public function close():Void
	{
		Node.fs.closeSync(this.stream);
	}


	override public function writeByte(c:Int):Void
	{

		var bytes = haxe.io.Bytes.alloc(1);
		bytes.set(0, c);
                Node.fs.writeSync(this.stream, bytes.getData(), 0, 1, null);

	}

}

class File
{
	public static function append( path : String, ?binary : Bool ) : FileOutput
	{
		throw "Not implemented";
		return null;
	}
	
	public static function copy( src : String, dst : String ) : Void
	{
		var content = Node.fs.readFileSync(src);
		Node.fs.writeFileSync(dst, content);
	}
	
	public static function getBytes( path : String ) : haxe.io.Bytes
	{
		var o = Node.fs.openSync(path, "r");
		var s = Node.fs.fstatSync(o);
		var len = s.size, pos = 0;
		var bytes = haxe.io.Bytes.alloc(s.size);
		while( len > 0 ) {
			var r = Node.fs.readSync(o, bytes.getData(), pos, len, null);
			pos += r;
			len -= r;
		}
		Node.fs.closeSync(o);
		return bytes;
	}
	
	public static function getContent( path : String ) : String
	{
		return Node.fs.readFileSync(path, UTF8_ENCODING);
	}
	
	public static function read( path : String, ?binary : Bool ) : FileInput
	{
		return new NodeFileInput(Node.fs.openSync(path, "r"), binary);
	}
	
	// public static function saveBytes( path : String, bytes : Bytes ) : Void
	// {
	// 	throw "Not implemented";
	// 	return null;
	// }
	
	public static function saveContent( path : String, content : String ) : Void
	{
		Node.fs.writeFileSync(path, content);
	}
	
	public static function write( path : String, ?binary : Bool ) : FileOutput
	{
		return new NodeFileOutput(Node.fs.openSync(path, "w"), binary);
	}
	
	private static var UTF8_ENCODING = {encoding:NodeC.UTF8};
}
