# frozen_string_literal: true

# rubocop-performance
# Performance/EndWith
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performanceendwith

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    REGEX = /bc\Z/
    END_STR = 'bc'

    def bad_sample1
      'abc' =~ REGEX
    end

    def bad_sample2
      'abc'.match(REGEX)
    end

    def good_sample
      'abc'.end_with?(END_STR)
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ good_sample }
end
