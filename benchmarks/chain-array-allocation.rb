# frozen_string_literal: true

# rubocop-performance
# Performance/ChainArrayAllocation
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancechainarrayallocation

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    def bad_sample
      array = ['a', 'b', 'c']
      array.compact.flatten.map { |x| x.downcase }
    end

    def good_sample
      array = ['a', 'b', 'c']
      array.compact!
      array.flatten!
      array.map! { |x| x.downcase }
      array
    end
  RUBY

  x.report %{ bad_sample }
  x.report %{ good_sample }
end
