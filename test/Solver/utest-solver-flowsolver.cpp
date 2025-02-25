// Copyright (C) 2010 von Karman Institute for Fluid Dynamics, Belgium
//
// This software is distributed under the terms of the
// GNU Lesser General Public License version 3 (LGPLv3).
// See doc/lgpl.txt and doc/gpl.txt for the license text.

#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MODULE "Test module for CF::Solver::FlowSolver"

#include <iostream>

#include <boost/test/unit_test.hpp>
#include <boost/assign/list_of.hpp>

#include "Common/Log.hpp"
#include "Common/CBuilder.hpp"
#include "Common/Core.hpp"
#include "Common/CRoot.hpp"
#include "Common/CEnv.hpp"
#include "Common/OptionT.hpp"
#include "Common/OptionArray.hpp"
#include "Common/CGroupActions.hpp"

#include "Mesh/CSimpleMeshGenerator.hpp"
#include "Mesh/CMesh.hpp"

#include "Physics/PhysModel.hpp"

#include "Solver/FlowSolver.hpp"
#include "Solver/CTime.hpp"
#include "Solver/Tags.hpp"

using namespace CF;
using namespace CF::Common;
using namespace CF::Solver;
using namespace CF::Mesh;

#define CF_CHECK_THROW( command , exception ) \
  { \
    Core::instance().environment().configure_option("exception_outputs",false); \
    Core::instance().environment().configure_option("exception_backtrace",false); \
    BOOST_CHECK_THROW( command , exception ); \
    Core::instance().environment().configure_option("exception_outputs",true); \
    Core::instance().environment().configure_option("exception_backtrace",true); \
  }

namespace CF {
namespace Solver {
class Solver_API Echo : public CAction
{
  public:

  typedef boost::shared_ptr<Echo> Ptr;
  typedef boost::shared_ptr<Echo const> ConstPtr;

  Echo(const std::string& name ) : CAction(name)
  {
    m_options.add_option(OptionT<std::string>::create("echo", "echo"))
        ->description("Print to screen")
        ->pretty_name("Echo");

    m_options.add_option(OptionArrayT<URI>::create("regions", std::vector<URI>()))
        ->description("Print to screen")
        ->pretty_name("Regions");
  }
  virtual ~Echo() {}

  static std::string type_name() { return "Echo"; }

  virtual void execute() { CFinfo << option("echo").value_str() << CFendl; }
};
} // Solver
} // CF

ComponentBuilder<Echo,CAction,LibSolver> Echo_builder;

////////////////////////////////////////////////////////////////////////////////////////////

BOOST_AUTO_TEST_SUITE( flow_solver_suite )

////////////////////////////////////////////////////////////////////////////////////////////

BOOST_AUTO_TEST_CASE( test_solver_setup1 )
{
  CRoot& root = Core::instance().root();

  Physics::PhysModel::Ptr physical_model =
      build_component_abstract_type<Physics::PhysModel>( "CF.Physics.DynamicModel", "physical_model" );

  root.add_component(physical_model);

  CMesh& mesh = root.create_component<CMesh>("mesh");
  CTime& time = root.create_component<CTime>("time");

  FlowSolver& solver = root.create_component<FlowSolver>("flowsolver");

  CAction& setup = solver.create_component<Echo>("setup");
  setup.configure_option("echo",std::string("setup called"));
  CAction& solve = solver.create_component<Echo>("solve");
  solve.configure_option("echo",std::string("solve called"));

  CF_CHECK_THROW( solver.execute() , SetupError );  // physical model not set

  solver.configure_option(Solver::Tags::physical_model(),root.get_child("physical_model").uri());

  CF_CHECK_THROW( solver.execute() , SetupError );

  solver.configure_option(Solver::Tags::mesh(),root.get_child("mesh").uri());

  CF_CHECK_THROW( solver.execute() , SetupError );

  solver.configure_option(Solver::Tags::time() ,root.get_child("time").uri());

  CF_CHECK_THROW( solver.execute() , SetupError ); // setup not set

  solver.configure_option( FlowSolver::Tags::setup(), setup.uri());

  CF_CHECK_THROW( solver.execute() , SetupError ); // setup not set

  solver.configure_option( FlowSolver::Tags::solve(),solve.uri());

  // Finally enough configured to solve
  BOOST_CHECK_NO_THROW(solver.execute());
}

////////////////////////////////////////////////////////////////////////////////

