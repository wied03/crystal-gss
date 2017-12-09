module GssApi
  @[Link("gss_extern_variable_fetcher")]
  lib GssExternVariableFetcher
    alias GssMechanism = GssLib::GssMechanism

    # See comments above
    fun gss_nt_user_name : GssMechanism
    fun gss_krb5_mechanism : GssMechanism
  end
end
