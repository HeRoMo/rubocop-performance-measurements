# frozen_string_literal: true

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    STR = 'abcdefghijklmnopqrstuvwxyz'
    AZ_DOWN = 'a-z'
    AZ_UP = 'A-Z'

    def use_upcase
      STR.upcase
    end

    def use_tr
      STR.tr(AZ_DOWN, AZ_UP)
    end
  RUBY

  x.report %{ use_upcase }
  x.report %{ use_tr }
end
