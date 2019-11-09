import std.getopt: config, defaultGetoptPrinter, getopt, GetoptResult, GetOptException;
import core.sys.posix.stdlib : EXIT_FAILURE, EXIT_SUCCESS, exit;
import common: getPageSize, lineCounter;
import std.stdio: File, writefln, stdout, stderr;
import std.parallelism: TaskPool, task;
import std.algorithm: map, reduce;

string filePath;
size_t nbPageSize;
size_t maxNbOfThreads;


void cli(string[] args){
    GetoptResult parser;
    try {
        parser = getopt(args,
                            config.required,
                            "n|nbPageSize", "Number of parge size to use as buffer", &nbPageSize,
                            config.required,
                            "i|input", "File Path to read", &filePath,
                            config.required,
                            "t|threads", "Number of threads to use", &maxNbOfThreads
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

ubyte[] next(File file, ref ubyte[] buffer){
    auto result = file.rawRead(buffer);
    stdout.writeln(cast(char[])result);
    return result;
}

void main(string[] args){
    cli(args);
    TaskPool taskPool = new TaskPool(maxNbOfThreads);
    File file = File(filePath, "rb");
    immutable size_t PageSize = getPageSize();
    auto asyncReader = taskPool.asyncBuf((ref ubyte[] buffer){ buffer = file.rawRead(buffer);} ,
                                         () => file.eof,
                                         PageSize, nbPageSize);
    size_t nbLines = asyncReader.map!(a=> lineCounter(a))
                                .reduce!("a+b");
    taskPool.finish();
    writefln("%d %s", nbLines, filePath);
}
