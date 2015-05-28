bfd
================
Installs and configures [OpenBFDD][1].

## Supported Platforms
- Ubuntu 12.04, 14.04

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['bfd']['repo']['url']</tt></td>
    <td>String</td>
    <td>Git repo for OpenBFDD.</td>
    <td><tt>https://github.com/dyninc/OpenBFDD.git</tt></td>
  </tr>
  <tr>
    <td><tt>['bfd']['repo']['sha']</tt></td>
    <td>String</td>
    <td>Git revision of the OpenBFD repo to pull down.</td>
    <td><tt>895cfb523bb96b3ef199fc5916578482ccd528ee</tt></td>
  </tr>
  <tr>
    <td><tt>['bfd']['version']</tt></td>
    <td>String</td>
    <td>v0.5.3</td>
    <td><tt>Version of OpenBFD to use in the package naming</tt></td>
  </tr>
  <tr>
    <td><tt>['bfd']['package']['short_name']</tt></td>
    <td>String</td>
    <td>openbfdd</td>
    <td><tt>Short name of the package name</tt></td>
  </tr>
  <tr>
    <td><tt>['bfd']['package']['name']</tt></td>
    <td>String</td>
    <td>openbfdd_v0.5.3_amd64.pkg</td>
    <td><tt>Full name of the package</tt></td>
  </tr>
  <tr>
    <td><tt>['bfd']['package']['dependencies']</tt></td>
    <td>String</td>
    <td></td>
    <td><tt>Dependencies of the package</tt></td>
  </tr>
  <tr>
    <td><tt>['bfd']['install_dir']</tt></td>
    <td>String</td>
    <td>/usr/local</td>
    <td><tt>Location where package files install</tt></td>
  </tr>
  <tr>
    <td><tt>['bfd']['bin_dir']</tt></td>
    <td>String</td>
    <td>/home/vagrant/chef-bcpc/bins</td>
    <td><tt>Location where package should be created</tt></td>
  </tr>
  <tr>
    <td><tt>['bfd']['owner']</tt></td>
    <td>String</td>
    <td>root</td>
    <td><tt>Owner of package files</tt></td>
  </tr>
  <tr>
    <td><tt>['bfd']['group']</tt></td>
    <td>String</td>
    <td>root</td>
    <td><tt>Group ownership of package files</tt></td>
  </tr>
</table>

## Usage

### bfd::default

Include `bfd` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[bfd::default]"
  ]
}
```

### cobbler::install

Include `bfd` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[bfd::install]"
  ]
}
```

## Maintainers

Author:: [Bloomberg Compute Architecture Group][2] (<compute@bloomberg.net>)

[1]: http://dyninc.github.io/OpenBFDD
[2]: http://www.bloomberglabs.com/compute-architecture/
