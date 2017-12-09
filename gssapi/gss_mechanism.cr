module GssApi
  class GssMechanism
    NT_USER_NAME = GssMechanism.new(GssApi::GssExternVariableFetcher.gss_nt_user_name)
    NT_HOST_BASED_SERVICE = GssMechanism.new(GssApi::GssExternVariableFetcher.gss_host_based_service)
    KRB5 = GssMechanism.new(GssApi::GssExternVariableFetcher.gss_krb5_mechanism)
    SPNEGO = GssMechanism.new(GssApi::GssExternVariableFetcher.gss_spnego_mechanism)

    getter underlying

    protected def initialize(underlying : GssApi::GssLib::GssMechanism)
      @underlying = underlying
    end
  end
end
