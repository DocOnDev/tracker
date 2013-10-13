class Story
  DATE_TIME_FORMAT = '%m/%d/%Y %H:%M:%S'
  attr_accessor :name, :status, :updated, :type, :creator, :created, :size, :url, :owner

  def created_date
    DateTime.strptime("#{@created/1000}", "%s").strftime(DATE_TIME_FORMAT)
  end

  def updated_date
    DateTime.strptime("#{@updated/1000}", "%s").strftime(DATE_TIME_FORMAT)
  end
end
