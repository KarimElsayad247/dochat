# frozen_string_literal: true

puts "Loading HMR Class"

class Hmr
  def initialize
    @cacher = RenderingCacher.new

    listener = Listen.to("#{Rails.root}/app/views") do |modified, _added, removed|
      puts "modified #{modified}"
      process_modifications(modified)
      process_deletions(removed)
    end

    listener.start
    puts "Listening for View changes"
  end

  def process_modifications(modified_files)
    modified_files.each do |filename|
      if relevant?(filename)
        puts "Processing Relevant Modified file #{filename}"
      end
    end
  end

  def process_deletions(deleted_files)
    deleted_files.each do |filename|
      if relevant?(filename)
        puts "Processing Relevant Deleted file #{filename}"
      end
    end
  end

  def relevant?(filename)
    @cacher.payload_contains?(filename)
  end
end
