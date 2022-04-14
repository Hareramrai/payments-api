# frozen_string_literal: true

class ApplicationContract
  include ActiveModel::Validations

  def validate!
    raise ActiveRecord::RecordInvalid, self unless valid?
  end
end
