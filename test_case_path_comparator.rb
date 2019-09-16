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
      @pathData = File.read(fileName).split "\n"
    rescue Error => e
      STDERR.puts e
    end

    @name = fileName
  end

  def <=>(other)
    smallerLength = @pathData.length > other.pathData.length ? other.pathData.length : @pathData.length

    (0..smallerLength).each do |i|
      if @pathData[i] != other.pathData[i]
        if pathData[i] == "1"
          return -1
        else
          return 1
        end
      end
    end

    return 0
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
  puts pathFiles.map { |fileName| TestCase.new(fileName) }.sort.map(&:name)
end

compare ARGV[0]

