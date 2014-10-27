module NetSuite
  module Support
    class Sublist
      include Support::Fields

      class << self

        def sublist(key, klass)
          field key

          # TODO setting class methods might be better? How to reach into the subclass?

          define_method(:sublist_key) { key }
          define_method(:sublist_class) { klass }

          define_method("#{key}=") do |list|
            self.process_sublist(list)
          end

          define_method("#{key}") do
            @list ||= []
          end
        end

      end

      field :replace_all

      def initialize(attributes = {})
        initialize_from_attributes_hash(attributes)
      end

      def to_record
        rec = { "#{record_namespace}:#{sublist_key}" => send(self.sublist_key).map(&:to_record) }

        if !replace_all.nil?
          rec["#{record_namespace}:replaceAll"] = replace_all
        end

        rec
      end

      protected
        def process_sublist(list)
          list = [ list ] if !list.is_a?(Array)

          @list = list.map do |item|
            self.sublist_class.new(item)
          end
        end

    end
  end
end