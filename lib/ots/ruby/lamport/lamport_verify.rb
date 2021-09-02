
require 'openssl'

module Ots
  module Ruby
    module LamportVerify
      include ToolRack::ConditionUtils

      def verify_init(pub,&block)
        raise OtsError, "Public verification key cannot be nil" if is_empty?(pub)

        @pub = pub
        @sign = StringIO.new
        @sign.binmode
        @dig = OpenSSL::Digest.new("sha3-256")

        if block
          instance_eval(&block)
          verify_final
        else
          self
        end
      end

      def verify_update(sec,data,&block)
        case sec
        when :sign, :signature
          @sign.write(data)
        when :data
          @dig.update(data)
        end
      end
      alias_method :update, :verify_update

      def verify_final

        dmsg = @dig.digest

        digV = OpenSSL::Digest.new("sha3-256")

        @sign.rewind

        indx = 0
        dmsg.each_byte do |b|

          t = 128
          while t > 0
            sign = digV.digest(@sign.read(32))

            if (b & t) == t
              res = @pub[indx][1]
            else
              res = @pub[indx][0]
            end

            raise OtsError, "Signature mismatched at indx #{indx}" if sign != res

            indx += 1
            t = t >> 1
          end
        end

        true
        
      end

    end
  end
end
