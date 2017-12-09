require "./gssapi/gssapi"

def do_stuff
  # TODO: test without a name/password (rely on ticket cache instead)
  target_name = GssApi::GssName.new("brady@FOO.COM",
                                    GssApi::GssMechanism::NT_USER_NAME)
  puts "Name created, now getting credential"
  credential = GssApi::GssCredential.new(target_name,
                                         "7jhN5KCqDZnKG3q",
                                         GssApi::GssLib::GssCredentialUsageFlags::Initiate,
                                         GssApi::GssMechanism::KRB5)
  puts "Got credential OK!"
  # TODO: gss_set_neg_mechs to the spnego OID
  # gss_import_name again for the target service except this time with gss_nt_service_name as the mech
  # then comes gss_init_sec_context
end

do_stuff()
