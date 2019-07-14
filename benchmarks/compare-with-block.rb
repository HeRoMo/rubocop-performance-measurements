# frozen_string_literal: true

# rubocop-performance
# Performance/CompareWithBlock
# see https://github.com/rubocop-hq/rubocop-performance/blob/master/manual/cops_performance.md#performancecomparewithblock

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

class Elm
  attr_accessor :foo
  def initialize(foo)
    @foo = foo
  end
end

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    class Elm
      attr_accessor :foo
      def initialize(foo)
        @foo = foo
      end
    end

    ARRAY = [Elm.new(5), Elm.new(4), Elm.new(3), Elm.new(2), Elm.new(1)]
    HASH_ARRAY = [{ foo: 5 }, { foo: 4 }, { foo: 3 }, { foo: 2 }, { foo: 1 }]

    def bad_sample_sort1
      ARRAY.sort { |a, b| a.foo <=> b.foo }
    end

    def bad_sample_max
      ARRAY.max { |a, b| a.foo <=> b.foo }
    end

    def bad_sample_min
      ARRAY.min { |a, b| a.foo <=> b.foo }
    end

    def bad_sample_sort_hash
      HASH_ARRAY.sort { |a, b| a[:foo] <=> b[:foo] }
    end

    def good_sample_sort1
      ARRAY.sort_by(&:foo)
    end

    def good_sample_sort2
      ARRAY.sort_by { |v| v.foo }
    end

    def good_sample_sort3
      ARRAY.sort_by do |var|
        var.foo
      end
    end

    def good_sample_max
      ARRAY.max_by(&:foo)
    end

    def good_sample_min
      ARRAY.min_by(&:foo)
    end

    def good_sample_sort_hash
      HASH_ARRAY.sort_by { |a| a[:foo] }
    end
  RUBY

  x.report %{ bad_sample_sort1 }
  x.report %{ good_sample_sort1 }
  x.report %{ good_sample_sort2 }
  x.report %{ good_sample_sort3 }
  x.report %{ bad_sample_max }
  x.report %{ good_sample_max }
  x.report %{ bad_sample_min }
  x.report %{ good_sample_min }
  x.report %{ bad_sample_sort_hash }
  x.report %{ good_sample_sort_hash }
end
