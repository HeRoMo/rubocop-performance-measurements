# frozen_string_literal: true

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    def use_times
      100.times.map{ |i| i }
    end

    def use_range
      (0...100).map{ |i| i }
    end
  RUBY

  x.report %{ use_times }
  x.report %{ use_range }
end
