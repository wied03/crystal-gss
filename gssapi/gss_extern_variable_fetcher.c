#include <gssapi/gssapi.h>

// for why this C code is in here, see comments in binding.cr re: https://github.com/crystal-lang/crystal/issues/4845

static gss_OID_desc gss_spnego_mechanism_oid_desc = {6, (void *)"\x2b\x06\x01\x05\x05\x02"};

gss_OID gss_nt_user_name() {
  return GSS_C_NT_USER_NAME;
}

gss_OID gss_host_based_service() {
  return GSS_C_NT_HOSTBASED_SERVICE;
}

gss_OID gss_spnego_mechanism() {
  return &gss_spnego_mechanism_oid_desc;
}
