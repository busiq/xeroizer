module Xeroizer
  module Record

    class ContactGroupModel < BaseModel
      set_permissions :read
    end

    class ContactGroup < Base
      set_primary_key :contact_group_id
      guid :contact_group_id
      string :name
      string :status

      has_many :contacts, :list_complete => true

      def add_contacts_by_ids(ids)
        xml = contacts_xml(ids)
        log "[UPDATE SENT] (#{__FILE__}:#{__LINE__}) \r\n#{xml}"
        client = parent.application.client
        url = [parent.url, id, 'Contacts'].join('/')
        parent.application.http_put(client, url, xml, {})
      end

      private

      def contacts_xml(ids)
        b = Builder::XmlMarkup.new(indent: 2)
        b.contacts do
          ids.each do |contact_id|
            b.contact do
              b.tag! 'ContactID', contact_id
            end
          end
        end
      end
    end

  end
end
