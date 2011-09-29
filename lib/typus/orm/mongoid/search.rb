module Typus
  module Orm
    module Mongoid
      module Search

        def build_search_conditions(key, value)
          search_fields = typus_search_fields
          search_fields = search_fields.empty? ? { "name" => "@" } : search_fields

          search_query = search_fields.map do |key, type|
            related_model = self

            split_keys = key.split('.')
            split_keys[0..-2].each do |split_key|
              if related_model.responds_to? :relations && related_model.relations[split_key] && related_model.relations[split_key].embeded?
                related_model = related_model.relations[split_key]
              else
                raise "Search key '#{key}' is invalid. #{split_key} is not an embeded document" if related_model.embeded?
              end
            end

            field = related_model.fields[split_keys.last]
            raise "Search key '#{field.name}' is invalid." unless field
            value = field.serialize(value) if field.type.ancestors.include?(Numeric)

            {key => value}
          end

          {'$or' => search_query}
        end

        def build_boolean_conditions(key, value)
          { key => (value == 'true') ? true : false }
        end

        def build_datetime_conditions(key, value)
          tomorrow = Time.zone.now.beginning_of_day.tomorrow

          interval = case value
                     when 'today'         then 0.days.ago.beginning_of_day..tomorrow
                     when 'last_few_days' then 3.days.ago.beginning_of_day..tomorrow
                     when 'last_7_days'   then 6.days.ago.beginning_of_day..tomorrow
                     when 'last_30_days'  then 30.days.ago.beginning_of_day..tomorrow
                     end

          build_filter_interval(interval, key)
        end

        alias_method :build_time_conditions, :build_datetime_conditions

        def build_date_conditions(key, value)
          tomorrow = 0.days.ago.tomorrow.to_date

          interval = case value
                     when 'today'         then 0.days.ago.to_date..tomorrow
                     when 'last_few_days' then 3.days.ago.to_date..tomorrow
                     when 'last_7_days'   then 6.days.ago.to_date..tomorrow
                     when 'last_30_days'  then 30.days.ago.to_date..tomorrow
                     end

          build_filter_interval(interval, key)
        end

        def build_filter_interval(interval, key)
          {key.to_sym.gt => interval.first, key.to_sym.lt => interval.last}
        end

        def build_string_conditions(key, value)
          { key => value }
        end

        alias_method :build_integer_conditions, :build_string_conditions
        alias_method :build_belongs_to_conditions, :build_string_conditions

        # TODO: Detect the primary_key for this object.
        def build_has_many_conditions(key, value)
          ["#{key}.id = ?", value]
        end

        ##
        # To build conditions we reject all those params which are not model
        # fields.
        #
        # Note: We still want to be able to search so the search param is not
        #       rejected.
        #
        def build_conditions(params)
          Array.new.tap do |conditions|
            query_params = params.dup

            query_params.reject! do |k, v|
              !model_fields.keys.include?(k.to_sym) &&
                !model_relationships.keys.include?(k.to_sym) &&
                !(k.to_sym == :search)
            end

            query_params.compact.each do |key, value|
              filter_type = model_fields[key.to_sym] || model_relationships[key.to_sym] || key
              conditions << send("build_#{filter_type}_conditions", key, value)
            end
          end
        end

      end
    end
  end
end
