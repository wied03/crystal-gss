module GssApi
  @[Link("gss_extern_variable_fetcher")]
  lib GssExternVariableFetcher
    alias GssMechanism = GssLib::GssMechanism

    # See comments in C file
    fun gss_spnego_mechanism : GssMechanism
    fun gss_s_continue_needed : UInt32

    GSS_S_CONTINUE_NEEDED = gss_s_continue_needed()
  end
end
