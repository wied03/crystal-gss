require "./gssapi/gssapi"

def do_stuff
  # TODO: Test with invalid principal
  # TODO: test without a name/password (rely on ticket cache instead)
  upn_name = GssApi::GssName.new("brady@FOO.COM",
                                 GssApi::GssMechanism::NT_USER_NAME)
  puts "Name created, now getting credential"
  credential = GssApi::GssCredential.new(upn_name,
                                         "7jhN5KCqDZnKG3q",
                                         GssApi::GssLib::GssCredentialUsageFlags::Initiate,
                                         GssApi::GssMechanism::KRB5)
  puts "Got credential OK!"
  # TODO: gss_set_neg_mechs to the spnego OID
  target_name = GssApi::GssName.new("HTTP/kdc.foo.com",
                                    GssApi::GssMechanism::NT_HOST_BASED_SERVICE)
  # then comes gss_init_sec_context
end

do_stuff()
