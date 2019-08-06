# frozen_string_literal: true

require 'benchmark_driver'

output = :gruff
versions = ['2.3.8', '2.4.6', '2.5.4', '2.6.3', '2.7.0-preview1']

Benchmark.driver(output: output) do |x|
  x.rbenv *versions

  x.prelude <<~RUBY
    require 'nkf'
    NKF_OPTS = '-Z1 -w -W'
    HANKAKU = 'a-z'
    ZENKAKU = 'ａ-ｚ'

    STR = 'ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ'

    def use_nkf
      NKF.nkf(NKF_OPTS, STR)
    end

    def use_tr
      STR.tr(ZENKAKU, HANKAKU)
    end
  RUBY

  x.report %{ use_nkf }
  x.report %{ use_tr }
end
