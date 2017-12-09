module GssApi
  class GssMechanism
    NT_USER_NAME = GssMechanism.new(GssApi::GssExternVariableFetcher.gss_nt_user_name)
    KRB5 = GssMechanism.new(GssApi::GssExternVariableFetcher.gss_krb5_mechanism)

    getter underlying

    protected def initialize(underlying : GssApi::GssLib::GssMechanism)
      @underlying = underlying
    end
  end
end
