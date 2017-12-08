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

  type NameStruct = Void*

  # https://github.com/crystal-lang/crystal/issues/4845
  # $gss_c_nt_user_name = __gss_c_nt_user_name_oid_desc : Oid

  # output_name is a pointer of a pointer
  fun gss_import_name(minor_status_ptr : Int32*,
                      buffer : Buffer*,
                      oid : Oid*,
                      output_name : NameStruct*) : Int32
end

@[Link("bwwrapper")]
lib BswWrapper
  # See comments above
  fun bsw_gss_nt_user_name : KrbWrapper::Oid*
end
