module UI
  class Camera < View
    include Eventable

    attr_accessor :detect_barcode_types, :facing

    def start
      barcode_formats = (@detect_barcode_types or []).map do |format|
        case format
          when :aztec
            AVMetadataObjectTypeAztecCode
          when :code_128
            AVMetadataObjectTypeCode128Code
          when :code_39
            AVMetadataObjectTypeCode39Code
          when :code_93
            AVMetadataObjectTypeCode93Code
          when :codabar
            raise ":codabar not supported in iOS"
          when :data_matrix
            AVMetadataObjectTypeDataMatrixCode
          when :ean_13, :upc_a
            # UPCA is EAN13 according to https://developer.apple.com/library/ios/technotes/tn2325/_index.html
            AVMetadataObjectTypeEAN13Code
          when :ean_8
            AVMetadataObjectTypeEAN8Code
          when :itf
            AVMetadataObjectTypeITF14Code
          when :pdf_417
            AVMetadataObjectTypePDF417Code
          when :qrcode
            AVMetadataObjectTypeQRCode
          when :upc_e
            AVMetadataObjectTypeUPCECode
          else
            raise "Incorrect value `#{format}' for `detect_barcode_types'"
        end
      end

      position = case (@facing or :back)
        when :front
          AVCaptureDevicePositionFront
        when :back
          AVCaptureDevicePositionBack
        else
          raise "Incorrect value `#{@facing}' for `facing'"
      end

      @capture_session = AVCaptureSession.alloc.init
      @capture_session.sessionPreset = AVCaptureSessionPresetHigh

      devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
      device = devices.find { |x| x.position == position }
      return false unless device

      error = Pointer.new(:id)
      input = AVCaptureDeviceInput.deviceInputWithDevice(device, error:error)
      raise error.description unless input

      @preview_layer = AVCaptureVideoPreviewLayer.alloc.initWithSession(@capture_session)
      @preview_layer.videoGravity = AVLayerVideoGravityResizeAspectFill
      layer_rect = proxy.layer.bounds
      @preview_layer.bounds = layer_rect
      @preview_layer.position = [CGRectGetMidX(layer_rect), CGRectGetMidY(layer_rect)]
      proxy.layer.addSublayer(@preview_layer)

      queue = Dispatch::Queue.new('camQueue')
      output = AVCaptureMetadataOutput.alloc.init
      output.setMetadataObjectsDelegate(self, queue:queue.dispatch_object)

      @capture_session.addInput input
      @capture_session.addOutput output

      output.metadataObjectTypes = barcode_formats

      @capture_session.startRunning
    end

    def captureOutput(capture_output, didOutputMetadataObjects:metadata_objects, fromConnection:connection)
      Task.main do
        metadata_objects.each do |barcode|
          trigger :barcode_scanned, barcode.stringValue
        end
      end
    end

    def stop
      if @capture_session
        @capture_session.stopRunning
        @capture_session = nil
      end
      if @preview_layer
        @preview_layer.removeFromSuperlayer
        @preview_layer = nil
      end
    end

    def take_capture
      puts "Not yet implemented"
    end

    # XXX Not defining #proxy here since we can reuse UI::View's.
  end
end
