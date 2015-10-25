class CustomSerializer < ActiveModel::Serializer

  attributes :id, :name

  def name
    "A wild #{object.name}"
  end

end
