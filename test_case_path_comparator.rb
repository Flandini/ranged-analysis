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
  sortedPaths = pathFiles.map { |fileName| TestCase.new(fileName) }.sort { |a, b| a <=> b }.map(&:name)
  puts sortedPaths
  sortedPaths

  chosenTestCases = static_range_select(sortedPaths)
  generate_slurm_conf_file(chosenTestCases, "/home/flandini/research/ranged_analysis/coreutils/src/base64.0.5.precodegen.bc")
end

def static_range_select(pathFiles)
  if pathFiles.length <= 9
    puts "Not enough test cases"
    return
  end

  # Resort but according to string order
  lastTestCaseGenerated = get_last_test_case(pathFiles)
  startTestCase = pathFiles.first

  lastTestCaseIndex = pathFiles.find_index(lastTestCaseGenerated)
  testCasesLessThanLast = pathFiles[0..lastTestCaseIndex]

  numTestCasesToTake = 10
  chosenTestCases = []
  chosenTestCases << startTestCase
  chosenTestCases << lastTestCaseGenerated

  while chosenTestCases.length <= numTestCasesToTake
    chosenTestCases << testCasesLessThanLast.sample
    chosenTestCases = chosenTestCases.uniq
  end

  sorted = chosenTestCases.map { |fileName| TestCase.new(fileName) }.sort { |a, b| a <=> b }.map(&:name)
  puts "Chose test cases:"
  puts sorted
  sorted
end

def get_last_test_case(pathFiles)
  pathFiles.sort[-1]
end

# @param pathFiles  the chosen random pathFiles making
#                   up the 10 ranges for a coreutils bin
def generate_slurm_conf_file(pathFiles, binary)
  current = 0
  rows = []
  workDir = "/work/06262/zzz/"

  pathFiles.each_cons(2) do |pathFilePair|
    rowString = ""
    rowString << "#{current} "
    rowString << File.join(workDir, "/klee-dev/build/bind/klee").to_s
    rowString << " -posix-runtime "
    rowString << " -libc=uclibc "
    rowString << " -max-time=600 "
    rowString << " -max-memory=0 "
    rowString << " -max-depth=75 "
    rowString << " -search=dfs"
    rowString << " -write-paths "
    rowString << " -use-cex-cache=false "
    rowString << " -ranged-analysis "
    rowString << " -beginTestCase="
    rowString << pathFilePair.first + " "
    rowString << " -endTestCase="
    rowString << pathFilePair.last + " "
    rowString << binary + " "
    rowString << "-sym-args 1 2 20\n"

    rows << rowString
    current += 1
  end

  puts rows
end

compare ARGV[0]

