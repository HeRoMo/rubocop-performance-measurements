# frozen_string_literal: true

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

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

    def string_plus
      s = ''
      STR.each do |str|
        s += str
      end
      s
    end

    def string_io
      s = StringIO.new
      STR.each do |str|
        s.write str
      end
      s.string
    end

    def string_push
      s = ''
      STR.each do |str|
        s << str
      end
      s
    end

    def string_concat
      s = ''
      STR.each do |str|
        s.concat str
      end
      s
    end

    def string_array_join
      s = []
      STR.each do |str|
        s.push str
      end
      s.join
    end
  RUBY

  x.report %{ string_plus }
  x.report %{ string_io }
  x.report %{ string_push }
  x.report %{ string_concat }
  x.report %{ string_array_join }
end
