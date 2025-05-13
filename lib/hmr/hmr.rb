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
    relevant_files_found = false
    modified_files.each do |filename|
      if relevant?(filename)
        puts "Found Relevant Modified file #{filename}"
        relevant_files_found = true
      end
    end

    if relevant_files_found
      rendered_html = ApplicationController.render(
        template: @cacher.template,
        assigns: @cacher.template_locals
      )
      p rendered_html
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
