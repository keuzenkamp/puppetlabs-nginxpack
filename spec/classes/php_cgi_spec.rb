require 'spec_helper'

describe 'nginxpack::php::cgi' do

  # MYSQL TESTS

  context 'with mysql' do
    let(:params) {{
      :mysql => true,
    }}

    it do
      should contain_package('php5-mysql') \
        .with_ensure('present')
    end
  end

  # TIMEZONE TESTS

  context 'with timezone' do
    let(:params) {{
      :timezone => 'Foo/Bar',
    }}

    it do
      should contain_file('/etc/php5/cgi/conf.d/timezone.ini') \
        .with_content("date.timezone = 'Foo/Bar'")
    end
  end

  # UPLOAD_MAX_FILESIZE TESTS

  context 'with upload_max_filesize' do
    let(:params) {{
      :upload_max_filesize => '1G',
    }}

    it do
      should contain_file_line('php.ini-upload_max_filesize') \
        .with_line('upload_max_filesize = 1G') \
    end
  end

  # MAX_FILE_UPLOADS TESTS

  context 'with upload_max_files' do
    let(:params) {{
      :upload_max_files => '42',
    }}

    it do
      should contain_file_line('php.ini-max_file_uploads') \
        .with_line('max_file_uploads = 42') \
    end
  end

  # AUTOMATIC POST MAX SIZE TESTS

  context 'with automatic post_max_size' do
    let(:params) {{
      :upload_max_filesize => '2G',
      :upload_max_files => '42',
    }}

    it do
      should contain_file_line('php.ini-post_max_size') \
        .with_line('post_max_size = 84G') \
    end
  end

  # ENABLE TESTS

  context 'with enable' do
    let(:params) {{
      :enable => true,
    }}

    it do
      should contain_package('php5-cgi') \
        .with_ensure('present')
    end

    it do
      should contain_package('spawn-fcgi') \
        .with_ensure('present')
    end

    it do
      should contain_service('php-fastcgi') \
        .with_ensure('running') \
        .with_enable(true)
    end

    it do
      should contain_file('/usr/bin/php-fastcgi.sh') \
        .with_ensure('file')
    end

    it do
      should contain_file('/usr/bin/php-fastcgi.sh') \
        .with_ensure('file')
    end
  end

  context 'with no enable' do
    let(:params) {{
      :enable => false,
    }}

    it do
      should contain_package('php5-cgi') \
        .with_ensure('absent')
    end

    it do
      should contain_package('php5-mysql') \
        .with_ensure('absent')
    end

    it do
      should contain_package('spawn-fcgi') \
        .with_ensure('absent')
    end

    it do
      should_not contain_service('php-fastcgi')
    end

    it do
      should contain_file('/usr/bin/php-fastcgi.sh') \
        .with_ensure('absent')
    end

    it do
      should contain_file('/etc/init.d/php-fastcgi') \
        .with_ensure('absent')
    end
  end
end
