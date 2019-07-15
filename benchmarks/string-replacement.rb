# frozen_string_literal: true

# rubocop-performance
# Performance/StringReplacement
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancestringreplacement

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    STR = 'abc'
    STR_WS = 'a b c'

    def bad_sample1
      STR.gsub('b', 'd')
    end

    def bad_sample2
      STR.gsub('a', '')
    end

    def bad_sample3
      STR.gsub(/a/, 'd')
    end

    def bad_sample4
      'abc'.gsub!('a', 'd')
    end

    def good_sample1
      STR.gsub(/.*/, 'a')
    end

    def good_sample2
      STR.gsub(/a+/, 'd')
    end

    def good_sample3
      STR.tr('b', 'd')
    end

    def good_sample4
      STR_WS.delete(' ')
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ bad_sample3 }
  x.report %{ bad_sample4 }
  x.report %{ good_sample1 }
  x.report %{ good_sample2 }
  x.report %{ good_sample3 }
  x.report %{ good_sample4 }
end
