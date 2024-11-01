project('zstd', 'c', version: '1.5.5')

compiler = meson.get_compiler('c')
link_deps = []

c_flags = []
incdirs = ['.', 'lib']

sources = [
    'lib/common/debug.c',
    'lib/common/entropy_common.c',
    'lib/common/error_private.c',
    'lib/common/fse_decompress.c',
    'lib/common/pool.c',
    'lib/common/threading.c',
    'lib/common/xxhash.c',
    'lib/common/zstd_common.c',
    'lib/compress/fse_compress.c',
    'lib/compress/hist.c',
    'lib/compress/huf_compress.c',
    'lib/compress/zstdmt_compress.c',
    'lib/compress/zstd_compress.c',
    'lib/compress/zstd_compress_literals.c',
    'lib/compress/zstd_compress_sequences.c',
    'lib/compress/zstd_compress_superblock.c',
    'lib/compress/zstd_double_fast.c',
    'lib/compress/zstd_fast.c',
    'lib/compress/zstd_lazy.c',
    'lib/compress/zstd_ldm.c',
    'lib/compress/zstd_opt.c',
    'lib/compress/zstd_preSplit.c',
    'lib/decompress/huf_decompress.c',
    'lib/decompress/zstd_ddict.c',
    'lib/decompress/zstd_decompress.c',
    'lib/decompress/zstd_decompress_block.c',
    'lib/deprecated/zbuff_common.c',
    'lib/deprecated/zbuff_compress.c',
    'lib/deprecated/zbuff_decompress.c',
    'lib/dictBuilder/cover.c',
    'lib/dictBuilder/divsufsort.c',
    'lib/dictBuilder/fastcover.c',
    'lib/dictBuilder/zdict.c',

    'lib/legacy/zstd_v01.c',
    'lib/legacy/zstd_v02.c',
    'lib/legacy/zstd_v03.c',
    'lib/legacy/zstd_v04.c',
    'lib/legacy/zstd_v05.c',
    'lib/legacy/zstd_v06.c',
    'lib/legacy/zstd_v07.c',
]

if target_machine.cpu_family() == 'x86_64' and compiler.get_id() != 'msvc'
    sources += ['lib/decompress/huf_decompress_amd64.S']
endif

if get_option('multithreaded').enabled()
    c_flags += ['-DZSTD_MULTITHREAD=1']
endif

if get_option('minify').enabled()
    c_flags += [
        '-DZSTD_EXCLUDE_BTLAZY2_BLOCK_COMPRESSOR=1',
        '-DZSTD_EXCLUDE_BTOPT_BLOCK_COMPRESSOR=1',
        '-DZSTD_EXCLUDE_BTULTRA_BLOCK_COMPRESSOR=1',
        '-DZSTD_EXCLUDE_DFAST_BLOCK_COMPRESSOR=1',
        '-DZSTD_EXCLUDE_GREEDY_BLOCK_COMPRESSOR=1',
        '-DZSTD_EXCLUDE_LAZY2_BLOCK_COMPRESSOR=1',
        '-DZSTD_FORCE_DECOMPRESS_SEQUENCES_SHORT=1',
        '-DZSTD_LEGACY_SUPPORT=0',
    ]
endif

incdirs = include_directories(incdirs)

zstd_lib = library(
    'zstd',
    sources,
    c_args: c_flags,
    include_directories: incdirs,
    dependencies: link_deps,
)

zstd_dep = declare_dependency(
    compile_args: c_flags,
    include_directories: incdirs,
    dependencies: link_deps,
    link_with: zstd_lib,
    version: meson.project_version()
)

meson.override_dependency('zstd', zstd_dep)

# vim: set ts=4 sts=4 sw=4 et:
