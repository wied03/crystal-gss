@[Link("heimdal-gssapi")]
lib KrbWrapper
  struct Buffer
    length : LibC::SizeT
    buffer : UInt8*
  end

  struct Oid
    length : UInt32
    elements : Void*
  end

  type NameStruct = Void*

  $nt_user_name_oid_desc = __gss_c_nt_user_name_oid_desc : Oid*

  fun gss_import_name(minor_status_ptr : Int32*,
                      buffer : Buffer*,
                      oid : Oid*,
                      output_name : NameStruct) : Int32
end
