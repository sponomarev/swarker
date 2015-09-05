module Swarker
  class PathsMerger
    attr_reader :original_paths, :paths

    def initialize(original_paths)
      @original_paths = original_paths
      @paths          = merge(original_paths)
    end

    private

    def merge(original_paths)
      groups = {}

      original_paths.each do |path|
        if groups[path_key(path)].nil?
          groups[path_key(path)] = path
        else
          groups[path_key(path)] = merge_paths(groups[path_key(path)], path)
        end
      end

      groups.values
    end

    def path_key(path)
      "#{path.verb}_#{path.path}"
    end

    def merge_paths(first_path, second_path)
      scheme = first_path.scheme.dup
      scheme.values.first['responses'].merge! second_path.scheme.values.first['responses']
      Swarker::Path.new(first_path.path, scheme, true)
    end
  end
end
