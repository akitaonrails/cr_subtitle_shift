require "./cr_subtitle_shift/*"
require "option_parser"

opt_operation = "add"
opt_amount = 0.0_f64
opt_input_file = ""
opt_output_file = ""
opt_encoding = "ISO-8859-1"

OptionParser.parse! do |opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Shifts time from an SRT subtitle file.\nAllows to add or subtract seconds and milliseconds from the entire file.\nUsage: shift_subtitle [options] input_file output_file"

  opts.on( "-o OPERATION", "--operation (add|sub)", "Choose (add) to add time or (sub) to subtract time" ) do |op|
    opt_operation = op if %w(add sub).includes?(op)
  end

  opts.on( "-t AMOUNT_OF_TIME", "--time 99,999", "Amount of time to operate, this has to be in the format 99,999 (sec,millisec)" ) do |time|
    begin
      opt_amount = time.sub(',','.').to_f64
    rescue
      raise ArgumentError.new("The time format has to be 99,999")
    end
  end

  opts.on( "-e ENCODING", "--encoding UTF-8", "Force an encoding for the input file, usually ISO-8859-1 or UTF-8") do |encoding|
    opt_encoding = encoding
  end

  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( "-h", "--help", "Display this screen" ) do
    puts opts
    exit
  end
end

# get the input and output files
if ARGV.size > 1
  opt_input_file, opt_output_file = ARGV.first, ARGV.last

  srt_time = CrSubtitleShift::SrtTime.new(opt_operation, opt_amount)
  File.open(opt_output_file, "w", encoding: opt_encoding) do |output|
    File.each_line(opt_input_file, encoding: opt_encoding) do |line|
      output.print srt_time.convert_line(line)
    end
  end
  puts "Done!"
else
  puts "no arguments passed, try -h"
end
