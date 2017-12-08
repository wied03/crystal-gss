#include <gssapi/gssapi.h>

gss_OID_desc* bsw_gss_nt_user_name() {
  return GSS_C_NT_USER_NAME;
}
