require_relative './base'

module Tigger
  module Commands
    class Init < Base
      def run
        tracks = Dir['*.mp3'].map do |path|
          tag = ID3Lib::Tag.new(path)

          {
            source: path,
            track: tag.track,
            title: tag.title,
            artist: tag.artist,
            album: tag.album,
          }
        end

        manifest = {
          global: {},
          tracks: tracks,
        }

        open_manifest('w') do |file|
          file.write(YAML.dump(manifest))
        end
      end
    end
  end
end
