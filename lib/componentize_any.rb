# frozen_string_literal: true

require_relative "componentize_any/version"

module ComponentizeAny
  class Error < StandardError; end

  def to_uleb128_bin(size)
    if size < 0x80
      [size].pack("C")
    else
      [(size & 0x7f) | 0x80].pack("C") + to_uleb128_bin(size >> 7)
    end  
  end
  module_function :to_uleb128_bin  
end

require_relative "componentize_any/dsl"
require_relative "componentize_any/wat_generator"