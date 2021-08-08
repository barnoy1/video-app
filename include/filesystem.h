#ifndef FILESYSTEM_H
#define FILESYSTEM_H

#include <string>
#include <cstdlib>
#include <boost//filesystem.hpp>
#include <boost/dll.hpp>
class FileSystem
{
private:
  typedef std::string (*Builder) (const std::string& path);

public:
  static std::string getPath(const std::string& path)
  {
    static std::string(*pathBuilder)(std::string const &) = getPathBuilder();
    return (*pathBuilder)(path);
  }

private:
  static std::string const & getRoot()
  {
    static boost::filesystem::path p = boost::dll::program_location().parent_path();    
    static std::string root = p.string();
    //std::replace(root.begin(), root.end(), '\\', '/');
    return root;
  }

  //static std::string(*foo (std::string const &)) getPathBuilder()
  static Builder getPathBuilder()
  {
    if (getRoot() != "")
      return &FileSystem::getPathRelativeRoot;
    else
      return &FileSystem::getPathRelativeBinary;
  }

  static std::string getPathRelativeRoot(const std::string& path)
  {
    return getRoot() + std::string("/") + path;
  }

  static std::string getPathRelativeBinary(const std::string& path)
  {
    return "../../../" + path;
  }


};

// FILESYSTEM_H
#endif
