import std.getopt: config, defaultGetoptPrinter, getopt, GetoptResult, GetOptException;
import std.conv: to;
import core.sys.posix.stdlib : EXIT_FAILURE, EXIT_SUCCESS, exit;
import std.stdio : stdout, File;
import std.range: iota;
import std.exception: errnoEnforce;
import std.random: MinstdRand0, randomShuffle;
import std.string : representation;


string weight ="16K"; //={ w16k, w32k, w64k, w128k, w256k, w512k, w1M, w5M, w10M, w100M, w500M};
string filePath;

string line = "123456789101112131415161718192021222324252627282930313233343536\n";

size_t to_octet( string weight ){
    immutable size_t quantity = to!size_t(weight[0..$-1]);
    immutable char unit = weight[$-1];
    size_t multiplier = 0;
    switch(unit){
        default:
            stdout.writefln("Unexpected unit '%s'!", unit);
            exit(EXIT_FAILURE);
            break;
        case 'k':
        case 'K':
            multiplier = 1024;
            break;
        case 'm':
        case 'M':
            multiplier = 1024 * 1024;
            break;
        case 'g':
        case 'G':
            multiplier = 1024 * 1024 * 1024;
            break;
    }
    return quantity * multiplier;
}

void fileGenerator( string filePath, size_t bits){
    auto rnd = MinstdRand0(42);
    immutable size_t nbIterations = bits / (line.length * char.sizeof);
    debug stdout.writefln("nb bits: %d", bits);
    debug stdout.writefln("nb iterations: %d", nbIterations);
    debug stdout.writefln("line.length: %d", line.length);
    debug stdout.writefln("string.sizeof: %d", char.sizeof);
    
    File f = File(filePath, "w");
    foreach(i; 0 .. nbIterations){
        auto shuffleUbytes = line.representation.dup.randomShuffle(rnd);
        f.write(cast(char[])shuffleUbytes);
    }
    f.close();
}


void main(string[] args){
    GetoptResult parser;
    try {
      parser = getopt(args,
              config.required,
              "w|weigth", "File weight to generate", &weight,
              config.required,
              "o|output", "File Path to generate the file", &filePath
              );
    }
    catch( GetOptException e ){
      stdout.writefln( "Error: %s", e.msg );
      exit( 1 );
    }
    if (parser.helpWanted){
        defaultGetoptPrinter("A file generator.\n\nUsage:", parser.options);
        exit(EXIT_SUCCESS);
    }
    fileGenerator( filePath, to_octet(weight) );
}
