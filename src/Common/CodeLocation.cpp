// Copyright (C) 2010 von Karman Institute for Fluid Dynamics, Belgium
//
// This software is distributed under the terms of the
// GNU Lesser General Public License version 3 (LGPLv3).
// See doc/lgpl.txt and doc/gpl.txt for the license text.

#include <cstdio>
#include <cstring>
#include <list>

#include "Common/BoostFilesystem.hpp"

#include "Common/CodeLocation.hpp"

using namespace std;
using namespace boost;

////////////////////////////////////////////////////////////////////////////////

namespace CF {
  namespace Common {

////////////////////////////////////////////////////////////////////////////////

CodeLocation::CodeLocation(const char * file, int line, const char * function)
: m_file(file), m_function(function), m_line (line)
{
}

////////////////////////////////////////////////////////////////////////////////

std::string CodeLocation::str () const
{
  char line [50];
  sprintf (line, "%d", m_line);
  std::string place (m_file);
  place += ":";
  place += line;
  if ( strlen(m_function) ) // skip if compiler does not set function
  {
    place += ":";
    place += m_function;
  }
  return place;
}

////////////////////////////////////////////////////////////////////////////////

std::string CodeLocation::short_str() const
{
  char line [50];
  sprintf (line, "%d", m_line);
  std::string place;// = filesystem::path(m_file).end().;//(filesystem::path(m_file).parent_path().string());

  filesystem::path path(m_file);
  std::list<std::string> parts;
  copy(path.begin(), path.end(), back_inserter(parts));

  if (parts.size() < 2)
  {
    place = path.string();
  }
  else
  {
    boost::filesystem::path pathSub;
    std::list<std::string>::iterator it = parts.end();

    it--; it--;
    for ( ; it != parts.end(); ++it)
      pathSub /= *it;

    place = pathSub.string();
  }

  place += ":";
  place += line;
  if ( strlen(m_function) ) // skip if compiler doees not set function
  {
    place += ":";
    place += m_function;
    //   filesystem::path(m_function).parent_path();
  }
  return place;
}

////////////////////////////////////////////////////////////////////////////////

  } // Common
} // CF
