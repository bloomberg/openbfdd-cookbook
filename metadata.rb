name             'bfd'
maintainer       'Compute Architecture'
maintainer_email 'compute@bloomberg.net'
license          'Apache 2.0'
description      'Installs/Configures OpenBFD'
long_description 'Installs/Configures OpenBFD'
version          '0.2.0'

supports 'ubuntu'

depends 'apt'
depends 'poise'

chef_version '>= 12' if respond_to?(:chef_version)
