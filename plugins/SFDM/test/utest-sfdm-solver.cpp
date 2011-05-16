// Copyright (C) 2010 von Karman Institute for Fluid Dynamics, Belgium
//
// This software is distributed under the terms of the
// GNU Lesser General Public License version 3 (LGPLv3).
// See doc/lgpl.txt and doc/gpl.txt for the license text.

#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MODULE "Test module for CF::SFDM"

#include <boost/test/unit_test.hpp>

#include "Common/CreateComponent.hpp"
#include "Common/Log.hpp"
#include "Common/Core.hpp"
#include "Common/CRoot.hpp"
#include "Common/FindComponents.hpp"
#include "Mesh/CMesh.hpp"
#include "Mesh/CRegion.hpp"
#include "Mesh/CField.hpp"
#include "Mesh/CSimpleMeshGenerator.hpp"
#include "Mesh/CEntities.hpp"
#include "Mesh/ElementType.hpp"
#include "Mesh/CMeshWriter.hpp"
#include "Mesh/CDomain.hpp"
#include "Mesh/Actions/CInitFieldFunction.hpp"
#include "Mesh/Actions/CreateSpaceP0.hpp"
#include "Solver/CModelUnsteady.hpp"
#include "Solver/CSolver.hpp"
#include "Solver/CPhysicalModel.hpp"
#include "Mesh/Actions/CBuildFaces.hpp"
#include "Mesh/Actions/CBuildVolume.hpp"
#include "Mesh/Actions/CreateSpaceP0.hpp"
#include "SFDM/CreateSpace.hpp"

using namespace CF;
using namespace CF::Common;
using namespace CF::Mesh;
using namespace CF::Mesh::Actions;
using namespace CF::Solver;
//using namespace CF::Solver::Actions;
using namespace CF::SFDM;

//////////////////////////////////////////////////////////////////////////////

BOOST_AUTO_TEST_SUITE( SFDM_Spaces_Suite )

//////////////////////////////////////////////////////////////////////////////

BOOST_AUTO_TEST_CASE( Solver )
{
  CModelUnsteady& model   = Core::instance().root().create_component<CModelUnsteady>("model");
  CPhysicalModel& physics = model.create_physics("Physics");
  CDomain&        domain  = model.create_domain("Domain");
  CSolver&        solver  = model.create_solver("CF.SFDM.SFDSolver");

  //////////////////////////////////////////////////////////////////////////////
  // configure physics

  physics.configure_property("solution_state",std::string("CF.AdvectionDiffusion.State"));


  //////////////////////////////////////////////////////////////////////////////
  // create and configure mesh

  /// Create a mesh consisting of a line with length 1. and 20 divisions
  CMesh& mesh = domain.create_component<CMesh>("mesh");
  const Uint divisions=200;
  const Real length=2.*divisions;
  CSimpleMeshGenerator::create_line(mesh, length, divisions);


  CGroup& tools = model.create_component<CGroup>("tools");
  tools.mark_basic();
  CMeshTransformer& spectral_difference_transformer = tools.create_component<CMeshTransformer>("SpectralFiniteDifferenceTransformer").mark_basic().as_type<CMeshTransformer>();
  spectral_difference_transformer.create_component<CBuildFaces>       ("1_build_faces").mark_basic().configure_property("store_cell2face",true);
  spectral_difference_transformer.create_component<CreateSpaceP0>     ("2_create_space_P0").mark_basic();
  spectral_difference_transformer.create_component<SFDM::CreateSpace> ("3_create_sfd_spaces").mark_basic().configure_property("P",0u);
  spectral_difference_transformer.create_component<CBuildVolume>      ("4_build_volume_field").mark_basic();

  spectral_difference_transformer.transform(mesh);

  //////////////////////////////////////////////////////////////////////////////
  // configure solver

  solver.configure_property("physical_model",physics.full_path());
  solver.configure_property("Domain",domain.full_path());
  solver.configure_option_recursively("riemann_solver",std::string("CF.RiemannSolvers.Roe"));
  solver.configure_option_recursively("roe_state",std::string("CF.AdvectionDiffusion.State"));
  solver.configure_option_recursively("solution_state",physics.solution_state().full_path());


  solver.configure_option_recursively("time",model.time().full_path());
  solver.configure_option_recursively("time_accurate",true);

  model.time().configure_property("end_time",length/2.);
  model.time().configure_property("time_step",length);

  /// Initialize solution field with the function sin(2*pi*x)
  Actions::CInitFieldFunction::Ptr init_field = Common::Core::instance().root().create_component_ptr<Actions::CInitFieldFunction>("init_field");
  //init_field->configure_property("Functions",std::vector<std::string>(1,"sin(2*pi*x/10)"));

  std::string gaussian="sigma:="+to_str(length/7.)+"; mu:="+to_str(length/2)+"; 1/sqrt(2*pi*sigma)*exp(-(x-mu)^2/(2*sigma))";
  init_field->configure_property("Functions",std::vector<std::string>(1,gaussian));
  init_field->configure_property("Field",find_component_with_tag<CField>(mesh,"solution").full_path());
  init_field->transform(mesh);


  CMeshWriter::Ptr gmsh_writer = create_component_abstract_type<CMeshWriter>("CF.Mesh.Gmsh.CWriter","meshwriter");
  std::vector<CField::Ptr> fields;
  fields.push_back(find_component_with_tag<CField>(mesh,"solution").as_ptr<CField>());
  gmsh_writer->set_fields(fields);
  boost::filesystem::path filename;


  gmsh_writer->write_from_to(mesh,URI("line_"+to_str(model.time().time())+".msh"));




  solver.get_child("iterate").configure_property("verbose",true);
  //solver.get_child("iterate").configure_property("MaxIterations",1u);
  solver.solve();

  CFinfo << model.tree() << CFendl;

  CFinfo << "time = " << model.time().time();

  filename = ("line_"+to_str(model.time().time())+".msh");
  /// write gmsh file. note that gmsh gets really confused because of the multistate view
  gmsh_writer->write_from_to(mesh,"line_"+to_str(model.time().time())+".msh");

}

////////////////////////////////////////////////////////////////////////////////

BOOST_AUTO_TEST_SUITE_END()

////////////////////////////////////////////////////////////////////////////////

