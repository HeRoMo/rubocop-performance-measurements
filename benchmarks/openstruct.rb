# frozen_string_literal: true

# rubocop-performance
# Performance/OpenStruct h
# see ttps://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performanceopenstruct

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    require 'ostruct'
    class BadClass
      def my_method
        OpenStruct.new(my_key1: 'my_value1', my_key2: 'my_value2')
      end
    end

    class GoodClass
      MyStruct = Struct.new(:my_key1, :my_key2)
      def my_method
        MyStruct.new('my_value1', 'my_value2')
      end
    end

    def bad_sample
      BadClass.new.my_method
    end

    def good_sample
      GoodClass.new.my_method
    end
  RUBY

  x.report %{ bad_sample }
  x.report %{ good_sample }
end
