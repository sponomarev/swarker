require 'thor'

module Swarker
  class Cli < Thor
    include Thor::Actions

    desc 'convert', 'Converts lurker schema to swaggers one'
    option :input, aliases: '-i', desc: 'Input path', default: 'lurker'
    option :output, aliases: '-o', desc: 'Output path', default: 'public'
    option :subtree, aliases: '-s', desc: 'Subtree of lurker paths', default: nil
    option :force, aliases: '-f', type: :boolean, desc: 'Rewrite output without confirmation'

    def convert
      say_status :input, input
      say_status :output, output

      services.each do |service|
        schema = Swarker::Serializers::ServiceSerializer.new(service).schema

        create_file(File.join(output, "#{service.host}.json"), JSON.pretty_generate(schema), force: force?)
      end
    end

    private

    def services
      Swarker::Readers::ServiceReader.new(input, subtree).services
    end

    def input
      File.expand_path(options[:input])
    end

    def output
      File.expand_path(options[:output])
    end

    def force?
      options[:force]
    end

    def subtree
      options[:subtree]
    end
  end
end
