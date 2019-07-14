# frozen_string_literal: true

# rubocop-performance
# Performance/Detect
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancedetect

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    ARRAY = [1, 1, 0, 1, 0, 1, 0, 1 ,0 ,1]

    def bad_sample1
      ARRAY.select { |item| item > 0 }.first
    end

    def bad_sample2
      ARRAY.select { |item| item > 0 }.last
    end

    def bad_sample3
      ARRAY.find_all { |item| item > 0 }.first
    end
    def bad_sample4
      ARRAY.find_all { |item| item > 0 }.last
    end

    def good_sample1
      ARRAY.detect { |item| item > 0 }
    end

    def good_sample2
      ARRAY.reverse.detect { |item| item > 0 }
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ bad_sample3 }
  x.report %{ bad_sample4 }
  x.report %{ good_sample1 }
  x.report %{ good_sample2 }
end
