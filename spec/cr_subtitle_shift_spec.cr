require "./spec_helper"

describe CrSubtitleShift do
  it "should correctly pad the milliseconds if microseconds is less than 100_000" do
    srt_time = CrSubtitleShift::SrtTime.new("add", 2.5)
    srt_time.convert_time("00:03:13,574").should eq("00:03:16,074")
  end

  it "should be able to shift right the time adding a float amount" do
    srt_time = CrSubtitleShift::SrtTime.new("add", 1.6)
    srt_time.convert_time("00:00:01,500").should eq("00:00:03,100")
    srt_time.convert_time("00:00:01,050").should eq("00:00:02,650")
    srt_time.convert_time("00:01:24,051").should eq("00:01:25,651")
    srt_time.convert_time("00:01:59,400").should eq("00:02:01,000")
  end

  it "should be able to shift left the time subtracting a float amount" do
    srt_time = CrSubtitleShift::SrtTime.new("sub", 1.6)
    srt_time.convert_time("00:00:01,500").should eq("23:59:59,900")
    srt_time.convert_time("00:00:01,050").should eq("23:59:59,450")
    srt_time.convert_time("00:01:24,051").should eq("00:01:22,451")
    srt_time.convert_time("00:01:59,400").should eq("00:01:57,800")
  end

  it "should convert a srt time range line in the correct format" do
    srt_time = CrSubtitleShift::SrtTime.new("add", 1.6)
    srt_time.convert_line("00:00:01,500 --> 00:00:02,100").should eq("00:00:03,100 --> 00:00:03,700\n")
  end
end

describe "Shift Subtitle" do
  it "should be able to convert a file and compare to the static fixture" do
    srt_time = CrSubtitleShift::SrtTime.new("add", 2.5)
    input_file = File.join(File.dirname(__FILE__), "fixtures", "input.srt")
    output_file = File.join(File.dirname(__FILE__), "fixtures", "output.srt")

    output = [] of String
    File.each_line(input_file, encoding: "ISO-8859-1") do |line|
      output << srt_time.convert_line(line)
    end

    output_static = File.read(output_file, encoding: "ISO-8859-1").gsub(/\n/, "\r\n")
    output_static.should eq(output.join(""))
  end
end
