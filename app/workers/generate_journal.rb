class GenerateJournal
  include Sidekiq::Worker
  sidekiq_options retry: :false

  def perform(journal_id)
    journal = Journal.find(journal_id)
    journal.update_column(:processing, true)
    intentions = journal.intentions
    Question.block(intentions, journal)
    Prompt.block(intentions, journal)
    Quote.block(intentions, journal)
    Challenge.block(intentions, journal)
    pdf = JournalTemplatePdf.new(journal)
    pdf.output_journal

    # stream file method 
    # ===
    # io = StringIO.new pdf.render
    # journal.journal_pdf.attach(io: io, 
    #                            filename: "#{journal.size}_#{journal.name.gsub(/\s+/, "")}_#{journal.id}.pdf", 
    #                            content_type: "application/pdf")

    # Save to tmp file method
    # ===
    source_file_name = "pdf_journal_#{(journal_id).to_s}"
    source_file_path = File.join(Dir.tmpdir, "#{source_file_name}-#{Time.now.strftime("%Y%m%d")}-#{$$}-#{rand(0x100000000).to_s(36)}-.pdf")
    pdf.render_file source_file_path
    journal.journal_pdf.attach(io: File.open(source_file_path), 
                               filename: "#{journal.size}_#{journal.name.gsub(/\s+/, "")}_#{journal.id}.pdf", 
                               content_type: "application/pdf")

    # Convert PDF with minimagick
    # ===

    # Get path to PDF from journal model (only works on local filesystem not in production w/ S3)
    # source_pdf_path = ActiveStorage::Blob.service.path_for(journal.journal_pdf.key)

    # set filename to starting"journal_id"
    destination_file_name = "journal_#{(journal_id).to_s}"

    # set path for tempfile that is about to be created
    converted_file_path = File.join(Dir.tmpdir, "#{destination_file_name}-#{Time.now.strftime("%Y%m%d")}-#{$$}-#{rand(0x100000000).to_s(36)}-.png")

    # Save first two pages as one PNG in landscape e.g (page 1 | page 2)
    MiniMagick::Tool::Montage.new do |montage|

      montage.density "300"
      montage.quality "80"
      montage.interlace "Plane"
      montage.strip
      montage.bordercolor "Black"
      montage.border "1"
      montage.geometry "600x+42+22"
      montage.tile "2x"
      montage.alpha "remove"

      # Journal pdf to be converted
      montage << "#{source_file_path}[0-3]"

      # Destination of resulting PNG
      montage << converted_file_path

    end

    # attach preview PNG using active storage
    journal.journal_pdf_preview.attach(io: File.open(converted_file_path), filename: destination_file_name, content_type: "image/png")

    # remove tempfile
    FileUtils.rm(converted_file_path)
    FileUtils.rm(source_file_path)

    journal.update_column(:processing, false)
    journal.save!
  end

end
