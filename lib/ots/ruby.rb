# frozen_string_literal: true

require 'toolrack'
require 'tlogger'

require_relative "ruby/version"
require_relative "ruby/lamport/lamport_key_engine"
require_relative "ruby/lamport/lamport_sign"
require_relative "ruby/lamport/lamport_verify"

module Ots
  module Ruby
    class Error < StandardError; end
    class OtsError < StandardError; end
    # Your code goes here...
  end
end
