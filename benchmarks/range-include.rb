# frozen_string_literal: true

# rubocop-performance
# Performance/RangeInclude
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancerangeinclude

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    RANGE = ('a'..'z')

    def bad_sample
      RANGE.include?('b')
    end

    def good_sample
      RANGE.cover?('b')
    end
  RUBY

  x.report %{ bad_sample }
  x.report %{ good_sample }
end
