require 'thor'
require 'yaml'
require 'id3lib'
require 'fileutils'

require_relative './commands/init'
require_relative './commands/tag'

module Tigger
  class CLI < Thor
    desc "init", "Creates a manifest file for the current directory"
    def init
      Tigger::Commands::Init.run
    end

    desc "tag", "Tags all files in the current directory"
    def tag
      Tigger::Commands::Tag.run
    end
  end
end


