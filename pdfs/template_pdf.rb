require "prawn/measurement_extensions"

class TemplatePdf < Prawn::Document
  def initialize(journal)
    super(skip_page_creation: :true)
    @journal = journal
    add_fonts
  end

  def output_journal
    output_page_size
    output_defaults
    output_page_content
  end

  def add_fonts
    font_families.update(

      # Fira Sans
      "Fira Sans Book" => {
        :regular        => Rails.root.join("app/assets/fonts/FiraSans-Book.ttf")
        # :italic      => "foo-italic.ttf",
        # :bold_italic => "foo-bold-italic.ttf",
        # :bold      => "foo.ttf" 
      },
      "Fira Sans Italic" => {regular: Rails.root.join("app/assets/fonts/FiraSans-Italic.ttf")},
      "Fira Sans Semi Bold" => {regular: Rails.root.join("app/assets/fonts/FiraSans-SemiBold.ttf")},

      # Inria
      "Inria Sans Bold" => {regular: Rails.root.join("app/assets/fonts/InriaSans-Bold.ttf")},
      "Inria Serif Light Italic" => { regular: Rails.root.join("app/assets/fonts/InriaSerif-LightItalic.ttf")},
      "Inria Serif Regular" => { regular: Rails.root.join.join("app/assets/fonts/InriaSerif-Regular.ttf")},

      # Jost
      "Jost 400 Book" => { regular: Rails.root.join("app/assets/fonts/Jost-400-Book.ttf")},
      "Jost 400 Book Italic" => { regular: Rails.root.join("app/assets/fonts/Jost-400-BookItalic.ttf")},
      "Jost 600 Semi" => { regular: Rails.root.join("app/assets/fonts/Jost-600-Semi.ttf")}
    )
  end

  def output_page_size 
    personal = {
      margin: [4.mm, 4.mm], 
      size: [95.mm, 171.mm], 
      skip_page_creation: :true
    } 

    a5 = {
      margin: [4.mm, 4.mm], 
      size: "A5", 
      skip_page_creation: :true
    }

    case @journal.size
    when "Personal"
      initialize_first_page(personal)
    when "A5"
      initialize_first_page(a5)
    end
  end

  def output_defaults
    @punch_margin = 8.mm

    case @journal.size
    when "Personal"
      @h1 = 8
      @h2 = 6
      @h3 = 6
      @body = 5
      @page_width = 95.mm
      @side_margin = 10.mm
      @bottom_margin = 10.mm
      @punch_indent = @side_margin + @punch_margin
    when "A5"
      @h1 = 12
      @h2 = 10
      @h3 = 8
      @body = 10
      @page_width = 148.mm
      @side_margin = 10.mm
      @bottom_margin = 10.mm
      @punch_indent = @side_margin + @punch_margin
    end
  end

  def output_page_content
    raise 'Called abstract method: output_page_content'
  end
end
