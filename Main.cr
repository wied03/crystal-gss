require "./gssapi/gssapi"

def do_stuff
  target_name = GssApi::GssName.new("brady@FOO.COM",
                                    GssApi::GssMechanism::NT_USER_NAME)
  puts "Name created, now getting credential"
  credential = GssApi::GssCredential.new(target_name,
                                         "7jhN5KCqDZnKG3q",
                                         GssApi::GssLib::GssCredentialUsageFlags::Initiate,
                                         GssApi::GssMechanism::KRB5)
  puts "Got credential OK!"
end

do_stuff()
