# frozen_string_literal: true

# rubocop-performance
# Performance/UriDefaultParser
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performanceuridefaultparser

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    URL_STR = 'https://www.sample.com'

    def bad_sample
      URI::Parser.new.parse(URL_STR)
    end

    def good_sample
      URI::DEFAULT_PARSER.parse(URL_STR)
    end

    def exstra_sample
      URI.parse(URL_STR)
    end
  RUBY

  x.report %{ bad_sample }
  x.report %{ good_sample }
  x.report %{ exstra_sample }
end