BOOST_AUTO_TEST_CASE( test_solver_setup2 )
{
  CRoot& root = Core::instance().root();

  FlowSolver& solver = root.create_component<FlowSolver>("flowsolver_1");
  CAction& setup = solver.create_component<Echo>("setup");
  setup.configure_option("echo",std::string("setup called"));
  CAction& solve = solver.create_component<Echo>("solve");
  solve.configure_option("echo",std::string("solve called"));

  CF_CHECK_THROW( solver.execute() , SetupError );

  solver.configure_option(FlowSolver::Tags::solve(),solve.uri());

  CF_CHECK_THROW( solver.execute() , SetupError );

  solver.configure_option(FlowSolver::Tags::setup(),setup.uri());

  CF_CHECK_THROW( solver.execute() , SetupError );

  solver.configure_option( FlowSolver::Tags::physical_model(),root.get_child("physical_model").uri());

  CF_CHECK_THROW( solver.execute() , SetupError );

  solver.configure_option(Solver::Tags::mesh(),root.get_child("mesh").uri());

  CF_CHECK_THROW( solver.execute() , SetupError );

  solver.configure_option( FlowSolver::Tags::time(),root.get_child("time").uri());

  // Finally enough configured to solve
  BOOST_CHECK_NO_THROW(solver.execute());


  CF_CHECK_THROW(solver.create_bc_action("compute_inlet","CF.Solver.Echo",root.get_child("mesh").as_type<CMesh>().topology()) , SetupError );
  CF_CHECK_THROW(solver.create_inner_action("compute_convective_terms","CF.Solver.Echo",root.get_child("mesh").as_type<CMesh>().topology()), SetupError );

  CAction& bc = solver.create_component<CGroupActions>("compute_bc");
  solver.configure_option( FlowSolver::Tags::bc(),bc.uri());

  CAction& inner = solver.create_component<CGroupActions>("compute_inner");
  solver.configure_option( FlowSolver::Tags::inner(),bc.uri());

  BOOST_CHECK_NO_THROW(solver.create_bc_action("compute_convective_terms","CF.Solver.Echo",root.get_child("mesh").as_type<CMesh>().topology()));



  CFinfo << solver.tree() << CFendl;
}

////////////////////////////////////////////////////////////////////////////////////////////

BOOST_AUTO_TEST_CASE( test_solver_setup3 )
{
  CRoot& root = Core::instance().root();

  FlowSolver& solver = root.create_component<FlowSolver>("flowsolver_2");

  CAction& setup = solver.create_component<Echo>("setup");
  setup.configure_option("echo",std::string("setup called"));

  CAction& solve = solver.create_component<CGroupActions>("solve");
  solve.create_component<CGroupActions>("inner")
      .add_tag(FlowSolver::Tags::inner());
  solve.create_component<CGroupActions>("bc")
      .add_tag(FlowSolver::Tags::bc());

  CF_CHECK_THROW( solver.execute() , SetupError );

  solver.configure_option(FlowSolver::Tags::solve(),solve.uri());

  CF_CHECK_THROW( solver.execute() , SetupError );

  solver.configure_option(FlowSolver::Tags::setup(),setup.uri());

  CF_CHECK_THROW( solver.execute() , SetupError );

  solver.configure_option(FlowSolver::Tags::physical_model(),root.get_child("physical_model").uri());

  CF_CHECK_THROW( solver.execute() , SetupError );

  solver.configure_option(Solver::Tags::mesh(),root.get_child("mesh").uri());

  CF_CHECK_THROW( solver.execute() , SetupError );

  solver.configure_option(FlowSolver::Tags::time(),root.get_child("time").uri());

  // Finally enough configured to solve
  BOOST_CHECK_NO_THROW(solver.execute());

  // bc component should be automatically detected.
  BOOST_CHECK_NO_THROW(solver.create_bc_action("compute_inlet","CF.Solver.Echo",root.get_child("mesh").as_type<CMesh>().topology()));
  BOOST_CHECK_NO_THROW(solver.create_bc_action("compute_outlet","CF.Solver.Echo",root.get_child("mesh").as_type<CMesh>().topology()));

  BOOST_CHECK_NO_THROW(solver.create_inner_action("compute_convective_terms","CF.Solver.Echo",root.get_child("mesh").as_type<CMesh>().topology()));
  BOOST_CHECK_NO_THROW(solver.create_inner_action("compute_diffusive_terms","CF.Solver.Echo",root.get_child("mesh").as_type<CMesh>().topology()));

  CFinfo << solver.tree() << CFendl;
  CFinfo << solver.options().list_options() << CFendl;
}

////////////////////////////////////////////////////////////////////////////////////////////

BOOST_AUTO_TEST_SUITE_END()
