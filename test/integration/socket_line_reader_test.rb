describe "socket programs" do
  it 'successfully sends some data over a real socket!' do
    output = `ruby test/bin/socket_printer.rb & sleep 0.01;ruby test/bin/socket_client.rb`
    assert_equal "hello\nhello2\n", output
  end
end
