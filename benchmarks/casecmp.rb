# frozen_string_literal: true

# rubocop-performance
# Performance/Casecmp
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancecasecmp

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    STR_U = 'ABC'
    STR_L = 'abc'

    def bad_sample1
      STR_U.downcase == STR_L
    end

    def bad_sample2
      STR_L.upcase.eql? STR_U
    end

    def bad_sample3
      STR_L == STR_U.downcase
    end

    def bad_sample4
      STR_U.eql? STR_L.upcase
    end

    def bad_sample5
      STR_U.downcase == STR_U.downcase
    end

    def good_sample1
      STR_L.casecmp(STR_U).zero?
    end

    def good_sample2
      STR_U.casecmp(STR_L).zero?
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
