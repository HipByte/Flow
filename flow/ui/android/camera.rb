class FlowUICameraSurfaceHolderCallback
  def initialize(view)
    @view = view
  end

  def surfaceCreated(holder)
    @view._surface_created
  end

  def surfaceChanged(holder, format, width, height)
    # Do nothing.
  end

  def surfaceDestroyed(holder)
    @view._surface_destroyed
  end
end

class FlowUICameraDetectorProcessor
  def initialize(view)
    @view = view
  end

  def receiveDetections(detections)
    Task.main do
      barcodes = detections.detectedItems
      barcodes.size.times do |i|
        barcode = barcodes.valueAt(i)
        @view.trigger :barcode_scanned, barcode.rawValue
      end
    end
  end

  def release
  end
end	

module UI
  class Camera < UI::View
    include Eventable

    attr_accessor :detect_barcode_types, :facing

    def start
      barcode_formats = (@detect_barcode_types or []).map do |format|
        case format
          when :aztec
            Com::Google::Android::Gms::Vision::Barcode::Barcode::AZTEC
          when :code_128
            Com::Google::Android::Gms::Vision::Barcode::Barcode::CODE_128
          when :code_39
            Com::Google::Android::Gms::Vision::Barcode::Barcode::CODE_39
          when :code_93
            Com::Google::Android::Gms::Vision::Barcode::Barcode::CODE_93
          when :codabar
            Com::Google::Android::Gms::Vision::Barcode::Barcode::CODABAR
          when :data_matrix
            Com::Google::Android::Gms::Vision::Barcode::Barcode::DATA_MATRIX
          when :ean_13
            Com::Google::Android::Gms::Vision::Barcode::Barcode::EAN_13
          when :ean_8
            Com::Google::Android::Gms::Vision::Barcode::Barcode::EAN_8
          when :itf
            Com::Google::Android::Gms::Vision::Barcode::Barcode::ITF
          when :pdf_417
            Com::Google::Android::Gms::Vision::Barcode::Barcode::PDF417
          when :qrcode
            Com::Google::Android::Gms::Vision::Barcode::Barcode::QR_CODE
          when :upc_a
            Com::Google::Android::Gms::Vision::Barcode::Barcode::UPC_A
          when :upc_e
            Com::Google::Android::Gms::Vision::Barcode::Barcode::UPC_E
          else
            raise "Incorrect value `#{format}' for `detect_barcode_types'"
        end
      end.inject(0) { |b, m| b | m }

      facing = case (@facing or :back)
        when :front
          Com::Google::Android::Gms::Vision::CameraSource::CAMERA_FACING_FRONT
        when :back
          Com::Google::Android::Gms::Vision::CameraSource::CAMERA_FACING_BACK
        else
          raise "Incorrect value `#{@facing}' for `facing'"
      end

      barcode_detector = Com::Google::Android::Gms::Vision::Barcode::BarcodeDetector::Builder.new(UI.context).setBarcodeFormats(barcode_formats).build
      barcode_detector.setProcessor(FlowUICameraDetectorProcessor.new(self))
      #puts "barcode_detector.isOperational -> #{barcode_detector.isOperational}"

      @camera_source = Com::Google::Android::Gms::Vision::CameraSource::Builder.new(UI.context, barcode_detector).setFacing(facing).setAutoFocusEnabled(true).build

      if proxy.holder.isCreating
        @start_after_created = true
      else
        _start
      end
    end

    def _start
      Task.after 0.5 { @camera_source.start(proxy.holder) }
    end

    def stop
      if @camera_source
        @camera_source.stop
        @camera_source = nil
      end
    end

    def _surface_created
      _start if @start_after_created 
    end

    def _surface_destroyed
      stop
    end

    def take_capture
      puts "Not yet implemented"
    end

    def proxy
      @proxy ||= begin
        surface_view = Android::View::SurfaceView.new(UI.context)
        surface_view.holder.addCallback(FlowUICameraSurfaceHolderCallback.new(self))
        surface_view
      end
    end
  end
end
