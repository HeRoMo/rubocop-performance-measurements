# frozen_string_literal: true

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    URL_STR = 'https://www.sample.com'

    def string_literal
      'string literal'
    end

    def array_literal
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
    end

    def hash_literal
      { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 0 }
    end
  RUBY

  x.report %{ string_literal }
  x.report %{ array_literal }
  x.report %{ hash_literal }
end
