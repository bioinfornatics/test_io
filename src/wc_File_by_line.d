import std.getopt: config, defaultGetoptPrinter, getopt, GetoptResult, GetOptException;
import core.sys.posix.stdlib : EXIT_FAILURE, EXIT_SUCCESS, exit;
import std.stdio: File, KeepTerminator, stderr, writefln;
import std.algorithm: reduce, sum, map;
import std.range: enumerate, only;


string filePath;
size_t nbPageSize;

void cli(string[] args){
    GetoptResult parser;
    try {
        parser = getopt(args,
                            config.required,
                            "i|input", "File Path to read", &filePath
                        );
    }
    catch( GetOptException e ){
        stderr.writefln( "Error: %s", e.msg );
        exit(EXIT_FAILURE);
    }
    if (parser.helpWanted){
        defaultGetoptPrinter("Count number of line inside a file.\n\nUsage:", parser.options);
        exit(EXIT_SUCCESS);
    }
}


void main(string[] args)
{
    cli(args);
    size_t nbLines = filePath.File()
                             .byLine(KeepTerminator.yes)
                             .map!( a => 1)
                             .reduce!("a+b");
    writefln("%d %s", nbLines, filePath);
}
