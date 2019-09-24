#!/usr/bin/ruby

class TestCase
  @pathData = ''
  @name = ''

  def pathData
    @pathData
  end

  def name
    @name
  end

  def initialize(fileName)
    begin
      @pathData = File.read(fileName).split("\n").join("")
    rescue Error => e
      STDERR.puts e
    end

    @name = fileName
  end

  def <=>(other)
    smallerLength = [@pathData.length, other.pathData.length].min

    (0..smallerLength-1).each do |i|
      if @pathData[i] != other.pathData[i]
        return (@pathData[i] == "1" ? -1 : 1)
      end
    end

    if @pathData.length == other.pathData.length
      0
    elsif @pathData.length < other.pathData.length
      -1
    else
      1
    end
  end
end

def compare(directory)
  pathFiles = Dir.glob("#{directory}/test*.path")

  if pathFiles.length == 0
    STDERR.puts "Didn't find any path files to compare"
    return
  end

  puts "Original paths are: "
  puts pathFiles

  puts "Sorted paths are: "
  puts pathFiles.map { |fileName| TestCase.new(fileName) }.sort { |a, b| a <=> b }.map(&:name)
end

compare ARGV[0]

