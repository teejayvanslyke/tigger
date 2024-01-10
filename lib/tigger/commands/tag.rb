require 'open-uri'
require_relative './base'

module Tigger
  module Commands
    class Tag < Base
      def run
        open_manifest('r') do |file|
          manifest = YAML.load(file.read)
          tracks = manifest[:tracks]
          global = manifest[:global]

          tracks.each do |item|
            tag = ID3Lib::Tag.new(item[:source])

            tag.track = item[:track]
            tag.title = item[:title]
            tag.artist = global[:artist] || item[:artist]
            tag.album = global[:album] || item[:album]

            cover_url = global[:cover_url] || item[:cover_url]
            if cover_url
              cover = {
                :id          => :APIC,
                :mimetype    => 'image/jpeg',
                :picturetype => 3,
                :textenc     => 0,
                :data        => URI.open(cover_url).read
              }
              tag << cover
            end

            tag.update!

            dest = [
              tag.artist,
              [
                tag.track ? tag.track.to_s.rjust(2, "0") : nil,
                tag.title,
              ].compact.join(' '),
            ].join(' - ').gsub('/', ' ')+ '.mp3'

            if item[:source] != dest
              FileUtils.mv item[:source], dest
            end
          end
        end

        # Re-init the manifest so it's updated with the changes
        Tigger::Commands::Init.run
      end
    end
  end
end
