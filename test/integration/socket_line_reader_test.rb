require_relative '../../src/socket_line_reader'

require 'fileutils'

describe "socket programs" do
  it 'successfully sends some data over a real socket!' do
    socket_path = File.join(File.dirname(__FILE__), '../socket_file')

    # clean up from previous test runs
    FileUtils.rm_f socket_path

    output = `ruby test/bin/socket_printer.rb #{socket_path} & sleep 0.01;ruby test/bin/socket_client.rb #{socket_path}`
    assert_equal "hello\nhello2\n", output

    # be nice to future test runs
    FileUtils.rm_f socket_path
  end
end
