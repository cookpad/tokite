module ApplicationHelper
  def nav_list_item(name, path)
    if current_page?(path)
      link_to(name, path, class: "nav-item is-tab is-active")
    else
      link_to(name, path, class: "nav-item is-tab")
    end
  end

  def form_text_field(form, name, options)
    html_class = options[:class].dup
    object = form.object
    content_tag("div", class: "field") do
      form.label(name, class: "label") +
        if object.errors[name].present?
          errors = object.errors[name]
          content_tag("p", class: "control") do
            form.text_field name, options.merge(class: "#{html_class} is-danger")
          end +
          content_tag("p", errors.join("\n"), class: "help is-danger")
        else
          content_tag("p", class: "control") do
            form.text_field name, size: 400, class: html_class
          end
        end
    end
  end
end
