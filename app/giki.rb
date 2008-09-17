$KCODE = 'UTF8'

require 'rdiscount'
require 'grit'
require 'merb-haml'

# run very flat apps with merb -I <app file>.

Merb::Config.use { |c|
  c[:framework]           = { :public => [Merb.root / "public", nil] },
  c[:session_store]       = 'none',
  c[:exception_details]   = true
  c[:wiki_dir]            = File.dirname(__FILE__) + '/../pages/'
}

Merb.push_path(:view, File.dirname(__FILE__))

Merb::Router.prepare do |r|
  r.match('/').to(:controller => 'giki', :action =>'wiki')
  r.match(%r{/(.+)}).to(:controller => 'giki', :action => 'wiki', :name => '[1]')
end

class Giki < Merb::Controller
  def index
    "hi"
  end

  def wiki
    params[:name] ||= 'Home'

    file = File.open(Merb::Config.wiki_dir + params[:name] + '.mkd')
    mkd = RDiscount.new(file.read)
    render(mkd.to_html, :layout => 'application')

  end
end
