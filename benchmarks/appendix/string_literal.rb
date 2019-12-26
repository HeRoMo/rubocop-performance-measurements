# frozen_string_literal: true

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.9', '2.5.7', '2.6.5', '2.7.0']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    def string_literal
      'string literal'
    end
  RUBY

  x.report %{ string_literal }
end
