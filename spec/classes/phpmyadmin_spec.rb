require 'spec_helper'

describe 'phpmyadmin' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "phpmyadmin class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('phpmyadmin::params') }
          it { is_expected.to contain_class('phpmyadmin::install').that_comes_before('phpmyadmin::config') }
          it { is_expected.to contain_class('phpmyadmin::config') }

          it { is_expected.to contain_package('phpMyAdmin').with(:ensure => 'present') }
          it { is_expected.to contain_file('/etc/phpMyAdmin/config.inc.php').with(:owner => 'apache', :group => 'apache')}
          it { is_expected.to contain_file('/etc/phpMyAdmin/config.inc.php').with(:content => /\$cfg\['blowfish_secret'\] = '10794148831867382';/)}
          it { is_expected.to contain_file('/etc/phpMyAdmin/config.inc.php').with(:content => /\$cfg\['UploadDir'\] = '\/var\/lib\/phpMyAdmin\/upload';/)}
          # secret
        end

        context "set package, version, config file, user, group" do
          let(:params) { { :package_name => 'myAdmin', :version => '1.2.3', :config_file => '/var/www/html/phpMyAdmin/config.inc.php', :www_user => 'www', :www_group => 'www' } }
          it { is_expected.to contain_package('myAdmin').with(:ensure => '1.2.3') }
          it { is_expected.to contain_file('/var/www/html/phpMyAdmin/config.inc.php').with(:owner => 'www', :group => 'www')}
        end

        context "configure secret, servers, app config" do
          let(:params) do
            {
              :secret => 123,
              :servers => [{'host' => 'host1'}, {'host' => 'host2', 'port' => 1234 }],
              :config => {'UploadDir' => '/tmp/upload'}
            }
          end

          it { is_expected.to contain_file('/etc/phpMyAdmin/config.inc.php').with(:content => /\$cfg\['blowfish_secret'\] = '123'/)}
          it { is_expected.to contain_file('/etc/phpMyAdmin/config.inc.php').with(:content => /\$cfg\['Servers'\]\[\$i\]\['host'\] = 'host1';/)}
          it { is_expected.to contain_file('/etc/phpMyAdmin/config.inc.php').with(:content => /\$cfg\['Servers'\]\[\$i\]\['host'\] = 'host2';/)}
          it { is_expected.to contain_file('/etc/phpMyAdmin/config.inc.php').with(:content => /\$cfg\['Servers'\]\[\$i\]\['port'\] = '1234';/)}
          it { is_expected.to contain_file('/etc/phpMyAdmin/config.inc.php').with(:content => /\$cfg\['UploadDir'\] = '\/tmp\/upload';/)}
        end

        context "failures" do
          context "config not a hash" do
            let(:params) { { :config => 'wrong' } }
            it { expect { is_expected.to contain_class('phpmyadmin') }.to raise_error(Puppet::Error, /::phpmyadmin::config must be a hash/) }
          end

          context "servers not an array" do
            let(:params) { { :servers => 'wrong' } }
            it { expect { is_expected.to contain_class('phpmyadmin') }.to raise_error(Puppet::Error, /::phpmyadmin::servers must be an array of hash/) }
          end

          context "invalid config_file path" do
            let(:params) { { :config_file => 'wrong' } }
            it { expect { is_expected.to contain_class('phpmyadmin') }.to raise_error(Puppet::Error, /is not an absolute path/) }
          end
        end #failures
      end # on os
    end
  end

  context 'unsupported operating system' do
    describe 'phpmyadmin class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('pypMyAdmin') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
