class DirectoryTraverser

  # TODO add support for exclude
  # TODO add fail fast option that by default will skip a file that cannot be processed (i.e. an error is raised). when set to true, the exception will not be caught

  def initialize(command, options = {})
    @command = command

    @include = options[:include] || /.*/
    @verbose = options[:verbose] || false
    @out = options[:out] || $stdout
    @err = options[:err] || $stderr
  end

  def process(*paths, &block)
    paths.each do |path|
      if FileTest.directory? path
        process_dir path, &block
      elsif FileTest.file? path
        process_file path, &block unless path.match(@include).nil? # only process file if it matches @include
      else
        raise "#{path} must be a directory or file"
      end
    end
  end

private

  def process_dir(dir, &block)
    @out.puts "entering #{dir}" if @verbose
    Find.find dir do |path|
      process path, &block unless path == dir
    end
  end

  def process_file(file, &block)
    @out.puts "processing #{file}" if @verbose
    result = @command.call file
    yield file, result if block_given?
  end
end
