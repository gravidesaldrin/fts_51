module ApplicationHelper
  def full_title page_title = ""
    base_title = "Framgia Testing System"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def link_to_remove_fields name, f, cssClass
    link_to name, "#", onclick: h("remove_fields(this)"), class: cssClass,
      remote: true
  end

  def link_to_add_fields name, f, association, cssClass, title
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object,
      child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to name, "#",
      onclick: h("add_fields(this, \"#{association}\",
      \"#{escape_javascript(fields)}\")"), class: cssClass, title: title,
      id: "add-button", remote: true
  end

end
