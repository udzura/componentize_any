class ComponentizeAny::Witty
  class << self
    attr_accessor :global_wit
  end

  class Package
    attr :interfaces
    def initialize
      @interfaces = {}
    end

    def interface(name, &blk)
      intf = Interface.new(name)
      @interfaces[name] = intf
      intf.instance_eval(&blk)
    end
  end

  class Interface
    attr :name
    attr :members

    def initialize(name)
      @name = name
      @members = {}
    end

    def define(name, type, argdef, counterpart: nil)
      memb = Member.new(name, type, argdef, counterpart)
      @members[name] = memb
    end
  end

  class Member
    attr :name
    attr :type
    attr :args
    attr :return_value
    attr :counterpart

    def initialize(name, type, argdef, counterpart=nil)
      @name = name
      @type = type
      if argdef.size != 1
        raise "argdef must have exactly one key-value pair"
      end
      @args = argdef.keys[0]
      @return_value = argdef.values[0]
      @counterpart = counterpart || name
    end
  end

  attr :packages
  attr :exports
  attr :imports

  def world(&blk)
    instance_eval(&blk)
  end

  def export(name)
    export = nil
    re = /^(\w+):(\w+)\/(\w+)@(\d+\.\d+\.\d+)$/    
    re.match(name)&.tap do |re|
      export = ExportName.new re[1], re[2], re[3], re[4]
    end
    if export.nil?
      raise "invalid export name: #{name}"
    end
    @exports << export
  end

  def package(name, &blk)
    pkg = Package.new
    @packages[name] = pkg
    pkg.instance_eval(&blk)
  end

  def initialize
    @packages = {}
    @exports = []
    @imports = []
  end
end

class ExportName
  attr :namespace
  attr :component
  attr :interface
  attr :version
  def initialize(namespace, component, interface, version)
    @namespace = namespace
    @component = component
    @interface = interface
    @version = version
  end

  def package_name
    "#{@namespace}:#{@component}@#{@version}"
  end

  def full_name
    "#{@namespace}:#{@component}/#{@interface}@#{@version}"
  end
end

# The grammer of the DSL will be as follows:
# witty do
#   world do
#     export "wasi:cli/run@0.2.0"
#   end
#
#   package "wasi:cli/run@0.2.0" do
#     interface "run" do
#       define "run", :func, {[] => :result}, counterpart: "component_run"
#     end
#   end
# end

def witty(&blk)
  wit = ComponentizeAny::Witty.new
  wit.instance_eval(&blk)
  ComponentizeAny::Witty.global_wit = wit
end
