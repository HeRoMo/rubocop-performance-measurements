# frozen_string_literal: true

# rubocop-performance
# Performance/CaseWhenSplat
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancecasewhensplat

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    BAR = 2
    BAZ = 3
    FOOBAR = 4
    CONDITION = [1, 2, 3, 4]

    def bad_sample1
      foo = BAZ
      case foo
      when *CONDITION
        BAR
      when BAZ
        FOOBAR
      end
    end

    def bad_sample2
      foo = 5
      case foo
      when *[1, 2, 3, 4]
        BAR
      when 5
        FOOBAR
      end
    end

    def good_sample1
      foo = BAZ
      case foo
      when BAZ
        FOOBAR
      when *CONDITION
        BAR
      end
    end

    def good_sample2
      foo = 5
      case foo
      when 1, 2, 3, 4
        BAR
      when 5
        BAZ
      end
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ good_sample1 }
  x.report %{ good_sample2 }
end
