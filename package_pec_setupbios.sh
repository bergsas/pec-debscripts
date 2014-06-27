#!/bin/bash

# http://askubuntu.com/questions/27715/create-a-deb-package-from-scripts-or-binaries

source ./make_package.sh

package_url=http://www.poweredgec.com/files/setupbios-2013-10-03.tgz
#cache_package="`pwd`/cache/setupbios-2013-10-03.tgz"

# subdir of tarball :/
package_bombed=setupbios

package_name=pec-setupbios
package_version=0.1

packager_email="$DEBEMAIL"
package_maintainer="$DEBFULLNAME"
package_copyright=blank


install_files()
{
  use opt/dell/pec "*.*"
  use opt/dell/pec alternate_version/setupbios.static
}

package_links="/opt/dell/pec/setupbios.static /usr/bin/setupbios"

make_package  
