module NestedForm
  class Builder < ActionView::Helpers::FormBuilder
    def link_to_add(name, association, add_num = 1)
      @fields ||= {}
      @template.after_nested_form(association) do
        output = ""
        model_object = object.class.reflect_on_association(association).klass.new
        output << %Q[<div id="#{association}_fields_blueprint" style="display: none">].html_safe
        add_num.times do |i|
          output << fields_for(association, model_object, :child_index => "new_#{association}#{i}", &@fields[association])
        end
        output << "</div>".html_safe
        output
      end
      @template.link_to(name, "javascript:void(0)", :class => "add_nested_fields", "data-association" => association)
    end

    def link_to_remove(name)
      hidden_field(:_destroy) + @template.link_to(name, "javascript:void(0)", :class => "remove_nested_fields")
    end
    
    
    def fields_for_with_nested_attributes(association, args, block)
      @fields ||= {}
      @fields[association] = block
      super
    end

    def child_index 
      object_name.gsub(/[^0-9]+/,'').to_i
    end

  end
end
