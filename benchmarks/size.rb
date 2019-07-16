# frozen_string_literal: true

# rubocop-performance
# Performance/Size
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancesize

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    ARRAY = [1, 2, 3]
    HASH = {a: 1, b: 2, c: 3}

    def bad_sample1
      ARRAY.count
    end

    def bad_sample2
      HASH.count
    end

    def good_sample1
      ARRAY.size
    end

    def good_sample2
      HASH.size
    end

    def good_sample3
      ARRAY.count { |e| e > 2 }
    end

    def good_sample4
      HASH.count { |k, v| v > 2 }
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ good_sample1 }
  x.report %{ good_sample2 }
  x.report %{ good_sample3 }
  x.report %{ good_sample4 }
end
