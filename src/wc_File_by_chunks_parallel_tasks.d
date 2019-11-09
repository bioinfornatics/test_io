import std.getopt: config, defaultGetoptPrinter, getopt, GetoptResult, GetOptException;
import core.sys.posix.stdlib : EXIT_FAILURE, EXIT_SUCCESS, exit;
import common: getPageSize, lineCounter;
import std.stdio: File, writefln, stderr;
import std.parallelism: TaskPool, task;
import std.algorithm: map;

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


void main(string[] args){
    cli(args);
    TaskPool taskPool = new TaskPool(maxNbOfThreads);
    File file = File(filePath, "rb");
    immutable size_t PageSize = getPageSize();
    immutable bufferSize = PageSize * nbPageSize;
    auto fileChunks = file.byChunk(bufferSize);
    size_t nbLines = taskPool.reduce!"a + b"(fileChunks.map!(buffer => lineCounter(buffer.idup)));
    writefln("%d %s", nbLines, filePath);
}
