module Tigger
  module Commands
    class Base
      def self.run
        new.run
      end

      def open_manifest(mode='r', &block)
        File.open('.tigger.yml', mode, &block)
      end
    end
  end
end
