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
  alias MinorStatusPtr = UInt32*
  alias MajorStatus = UInt32
  type CredentialStruct = Void*
  GSS_C_BOTH = 0
  GSS_C_INITIATE = 1
  GSS_C_ACCEPT = 2
  alias GssCredentialUsageFlags = Int32

  # https://github.com/crystal-lang/crystal/issues/4845
  # $gss_c_nt_user_name = __gss_c_nt_user_name_oid_desc : Oid

  # output_name is a pointer of a pointer
  fun gss_import_name(minor_status_ptr : MinorStatusPtr,
                      buffer : Buffer*,
                      oid : Oid*,
                      output_name : NameStruct*) : MajorStatus

  fun gss_release_buffer(minor_status_ptr : MinorStatusPtr,
                         buffer : Buffer*) : MajorStatus

  fun gss_release_name(minor_status_ptr : MinorStatusPtr,
                       name : NameStruct*) : MajorStatus

  fun gss_release_cred(minor_status_ptr : MinorStatusPtr,
                       cred : CredentialStruct*) : MajorStatus

  fun gss_acquire_cred_with_password(minor_status_ptr : MinorStatusPtr,
                                     name : NameStruct,
                                     password: Buffer*,
                                     time: Int32,
                                     desired_mechs: OidSet*,
                                     cred_usage: GssCredentialUsageFlags,
                                     credential_id: CredentialStruct*,
                                     actual_mechs: OidSet**,
                                     time_rec: Int32*) : MajorStatus

  fun gss_display_status(minor_status_ptr : MinorStatusPtr,
                         status_code : UInt32,
                         status_type : Int32,
                         mechanism_type: Oid*,
                         message_context: UInt32*,
                         buffer : Buffer*) : MajorStatus
end

@[Link("bwwrapper")]
lib GssExternVariableFetcher
  # See comments above
  fun gss_nt_user_name : GssLib::Oid*
  fun gss_krb5_mechanism : GssLib::Oid*
end
