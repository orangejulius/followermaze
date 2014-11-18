require_relative '../../src/socket_line_reader'

require 'fileutils'

describe "socket programs" do
  it 'successfully sends some data over a real socket!' do
    FileUtils.rm_f("socket_file")
    output = `ruby test/bin/socket_printer.rb socket_file & sleep 0.01;ruby test/bin/socket_client.rb socket_file`
    assert_equal "hello\nhello2\n", output
    FileUtils.rm_f("socket_file")
  end
end
