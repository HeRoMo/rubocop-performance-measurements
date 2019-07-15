# frozen_string_literal: true

# rubocop-performance
# Performance/StartWith
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancestartwith

require 'benchmark_driver'

output = :gruff
versions = ['2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    STR = 'abc'
    RE = /\Aab/
    START_STR = 'ab'

    def bad_sample1
      STR.match?(RE)
    end

    def bad_sample2
      STR =~ RE
    end

    def bad_sample3
      STR.match(RE)
    end

    def good_sample
      STR.start_with?(START_STR)
    end

  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ bad_sample3 }
  x.report %{ good_sample }
end
