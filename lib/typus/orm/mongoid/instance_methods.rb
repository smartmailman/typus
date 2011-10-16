module Typus
  module Orm
    module Mongoid

      def assign_attributes(attrs = nil, options = {})
        _assigning do
          process(attrs, !options[:without_protection]) do |document|
            document.identify if new? && id.blank?
          end
        end
      end

      def update_attributes(attributes, options ={})
        super(attributes)
      end

      def toggle(attribute)
        self[attribute] = !send("#{attribute}?")
        self
      end

    end
  end
end
