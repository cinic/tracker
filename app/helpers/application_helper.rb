module ApplicationHelper

  def li_with_link_to_unles_current_with_class(name, class_for_current = nil, options = {}, html_options = {}, &block)
    if current_page?(options)
      if block_given?
        block.arity <= 1 ? capture(name, &block) : capture(name, options, html_options, &block)
      else
        content_tag :li, class: class_for_current do
          raw('<div class="pointer"><i class="arrow"></i><i class="arrow_border"></i></div>') + # content_tag выводит только последнюю строку, поэтому делаем конкатенацию
          content_tag(:span, ERB::Util.html_escape(name))
        end
      end
    else
      content_tag(:li, link_to(name, options, html_options))
    end
  end

  def link_to_unless_active(name, options = {}, class_for_current = nil, html_options = {}, &block)
    if current_page?(options)
      if block_given?
        block.arity <= 1 ? capture(name, &block) : capture(name, options, html_options, &block)
      else
        content_tag :span, class: class_for_current do
          ERB::Util.html_escape(name)
        end
      end
    else
      link_to(name, options, html_options)
    end
  end
end
