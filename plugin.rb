# name: discourse-tec-email-tweak
# about: Override discourse email handling so that NoBodyDetected never happens
# version: 1.0
# authors: David Taylor
# url: https://github.com/nottinghamtec/discourse-tec-email-tweak

after_initialize do
  reloadable_patch do |plugin|

    class Email::Receiver

      module TECOverrides
        def trim_reply_and_extract_elided(text)
          is_info_message = false
          destinations.each do |destination|
            next unless destination[:type] == :category
            category = destination[:obj]
            is_info_message = true if category.id == SiteSetting.tec_email_tweak_category_id.to_i
          end

          if is_info_message
            return [text, ""]
          end

          return super
        end
      end

      prepend TECOverrides
    end

  end
end
