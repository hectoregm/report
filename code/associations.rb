module Bezel::Associations
  def associations
    @associations ||= {}
  end

  def has_many(field_name, model_name)
    model = get_model_class(model_name)
    define_assoc_method(field_name, model, false)
  end

  def has_one(field_name, model_name)
    model = get_model_class(model_name)
    define_assoc_method(field_name, model)
  end

  private
  
  def get_model_class(model_name)
    model = model_name.to_s.constantize
    associations[field_name] = model
    model
  end

  def define_assoc_method(field_name, model, one = true)
    define_method(field_name) do
      value = @attributes[field_name.to_s] || @attributes[field_name.to_sym]

      # Caundo el modelo tiene ya tiene los identificadores de los objetos asociados
      if value
        if one
          model.find(value["id"])
        else
          value.map {|v| model.find(v["id"]) }
        end
      else # Se tienen que utilizar un JOIN para obtener los objetos asociados
        if id = @attributes["#{field_name}_id"]
          res = model.find(id)
        else
          res = model.find(:all, 
            filter: "#{c3_type.to_s.camelize(:lower)}.id == '#{@attributes["id"]}'")

          one ? res[0] : res
        end
      end
    end
  end
end
