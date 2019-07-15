# frozen_string_literal: true

# rubocop-performance
# Performance/Count
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancecount

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    class Elm
      attr_accessor :value
      def initialize(value)
        @value = value
      end
    end

    NUM_ARRAY = [1, 2, 3]
    OBJ_ARRAY = [Elm.new(5), Elm.new(4), Elm.new(3), Elm.new(2), Elm.new(5)]

    def bad_sample1
      NUM_ARRAY.select { |e| e > 2 }.size
    end

    def bad_sample2
      NUM_ARRAY.reject { |e| e > 2 }.size
    end

    def bad_sample3
      NUM_ARRAY.select { |e| e > 2 }.length
    end

    def bad_sample4
      NUM_ARRAY.reject { |e| e > 2 }.length
    end

    def bad_sample5
      NUM_ARRAY.select { |e| e > 2 }.count { |e| e.odd? }
    end

    def bad_sample6
      NUM_ARRAY.reject { |e| e > 2 }.count { |e| e.even? }
    end

    def bad_sample7
      OBJ_ARRAY.select(&:value).count
    end

    def good_sample1
      NUM_ARRAY.count { |e| e > 2 }
    end

    def good_sample2
      NUM_ARRAY.count { |e| e < 2 }
    end

    def good_sample3
      NUM_ARRAY.count { |e| e > 2 && e.odd? }
    end

    def good_sample4
      NUM_ARRAY.count { |e| e < 2 && e.even? }
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ bad_sample3 }
  x.report %{ bad_sample4 }
  x.report %{ bad_sample5 }
  x.report %{ bad_sample6 }
  x.report %{ bad_sample7 }
  x.report %{ good_sample1 }
  x.report %{ good_sample2 }
  x.report %{ good_sample3 }
  x.report %{ good_sample4 }
end
