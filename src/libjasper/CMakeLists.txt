set(lib_name libjasper)
#######################################
# preprocessor
if(MSVC)
  add_definitions(
    -D_CRT_NONSTDC_NO_DEPRECATE
    -D_CRT_SECURE_NO_WARNINGS
    )
endif()
#######################################
# include directories
include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/include
  )
#######################################
# library sources
###################
# base
set(base_srcs
  base/jas_cm.c
  base/jas_debug.c
  base/jas_getopt.c
  base/jas_icc.c
  base/jas_iccdata.c
  base/jas_image.c
  base/jas_init.c
  base/jas_malloc.c
  base/jas_seq.c
  base/jas_stream.c
  base/jas_string.c
  base/jas_tmr.c
  base/jas_tvp.c
  base/jas_version.c
  )
source_group(base FILES ${base_srcs})
list(APPEND ${lib_name}_libsrcs ${base_srcs})
###################
# bmp
set(bmp_srcs
  bmp/bmp_cod.c
  bmp/bmp_cod.h
  bmp/bmp_dec.c
  bmp/bmp_enc.c
  bmp/bmp_enc.h
  )
source_group(bmp FILES ${bmp_srcs})
list(APPEND ${lib_name}_libsrcs ${bmp_srcs})
###################
# include
set(include_srcs
  include/jasper/jas_cm.h
  include/jasper/jas_config2.h
  include/jasper/jas_debug.h
  include/jasper/jas_fix.h
  include/jasper/jas_getopt.h
  include/jasper/jas_icc.h
  include/jasper/jas_image.h
  include/jasper/jas_init.h
  include/jasper/jas_malloc.h
  include/jasper/jas_math.h
  include/jasper/jasper.h
  include/jasper/jas_seq.h
  include/jasper/jas_stream.h
  include/jasper/jas_string.h
  include/jasper/jas_tmr.h
  include/jasper/jas_tvp.h
  include/jasper/jas_types.h
  include/jasper/jas_version.h
  ${PROJECT_BINARY_DIR}/jasper/jas_config.h
  )
source_group(include FILES ${include_srcs})
list(APPEND ${lib_name}_libsrcs ${include_srcs})
###################
# jp2
set(jp2_srcs
  jp2/jp2_cod.c
  jp2/jp2_cod.h
  jp2/jp2_dec.c
  jp2/jp2_dec.h
  jp2/jp2_enc.c
  )
source_group(jp2 FILES ${jp2_srcs})
list(APPEND ${lib_name}_libsrcs ${jp2_srcs})
###################
# jpc
set(jpc_srcs
  jpc/jpc_bs.c
  jpc/jpc_bs.h
  jpc/jpc_cod.h
  jpc/jpc_cs.c
  jpc/jpc_cs.h
  jpc/jpc_dec.c
  jpc/jpc_dec.h
  jpc/jpc_enc.c
  jpc/jpc_enc.h
  jpc/jpc_fix.h
  jpc/jpc_flt.h
  jpc/jpc_math.c
  jpc/jpc_math.h
  jpc/jpc_mct.c
  jpc/jpc_mct.h
  jpc/jpc_mqcod.c
  jpc/jpc_mqcod.h
  jpc/jpc_mqdec.c
  jpc/jpc_mqdec.h
  jpc/jpc_mqenc.c
  jpc/jpc_mqenc.h
  jpc/jpc_qmfb.c
  jpc/jpc_qmfb.h
  jpc/jpc_t1cod.c
  jpc/jpc_t1cod.h
  jpc/jpc_t1dec.c
  jpc/jpc_t1dec.h
  jpc/jpc_t1enc.c
  jpc/jpc_t1enc.h
  jpc/jpc_t2cod.c
  jpc/jpc_t2cod.h
  jpc/jpc_t2dec.c
  jpc/jpc_t2dec.h
  jpc/jpc_t2enc.c
  jpc/jpc_t2enc.h
  jpc/jpc_tagtree.c
  jpc/jpc_tagtree.h
  jpc/jpc_tsfb.c
  jpc/jpc_tsfb.h
  jpc/jpc_util.c
  jpc/jpc_util.h
  )
source_group(jpc FILES ${jpc_srcs})
list(APPEND ${lib_name}_libsrcs ${jpc_srcs})
###################
# jpg
set(jpg_srcs
  jpg/jpg_cod.h
  jpg/jpg_dummy.c
  jpg/jpg_val.c
  )
source_group(jpg FILES ${jpg_srcs})
list(APPEND ${lib_name}_libsrcs ${jpg_srcs})
###################
# mif
set(mif_srcs
  mif/mif_cod.c
  mif/mif_cod.h
  )
source_group(mif FILES ${mif_srcs})
list(APPEND ${lib_name}_libsrcs ${mif_srcs})
###################
# pgx
set(pgx_srcs
  pgx/pgx_cod.c
  pgx/pgx_cod.h
  pgx/pgx_dec.c
  pgx/pgx_enc.c
  pgx/pgx_enc.h
  )
source_group(pgx FILES ${pgx_srcs})
list(APPEND ${lib_name}_libsrcs ${pgx_srcs})
###################
# pnm
set(pnm_srcs
  pnm/pnm_cod.c
  pnm/pnm_cod.h
  pnm/pnm_dec.c
  pnm/pnm_enc.c
  pnm/pnm_enc.h
  )
source_group(pnm FILES ${pnm_srcs})
list(APPEND ${lib_name}_libsrcs ${pnm_srcs})
###################
# ras
set(ras_srcs
  ras/ras_cod.c
  ras/ras_cod.h
  ras/ras_dec.c
  ras/ras_enc.c
  ras/ras_enc.h
  )
source_group(ras FILES ${ras_srcs})
list(APPEND ${lib_name}_libsrcs ${ras_srcs})
#######################################
# library
add_library(${lib_name} STATIC ${${lib_name}_libsrcs})
# strip off the "lib" prefix, since it's already libjasper
set_target_properties(${lib_name} PROPERTIES PREFIX "")
#######################################
# install
install(TARGETS ${lib_name} EXPORT ${PROJECT_NAME}-targets
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  )
install(FILES ${include_srcs} DESTINATION include/jasper)
install(EXPORT ${PROJECT_NAME}-targets DESTINATION lib/cmake)
