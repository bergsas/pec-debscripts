#!/bin/bash
#
# https://github.com/bergsas/pec-debscripts/
#   
# The create process is copied from
#   http://askubuntu.com/questions/27715/create-a-deb-package-from-scripts-or-binaries
#
# I just provide the structure.
#
#   -Erlend
#
#
# This script doesn't do anything.
#
# The package_* scripts do.
#
# Requires at least the following packages:
#   sudo apt-get install dh-make pbuilder
#

#
# read variables:
#   package_url
#   package_bombed
#   package_name
#   package_version
#   packager_email    NOTE THE R: :)
#   package_maintainer
#   package_copyright
#

package_url=
package_bombed=
package_name=
package_version=

package_links=

package_tgz=
cache_package=
source_dir=
tgz_rootdir=

control_c()
{
  echo "*** DELETE tmpdir $tmpdir!" 1>&2
}

# Ugh. A name.
#   Output should be usable for debian/install file.
use()
{
  # source_dir => target dir
  # tgz_rootdir => source dir Ugh.

  target="$1"
  shift

  cd "$tgz_rootdir"
  for n in "$@"
  do
    if [ -e "$n" ]
    then
      basename="`basename "$n"`"
      cp "$n" "$source_dir/$basename"
      echo "$basename" "$target"
    else
      find . -mindepth 1 -maxdepth 1 -name "$n" -type f -print0 | while read -r -d $'\0' file
      do
        basename="`basename "$file"`"
        cp "$file" "$source_dir/$basename"
        echo "$basename" "$target"
      done
    fi
  done
}
install_files()
{
  echo "This fails so bad. heh" 1>&2
  exit 1
}

make_package()
{
  package_tgz=package.tgz
  die=
  for n in package_url package_bombed package_name package_version packager_email package_maintainer package_copyright
  do
    # This would be dangerous if I didn't know what's going on in the for above. :)
    eval "if [ -z \"\$$n\" ]; then echo \"*** $n: NOT SET\"; die=\"$die $n\"; else echo \"*** $n: \$$n\"; fi"
  done
  
  [ ! -z "$die" ] && echo "*** Cannot continue: variable(s) not set:$die" 1>&2 && exit 1

  case $package_url in
    *.tar.gz|*.tgz) true ;;
    *)
      echo "*** I'm primitive. I don't recognise file format: $package_url"  1>&2
      exit 1
    ;;
  esac

  set -e
  trap control_c SIGINT

  orig_dir="`pwd`"
  tmpdir="`mktemp -d`"
  cd "$tmpdir"

  if [ ! -z "$cache_package" ]
  then
    cp "$cache_package" "$package_tgz"
  else
    curl -lo "$package_tgz" "$package_url"
  fi
  mkdir tarbomb

  tgz_rootdir="`pwd`/tarbomb/$package_bombed" 
  tar xzf "$package_tgz" -C "tarbomb"
  
  source_dir="`pwd`/$package_name-$package_version"
  mkdir "$source_dir"
  cd "$source_dir" 

  # Call the ''install_files'' function.
  # Copy files to source dir and create an output
  #   to be used in debian/install
  install_file_content="`install_files`"

  DEBFULLNAME="$package_maintainer"
  dh_make -s --indep --createorig -y --email "$packager_email" --copyright "$package_copyright"

  # Remove make calls
  grep -v makefile debian/rules > debian/rules.new 
  mv debian/rules.new debian/rules 

  echo "$install_file_content" > debian/install

  [ ! -z "$package_links" ] && echo "$package_links" > debian/$package_name.links

  # We don't want a quilt based package
  echo "1.0" > debian/source/format 
  
  # Remove the example files
  rm debian/*.ex
  
  # Build the package.
  # You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
  debuild -us -uc 

  # ugh. :)
  (
    set -x
    cp ../*.deb "$orig_dir"
  )
  cd "$orig_dir"
#  [ ! -z "$tmpdir" ] && rm -rf "$tmpdir"
}
