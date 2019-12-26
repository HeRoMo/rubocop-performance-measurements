# frozen_string_literal: true

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.9', '2.5.7', '2.6.5', '2.7.0']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    STR = %w(
      あ い う え お
      か き く け こ
      さ し す せ そ
      た ち つ て と
      な に ぬ ね の
      は ひ ふ へ ほ
      ま み む め も
      や ゆ よ
    )

    def splat
      [*STR]
    end
  RUBY

  x.report %{ splat }
end
