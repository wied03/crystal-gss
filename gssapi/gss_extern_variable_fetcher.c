#include <gssapi/gssapi.h>

// for why this C code is in here, see comments in binding.cr re: https://github.com/crystal-lang/crystal/issues/4845

gss_OID gss_nt_user_name() {
  return GSS_C_NT_USER_NAME;
}

gss_OID gss_krb5_mechanism() {
  return GSS_KRB5_MECHANISM;
}

gss_OID gss_spnego_mechanism() {
  return GSS_SPNEGO_MECHANISM;
}
