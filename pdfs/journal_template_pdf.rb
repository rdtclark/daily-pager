require "prawn/measurement_extensions"

class JournalTemplatePdf < TemplatePdf

  def output_page_content

    183.times do

      start_new_page(right_margin: @punch_indent, 
                     left_margin: @side_margin, 
                     bottom_margin: @bottom_margin,
                     top_margin: @bottom_margin)

      # Create left hand page
      # ====

      # Heading
      bounding_box([0,cursor], width: bounds.width, height: bounds.height) do
        # Heading 
        # text "DATE", size: @h1, align: :center
        question_cell_height = bounds.height / 5
        bounding_box([0,cursor], width: bounds.width, height: question_cell_height) do
          stroke_bounds

          # quote or challenge
          font @journal.cached_font_1, style: :regular

          indent(20, 20) do
            if page_number.to_s[/5/]
              text @journal.cached_challenges.sample(1)[0].content, size: @body, align: :center, valign: :center
            else
              text @journal.cached_quotes.sample(1)[0].content, size: @body, align: :center, valign: :center
            end
          end 
        end

        # question boxes
        @journal.cached_questions.sample(4).each do |question|
          bounding_box([0,cursor], width: bounds.width, height: question_cell_height) do
            move_down 2.mm
            indent 2.mm, 2.mm do
              # Show intentions for questions
              # font @journal.font_2, style: :regular
              # text question.intention_list.to_s, size: @body - 2
              font @journal.cached_font_1, style: :regular
              text question.content, size: @body
            end
            stroke do
              stroke_color "242424" # @accent_color
              line_width 0.1.mm
              stroke_bounds
            end
          end
        end
      end

      # Create right hand page
      # ====

      start_new_page(left_margin: @punch_indent, right_margin: @side_margin, bottom_margin: @bottom_margin)


      bounding_box([0,cursor], width: bounds.width, height: bounds.height) do
        # Prompt
        stroke_bounds
        move_down 2.mm
        indent 2.mm, 2.mm do
          font @journal.cached_font_1, style: :regular
          text @journal.cached_prompts.sample(1)[0].content, size: @body
        end
      end
    end
  end
end 

