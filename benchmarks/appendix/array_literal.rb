# frozen_string_literal: true

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    def array_literal
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
    end
  RUBY

  x.report %{ array_literal }
end
