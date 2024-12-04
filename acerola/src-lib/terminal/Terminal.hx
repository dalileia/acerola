package terminal;

class Terminal {
    
    public static function print(context:String, message:String):Void {
        Sys.println('   ${context.toUpperCase()} : ${message}');
    }

}