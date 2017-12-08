@[Link("heimdal-gssapi")]
lib GssLib
  struct Buffer
    length : LibC::SizeT
    value : UInt8*
  end

  struct Oid
    length : UInt32
    elements : Void*
  end

  struct OidSet
    count : LibC::SizeT
    elements : Oid*
  end

  type NameStruct = Void*
  type CredentialStruct = Void*
  alias GssCredentialUsageFlags = Int32

  GSS_INITIATE = 1

  # https://github.com/crystal-lang/crystal/issues/4845
  # $gss_c_nt_user_name = __gss_c_nt_user_name_oid_desc : Oid

  # output_name is a pointer of a pointer
  fun gss_import_name(minor_status_ptr : UInt32*,
                      buffer : Buffer*,
                      oid : Oid*,
                      output_name : NameStruct*) : UInt32

  fun gss_release_buffer(minor_status_ptr : UInt32*,
                         buffer : Buffer*) : UInt32

  fun gss_release_name(minor_status_ptr : UInt32*,
                       name : NameStruct*) : UInt32

  fun gss_release_cred(minor_status_ptr : UInt32*,
                       cred : CredentialStruct*) : UInt32

  fun gss_acquire_cred_with_password(minor_status_ptr : UInt32*,
                                     name : NameStruct,
                                     password: Buffer*,
                                     time: Int32,
                                     desired_mechs: OidSet*,
                                     cred_usage: GssCredentialUsageFlags,
                                     credential_id: CredentialStruct*,
                                     actual_mechs: OidSet**,
                                     time_rec: Int32*) : UInt32

  fun gss_display_status(minor_status_ptr : UInt32*,
                         status_code : UInt32,
                         status_type : Int32,
                         mechanism_type: Oid*,
                         message_context: UInt32*,
                         buffer : Buffer*) : UInt32
end

@[Link("bwwrapper")]
lib BswWrapper
  # See comments above
  fun bsw_gss_nt_user_name : GssLib::Oid*
  fun bsw_gss_krb5_mechanism : GssLib::Oid*
end
