list( APPEND utest-fvm-shocktube1d_cflibs coolfluid_fvm_core coolfluid_mesh_gmsh coolfluid_mesh_actions )
list( APPEND utest-fvm-shocktube1d_files  utest-fvm-shocktube1d.cpp )

coolfluid_add_unit_test( utest-fvm-shocktube1d )

#########################################################################################

list( APPEND utest-fvm-shocktube2d_cflibs coolfluid_fvm_core coolfluid_mesh_gmsh coolfluid_mesh_tecplot coolfluid_mesh_actions )
list( APPEND utest-fvm-shocktube2d_files  utest-fvm-shocktube2d.cpp )

coolfluid_add_unit_test( utest-fvm-shocktube2d )

#########################################################################################

list( APPEND utest-fvm-buildghoststates_cflibs coolfluid_fvm_core )
list( APPEND utest-fvm-buildghoststates_files  utest-fvm-buildghoststates.cpp )

coolfluid_add_unit_test( utest-fvm-buildghoststates )

#########################################################################################

list( APPEND utest-fvm-fluxsplitter_cflibs coolfluid_fvm_core )
list( APPEND utest-fvm-fluxsplitter_files  utest-fvm-fluxsplitter.cpp )

coolfluid_add_unit_test( utest-fvm-fluxsplitter )

##########################################################################
# acceptance tests

coolfluid_add_acceptance_test( NAME   atest-fvm-shocktube1d
                               SCRIPT atest-fvm-shocktube1d.cfscript )

coolfluid_add_acceptance_test( NAME   atest-fvm-shocktube2d
                               SCRIPT atest-fvm-shocktube2d.cfscript )


