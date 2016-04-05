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
    time_now = Time.now.strftime("%Y%m%d%H%M%S%L")
    new_basename = "#{io.original_filename}.#{time_now}"

    new_f =
      Rails.root.join("public", "uploads", new_basename)

    File.open(new_f, "w") do |file|
      file.write(io.read)
    end

    new_f
  end

  def self.remove_upload fname
    FileUtils.rm fname
  end
end
