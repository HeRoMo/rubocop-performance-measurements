# frozen_string_literal: true

# rubocop-performance
# Performance/TimesMap
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancetimesmap

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    def bad_sample
      9.times.map do |i|
        i.to_s
      end
    end

    def good_sample
      Array.new(9) do |i|
        i.to_s
      end
    end
  RUBY

  x.report %{ bad_sample }
  x.report %{ good_sample }
end
