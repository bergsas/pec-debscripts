#!/bin/bash

source ./make_package.sh

package_url=http://www.poweredgec.com/files/setupbios-2013-10-03.tgz
package_url=http://www.poweredgec.com/files/ldstate-2013-11-23.tgz
#cache_package="`pwd`/cache/ldstate-2013-11-23.tgz"

# subdir of tarball :/
package_bombed=.

package_name=pec-ldstate
package_version=0.1

packager_email=erlend.bergsaas@met.no
package_maintainer="Erlend Bergsaas"
package_copyright=blank


install_files()
{
  use opt/dell/pec "*"
}

package_links="/opt/dell/pec/sas2flash /usr/bin/sas2flash
/opt/dell/pec/sas2ircu /usr/bin/sas2ircu
/opt/dell/pec/ldstate /usr/bin/ldstate"

make_package  
