# frozen_string_literal: true

# rubocop-performance
# Performance/RegexpMatch
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performanceregexpmatch

require 'benchmark_driver'

output = :gruff
versions = ['2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    def do_something(arg = nil)
      1 + 1
    end

    X = 'regex-match'
    RE = /re/

    def bad_sample1
      if X =~ RE
        do_something
      end
    end

    def bad_sample2
      if X !~ RE
        do_something
      end
    end

    def bad_sample3
      if X.match(RE)
        do_something
      end
    end

    def bad_sample4
      if RE === X
        do_something
      end
    end

    def good_sample1
      if X.match?(RE)
        do_something
      end
    end

    def good_sample2
      if !X.match?(RE)
        do_something
      end
    end

    def good_sample3
      if X =~ RE
        do_something(Regexp.last_match)
      end
    end

    def good_sample4
      if X.match(RE)
        do_something($~)
      end
    end

    def good_sample5
      if RE === X
        do_something($~)
      end
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
  x.report %{ good_sample5 }
end
