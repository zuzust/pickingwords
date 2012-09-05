class BaseForm
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Conversion

  def initialize(attrs = {})
    attrs.each do |name, value|
      send("#{name}=", value)
    end
  end

  def clear
    self.instance_variables.each { |var| self.instance_variable_set(var, nil) }
  end

  def persisted?
    false
  end

  def error_messages
    errors.full_messages.to_sentence.humanize
  end
end
