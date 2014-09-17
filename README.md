# puppet-phpbrew

This is a puppet module for phpbrew

Dependencies
------------

To run `puppet-module`, you must have the following installed:

* Puppet stdlib > 3.2.0 https://github.com/puppetlabs/puppetlabs-stdlib

a more complex example
------------
```ruby
  phpbrew::php { '5.3.29': }
  phpbrew::inisettings {
    'memory_limit':
      version => '5.3.29',
      entry => 'PHP/memory_limit',
      value => '256M';
    'timezone':
      version => '5.3.29',
      entry => 'Date/date.timezone',
      value => 'Europe/Berlin';
  }
  phpbrew::extension {'xdebug':
    extension_name => 'xdebug',
    version => '5.3.29'
  }
  phpbrew::extension::inisettings {
    'force_display_errors':
      version => '5.3.29',
      extension => 'xdebug',
      entry => 'Xdebug/force_display_errors',
      value => '1';
  }
  phpbrew::extension {'memcached':
    extension_name => 'memcached',
    version => '5.3.29',
  }
  phpbrew::fpmsettings {
    'fpm_socket':
      version => '5.3.29',
      entry => 'www/listen',
      value => '/tmp/php5-fpm.sock';
    'listen.owner':
      version => '5.3.29',
      entry => 'www/listen.owner',
      value => 'vagrant';
    'listen.group':
      version => '5.3.29',
      entry => 'www/listen.group',
      value => 'vagrant';
    'listen.mode':
      version => '5.3.29',
      entry => 'www/listen.mode',
      value => '0777';
}


  phpbrew::php { '5.4.32': }
  phpbrew::extension {'xdebug-5.4.32':
    extension_name => 'xdebug',
    version => '5.4.32'
  }
  phpbrew::extension {'memcached-5.4.32':
    extension_name => 'memcached',
    version => '5.4.32',
  }
  phpbrew::inisettings {
    'memory_limit_5.4.32':
      version => '5.4.32',
      entry => 'PHP/memory_limit',
      value => '256M';
    'timezone_5.4.32':
      version => '5.4.32',
      entry => 'Date/date.timezone',
      value => 'Europe/Berlin';
  }

  phpbrew::fpmsettings {
    'fpm_socket5.4.32':
      version => '5.4.32',
      entry => 'www/listen',
      value => '/tmp/php5-fpm.sock';
    'listen.owner5.4.32':
      version => '5.4.32',
      entry => 'www/listen.owner',
      value => 'vagrant';
    'listen.group5.4.32':
      version => '5.4.32',
      entry => 'www/listen.group',
      value => 'vagrant';
    'listen.mode5.4.32':
      version => '5.4.32',
      entry => 'www/listen.mode',
      value => '0777';
  }
```

## License

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


## Copyright

	Jan Gantzert
	www.jg-dev.de

Support
-------

Please log tickets and issues at our [Projects site](https://github.com/jg-development/puppet-phpbrew)
