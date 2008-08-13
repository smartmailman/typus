class << ActionController::Routing::Routes;self;end.class_eval do
  define_method :clear!, lambda {}
end

ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|

    Typus.models.each do |m|
      admin.resources m.tableize, :member => { :position => :get, 
                                               :toggle => :get, 
                                               :relate => :get, 
                                               :unrelate => :get }
    end

  end

end

=begin

    draw_without_admin do |map|

      map.with_options :controller => 'typus' do |i|
        i.typus_dashboard "#{prefix}", :action => 'dashboard'
        i.typus_login "#{prefix}/login", :action => 'login'
        i.typus_logout "#{prefix}/logout", :action => 'logout'
        i.typus_email_password "#{prefix}/email_password", :action => 'email_password'
        i.typus_index "#{prefix}/:model", :action => 'index'
        i.connect "#{prefix}/:model/:action", :requirements => { :action => /index|new|create/ }
        i.connect "#{prefix}/:model/:id/:action", :requirements => { :action => /edit|update|destroy|position|toggle|relate|unrelate/, :id => /\d+/ }
      end

      map.connect "#{prefix}/:model/:action", :controller => "typus/#{:model}"
      map.connect "#{prefix}/:model/:id/:action", :controller => "typus/#{:model}"

      yield map

=end