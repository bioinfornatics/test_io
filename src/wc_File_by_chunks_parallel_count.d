import std.getopt: config, defaultGetoptPrinter, getopt, GetoptResult, GetOptException;
import core.sys.posix.stdlib : EXIT_FAILURE, EXIT_SUCCESS, exit;
import common: getFileSize, getFragment, getNbOfTasks, getPageSize, lineCounter;
import std.stdio: File, writefln, stderr;
import std.parallelism: TaskPool;
import std.algorithm.iteration: map;
import std.range : iota;

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
    size_t fileSize = getFileSize(file);
    size_t nbOfTasks = 0;
    size_t nbLines = 0;
    auto chunks = file.byChunk(bufferSize);
    immutable size_t piece_chunk_size = 1024;
    //debug writefln("Number of threads: %d", maxNbOfThreads);
    foreach(ref ubyte[] buffer; chunks){
        immutable(ubyte)[] content = buffer.idup; // immutable imply shared
        nbOfTasks = content.length / piece_chunk_size;
        //debug writefln("buffer size: %d", buffer.length);
        //debug writefln("Number of tasks: %d", nbOfTasks);
        nbLines += taskPool.reduce!"a + b"(nbOfTasks.iota
                                                    .map!(i => getFragment(i, piece_chunk_size, content.length))
                                                    .map!(f => lineCounter(content[f.start .. f.end])));
    }
    taskPool.finish();
    writefln("%d %s", nbLines, filePath);
}
