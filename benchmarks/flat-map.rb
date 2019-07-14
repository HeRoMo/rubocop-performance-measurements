# frozen_string_literal: true

# rubocop-performance
# Performance/FlatMap
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performanceflatmap

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY

    ARRAY = [1, 2, 3, 4]

    def bad_sample1
      ARRAY.map { |e| [e, e] }.flatten(1)
    end

    def bad_sample2
      ARRAY.collect { |e| [e, e] }.flatten(1)
    end

    def good_sample1
      ARRAY.flat_map { |e| [e, e] }
    end

    def good_sample2
      ARRAY.map { |e| [e, e] }.flatten
    end

    def good_sample3
      ARRAY.collect { |e| [e, e] }.flatten
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ good_sample1 }
  x.report %{ good_sample2 }
  x.report %{ good_sample3 }
end
