# frozen_string_literal: true

# rubocop-performance
# Performance/EndWith
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performanceendwith

require 'benchmark_driver'

output = :gruff
versions = ['2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    REGEX = /bc\Z/
    END_STR = ''

    def bad_sample_match1
      'abc'.match?(/bc\Z/)
    end

    def bad_sample_match2
      'abc'.match?(REGEX)
    end

    def bad_sample3
      'abc' =~ /bc\Z/
    end

    def bad_sample4
      'abc'.match(/bc\Z/)
    end

    def bad_sample5
      'abc' =~ REGEX
    end

    def bad_sample6
      'abc'.match(REGEX)
    end

    def end_with1
      'abc'.end_with?('bc')
    end

    def end_with2
      'abc'.end_with?(END_STR)
    end
  RUBY

  x.report %{ bad_sample_match1 }
  x.report %{ bad_sample_match2 }
  x.report %{ bad_sample3 }
  x.report %{ bad_sample4 }
  x.report %{ bad_sample5 }
  x.report %{ bad_sample6 }
  x.report %{ end_with1 }
  x.report %{ end_with2 }
end
