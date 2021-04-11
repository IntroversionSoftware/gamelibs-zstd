project('zstd', 'c', version: '1.4.9')

compiler = meson.get_compiler('c')
link_deps = []

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

incdirs = include_directories(incdirs)

lib = static_library(
    'zstd',
    sources,
    include_directories: incdirs,
    dependencies: link_deps,
)

zstd_dep = declare_dependency(
    include_directories: incdirs,
    dependencies: link_deps,
    link_with: lib,
    version: meson.project_version()
)

meson.override_dependency('zstd', zstd_dep)

# vim: set ts=4 sts=4 sw=4 et:
