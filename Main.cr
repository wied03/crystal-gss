require "./gssapi/gssapi"

def do_stuff
  target_name = GssApi::GssName.new("someone@FOO.COM",
                                    GssApi::GssExternVariableFetcher.gss_nt_user_name)
  puts "Name created, now getting credential"
  credential = GssApi::GssCredential.new(target_name,
                                         "thePassword",
                                         GssApi::GssLib::GssCredentialUsageFlags::Initiate,
                                         GssApi::GssExternVariableFetcher.gss_krb5_mechanism)
  puts "Got credential OK!"
end

do_stuff()
