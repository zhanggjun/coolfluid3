// Copyright (C) 2010 von Karman Institute for Fluid Dynamics, Belgium
//
// This software is distributed under the terms of the
// GNU Lesser General Public License version 3 (LGPLv3).
// See doc/lgpl.txt and doc/gpl.txt for the license text.

#include "Common/LibLoader.hpp"
#include "Common/CLibrary.hpp"
#include "Common/CLibraries.hpp"
#include "Common/Core.hpp"

////////////////////////////////////////////////////////////////////////////////

namespace CF {
namespace Common {

////////////////////////////////////////////////////////////////////////////////

LibLoader::LibLoader()
{
}

LibLoader::~LibLoader()
{
}

////////////////////////////////////////////////////////////////////////////////

void LibLoader::load_library(const std::string& lib)
{
//  void* handle =
      system_load_library(lib);

  /// @todo find a cross-platform way of storing the pointer, maybe using void*

  // initiate all libraries not yet initiated
  // because loading one library might implicitly load many others

  Core::instance().libraries().initiate_all_libraries();

}

////////////////////////////////////////////////////////////////////////////////

void LibLoader::unload_library( CLibrary::Ptr lib )
{
  lib->terminate();

  /// @todo implement system_unload_library
  //  system_unload_library(lib);
}

////////////////////////////////////////////////////////////////////////////////

} // Common
} // CF

////////////////////////////////////////////////////////////////////////////////
