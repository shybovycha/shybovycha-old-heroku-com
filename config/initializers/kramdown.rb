module Kramdown
    module Converter
        class Html
            def convert_codeblock(el, indent)
              attr = el.attr.dup
              lang = extract_code_language!(attr)
              if @coderay_enabled && (lang || @options[:coderay_default_lang])
                opts = {:wrap => @options[:coderay_wrap], :line_numbers => @options[:coderay_line_numbers],
                  :line_number_start => @options[:coderay_line_number_start], :tab_width => @options[:coderay_tab_width],
                  :bold_every => @options[:coderay_bold_every], :css => @options[:coderay_css]}
                lang = (lang || @options[:coderay_default_lang]).to_sym
                result = CodeRay.scan(el.value, lang).html(opts).chomp << "\n"
                "#{' '*indent}<div#{html_attributes(attr)}>#{result}#{' '*indent}</div>\n"
              else
                result = escape_html(el.value)
                result.chomp!
                if el.attr['class'].to_s =~ /\bshow-whitespaces\b/
                  result.gsub!(/(?:(^[ \t]+)|([ \t]+$)|([ \t]+))/) do |m|
                    suffix = ($1 ? '-l' : ($2 ? '-r' : ''))
                    m.scan(/./).map do |c|
                      case c
                      when "\t" then "<span class=\"ws-tab#{suffix}\">\t</span>"
                      when " " then "<span class=\"ws-space#{suffix}\">&#8901;</span>"
                      end
                    end.join('')
                  end
                end
                code_attr = {}
                code_attr['class'] = "brush:#{lang};" if lang
                "#{' '*indent}<pre#{html_attributes(code_attr)}>#{result}\n</pre>\n"
              end
            end
        end
    end
end