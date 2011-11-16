class String

  def extract_settings
    split(",").map { |x| x.strip }
  end

  def remove_prefix
    split("/")[1..-1].join("/")
  end

  def extract_class
    klass = remove_prefix.classify

    # Try to load a decorator class. If not exists, load the real user.
    # Use this with Drapper to cleanup your model of view stuff
    # https://github.com/jcasimir/draper
    begin
      "#{klass}Decorator".constantize
    rescue NameError
      klass.typus_constantize
    end
  end

  def typus_constantize
    Typus::Configuration.models_constantized[self]
  end

  def acl_action_mapper
    case self
    when "new", "create"
      "create"
    when "index", "show", "autocomplete"
      "read"
    when "edit", "update", "position", "toggle", "relate", "unrelate"
      "update"
    when "destroy", "trash"
      "delete"
    else
      self
    end
  end

  def to_resource
    self.underscore.pluralize
  end

end
