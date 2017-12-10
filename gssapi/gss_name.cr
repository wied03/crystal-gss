module GssApi
  class GssName
    @structure : GssApi::GssLib::NameStruct
    getter structure

    def initialize(upn : String,
                   oid : GssApi::GssMechanism)
      @closed = false
      buffer = GssApi::GssLib::Buffer.new
      buffer.value = upn
      buffer.length = upn.size
      invoker = GssApi::FunctionInvoker(GssApi::GssLib::NameStruct).new("gss_import_name")
      @structure = invoker.invoke do |minor_pointer|
        status = GssApi::GssLib.gss_import_name(minor_pointer,
                                                pointerof(buffer),
                                                oid.underlying,
                                                out target_name)
        {status, target_name}
      end
    end

    # Protected so we can create copies (private doesn't work)
    protected def copy(structure)
      @closed = false
      @structure = structure
    end

    def canonicalize(mechanism : GssApi::GssMechanism)
        invoker = GssApi::FunctionInvoker(GssApi::GssLib::NameStruct).new("gss_canonicalize_name")
        structure = invoker.invoke do |minor_pointer|
          stat = GssApi::GssLib.gss_canonicalize_name(minor_pointer,
                                                      @structure,
                                                      mechanism.underlying,
                                                      out canon_name)
          {stat, canon_name}
        end
        # We already have a structure so don't want to use the typical initializer
        instance = GssName.allocate
        instance.copy(structure)
        instance
    end

    def display_name
      invoker = GssApi::FunctionInvoker(GssApi::GssLib::GssMechanism).new("gss_display_name")
      buffer = GssApi::GssLib::Buffer.new
      buffer_pointer = pointerof(buffer)
      mechanism = invoker.invoke do |minor_pointer|
        status = GssApi::GssLib.gss_display_name(minor_pointer,
                                                 @structure,
                                                 buffer_pointer,
                                                 out mechanism)
        {status, mechanism}
      end
      message = String.new(buffer.value)
      minor = uninitialized UInt32
      # String creates a copy, so need to free this
      GssApi::GssLib.gss_release_buffer(pointerof(minor),
                                        buffer_pointer)
      message
    end

    def finalize
      return if @closed
      @closed = true
      puts "Cleaning up name"
      begin
        invoker = GssApi::VoidFunctionInvoker.new("gss_release_name")
        invoker.invoke do |minor_pointer|
          GssApi::GssLib.gss_release_name(minor_pointer,
                                          pointerof(@structure))
        end
      rescue
        nil
      end
    end
  end
end
