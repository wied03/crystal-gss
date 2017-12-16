module GssApi
  module Functions
    macro gss_return_function(name, return_type, *params)
      def self.{{name}}(
                    {% for param in params %}
                        {{param}},
                    {% end %}
                  )
        invoker = GssApi::FunctionInvoker({{return_type}}).new("{{name}}")
        invoker.invoke do |minor_pointer|
          status = GssApi::GssLib.{{name}}(minor_pointer,
                                          {% for param in params %}
                                          {{param}},
                                          {% end %}
                                          out output)
          {status, output}
        end
      end
    end

    gss_return_function gss_import_name,
                        GssApi::GssLib::NameStruct,
                        buffer,
                        mechanism

    gss_return_function gss_canonicalize_name,
                        GssApi::GssLib::NameStruct,
                        name_structure,
                        mechanism

    gss_return_function gss_display_name,
                        GssApi::GssLib::GssMechanism,
                        input_name,
                        output_buffer
  end
end
