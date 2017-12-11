module GssApi
  @[Link("gss_extern_variable_fetcher")]
  lib GssExternVariableFetcher
    alias GssMechanism = GssLib::GssMechanism

    # See comments in C file
    fun gss_spnego_mechanism : GssMechanism
  end
end
