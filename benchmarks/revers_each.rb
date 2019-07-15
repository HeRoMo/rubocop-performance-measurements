# frozen_string_literal: true

# rubocop-performance
# Performance/ReverseEach
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancereverseeach

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    ARRAY = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    def bad_sample
      ARRAY.reverse.each
    end

    def good_sample
      ARRAY.reverse_each
    end
  RUBY

  x.report %{ bad_sample }
  x.report %{ good_sample }
end
