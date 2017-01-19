name             'bfd'
maintainer       'Compute Architecture'
maintainer_email 'compute@bloomberg.net'
license          'Apache 2.0'
description      'Installs/Configures OpenBFD'
long_description 'Installs/Configures OpenBFD'
version          '0.2.0'

supports 'ubuntu', '= 12.04'
supports 'ubuntu', '= 14.04'

depends 'apt'
depends 'poise'

chef_version '>= 11' if respond_to?(:chef_version)
