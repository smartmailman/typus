if defined?(Mongoid)
  require 'typus/orm/mongoid/class_methods'
  Mongoid::Document::ClassMethods.send(:include, Typus::Orm::Mongoid::ClassMethods)

  require 'typus/orm/mongoid/instance_methods'
  Mongoid::Document.send(:include, Typus::Orm::Mongoid)

  require 'typus/orm/mongoid/search'
  Mongoid::Document::ClassMethods.send(:include, Typus::Orm::Mongoid::Search)
end
