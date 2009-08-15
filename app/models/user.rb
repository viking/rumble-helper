class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.merge_validates_length_of_email_field_options :allow_nil => true
    c.merge_validates_format_of_email_field_options :allow_nil => true
    c.openid_required_fields [:nickname, :email]

    def attributes_to_save
      attrs_to_save = attributes.clone.delete_if do |k, v|
        [:id, :persistence_token, :perishable_token, :single_access_token, :login_count,
          :failed_login_count, :last_request_at, :current_login_at, :last_login_at, :current_login_ip, :last_login_ip, :created_at,
          :updated_at, :lock_version].include?(k.to_sym)
      end
    end

    def map_openid_registration(registration)
      self.nickname = registration['nickname'] if !registration['nickname'].blank?
      self.email    = registration['email']    if !registration['email'].blank?
    end
  end

  belongs_to :member

  protected
    def validate
      if self.new_record? && User.count >= 4
        errors.add_to_base("You can only have 4 people on your team, cheater!")
      end
    end
end
