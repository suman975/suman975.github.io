# _plugins/generate_gallery.rb
require 'fastimage'
require 'yaml'
require 'pathname'

module Jekyll
  class GalleryGenerator < Generator
    safe true
    priority :low  # run after pages are read

    # Base folder to scan
    BASE_FOLDER = "assets"

    def generate(site)
      gallery_data = {}

      base_path = File.join(site.source, BASE_FOLDER)
      unless Dir.exist?(base_path)
        Jekyll.logger.warn "GalleryGenerator:", "Base folder '#{BASE_FOLDER}' does not exist"
        return
      end

      # Get all subfolders inside BASE_FOLDER
      Dir.glob("#{base_path}/*").select { |f| File.directory?(f) }.each do |folder_path|
        key = File.basename(folder_path)  # folder name as key
        gallery_data[key] = []

        Dir.glob("#{folder_path}/*.{jpg,jpeg,png,webp}") do |file_path|
          rel_path = "/" + Pathname.new(file_path).relative_path_from(Pathname.new(site.source)).to_s
          size = FastImage.size(file_path) || [800, 600]  # fallback if size fails

          gallery_data[key] << {
            'path' => rel_path,
            'width' => size[0],
            'height' => size[1]
          }
        end
      end

      # Write _data/gallery.yml
      data_file = File.join(site.source, "_data", "gallery.yml")
      File.open(data_file, "w") { |f| f.write(gallery_data.to_yaml) }

      Jekyll.logger.info "GalleryGenerator:", "Generated _data/gallery.yml with #{gallery_data.keys.size} galleries"
    end
  end
end
