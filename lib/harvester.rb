class Harvester
  def harvest options
    raise "Source Required" if !options[:source]
    raise "Destination Required" if !options[:destination]
  end
end

