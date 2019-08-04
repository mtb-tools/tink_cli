package mtb.cli;

@:forward
abstract Rest<T>(Array<T>) from Array<T> to Array<T> {
	@:to
	public inline function asArray():Array<T>
		return this;
}