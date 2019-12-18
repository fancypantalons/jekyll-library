# frozen_string_literal: true

require "tmpdir"
require "securerandom"
require "time"

module Jekyll
  module Library
    class Generator < Jekyll::Generator
      safe true
      priority :lowest

      # Main plugin action, called by Jekyll-core
      def generate(site)
        @site = site
        @config = @site.config["library"] || {}
        @logger_prefix = "[jekyll-library]"

        if ! @config.key? "cover_folder"
          log("error", "No cover folder defined in configuration!")
          return;
        end

        pages = get_page_list(@config["pages"] || false, @config["collections"] || [])

        with_cache { |cache|
          pages.each do |page|
            isbn = page.data["isbn"]

            metadata = cache.fetch(isbn) { cache[isbn] = get_book_info(isbn) }

            page.data["image"] = File.join(@site.config["baseurl"], metadata["cover"]["url"])
            page.data["book"] = metadata
          end
        }
      end

      private

      def log(type, message)
        debug = !!@config.dig("debug")

        if debug || %w(error msg).include?(type)
          type = "info" if type == "msg"

          Jekyll.logger.method(type).call("#{@logger_prefix} #{message}")
        end
      end

      def get_cache_file()
        cache_folder = @site.in_source_dir(@config["cache_folder"] || ".jekyll-cache")
        Dir.mkdir(cache_folder) unless File.exist?(cache_folder)

        file = Jekyll.sanitized_path(cache_folder, "library-cache")
        File.open(file, "wb") { |f| f.puts YAML.dump({}) } unless File.exist?(file)

        file
      end

      def with_cache(&block)
        cache = SafeYAML.load_file(get_cache_file()) || {}

        block.call(cache)

        File.open(get_cache_file(), "wb") { |f| f.puts YAML.dump(cache) }
      end

      def get_page_list(include_pages, collections)
        pages = []

        pages += @site.pages if (include_pages)

        pages += @site
          .collections
          .values
          .find_all { |collection| collections.include? collection.label }
          .map { |collection| collection.docs }
          .flatten

        pages.select { |p| p.data.key? "isbn" }
      end

      def get_cover_path(id)
        cover_folder = @site.in_source_dir(@config["cover_folder"])
        Dir.mkdir(cover_folder) unless File.exist?(cover_folder)

        fname = id + ".jpg"

        return {
          "abs" => Jekyll.sanitized_path(cover_folder, fname),
          "url" => File.join(@config["cover_folder"], fname)
        }
      end

      def get_book_info(isbn)
        metadata = { "cover" => get_cover_path(isbn) }

        need_cover = ! File.exist?(metadata["cover"]["abs"])

        Dir.mktmpdir { |dir|
          opf = File.join(dir, "opf.xml")
          cover = File.join(dir, "cover.jpg")

          args = [ "fetch-ebook-metadata" ]
          args += [ "-i", isbn ]
          args += [ "-o" ]
          args += [ "-c", cover ] if need_cover

          system(*args, :err => File::NULL, :out => [opf, "w"])

          doc = File.open(opf) { |f| Nokogiri::XML(f) }
          doc.remove_namespaces!

          metadata["title"] = doc.xpath("//title").map { |n| n.text }.first
          metadata["authors"] = doc.xpath("//creator").map { |n| n.text }
          metadata["description"] = doc.xpath("//description").map { |n| n.text }.first
          metadata["publisher"] = doc.xpath("//publisher").map { |n| n.text }.first
          metadata["date"] = Time.parse(doc.xpath("//date").map { |n| n.text }.first)

          IO::copy_stream(cover, metadata["cover"]["abs"]) if need_cover

          metadata
        }
      end
    end
  end
end
