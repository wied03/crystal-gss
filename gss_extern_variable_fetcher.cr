module GssApi
  @[Link("gss_extern_variable_fetcher")]
  lib GssExternVariableFetcher
    # See comments above
    fun gss_nt_user_name : GssLib::Oid*
    fun gss_krb5_mechanism : GssLib::Oid*
  end
end
