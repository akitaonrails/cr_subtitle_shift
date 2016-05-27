module CrSubtitleShift
  class SrtTime
    TIME_TEMPLATE = "01/01/2000 %s"
    TIME_FORMAT   = "%d/%m/%Y %H:%M:%S,%L"
    SRT_LINE_FORMAT = /^(\d{2}:\d{2}:\d{2},\d{3}) --\> (\d{2}:\d{2}:\d{2},\d{3})(.*)/

    def initialize(@operation : String, amount : Float64)
      @amount = Time::Span.new(amount * Time::Span::TicksPerSecond)
    end

    def convert_time(time : String) : String
      time = Time.parse(TIME_TEMPLATE % time, TIME_FORMAT)
      time = @operation == "add" ? time + @amount : time - @amount

      microseconds = ( time.millisecond * 1_000 ).to_s
      microseconds = microseconds.rjust(6, '0') if microseconds.size < 6

      (time.to_s("%H:%M:%S") + ",%s") % microseconds[0..2].rjust(3, '0')
    end

    def convert_line(line : String) : String
      if tokens = SRT_LINE_FORMAT.match(line)
        start_time  = convert_time(tokens[1])
        finish_time = convert_time(tokens[2])
        tags        = tokens[3] || ""
        "%s --> %s%s\n" % [start_time, finish_time, tags]
      else
        line
      end
    end
  end
end
