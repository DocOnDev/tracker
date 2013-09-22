class Story
  attr_accessor :name, :status, :updated, :type, :creator, :created, :size

  def created_date
    DateTime.new(@created).strftime('%F %T')
  end

  def updated_date
    DateTime.new(@updated).strftime('%F %T')
  end
end
