#!/usr/bin/ruby


coreutils_dir = "/work/06262/zzz/coreutils_bytecode"

klee_test_dirs = Dir.glob(File.join(coreutils_dir, "klee-out-*"))

puts "KLEE test output dirs are: #{klee_test_dirs}"

test_dirs = []

klee_test_dirs.each do |k_dir|
	ktest_files = Dir.glob(File.join(k_dir, "*.ktest"))
		
	test_dirs << [ k_dir,  `/work/06262/zzz/klee/build/bin/klee-stats #{k_dir}`, ktest_files.length ]
	puts "#{k_dir} produced #{ktest_files.length} ktest files"
end

# Sorted ascending -> flip to descending
sorted_test_dirs = test_dirs.sort { |a, b| a.last <=> b.last }.reverse

# sorted_coreutils_names = sorted_test_dirs.map do |test_dir|
	# info_file_data = File.read(File.join(test_dir, "info").to_s)
	# result = info_file_data =~ /(\w+)\.0\.5\.precodegen\.bc/i
	# result ? $1 : test_dir
# end
sorted_coreutils = sorted_test_dirs.map do |subarray|
	info_file_data = File.read(File.join(subarray.first, "info").to_s)
	result = info_file_data =~ /(\w+)\.0\.5\.precodegen\.bc/i
	result ? [$1, subarray[1], subarray[2]] : subarray
end

# puts sorted_coreutils_names.uniq[0..70].sort
puts sorted_coreutils.uniq { |subarray| subarray.first }[0..70].sort_by { |subarray| subarray.first }.join("\n")
