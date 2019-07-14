# frozen_string_literal: true

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    def bad_sample1
      foo = 1
      bar = 2
      baz = 3
      condition = [1, 2, 3, 4]
      foo = 1
      case foo
      when *condition
        bar
      when baz
        foobar
      end
    end

    def bad_sample2
      foo = 1
      bar = 2
      baz = 3
      case foo
      when *[1, 2, 3, 4]
        bar
      when baz
        foobar
      end
    end

    def good_sample1
      foo = 1
      bar = 2
      baz = 3
      condition = [1, 2, 3, 4]
      case foo
      when baz
        foobar
      when *condition
        bar
      end
    end

    def good_sample2
      foo = 1
      bar = 2
      baz = 3
      case foo
      when 1, 2, 3, 4
        bar
      when 5
        baz
      end
    end
  RUBY

  x.report %{ bad_sample1 }
  x.report %{ bad_sample2 }
  x.report %{ good_sample1 }
  x.report %{ good_sample2 }
end
