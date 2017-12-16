module GssApi
  class GssName
    @structure : GssApi::GssLib::NameStruct
    getter structure

    def initialize(principal : String,
                   oid : GssApi::GssMechanism)
      @closed = false
      buffer = GssApi::GssLib::Buffer.new
      buffer.value = principal
      buffer.length = principal.size
      @structure = GssApi::Functions.gss_import_name(pointerof(buffer),
                                                     oid.underlying)
    end

    # TODO: Change back to protected??
    # Protected so we can create copies (private doesn't work)
    def copy(structure)
      @closed = false
      @structure = structure
    end

    def canonicalize(mechanism : GssApi::GssMechanism)
      new_structure = GssApi::Functions.gss_canonicalize_name(@structure,
                                                              mechanism.underlying)
      # We already have a structure so don't want to use the typical initializer
      instance = GssName.allocate
      instance.copy(new_structure)
      instance
    end

    def to_s(io)
      buffer = GssApi::GssLib::Buffer.new
      buffer_pointer = pointerof(buffer)
      GssApi::Functions.gss_display_name @structure,
                                         buffer_pointer
      message = String.new(buffer.value)
      minor = uninitialized UInt32
      # String creates a copy, so need to free this
      GssApi::GssLib.gss_release_buffer(pointerof(minor),
                                        buffer_pointer)
      io << "<GssName: '#{message}'>"
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
