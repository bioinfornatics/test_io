project('wc', 'd', default_options: ['optimization=3'] )

common_sources = ['src/common.d']
inc_dir =  include_directories('src/')
common_project_arguments = ['-dip25', '-dip1000', '-dip1008', '-release'] #, '--d-debug'
add_project_arguments(common_project_arguments, language: 'd')

# file generator
executable(meson.project_name() + '_file_generator', ['src/wc_file_generator.d'], include_directories: inc_dir)
# wc_File_by_line
executable(meson.project_name() + '_File_by_line', ['src/wc_File_by_line.d'] + common_sources, include_directories: inc_dir)
# wc_File_by_chunks
executable(meson.project_name() + '_File_by_chunks', ['src/wc_File_by_chunks.d'] + common_sources, include_directories: inc_dir)
# wc_File_by_parallel_chunks
executable(meson.project_name() + '_File_by_chunks_parallel_count', ['src/wc_File_by_chunks_parallel_count.d'] + common_sources, include_directories: inc_dir)
# wc_File_by_chunk_parallel_tasks
#executable(meson.project_name() + '_File_by_chunks_parallel_tasks', ['src/wc_File_by_chunks_parallel_tasks.d'] + common_sources, include_directories: inc_dir)
# wc_File_by_chunk_parallel_tasks
executable(meson.project_name() + '_File_by_chunks_async_buffer', ['src/wc_File_by_chunks_async_buffer.d'] + common_sources, include_directories: inc_dir)
# wc_MMAP
#~executable(meson.project_name() + '_File', ['src/wc_MMAP.d'] + common_sources, include_directories: inc_dir)
# wc_File_pool_thread
#~executable(meson.project_name() + '_File', ['src/wc_File_pool_thread.d'] + common_sources, include_directories: inc_dir)
# wc_MMAP_pool_thread
#~executable(meson.project_name() + '_File', ['src/wc_MMAP_pool_thread.d'] + common_sources, include_directories: inc_dir)
# wc_File_fiber
#~executable(meson.project_name() + '_File', ['src/wc_File_fiber.d'] + common_sources, include_directories: inc_dir)
# wc_MMAP_fiber
#~executable(meson.project_name() + '_File', ['src/wc_MMAP_fiber.d'] + common_sources, include_directories: inc_dir)
