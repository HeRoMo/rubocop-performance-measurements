# frozen_string_literal: true

# rubocop-performance
# Performance/InefficientHashSearch
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performanceinefficienthashsearch

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY

    HASH = { a: 1, b: 2 }

    def bad_sample_value1
      HASH.values.include?(2)
    end

    def bad_sample_value2
      HASH.values.include?('garbage')
    end

    def bad_sample_value3
      h = { a: 1, b: 2 }; h.values.include?(nil)
    end

    def good_sample_value1
      HASH.value?(2)
    end

    def good_sample_value2
      HASH.has_value?('garbage')
    end

    def good_sample_value3
      h = { a: 1, b: 2 }; h.value?(nil)
    end
  RUBY

  x.report %{ bad_sample_value1 }
  x.report %{ bad_sample_value2 }
  x.report %{ bad_sample_value3 }
  x.report %{ good_sample_value1 }
  x.report %{ good_sample_value2 }
  x.report %{ good_sample_value3 }
end
