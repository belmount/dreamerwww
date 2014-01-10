module ApplicationHelper

	def nav_link(link_text, link_path)
    path = current_path
    ctrl = path[:controller]
    action = current_path[:action] 
    if ctrl == 'home' then 
      class_name = 'active' if link_text =~ /#{action}/
    else
  	  class_name = link_path =~ /#{ctrl}/ ? 'active' : ''
    end
    class_name = 'active' if current_page?(link_path)


	  content_tag(:li, :class => class_name) do
	  	link = link_to link_text, link_path
	  end
	end

  def current_path
    current_uri = request.env['PATH_INFO']
    Rails.application.routes.recognize_path current_uri
  end

  def str_padding (str, target_length = 50)
    result_str = str.dup
    (target_length- str.length).times do 
      result_str << '&nbsp; '
    end
    result_str.html_safe
  end

  def date_str(date)
      date.strftime("%Y-%m-%d")
  end

  def date_str_format date_str
    date_str Time.zone.parse(date_str).utc
  end

  def estate_img img
    "http://119.97.201.21#{img}"
  end

  def estate_idx_img imgs
    if imgs.blank? 
      return '/images/notfound.jpg'
    elsif imgs.is_a? Array
      return imgs[0]
    elsif imgs=~/^http/
      return imgs
    else
      return estate_img imgs
    end
  end

  def estate_img_thumb img
    thumb = img.sub(/files/,"thumb")
  end

  def add_star(broker)
    "<i class='icon-star'/>" if broker[:rank]
  end

  def icon(name, title='', right=false)
    if right then
      "#{title}<span class='glyphicon glyphicon-#{name}'><span>".html_safe
    else 
      "<span class='glyphicon glyphicon-#{name}'><span>#{title}".html_safe
    end
  end 
end
