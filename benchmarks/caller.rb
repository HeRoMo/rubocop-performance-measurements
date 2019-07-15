# frozen_string_literal: true

# rubocop-performance
# Performance/Caller
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancecasewhensplat

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    def bad_sample1
      caller[1]
    end

    def bad_sample2
      caller.first
    end

    def bad_sample3
      caller_locations.first
    end

    def good_sample1
      caller(1..1).first
    end

    def good_sample2
      caller_locations(1..1).first
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ bad_sample3 }
  x.report %{ good_sample1 }
  x.report %{ good_sample2 }
end
