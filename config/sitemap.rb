# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://jjjg.027xf.com"

SitemapGenerator::Sitemap.create do
   Agency.all.each do |a|
      add agency_path(a)   
   end  
   Law.all.each do |l|
      add law_path(l)
   end
end
