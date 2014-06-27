#!/bin/bash

# http://askubuntu.com/questions/27715/create-a-deb-package-from-scripts-or-binaries

source ./make_package.sh

package_url="http://www.poweredgec.com/files/bmc-2014-01-08.tgz"
#cache_package="`pwd`/cache/bmc-2014-01-08.tgz"

# subdir of tarball :/
package_bombed=.

package_name=pec-bmc-tools
package_version=0.1


package_email="$DEBEMAIL"
packager_maintainer="$DEBFULLNAME"
package_copyright=blank

install_files()
{
  use opt/dell/pec bmc
  use opt/dell/pec "*.*"
}

# UGHly
package_links="/opt/dell/pec/bmc /usr/bin/bmc
/opt/dell/pec/pec-logs.sh /usr/bin/pec-logs.sh"

make_package  
