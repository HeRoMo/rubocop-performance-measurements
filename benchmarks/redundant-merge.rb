# frozen_string_literal: true

# rubocop-performance
# Performance/RedundantMerge
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performanceredundantmergerequire 'benchmark_driver'

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    def bad_sample1
      { x: 10, y: 20, z: 30 }.merge!(a: 1)
    end

    def bad_sample2
      { x: 10, y: 20, z: 30 }.merge!({'key' => 'value'})
    end

    def bad_sample3
      { x: 10, y: 20, z: 30 }.merge!(a: 1, b: 2)
    end

    def good_sample1
      hash = { x: 10, y: 20, z: 30 }
      hash[:a] = 1
    end

    def good_sample2
      hash = { x: 10, y: 20, z: 30 }
      hash['key'] = 'value'
    end

    def good_sample3
      hash = { x: 10, y: 20, z: 30 }
      hash[:a] = 1
      hash[:b] = 2
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ bad_sample3 }
  x.report %{ good_sample1 }
  x.report %{ good_sample2 }
  x.report %{ good_sample3 }
end
