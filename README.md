# Test IO
This repository explore various way to read a file and to count the number of line.
The result is compared to `wc -l` command. 
The line counting is only a pretext to evaluate the io, this proces can be switched by any io processing.
Thus we use much as possible the buffer instead the byLine range. Moreover such range imply that the
buffer was read once before to be ready to process.

## Build
it is required:
  - A D compiler (dnd,ldc2,gdc)
  - meson
	- ninja
	- D libraries: (iopipe, io  not yet)  phobos

```
$ meson build
$ ninja -C build
```

executable are generaced into the directory named `build`

## wc_file_generator
This tools is used to simulate various file size

```
$ ./build/wc_file_generator -w 16k -o file_16kb
$ ./build/wc_file_generator -w 100M -o file_100Mb
…
```

# Results

lesser time is better

| Tool                                   | Description | File size | Time (ns) | nb Thread | nb PageSize |
| -------------------------------------- | ----------- | --------- | --------- | --------- | ----------- |
| wc                                     |             | 4k        | 3.900     |     1     |     N/A     |
| wc_File_by_line                        |             | 4k        | 12.700    |     1     |      1      |
| wc_File_by_chunks                      |             | 4k        | 11.500    |     1     |      1      |
| wc_File_by_chunks_parallel_count       |             | 4k        | 10.700    |     4     |      1      |
| wc                                     |             | 16k       | 3.300     |     1     |     N/A     |
| wc_File_by_line                        |             | 16k       | 12.600    |     1     |      1      |
| wc_File_by_chunks                      |             | 16k       | 15.100    |     1     |      1      |
| wc_File_by_chunks_parallel_count       |             | 16k       | 12.000    |     4     |      1      |
| wc                                     |             | 1M        | 3.700     |     1     |     N/A     |
| wc_File_by_line                        |             | 1M        | 12.600    |     1     |      1      |
| wc_File_by_chunks                      |             | 1M        | 14.200    |     1     |      1      |
| wc_File_by_chunks_parallel_count       |             | 1M        | 15.800    |     4     |      1      |
| wc                                     |             | 10M       | 10.000    |     1     |     N/A     | 
| wc_File_by_line                        |             | 10M       | 48.500    |     1     |      1      |
| wc_File_by_chunks                      |             | 10M       | 26.800    |     1     |      1      |
| wc_File_by_chunks_parallel_count       |             | 10M       | 58.100    |     4     |      1      |
| wc                                     |             | 100M      | 76.100    |     1     |     N/A     |
| wc_File_by_line                        |             | 100M      | 210.600   |     1     |      1      |
| wc_File_by_chunks                      |             | 100M      | 110.300   |     1     |      1      |
| wc_File_by_chunks_parallel_count       |             | 100M      | 482.900   |     4     |      1      |
| wc                                     |             | 200M      | 118.000   |     1     |     N/A     |
| wc_File_by_line                        |             | 200M      | 380.800   |     1     |      1      |
| wc_File_by_chunks                      |             | 200M      | 223.700   |     1     |      1      |
| wc_File_by_chunks_parallel_count       |             | 200M      | 966.400   |     3     |      1      |


**Note:** `src/wc_File_by_chunks_async_buffer.d` is currently broken
