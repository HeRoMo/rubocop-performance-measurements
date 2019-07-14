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

    def bad_sample_key1
      HASH.keys.include?(:a)
    end

    def bad_sample_key2
      HASH.keys.include?(:z)
    end

    def bad_sample_key3
      h = { a: 1, b: 2 }; h.keys.include?(100)
    end

    def good_sample_key1
      HASH.key?(:a)

    end

    def good_sample_key2
      HASH.has_key?(:z)
    end

    def good_sample_key3
      h = { a: 1, b: 2 }; h.key?(100)
    end
  RUBY

  x.report %{ bad_sample_key1 }
  x.report %{ bad_sample_key2 }
  x.report %{ bad_sample_key3 }
  x.report %{ good_sample_key1 }
  x.report %{ good_sample_key2 }
  x.report %{ good_sample_key3 }
end
