#include <gssapi/gssapi.h>

// for why this C code is in here, see comments in binding.cr re: https://github.com/crystal-lang/crystal/issues/4845
extern gss_OID gss_mech_krb5;

gss_OID gss_nt_user_name() {
  return GSS_C_NT_USER_NAME;
}

gss_OID gss_host_based_service() {
  return GSS_C_NT_HOSTBASED_SERVICE;
}

gss_OID gss_krb5_mechanism() {
  return gss_mech_krb5;
}

// gss_OID gss_spnego_mechanism() {
//   return GSS_SPNEGO_MECHANISM;
// }
