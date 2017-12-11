#include <gssapi/gssapi.h>

// for why this C code is in here, see comments in binding.cr re: https://github.com/crystal-lang/crystal/issues/4845

static gss_OID_desc gss_spnego_mechanism_oid_desc = {6, (void *)"\x2b\x06\x01\x05\x05\x02"};

gss_OID gss_spnego_mechanism() {
  return &gss_spnego_mechanism_oid_desc;
}

OM_uint32 gss_s_continue_needed() {
  return GSS_S_CONTINUE_NEEDED;
}
