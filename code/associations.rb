module Bezel::Associations
  def associations
    @associations ||= {}
  end

  def has_many(field_name, model_name)
    model = model_name.to_s.constantize
    associations[field_name] = model
    assoc_name = ActiveSupport::Inflector.pluralize(model.model_name.downcase)
    define_assoc_method(field_name, assoc_name, model, false)
  end

  def belongs_to(field_name, model_name)
    has_one(field_name, model_name)
  end

  def has_one(field_name, model_name)
    model = model_name.to_s.constantize
    associations[field_name] = model
    assoc_name = model.model_name.downcase
    define_assoc_method(field_name, assoc_name, model)
  end

  private

  def define_assoc_method(field_name, assoc_name, model, one = true)
    define_method(field_name) do
      value = @attributes[field_name.to_s] || @attributes[field_name.to_sym]

      if value
        if one
          model.find(value["id"])
        else
          value.map {|v| model.find(v["id"]) }
        end
      else
        if id = @attributes["#{field_name}_id"]
          res = model.find(id)
        else
          res = model.find(:all, filter: "#{c3_type.to_s.camelize(:lower)}.id == '#{@attributes["id"]}'")

          if one
            res[0]
          else
            res
          end
        end
      end
    end
  end
end
