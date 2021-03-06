require_relative 'unit/user_test'

require_relative 'unit/socket_line_reader_test'
require_relative 'unit/event_decoder_test'
require_relative 'unit/sequencer_test'
require_relative 'unit/user_database_test'
require_relative 'unit/user_collector_test'
require_relative 'unit/follower_manager_test'
require_relative 'unit/message_builder_test'
require_relative 'unit/user_connection_manager_test'
require_relative 'unit/user_connection_test'

require_relative 'integration/socket_line_reader_test'
require_relative 'integration/user_connection_manager_test'
require_relative 'integration/internal_pipeline_test'

require 'minitest/autorun'
