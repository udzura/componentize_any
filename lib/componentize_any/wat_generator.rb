class ComponentizeAny::WatGenerator
  def initialize
    @buf = ""
  end

  def to_func_type_wat(args, return_value)
    arg_types = args.map.with_index do |arg, i|
      case arg
      when :s32, :s64, :u32, :u64, :f32, :f64
        "(param \"arg#{i}\" #{arg.to_s})"
      else
        raise "unknown type: #{arg}"
      end
    end
    return_type = case return_value
    when :i32
      "i32"
    when :i64
      "i64"
    when :f32
      "f32"
    when :f64
      "f64"
    when :result
      "0" # result is predefined
    else
      raise "unknown type: #{return_value}"
    end
    "(func #{arg_types.join(' ')} (result #{return_type}))"
  end

  def parse_wit(wit)
    export = wit.exports[0]
    export_package = wit.packages[wit.exports[0].package_name]
    export_interface = export_package.interfaces[export.interface]
    export_func = export_interface.members.values[0] #: ComponentizeAny::Witty::Member

    @buf << <<~WAT
      (component
        (core module) ;; empty
        (core instance $m (;0;) (instantiate 0))
        (type (;0;) (result))
        (type $main_t #{to_func_type_wat(export_func.args, export_func.return_value)})
        (alias core export $m "#{export_func.counterpart}" (core func (;0;)))
        (func $main (;0;) (type $main_t) (canon lift (core func 0)))
        (component $C (;0;)
          (type (;0;) (result))
          (type $main_t #{to_func_type_wat(export_func.args, export_func.return_value)})
          (import "main" (func $f (;0;) (type $main_t)))
          (export (;1;) "run" (func $f))
        )
        (instance $c (;0;) (instantiate $C
            (with "main" (func $main))
        ))
        (export (;1;) "#{export.full_name}" (instance $c))
      )
    WAT
  end

  def to_s
    @buf
  end
end