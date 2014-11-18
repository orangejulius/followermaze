describe 'user connection manager' do
  it 'sends hello#{id} to each of the two expected clients' do
    output = `ruby test/bin/static_messager.rb& sleep 0.05; ruby test/bin/static_message_client.rb 1& ruby test/bin/static_message_client.rb 2`

    assert_equal "ok\nok\n", output
  end
end
