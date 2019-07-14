# frozen_string_literal: true

# rubocop-performance
# Performance/DoubleStartEndWith
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancedoublestartendwith

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    module Some
      CONST = 'c'
    end

    STR = 'hogehoge'
    VAR1 = 'a'
    VAR2 = 'b'

    def bad_sample1
      STR.start_with?('a') || STR.start_with?(Some::CONST)
    end

    def bad_sample2
      STR.start_with?('a', 'b') || STR.start_with?('c')
    end

    def bad_sample3
      STR.end_with?(VAR1) || STR.end_with?(VAR2)
    end

    def good_sample1
      STR.start_with?('a', Some::CONST)
    end

    def good_sample2
      STR.start_with?('a', 'b', 'c')
    end

    def good_sample3
      STR.end_with?(VAR1, VAR2)
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ bad_sample3 }
  x.report %{ good_sample1 }
  x.report %{ good_sample2 }
  x.report %{ good_sample3 }
end
