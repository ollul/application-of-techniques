require 'json'

module ProxyApp
  class Model
    private_class_method :new

    def self.load_data
      file_name = ProxyApp::StringHelper.underscore(name.split(':').last)
      data = JSON.parse(File.read(File.join(__dir__, "#{file_name}.json")))
      @models = {}
      model_key = key

      data.each.with_object(@models) { |item, obj| obj[item[model_key]] = new(item) }
    end

    def initialize(data)
      data.each_key { |key| instance_variable_set("@#{key}", data[key]) }
    end

    def self.find(id)
      @models[id]
    end

    def self.where(restrictions = {})
      @models.each_key.with_object([]) do |id, obj|
        obj << @models[id] if restrictions.each_key.all? { |r| @models[id].send(r) == restrictions[r] }
      end
    end

    def self.all
      @models.each_value.to_a
    end

    def self.key
      'id'
    end

    def inspect
      v = instance_variables.map { |var| "#{var.to_s.gsub('@', '')}: #{instance_variable_get(var)}" }.join(', ')
      "<#{self.class.name}: #{v}>"
    end

    def to_s
      inspect
    end

    def self.has_many(model, foreign_key)
      define_method "#{model.name}s" do
        klass = ProxyApp::StringHelper.constantize(model)
        klass.where({ foreign_key.to_s => send('id') })
      end
    end

    def self.belongs_to(model, foreign_key)
      define_method model.name.downcase do
        klass = ProxyApp::StringHelper.constantize(model)
        klass.where(id: send(foreign_key))
      end
    end
  end
end
