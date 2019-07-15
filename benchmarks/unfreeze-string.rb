# frozen_string_literal: true

# rubocop-performance
# Performance/UnfreezeString
# https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performanceunfreezestring

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    def bad_sample1
      ''.dup
    end

    def bad_sample2
      'something'.dup
    end

    def bad_sample3
      String.new
    end

    def bad_sample4
      String.new('')
    end

    def bad_sample5
      String.new('something')
    end

    def good_sample1
      +'something'
    end

    def good_sample2
      +''
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ bad_sample3 }
  x.report %{ bad_sample4 }
  x.report %{ bad_sample5 }
  x.report %{ good_sample1 }
  x.report %{ good_sample2 }
end
