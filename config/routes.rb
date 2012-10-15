Gitscm::Application.routes.draw do

  constraints(:host => 'whygitisbetterthanx.com') do
    root :to => 'site#redirect_wgibtx'
  end

  constraints(:host => 'progit.org') do
    root :to => 'site#redirect_book'
    match '*path' => 'site#redirect_book'
  end

  constraints(:subdomain => 'book') do
    root :to => 'site#redirect_book'
    match '*path' => 'site#redirect_combook'
  end

  constraints(:host => 'libgit2.github.com') do
    root :to => 'library#index'
  end

  get "site/index"

  match "/doc" => "doc#index"
  match "/docs" => "doc#ref"
  match "/docs/:file.html" => "doc#man", :as => :doc_file, :file => /[\w\-\.]+/
  match "/docs/:file" => "doc#man", :as => :doc_file, :file => /[\w\-\.]+/
  match "/docs/:file/:version" => "doc#man", :version => /[^\/]+/
  match "/test" => "doc#test"
  match "/doc/ext" => "doc#ext"

  %w{man ref git}.each do |path|
    match "/#{path}/:file" => redirect("/docs/%{file}")
    match "/#{path}/:file/:version" => redirect("/docs/%{file}/%{version}"),
    :version => /[^\/]+/
  end

  resource :book do
    match "/ch:chapter-:section.html"    => "books#chapter"
    match "/:lang/ch:chapter-:section.html" => "books#chapter"
    match "/index"                          => redirect("/book")
    match "/commands"                       => "books#commands"
    match "/:lang"                          => "books#show"
    match "/:lang/:slug"                    => "books#section"
  end

  match "/download"               => "downloads#index"
  match "/download/:platform"     => "downloads#download"
  match "/download/gui/:platform" => "downloads#gui"

  resources :downloads, :only => [:index] do
    collection do
      match "/guis"       => "downloads#guis"
      match "/installers" => "downloads#installers"
      match "/logos"       => "downloads#logos"
      match "/latest"     => "downloads#latest"
    end
  end

  match "/:year/:month/:day/:slug" => "blog#progit",  :year   => /\d{4}/,
                                                      :month  => /\d{2}/,
                                                      :day    => /\d{2}/

  match "/publish" => "doc#book_update"
  match "/related" => "doc#related_update"


  match "/about" => "about#index"
  match "/about/:section" => "about#index"

  match "/videos" => "doc#videos"
  match "/video/:id" => "doc#watch"

  match "/community" => "community#index"

  match "/admin" => "site#admin"

  match "/search" => "site#search"
  match "/search/results" => "site#search_results"

  # mapping for jasons mocks
  match "/documentation" => "doc#index"
  match "/documentation/reference" => "doc#ref"
  match "/documentation/reference/:file.html" => "doc#man"
  match "/documentation/book" => "doc#book"
  match "/documentation/videos" => "doc#videos"
  match "/documentation/external-links" => "doc#ext"

  get "/library" => "library#index"
  get "/library/api/(:version)" => "library#api", :version => /(HEAD|v\d+\.\d+\.\d+)/, :defaults => {:version => 'HEAD'} 
  get "/library/api/:version/f/:fname" => "library#function", :version => /(HEAD|v\d+\.\d+\.\d+)/
  get "/library/api/:version/g/:gname" => "library#group", :version => /(HEAD|v\d+\.\d+\.\d+)/

  match "/course/svn" => "site#svn"
  match "/sfc" => "site#sfc"

  root :to => 'site#index'
end
