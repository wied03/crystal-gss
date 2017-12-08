#include <gssapi/gssapi.h>

gss_OID bsw_gss_nt_user_name() {
  // see comments in krbwrapper.cr
  return GSS_C_NT_USER_NAME;
}
