// Copyright (C) 2010 von Karman Institute for Fluid Dynamics, Belgium
//
// This software is distributed under the terms of the
// GNU Lesser General Public License version 3 (LGPLv3).
// See doc/lgpl.txt and doc/gpl.txt for the license text.

#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MODULE "Test module for heat-conduction related proto operations"

#include <boost/test/unit_test.hpp>

#include "Common/Core.hpp" 
#include "Common/CEnv.hpp"
#include "Common/CRoot.hpp"

#include "Mesh/CDomain.hpp"

#include "Solver/CModel.hpp"

#include "Solver/Actions/Proto/CProtoAction.hpp"
#include "Solver/Actions/Proto/Expression.hpp"

#include "Tools/MeshGeneration/MeshGeneration.hpp"

#include "UFEM/LinearSolver.hpp"

using namespace CF;
using namespace CF::Solver;
using namespace CF::Solver::Actions;
using namespace CF::Solver::Actions::Proto;
using namespace CF::Common;
using namespace CF::Math::Consts;
using namespace CF::Mesh;

using namespace boost;


typedef std::vector<std::string> StringsT;
typedef std::vector<Uint> SizesT;

/// Check close, for testing purposes
inline void
check_close(const Real a, const Real b, const Real threshold)
{
  BOOST_CHECK_CLOSE(a, b, threshold);
}

static boost::proto::terminal< void(*)(Real, Real, Real) >::type const _check_close = {&check_close};

struct ProtoHeatFixture
{
  ProtoHeatFixture() :
    root( Core::instance().root() )
  {
    solver_config = boost::unit_test::framework::master_test_suite().argv[1];
  }

  CRoot& root;
  std::string solver_config;

};

BOOST_FIXTURE_TEST_SUITE( ProtoHeatSuite, ProtoHeatFixture )

BOOST_AUTO_TEST_CASE( Heat1DComponent )
{
  Core::instance().environment().configure_option("log_level", 4u);
  
  // Parameters
  Real length            = 5.;
  const Uint nb_segments = 5 ;

  // Setup a model
  CModel& model = root.create_component<CModel>("Model");
  CDomain& domain = model.create_domain("Domain");
  UFEM::LinearSolver& solver = model.create_component<UFEM::LinearSolver>("Solver");

  // Linear system setup (TODO: sane default config for this, so this can be skipped)
  CEigenLSS& lss = model.create_component<CEigenLSS>("LSS");
  lss.set_config_file(solver_config);
  solver.solve_action().configure_option("lss", lss.uri());

  // Proto placeholders
  MeshTerm<0, ScalarField> temperature("Temperature", "T");

  // Allowed elements (reducing this list improves compile times)
  boost::mpl::vector1<Mesh::SF::Line1DLagrangeP1> allowed_elements;
  
  // add the top-level actions (assembly, BC and solve)
  solver
    << create_proto_action
    (
      "Assembly",
      elements_expression
      (
        allowed_elements,
        group <<
        (
          _A = _0,
          element_quadrature( _A(temperature) += transpose(nabla(temperature)) * nabla(temperature) ),
          solver.system_matrix += _A
        )
      )
    )
    << solver.boundary_conditions()
    << solver.solve_action()
    << create_proto_action("Increment", nodes_expression(temperature += solver.solution(temperature)))
    << create_proto_action("Output", nodes_expression(_cout << "T(" << coordinates(0,0) << ") = " << temperature << "\n"))
    << create_proto_action("CheckResult", nodes_expression(_check_close(temperature, 10. + 25.*(coordinates(0,0) / length), 1e-6)));
  
  // Creating the physics here makes sure everything is up-to-date
  model.create_physics("CF.Physics.DynamicModel");
  
  // Setup mesh
  CMesh& mesh = domain.create_component<CMesh>("Mesh");
  Tools::MeshGeneration::create_line(mesh, length, nb_segments);
    
  // Set boundary conditions
  solver.boundary_conditions().add_constant_bc("xneg", "Temperature", 10.);
  solver.boundary_conditions().add_constant_bc("xpos", "Temperature", 35.);
  
  
  // Run the solver
  model.simulate();
}

////////////////////////////////////////////////////////////////////////////////

BOOST_AUTO_TEST_SUITE_END()

////////////////////////////////////////////////////////////////////////////////
