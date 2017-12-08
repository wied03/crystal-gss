@[Link("heimdal-gssapi")]
lib KrbWrapper
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
  fun gss_import_name(minor_status_ptr : Int32*,
                      buffer : Buffer*,
                      oid : Oid*,
                      output_name : NameStruct*) : Int32

  fun gss_release_buffer(minor_status_ptr : Int32*,
                         buffer : Buffer*) : Int32

  fun gss_release_name(minor_status_ptr : Int32*,
                       name : NameStruct*) : Int32

  fun gss_release_cred(minor_status_ptr : Int32*,
                       cred : CredentialStruct*) : Int32

  fun gss_acquire_cred_with_password(minor_status_ptr : Int32*,
                                     name : NameStruct,
                                     password: Buffer*,
                                     time: Int32,
                                     desired_mechs: OidSet*,
                                     cred_usage: GssCredentialUsageFlags,
                                     credential_id: CredentialStruct*,
                                     actual_mechs: OidSet**,
                                     time_rec: Int32*) : Int32
end

@[Link("bwwrapper")]
lib BswWrapper
  # See comments above
  fun bsw_gss_nt_user_name : KrbWrapper::Oid*
  fun bsw_gss_krb5_mechanism : KrbWrapper::Oid*
end
