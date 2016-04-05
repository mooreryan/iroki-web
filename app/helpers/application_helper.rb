require "iroki_lib"
require "fileutils"

module ApplicationHelper
  # Returns the full title on a per-page basis.
  #
  # Eg., PubMedApps | Flower
  #
  # @param page_title [String] The title of the page
  #
  # @return [String] The nav bar title of the page
  def full_title page_title
    base_title = "Iroki"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def self.upload io
    new_f =
      Rails.root.join("public",
                      "uploads",
                      io.original_filename)

    File.open(new_f, "w") do |file|
      file.write(io.read)
    end

    new_f
  end

  def self.remove_upload fname
    FileUtils.rm fname
  end
end
