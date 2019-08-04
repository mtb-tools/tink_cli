package mtb;

import haxe.macro.Expr;
import haxe.macro.Context;

import mtb.cli.Prompt;
import mtb.cli.Result;
import mtb.cli.DocFormatter;

using tink.CoreApi;
#if macro
using tink.MacroApi;
#end

class Cli {
	public static macro function process<Target:{}>(args:ExprOf<Array<String>>, target:ExprOf<Target>, ?prompt:ExprOf<Prompt>):ExprOf<Result> {
		var ct = Context.toComplexType(Context.typeof(target));
		prompt = prompt.ifNull(macro new mtb.cli.prompt.RetryPrompt(5));
		
		return macro new mtb.cli.macro.Router<$ct>($target, $prompt).process($args);
	}
	
	public static macro function getDoc<Target:{}, T>(target:ExprOf<Target>, ?formatter:ExprOf<DocFormatter<T>>):ExprOf<T> {
		formatter = formatter.ifNull(macro new mtb.cli.doc.DefaultFormatter());
		var doc = mtb.cli.Macro.buildDoc(Context.typeof(target), target.pos);
		return macro $formatter.format($doc);
	}
	
	public static function exit(result:Outcome<Noise, Error>) {
		switch result {
			case Success(_): Sys.exit(0);
			case Failure(e):
				var message = e.message;
				if(e.data != null) message += ', ${e.data}';
				Sys.println(message); Sys.exit(e.code);
		}
	}
}