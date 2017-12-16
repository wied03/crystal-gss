module GssApi
  class GssMechanism
    NT_USER_NAME          = GssMechanism.new("NT_USER_NAME", GssApi::GssLib.gss_nt_user_name)
    NT_HOST_BASED_SERVICE = GssMechanism.new("NT_HOST_BASED_SERVICE", GssApi::GssLib.gss_host_based_service)
    SPNEGO                = get_from_str("SPNEGO", "1.3.6.1.5.5.2")

    protected def self.get_from_str(name, str)
      buffer = GssApi::GssLib::Buffer.new
      buffer.length = str.size
      buffer.value = str
      oid_struct = GssApi::Functions.gss_str_to_oid(pointerof(buffer))
      GssMechanism.new(name, oid_struct)
    end

    getter underlying

    protected def initialize(name       : String,
                             underlying : GssApi::GssLib::GssMechanism)
      @underlying = underlying
      @name = name
    end

    def to_s(io)
        structure = @underlying.value
        # We want to keep the general structure opaque but it's actually octets underneath
        slice = structure.elements.as(Pointer(UInt8)).to_slice(structure.length)
        io << "<GssMechanism #{@name} #{slice}>"
    end
  end
end
