# frozen_string_literal: true

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    def bad_sample1
      str = 'ABC'
      str.downcase == 'abc'
    end

    def bad_sample2
      str = 'abc'
      str.upcase.eql? 'ABC'
    end
    def bad_sample3
      str = 'ABC'
      'abc' == str.downcase
    end

    def bad_sample4
      str = 'abc'
      'ABC'.eql? str.upcase
    end

    def bad_sample5
      str = 'ABC'
      str.downcase == str.downcase
    end

    def good_sample1
      str = 'abc'
      str.casecmp('ABC').zero?
    end

    def good_sample2
      str = 'ABC'
      'abc'.casecmp(str).zero?
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ bad_sample3 }
  x.report %{ bad_sample4 }
  x.report %{ bad_sample5 }
  x.report %{ good_sample1 }
  x.report %{ good_sample2 }
end
