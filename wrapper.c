#include <gssapi/gssapi.h>
#include <stdio.h>

gss_OID bsw_gss_nt_user_name() {
  printf("Wrapper; returning GSS_C_NT_USER_NAME at memory address %p\n",GSS_C_NT_USER_NAME);
  return GSS_C_NT_USER_NAME;
}
