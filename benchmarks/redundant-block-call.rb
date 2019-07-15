# frozen_string_literal: true

# rubocop-performance
# Performance/RedundantBlockCall
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performanceredundantblockcall

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    def bad_method(&block)
      block.call
    end

    def bad_another(&func)
      func.call 1, 2, 3
    end

    def good_method
      yield
    end

    def good_another
      yield 1, 2, 3
    end

    def bad_sample1
      bad_method { 1 + 2 }
    end

    def bad_sample2
      bad_another { |a, b, c | a + b + c }
    end

    def good_sample1
      good_method { 1 + 2 }
    end

    def good_sample2
      good_another { |a, b, c | a + b + c }
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ good_sample1 }
  x.report %{ good_sample2 }
end
