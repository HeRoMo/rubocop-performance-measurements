# frozen_string_literal: true

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    RANGE = (1..100)

    def use_amp
      RANGE.map(&:to_s)
    end

    def use_block
      RANGE.map{ |i| i.to_s }
    end
  RUBY

  x.report %{ use_amp }
  x.report %{ use_block }
end
