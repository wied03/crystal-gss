module GssApi
  class GssName
    @structure : GssApi::GssLib::NameStruct
    getter structure

    def initialize(upn : String,
                   oid : GssApi::GssLib::Oid*)
      @closed = false
      buffer = GssApi::GssLib::Buffer.new
      buffer.value = upn
      buffer.length = upn.size
      invoker = GssApi::FunctionInvoker(GssApi::GssLib::NameStruct).new("gss_import_name")
      @structure = invoker.invoke do |minor_pointer|
        status = GssApi::GssLib.gss_import_name(minor_pointer,
                                                pointerof(buffer),
                                                oid,
                                                out target_name)
        {status, target_name}
      end
    end

    def finalize
      return if @closed
      @closed = true
      puts "Cleaning up name"
      begin
        invoker = GssApi::VoidFunctionInvoker.new("gss_release_name")
        invoker.invoke do |minor_pointer|
          GssApi::GssLib.gss_release_name(minor_pointer,
                                          pointerof(@structure))
        end
      rescue
        nil
      end
    end
  end
end
