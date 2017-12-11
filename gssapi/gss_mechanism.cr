module GssApi
  class GssMechanism
    NT_USER_NAME = GssMechanism.new(GssApi::GssLib.gss_nt_user_name)
    NT_HOST_BASED_SERVICE = GssMechanism.new(GssApi::GssLib.gss_host_based_service)
    SPNEGO = GssMechanism.new(GssApi::GssExternVariableFetcher.gss_spnego_mechanism)

    getter underlying

    protected def initialize(underlying : GssApi::GssLib::GssMechanism)
      @underlying = underlying
    end

    def to_s(io)
        structure = @underlying.value
        # We want to keep the general structure opaque but it's actually octets underneath
        slice = structure.elements.as(Pointer(UInt8)).to_slice(structure.length)
        io << "<GssMechanism #{slice}>"
    end
  end
end
