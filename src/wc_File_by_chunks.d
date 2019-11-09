import std.getopt: config, defaultGetoptPrinter, getopt, GetoptResult, GetOptException;
import core.sys.posix.stdlib : EXIT_FAILURE, EXIT_SUCCESS, exit;
import common: getPageSize, lineCounter;
import std.stdio: File, chunks, writefln, stderr;

string filePath;
size_t nbPageSize;

void cli(string[] args){
    GetoptResult parser;
    try {
        parser = getopt(args,
                            config.required,
                            "n|nbPageSize", "Number of parge size to use as buffer", &nbPageSize,
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




void main(string[] args){
    cli(args);
    File file = File(filePath, "rb");
    immutable size_t PageSize = getPageSize();
    immutable bufferSize = PageSize * nbPageSize;
    size_t nbLines = 0;
    foreach(ref ubyte[] buffer; chunks(file, bufferSize)){
        nbLines += lineCounter(buffer);
    }
    writefln("%d %s", nbLines, filePath);
}
