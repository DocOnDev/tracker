class PivotalReader
  DEVSPECT_PROJECT = 707539

  attr_accessor :pivotal_project

  def initialize options = {}
    @pivotal_project = options[:pivotal_project] || DEVSPECT_PROJECT
    @use_ssl = options[:use_ssl].nil? ? true : options[:use_ssl]
  end

  def secure?
    @use_ssl
  end

end
