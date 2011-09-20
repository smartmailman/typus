module Typus
  module Orm
    module Mongoid
      module ClassMethods

        include Typus::Orm::Base

        def table_name
          collection_name
        end
        #
        # Model fields as an <tt>ActiveSupport::OrderedHash</tt>.
        def model_fields
          ActiveSupport::OrderedHash.new.tap do |hash|
            fields.values.map { |u| hash[u.name.to_sym] = u.type.name.to_sym }
          end
        end

        # Model relationships as an <tt>ActiveSupport::OrderedHash</tt>.
        def model_relationships
          ActiveSupport::OrderedHash.new.tap do |hash|
            relations.values.map { |i| hash[i.name] = i.macro }
          end
        end
      end
    end
  end
end
